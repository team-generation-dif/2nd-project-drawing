// main.js
import * as THREE from 'three';
import { state } from './state.js'; 
import { initCore, animate, switchCamera, scene, renderer, currentCamera } from './core.js'; 
import { 
    setupEventListeners, setMode, onWallThicknessChange, onPillarSizeChange, onOpeningPropChange, 
    setGlobalHeight, switchTab, repositionFurniture, deleteFurniture, onFurniturePropChange
} from './interaction.js';
import { closePanel, loadFurnitureList } from './ui.js'; 
import { undo, redo, restoreState } from './history.js';
import { createPillar, createWall } from './objects.js';

initCore();
setupEventListeners();
animate();

window.switchView = switchCamera;
window.setGlobalHeight = setGlobalHeight;
window.undo = undo;
window.redo = redo;

window.setMode = setMode;
window.loadFurnitureList = loadFurnitureList;
loadFurnitureList(1);
window.closePanel = closePanel;
window.onWallThicknessChange = onWallThicknessChange;
window.onPillarSizeChange = onPillarSizeChange;
window.onOpeningPropChange = onOpeningPropChange;
window.switchTab = switchTab;

window.repositionFurniture = repositionFurniture;
window.deleteFurniture = deleteFurniture;
window.onFurniturePropChange = onFurniturePropChange;

window.saveInterior = function() { let title = state.iTitle; if (!title) { title = prompt("인테리어 제목을 입력하세요:", "나의 멋진 방"); if (!title) return; state.iTitle = title; } const saveData = createSaveDataJSON(); const jsonString = JSON.stringify(saveData); const blob = captureThumbnail(); const formData = new FormData(); if (state.iCode) formData.append("i_code", state.iCode); formData.append("i_title", title); formData.append("json_data", jsonString); formData.append("file", blob, "thumbnail.png"); formData.append("m_code", "temp_user"); fetch('/user/interior/interiorsave', { method: 'POST', body: formData }).then(response => response.json()).then(result => { if (result.status === "ok") { if (result.iCode) state.iCode = result.iCode; alert("저장되었습니다."); } else { alert("저장 실패: " + result.message); } }).catch(err => { console.error(err); alert("서버 통신 오류"); }); };
// 평면도 저장 로직
window.saveAsFloorplan = function() {
    const templateName = prompt("평면도 템플릿 이름을 입력하세요:", "나의 평면도 1");
    if (!templateName) return;

    // 1. 데이터 추출 (가구 제외)
    const saveData = createSaveDataJSON();
    saveData.furnitures = []; // 가구 데이터 비우기
    
    const jsonString = JSON.stringify(saveData);

    // 2. 썸네일 (가구가 안 보이게 잠깐 숨기고 찍는 센스)
    const originalVisibility = state.furnitures.map(f => f.mesh.visible);
    state.furnitures.forEach(f => f.mesh.visible = false); // 가구 숨김
    renderer.render(scene, currentCamera);
    const screenshotData = renderer.domElement.toDataURL("image/png");
    state.furnitures.forEach((f, i) => f.mesh.visible = originalVisibility[i]); // 가구 복구
    
    const blob = dataURItoBlob(screenshotData);

    // 3. 전송
    const formData = new FormData();
    formData.append("f_template", templateName); // DTO의 f_template 매핑
    formData.append("json_data", jsonString);
    formData.append("file", blob, "fp_thumb.png");
    // formData.append("mCode", "temp_user"); // 세션 처리

    fetch('/user/floorplan/save', { // 새로운 엔드포인트
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(result => {
        if (result.trim() === "ok") {
            alert("평면도가 저장되었습니다.");
        } else {
            alert("저장 실패: " + result);
        }
    })
    .catch(err => console.error(err));
};
function createSaveDataJSON() { return { meta: { height: state.wallHeight }, pillars: state.pillars.map(p => ({ x: p.position.x, z: p.position.z, size: p.size })), walls: state.walls.map(w => ({ startIndex: state.pillars.indexOf(w.start), endIndex: state.pillars.indexOf(w.end), thickness: w.thickness })), floors: state.floors.map(f => ({ x: f.mesh.position.x, z: f.mesh.position.z, w: f.width, h: f.depth })), openings: state.openings.map(o => ({ type: o.type, x: o.mesh.position.x, z: o.mesh.position.z, rot: o.mesh.rotation.y, width: o.width, height: o.height, elevation: o.elevation, hostWallIndex: state.walls.indexOf(o.hostWall) })), furnitures: state.furnitures.map(f => ({ subType: f.subType, x: f.mesh.position.x, z: f.mesh.position.z, rot: f.mesh.rotation.y, width: f.width, height: f.height, depth: f.depth })) }; }
function captureThumbnail() { renderer.render(scene, currentCamera); const screenshotData = renderer.domElement.toDataURL("image/png"); return dataURItoBlob(screenshotData); }
function dataURItoBlob(dataURI) { const byteString = atob(dataURI.split(',')[1]); const mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]; const ab = new ArrayBuffer(byteString.length); const ia = new Uint8Array(ab); for (let i = 0; i < byteString.length; i++) ia[i] = byteString.charCodeAt(i); return new Blob([ab], {type: mimeString}); }
(function loadDataFromServer() { const iCodeInput = document.getElementById('server-i-code'); const iTitleInput = document.getElementById('server-i-title'); const jsonDataInput = document.getElementById('server-json-data'); if (iCodeInput && iCodeInput.value) { state.iCode = iCodeInput.value; } if (iTitleInput && iTitleInput.value) { state.iTitle = iTitleInput.value; console.log("제목 로드:", state.iTitle); } if (jsonDataInput && jsonDataInput.value) { try { const savedData = JSON.parse(jsonDataInput.value); restoreState(savedData); if (savedData.meta && savedData.meta.height) { state.wallHeight = savedData.meta.height; document.getElementById('globalHeight').value = state.wallHeight; } } catch (e) { console.error("데이터 로딩 실패:", e); } } })();
(function checkImportedData() {
    // 1. URL 파라미터 체크 (mode=import)
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('mode') === 'import') {
        
        const wallsJson = sessionStorage.getItem("importedWalls");
        if (wallsJson) {
            const wallsData = JSON.parse(wallsJson);
            
            // 2. 벽 생성 루프
            // 좌표 데이터: {x1, z1, x2, z2}
            wallsData.forEach(w => {
                const startPos = new THREE.Vector3(w.x1, 0, w.z1);
                const endPos = new THREE.Vector3(w.x2, 0, w.z2);
                
                // objects.js의 함수 활용
                // 기둥 생성 (중복 체크는 createPillar 내부에서 함)
                const p1 = createPillar(startPos);
                const p2 = createPillar(endPos);
                
                // 벽 생성
                createWall(p1, p2);
            });

            // 3. 데이터 청소 (재접속 시 중복 생성 방지)
            sessionStorage.removeItem("importedWalls");
            console.log("이미지 기반 벽 생성 완료!");
        }
    }
})();