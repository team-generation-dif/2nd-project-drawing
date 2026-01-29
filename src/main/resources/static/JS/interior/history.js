// history.js
import * as THREE from 'three';
import { state } from './state.js';
import { scene } from './core.js';
import { createPillar, createWall, createFloorMesh, createOpeningMesh, refreshPillarGeometry, refreshWallGeometry, createFurniture } from './objects.js';
import { deselectObject, resetUI } from './ui.js'; // [수정] ui.js 사용

const history = [];
let historyIndex = -1;
const MAX_HISTORY = 50;

export function saveState() {
    if (historyIndex < history.length - 1) history.splice(historyIndex + 1);
    
    // ... 데이터 저장 로직 (기존과 동일) ...
    const pillarsData = state.pillars.map(p => ({ x: p.position.x, z: p.position.z, size: p.size }));
    const wallsData = state.walls.map(w => ({ startIndex: state.pillars.indexOf(w.start), endIndex: state.pillars.indexOf(w.end), thickness: w.thickness }));
    const floorsData = state.floors.map(f => ({ x: f.mesh.position.x, z: f.mesh.position.z, w: f.width, h: f.depth }));
    const openingsData = state.openings.map(o => ({
        type: o.type, x: o.mesh.position.x, z: o.mesh.position.z, rot: o.mesh.rotation.y,
        width: o.width, height: o.height, elevation: o.elevation,
        hostWallIndex: state.walls.indexOf(o.hostWall)
    }));
    const furnituresData = state.furnitures.map(f => ({
        subType: f.subType, x: f.mesh.position.x, z: f.mesh.position.z, rot: f.mesh.rotation.y,
        width: f.width, height: f.height, depth: f.depth
    }));

    history.push({ pillars: pillarsData, walls: wallsData, floors: floorsData, openings: openingsData, furnitures: furnituresData });
    historyIndex++;
    if (history.length > MAX_HISTORY) { history.shift(); historyIndex--; }
}

export function undo() {
    if (historyIndex > 0) {
        historyIndex--;
        restoreState(history[historyIndex]);
    }
}

export function redo() {
    if (historyIndex < history.length - 1) {
        historyIndex++;
        restoreState(history[historyIndex]);
    }
}

export function restoreState(s) {
    deselectObject();
    resetUI(); // [수정] ui.js의 함수 호출

    // ... 복구 로직 (기존과 동일) ...
    [...state.pillars, ...state.walls, ...state.floors, ...state.openings, ...state.furnitures].forEach(item => {
        scene.remove(item.mesh);
        if (item.mesh.geometry) item.mesh.geometry.dispose();
        if (item.mesh.material) item.mesh.material.dispose();
    });
    state.pillars.length = 0; state.walls.length = 0; state.floors.length = 0; state.openings.length = 0; state.furnitures.length = 0;

    s.pillars.forEach(p => { const pillar = createPillar(new THREE.Vector3(p.x, 0, p.z), true); pillar.size = p.size; refreshPillarGeometry(pillar); });
    s.walls.forEach(w => {
        const p1 = state.pillars[w.startIndex]; const p2 = state.pillars[w.endIndex];
        if (p1 && p2) createWall(p1, p2, w.thickness, true);
    });
    if (s.floors) s.floors.forEach(f => createFloorMesh(f.x, f.z, f.w, f.h, true));
    if (s.openings) s.openings.forEach(o => {
        const hostWall = (o.hostWallIndex !== -1) ? state.walls[o.hostWallIndex] : null;
        createOpeningMesh(o.type, new THREE.Vector3(o.x, 0, o.z), o.rot, { width: o.width, height: o.height, elevation: o.elevation }, hostWall, true);
    });
    if (s.furnitures) {
        s.furnitures.forEach(f => {
            createFurniture(f.subType || 'desk', new THREE.Vector3(f.x, 0, f.z), f.rot, true);
        });
    }
    state.walls.forEach(w => refreshWallGeometry(w));
}