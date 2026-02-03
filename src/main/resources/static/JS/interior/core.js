// core.js
import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { state } from './state.js';

export const scene = new THREE.Scene();
scene.background = new THREE.Color(0xf5f5f5);

export const aspect = window.innerWidth / window.innerHeight;
export const viewSize = 15000;

// 카메라 설정
export const camera2D = new THREE.OrthographicCamera(-viewSize * aspect, viewSize * aspect, viewSize, -viewSize, 1, 50000);
camera2D.position.set(0, 10000, 0); 
camera2D.lookAt(0, 0, 0);

export const camera3D = new THREE.PerspectiveCamera(45, aspect, 100, 100000);
camera3D.position.set(8000, 8000, 8000); 
camera3D.lookAt(0, 0, 0);

export let currentCamera = camera2D;

export const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.shadowMap.enabled = true; 
renderer.shadowMap.type = THREE.PCFSoftShadowMap;

export const controls = new OrbitControls(currentCamera, renderer.domElement);
controls.enableDamping = true; 
controls.dampingFactor = 0.1;
controls.mouseButtons = { LEFT: null, MIDDLE: THREE.MOUSE.DOLLY, RIGHT: THREE.MOUSE.PAN };
controls.minZoom = 0.1; controls.maxZoom = 10;
controls.minDistance = 100; controls.maxDistance = 50000;

// 초기화 함수
export function initCore() {
    // [수정] 캔버스 위치 강제 고정 (좌표 오차 방지)
    renderer.domElement.style.position = 'absolute';
    renderer.domElement.style.top = '0';
    renderer.domElement.style.left = '0';
    renderer.domElement.style.zIndex = '0'; // UI 뒤쪽으로 배치
    
    document.body.appendChild(renderer.domElement);

    const grid = new THREE.GridHelper(20000, 80, 0xdddddd, 0xeeeeee);
    scene.add(grid);

    const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
    scene.add(ambientLight);
    const dirLight = new THREE.DirectionalLight(0xffffff, 0.7);
    dirLight.position.set(5000, 10000, 5000);
    dirLight.castShadow = true;
    scene.add(dirLight);

    window.addEventListener('resize', onWindowResize);
}

// 뷰 전환
export function switchCamera(type) {
    if (type === '2D') {
        currentCamera = camera2D;
        controls.object = camera2D;
        controls.enableRotate = false;
        controls.mouseButtons.RIGHT = THREE.MOUSE.PAN;
        camera2D.position.set(0, 10000, 0); camera2D.lookAt(0, 0, 0); camera2D.zoom = 1; camera2D.updateProjectionMatrix();
        state.walls.forEach(w => { if(w.mesh) w.mesh.visible = true; });
    } else {
        currentCamera = camera3D;
        controls.object = camera3D;
        controls.enableRotate = true;
        controls.mouseButtons.RIGHT = THREE.MOUSE.ROTATE;
    }
    controls.reset();
}

// 렌더링 루프
export function animate() {
    requestAnimationFrame(animate);
    if (currentCamera === camera3D) hideObstructingWalls();
    else state.walls.forEach(w => { if(w.mesh) w.mesh.visible = true; });
    
    controls.update();
    renderer.render(scene, currentCamera);
}

function hideObstructingWalls() {
    const camPos = camera3D.position;
    state.walls.forEach(wall => {
        if (!wall.mesh) return;
        const start = wall.start.position;
        const end = wall.end.position;
        const center = new THREE.Vector3((start.x + end.x) / 2, state.wallHeight / 2, (start.z + end.z) / 2);
        const dx = end.x - start.x;
        const dz = end.z - start.z;
        const normal = new THREE.Vector3(dz, 0, -dx).normalize();
        const viewVector = new THREE.Vector3().subVectors(center, camPos).normalize();
        const dot = normal.dot(viewVector);
        wall.mesh.visible = (dot > -0.2);
    });
}

function onWindowResize() {
    const aspect = window.innerWidth / window.innerHeight;
    camera2D.left = -viewSize * aspect; camera2D.right = viewSize * aspect;
    camera2D.top = viewSize; camera2D.bottom = -viewSize;
    camera2D.updateProjectionMatrix();
    camera3D.aspect = aspect; camera3D.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
}