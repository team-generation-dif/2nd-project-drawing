// objects.js
import * as THREE from 'three';
import { scene } from './core.js';
import { state } from './state.js';
import { COLORS, DEFAULT_PILLAR_SIZE, DEFAULT_WALL_THICKNESS, FURNITURE_DATA } from './constants.js';
import { selectObject } from './ui.js';

const textureLoader = new THREE.TextureLoader();
// [수정] URL을 상수로 분리
const FLOOR_IMG_URL = 'https://raw.githubusercontent.com/mrdoob/three.js/master/examples/textures/hardwood2_diffuse.jpg';

// --- 생성 함수 ---
export function createPillar(pos, save = true) {
    for (let p of state.pillars) if (p.position.distanceTo(pos) < 1) return p;
	if (save) { checkAndRemoveOpeningsAtPoint(pos); }
    const data = { position: pos.clone(), mesh: null, size: DEFAULT_PILLAR_SIZE, isPillar: true };
    const mesh = new THREE.Mesh(new THREE.BoxGeometry(data.size, state.wallHeight, data.size), new THREE.MeshStandardMaterial({ color: COLORS.PILLAR }));
    mesh.position.set(pos.x, state.wallHeight / 2, pos.z);
    mesh.castShadow = true; mesh.receiveShadow = true;
    scene.add(mesh);
    data.mesh = mesh;
    if (save) state.pillars.push(data);
    return data;
}

export function createWall(p1, p2, thickness = DEFAULT_WALL_THICKNESS, save = true) {
    const dist = p1.position.distanceTo(p2.position); if (dist < 1) return;
    if (save) {
        checkAndRemoveFurnituresOnPath(p1.position, p2.position);
        checkAndRemoveOpeningsOnPath(p1.position, p2.position);
    }
    const data = { start: p1, end: p2, mesh: null, thickness: thickness, isWall: true };
    refreshWallGeometry(data);
    if (save) state.walls.push(data);
    return data;
}

export function createOpeningMesh(type, pos, rotationY, dims = {}, hostWall = null, save = true) {
    const width = dims.width || ((type === 'door') ? 900 : 1200);
    const height = dims.height || ((type === 'door') ? 2100 : 1200);
    const elevation = (dims.elevation !== undefined) ? dims.elevation : ((type === 'door') ? 0 : 900);

    const group = new THREE.Group();
    const frameMat = new THREE.MeshStandardMaterial({ color: 0x333333 });
    const frameThick = 20; const frameDepth = 140;

    const left = new THREE.Mesh(new THREE.BoxGeometry(frameThick, height, frameDepth), frameMat);
    left.position.set(-width / 2 + frameThick / 2, 0, 0); group.add(left);
    const right = new THREE.Mesh(new THREE.BoxGeometry(frameThick, height, frameDepth), frameMat);
    right.position.set(width / 2 - frameThick / 2, 0, 0); group.add(right);
    const top = new THREE.Mesh(new THREE.BoxGeometry(width, frameThick, frameDepth), frameMat);
    top.position.set(0, height / 2 - frameThick / 2, 0); group.add(top);

    if (type === 'window') {
        const bottom = new THREE.Mesh(new THREE.BoxGeometry(width, frameThick, frameDepth), frameMat);
        bottom.position.set(0, -height / 2 + frameThick / 2, 0); group.add(bottom);
    }

    let panelMat;
    const panelDepth = 20;
    if (type === 'door') {
        panelMat = new THREE.MeshStandardMaterial({ color: COLORS.DOOR, transparent: true, opacity: 0.6 });
        const handle = new THREE.Mesh(new THREE.SphereGeometry(30), new THREE.MeshStandardMaterial({ color: 0xcccccc }));
        handle.position.set(width / 2 - 60, 0, panelDepth + 10); group.add(handle);
    } else {
        panelMat = new THREE.MeshStandardMaterial({ color: COLORS.WINDOW, transparent: true, opacity: 0.3, roughness: 0.1, metalness: 0.1 });
    }
    const panel = new THREE.Mesh(new THREE.BoxGeometry(width - frameThick * 2, height - frameThick * 2, panelDepth), panelMat);
    group.add(panel);

    group.position.set(pos.x, elevation + height / 2, pos.z);
    group.rotation.y = rotationY;
    scene.add(group);

    const data = {
        type: type, mesh: group,
        width: width, height: height, elevation: elevation,
        rotationY: rotationY, hostWall: hostWall
    };
    if (save) state.openings.push(data);
    return data;
}

// [수정] 텍스처 로딩 방식 변경 (비동기 처리)
export function createFloorMesh(centerX, centerZ, width, depth, save = true) {
    const geometry = new THREE.PlaneGeometry(width, depth);
    
    // 1. 일단 텍스처 없는 재질로 생성
    const material = new THREE.MeshStandardMaterial({ 
        side: THREE.DoubleSide, 
        roughness: 0.8 
    });
    
    // 2. 텍스처 로더를 통해 이미지가 "준비되면" 그때 텍스처 입힘
    // (캐시가 있으면 즉시 실행되므로 성능 문제 없음)
    textureLoader.load(FLOOR_IMG_URL, (texture) => {
        texture.wrapS = THREE.RepeatWrapping;
        texture.wrapT = THREE.RepeatWrapping;
        texture.colorSpace = THREE.SRGBColorSpace;
        
        // 바닥 크기에 맞춰 텍스처 반복 설정
        texture.repeat.set(width / 2000, depth / 2000);
        
        material.map = texture;
        material.needsUpdate = true; // 재질 업데이트 알림
    });
    
    const floor = new THREE.Mesh(geometry, material);
    floor.rotation.x = -Math.PI / 2; 
    floor.position.set(centerX, 1, centerZ); 
    floor.receiveShadow = true;
    
    scene.add(floor);
    if (save) state.floors.push({ mesh: floor, width: width, depth: depth });
}

export function createFurniture(id, pos, rotationY, save = true, customDims = null) {
    const info = FURNITURE_DATA[id];
    if (!info) return null;

    // 저장된 크기가 있으면 그걸 쓰고, 없으면 기본값 사용
    const width = customDims ? customDims.width : info.width;
    const height = customDims ? customDims.height : info.height;
    const depth = customDims ? customDims.depth : info.depth;

    const geometry = new THREE.BoxGeometry(width, height, depth);
    const material = new THREE.MeshStandardMaterial({ color: info.color });
    const mesh = new THREE.Mesh(geometry, material);
    
    // 높이에 따라 위치 조정
    mesh.position.set(pos.x, height / 2, pos.z);
    mesh.rotation.y = rotationY;
    mesh.castShadow = true; mesh.receiveShadow = true;
    
    scene.add(mesh);

    const data = { 
        type: 'furniture', subType: id, mesh: mesh,
        width: width, height: height, depth: depth // 실제 적용된 크기 저장
    };

    if (save) state.furnitures.push(data);
    return data;
}

// --- 업데이트 함수들 ---
export function refreshWallGeometry(w) {
    const p1 = w.start.position; const p2 = w.end.position;
    const dist = Math.hypot(p2.x - p1.x, p2.z - p1.z);

    const shape = new THREE.Shape();
    shape.moveTo(0, 0); shape.lineTo(dist, 0); shape.lineTo(dist, state.wallHeight); shape.lineTo(0, state.wallHeight); shape.lineTo(0, 0);

    const attachedOpenings = state.openings.filter(o => o.hostWall === w);
    attachedOpenings.forEach(o => {
        const distanceData = Math.hypot(o.mesh.position.x - p1.x, o.mesh.position.z - p1.z);
        const holeX = distanceData - (o.width / 2);
        const holeY = o.elevation;
        if (holeX < 0 || holeX + o.width > dist) return;

        const holePath = new THREE.Path();
        holePath.moveTo(holeX, holeY);
        holePath.lineTo(holeX + o.width, holeY);
        holePath.lineTo(holeX + o.width, holeY + o.height);
        holePath.lineTo(holeX, holeY + o.height);
        holePath.lineTo(holeX, holeY);
        shape.holes.push(holePath);
    });

    const geometry = new THREE.ExtrudeGeometry(shape, { depth: w.thickness, bevelEnabled: false });
    if (w.mesh) { scene.remove(w.mesh); w.mesh.geometry.dispose(); }

    w.mesh = new THREE.Mesh(geometry, new THREE.MeshStandardMaterial({ color: (state.selectedObject === w) ? COLORS.SELECT : COLORS.WALL }));
    w.mesh.castShadow = true; w.mesh.receiveShadow = true;
    w.mesh.position.copy(p1);
    const angle = Math.atan2(p2.z - p1.z, p2.x - p1.x);
    w.mesh.rotation.y = -angle;
    geometry.translate(0, 0, -w.thickness / 2);
    scene.add(w.mesh);
}

export function refreshPillarGeometry(p) {
    p.mesh.geometry.dispose();
    p.mesh.geometry = new THREE.BoxGeometry(p.size, state.wallHeight, p.size);
    p.mesh.position.y = state.wallHeight / 2;
    if (p === state.selectedObject) p.mesh.material.color.setHex(COLORS.SELECT);
}

export function refreshOpeningGeometry(data) {
    scene.remove(data.mesh);
    const pos = new THREE.Vector3(data.mesh.position.x, 0, data.mesh.position.z);
    const newData = createOpeningMesh(data.type, pos, data.rotationY, {
        width: data.width, height: data.height, elevation: data.elevation
    }, data.hostWall, false);
    data.mesh = newData.mesh;
    if (state.selectedObject === data) selectObject(data); 
}

export function refreshFurnitureGeometry(furn) {
    if (!furn || !furn.mesh) return;
    if (furn.mesh.geometry) furn.mesh.geometry.dispose();
    furn.mesh.geometry = new THREE.BoxGeometry(furn.width, furn.height, furn.depth);
    furn.mesh.position.y = furn.height / 2;
}

export function checkAndResizePillar(p, min) {
    if (p.size < min) { p.size = min; refreshPillarGeometry(p); }
}

export function updateConnectedWalls(p) {
    state.walls.filter(w => w.start === p || w.end === p).forEach(refreshWallGeometry);
}

export function deleteWall(w) {
    for (let i = state.openings.length - 1; i >= 0; i--) {
        if (state.openings[i].hostWall === w) {
            scene.remove(state.openings[i].mesh);
            state.openings.splice(i, 1);
        }
    }
    scene.remove(w.mesh); w.mesh.geometry.dispose();
    state.walls.splice(state.walls.indexOf(w), 1);
}

export function deletePillar(p) {
    state.walls.filter(w => w.start === p || w.end === p).forEach(deleteWall);
    scene.remove(p.mesh); p.mesh.geometry.dispose();
    state.pillars.splice(state.pillars.indexOf(p), 1);
}

export function removeWall(w) {
    scene.remove(w.mesh); w.mesh.geometry.dispose();
    state.walls.splice(state.walls.indexOf(w), 1);
}

export function cleanupOrphanPillars() {
    for (let i = state.pillars.length - 1; i >= 0; i--) {
        if (!state.walls.some(w => w.start === state.pillars[i] || w.end === state.pillars[i])) {
            scene.remove(state.pillars[i].mesh);
            state.pillars[i].mesh.geometry.dispose();
            state.pillars.splice(i, 1);
        }
    }
}

export function createPreviewWall(pos) {
    const g = new THREE.BoxGeometry(1, state.wallHeight, DEFAULT_WALL_THICKNESS);
    const m = new THREE.MeshBasicMaterial({ color: 0xff0000, opacity: 0.5, transparent: true });
    state.previewObject = new THREE.Mesh(g, m);
    state.previewObject.position.copy(pos);
    scene.add(state.previewObject);
}

export function updateWallPreview(pos, len) {
    if (!state.previewObject) createPreviewWall(state.startPillar.position);
    const sp = state.startPillar.position;
    const dist = len !== undefined ? len : sp.distanceTo(pos);
    const mid = new THREE.Vector3().addVectors(sp, pos).multiplyScalar(0.5); mid.y = state.wallHeight / 2;
    const angle = Math.atan2(pos.z - sp.z, pos.x - sp.x);
    if (dist > 0) {
        state.previewObject.rotation.y = -angle; state.previewObject.scale.x = dist;
        const dir = new THREE.Vector3().subVectors(pos, sp).normalize();
        const center = sp.clone().add(dir.multiplyScalar(dist / 2)); center.y = state.wallHeight / 2;
        state.previewObject.position.copy(center);
    }
}

export function updatePillarPreview(pos) {
    if (!state.previewObject) {
        const g = new THREE.BoxGeometry(DEFAULT_PILLAR_SIZE, state.wallHeight, DEFAULT_PILLAR_SIZE);
        const m = new THREE.MeshBasicMaterial({ color: 0x5d4037, opacity: 0.6, transparent: true });
        state.previewObject = new THREE.Mesh(g, m);
        scene.add(state.previewObject);
    }
    state.previewObject.position.set(pos.x, state.wallHeight / 2, pos.z);
}

export function createPreviewRoom(pos) {
    const g = new THREE.BoxGeometry(1, 1, 1);
    const m = new THREE.MeshBasicMaterial({ color: 0x00ff00, opacity: 0.3, transparent: true });
    state.previewObject = new THREE.Mesh(g, m);
    state.previewObject.position.copy(pos);
    scene.add(state.previewObject);
}

export function updateRoomPreview(pos) {
    if (!state.previewObject) createPreviewRoom(state.startPillar.position);
    const sp = state.startPillar.position;
    const w = Math.abs(pos.x - sp.x); const d = Math.abs(pos.z - sp.z);
    state.previewObject.position.set((sp.x + pos.x) / 2, 1, (sp.z + pos.z) / 2);
    state.previewObject.scale.set(w, 10, d);
    return `${Math.round(w)} x ${Math.round(d)}`;
}

export function updateOpeningPreview(type, pos, rotY) {
    if (state.previewObject) { scene.remove(state.previewObject); state.previewObject = null; }
    const width = 900; const height = (type === 'door') ? 2100 : 1200;
    const color = (type === 'door') ? 0xff0000 : 0x0000ff;
    const geo = new THREE.BoxGeometry(width, height, 150);
    state.previewObject = new THREE.Mesh(geo, new THREE.MeshBasicMaterial({ color: color, opacity: 0.5, transparent: true }));
    const y = (type === 'door') ? height / 2 : 900 + height / 2;
    state.previewObject.position.set(pos.x, y, pos.z);
    state.previewObject.rotation.y = rotY;
    scene.add(state.previewObject);
}

export function updateFurniturePreview(id, pos, rotationY, isValid, customDims = null) { // customDims 추가
    // 정보 가져오기 (커스텀 or 상수)
    let width, height, depth;
    
    if (id === 'custom' && customDims) {
        width = customDims.width;
        height = customDims.height;
        depth = customDims.depth;
    } else {
        const info = FURNITURE_DATA[id];
        if (!info) return;
        width = info.width; height = info.height; depth = info.depth;
    }

    // 프리뷰 객체가 없거나, ID가 바뀌었거나, 크기가 다르면 재생성
    if (!state.previewObject || state.previewObject.userData.id !== id) {
        if (state.previewObject) scene.remove(state.previewObject);
        
        const geometry = new THREE.BoxGeometry(width, height, depth);
        const material = new THREE.MeshBasicMaterial({ 
            color: isValid ? COLORS.VALID : COLORS.COLLISION, 
            opacity: 0.5, 
            transparent: true 
        });
        state.previewObject = new THREE.Mesh(geometry, material);
        state.previewObject.userData.id = id;
        scene.add(state.previewObject);
    } 
    // (선택) 같은 'custom' ID라도 크기가 다른 가구를 연달아 클릭했을 때 프리뷰 갱신 로직이 필요할 수 있음
    // 간단하게 하려면 클릭 시마다 previewObject를 null로 초기화해주는 것도 방법.

    state.previewObject.position.set(pos.x, height / 2, pos.z);
    state.previewObject.rotation.y = rotationY;
    state.previewObject.material.color.setHex(isValid ? COLORS.VALID : COLORS.COLLISION);
    
    // 만약 기존 프리뷰의 스케일/지오메트리가 안 맞으면 강제 업데이트
    if (state.previewObject.geometry.parameters.width !== width) {
         state.previewObject.geometry.dispose();
         state.previewObject.geometry = new THREE.BoxGeometry(width, height, depth);
    }
}

export function createRoomWalls(p1Pos, p2Pos) {
    const minX = Math.min(p1Pos.x, p2Pos.x); const maxX = Math.max(p1Pos.x, p2Pos.x);
    const minZ = Math.min(p1Pos.z, p2Pos.z); const maxZ = Math.max(p1Pos.z, p2Pos.z);
    const corners = [new THREE.Vector3(minX, 0, minZ), new THREE.Vector3(maxX, 0, minZ), new THREE.Vector3(maxX, 0, maxZ), new THREE.Vector3(minX, 0, maxZ)];
    const p = corners.map(pos => createPillar(pos));
    createWall(p[0], p[1]); createWall(p[1], p[2]); createWall(p[2], p[3]); createWall(p[3], p[0]);
    createFloorMesh((minX + maxX) / 2, (minZ + maxZ) / 2, maxX - minX, maxZ - minZ);
}

export function finishWallDrawing(ep) {
    if (state.startPillar === ep) return;
    createWall(state.startPillar, ep); 
    state.startPillar = ep; 
}

export function handleWallSplit(snap) {
    if (snap.type === 'pillar') return snap.object;
    if (snap.type === 'wall') {
        const ow = snap.object, sp = snap.position, np = createPillar(sp), th = ow.thickness;
        removeWall(ow); createWall(ow.start, np, th); createWall(np, ow.end, th); return np;
    } return createPillar(snap.position);
}

// 특정 위치(기둥)에 있는 문/창문 감지 및 삭제 함수
function checkAndRemoveOpeningsAtPoint(pos) {
    // 삭제할 목록 찾기
    const toRemove = [];
    state.openings.forEach(op => {
        // 문/창문의 위치와 기둥 위치의 거리가 가까우면 (기둥 크기 고려 100mm 정도)
        if (op.mesh.position.distanceTo(new THREE.Vector3(pos.x, op.mesh.position.y, pos.z)) < 150) {
            toRemove.push(op);
        }
    });

    // 실제 삭제 수행
    toRemove.forEach(op => {
        scene.remove(op.mesh);
        const idx = state.openings.indexOf(op);
        if (idx > -1) state.openings.splice(idx, 1);
        
        // 문이 있던 벽 갱신 (구멍 메우기)
        if (op.hostWall) refreshWallGeometry(op.hostWall);
    });
}

function checkAndRemoveFurnituresOnPath(p1, p2) {
    for (let i = state.furnitures.length - 1; i >= 0; i--) {
        const furn = state.furnitures[i];
        if (checkObjectOverlap(furn, p1, p2)) {
            scene.remove(furn.mesh);
            state.furnitures.splice(i, 1);
        }
    }
}

function checkAndRemoveOpeningsOnPath(p1, p2) {
    for (let i = state.openings.length - 1; i >= 0; i--) {
        const op = state.openings[i];
        const objMock = { width: op.width, depth: 200, mesh: op.mesh };
        if (checkObjectOverlap(objMock, p1, p2)) {
            scene.remove(op.mesh);
            state.openings.splice(i, 1);
        }
    }
}

export function checkCollision(previewObj, targetPos, ignoreObj = null) {
    let targetMesh = previewObj;
    if (!targetMesh && ignoreObj) {
        targetMesh = ignoreObj.mesh;
    }
    
    if (!targetMesh) return false;

    const subjectBox = new THREE.Box3().setFromObject(targetMesh);
    subjectBox.expandByScalar(-1); 

    const geom = targetMesh.geometry;
    const furnWidth = geom.parameters ? geom.parameters.width : (subjectBox.max.x - subjectBox.min.x);
    const furnDepth = geom.parameters ? geom.parameters.depth : (subjectBox.max.z - subjectBox.min.z);

    const furnData = {
        width: furnWidth,
        depth: furnDepth,
        mesh: targetMesh
    };

    for (let w of state.walls) {
        if (checkObjectOverlap(furnData, w.start.position, w.end.position)) {
            return true; 
        }
    }

    for (let p of state.pillars) {
        const pillarBox = new THREE.Box3().setFromObject(p.mesh);
        pillarBox.expandByScalar(-1); 
        if (subjectBox.intersectsBox(pillarBox)) return true;
    }

    for (let f of state.furnitures) {
        if (ignoreObj && f === ignoreObj) continue; 
        const furBox = new THREE.Box3().setFromObject(f.mesh);
        if (subjectBox.intersectsBox(furBox)) return true;
    }

    return false;
}

function checkObjectOverlap(obj, p1, p2) {
    const w = obj.width;
    const d = obj.depth;
    const angle = obj.mesh.rotation.y;
    const pos = obj.mesh.position;
    
    const corners = [
        { x: -w/2, z: -d/2 }, { x: w/2, z: -d/2 },
        { x: w/2, z: d/2 }, { x: -w/2, z: d/2 }
    ];
    
    const cos = Math.cos(angle);
    const sin = Math.sin(angle);
    
    const worldCorners = corners.map(c => ({
        x: (c.x * cos - c.z * sin) + pos.x,
        z: (c.x * sin + c.z * cos) + pos.z
    }));
    
    if (isPointInPolygon(p1, worldCorners) || isPointInPolygon(p2, worldCorners)) return true;
    
    for (let i = 0; i < 4; i++) {
        const c1 = worldCorners[i];
        const c2 = worldCorners[(i+1)%4];
        if (getLineIntersection(p1, p2, c1, c2)) return true;
    }
    return false;
}

function isPointInPolygon(p, polygon) {
    let inside = false;
    for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
        const xi = polygon[i].x, yi = polygon[i].z;
        const xj = polygon[j].x, yj = polygon[j].z;
        const intersect = ((yi > p.z) !== (yj > p.z)) && (p.x < (xj - xi) * (p.z - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
    }
    return inside;
}

function getLineIntersection(p1, p2, p3, p4) {
    const x1 = p1.x, y1 = p1.z;
    const x2 = p2.x, y2 = p2.z;
    const x3 = p3.x, y3 = p3.z;
    const x4 = p4.x, y4 = p4.z;
    const denom = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
    if (denom === 0) return false; 
    const ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / denom;
    const ub = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / denom;
    return (ua >= 0 && ua <= 1 && ub >= 0 && ub <= 1);
}