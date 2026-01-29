// main.js
import { state } from './state.js'; 
import { initCore, animate, switchCamera, scene, renderer, currentCamera } from './core.js'; 
import { 
    setupEventListeners, setMode, onWallThicknessChange, onPillarSizeChange, onOpeningPropChange, 
    setGlobalHeight, switchTab, repositionFurniture, deleteFurniture, onFurniturePropChange
} from './interaction.js';
import { closePanel } from './ui.js'; 
import { undo, redo, restoreState } from './history.js';

initCore();
setupEventListeners();
animate();

window.switchView = switchCamera;
window.setGlobalHeight = setGlobalHeight;
window.undo = undo;
window.redo = redo;

window.setMode = setMode;
window.closePanel = closePanel;
window.onWallThicknessChange = onWallThicknessChange;
window.onPillarSizeChange = onPillarSizeChange;
window.onOpeningPropChange = onOpeningPropChange;
window.switchTab = switchTab;

window.repositionFurniture = repositionFurniture;
window.deleteFurniture = deleteFurniture;
window.onFurniturePropChange = onFurniturePropChange;

window.saveInterior = function() { let title = state.iTitle; if (!title) { title = prompt("인테리어 제목을 입력하세요:", "나의 멋진 방"); if (!title) return; state.iTitle = title; } const saveData = createSaveDataJSON(); const jsonString = JSON.stringify(saveData); const blob = captureThumbnail(); const formData = new FormData(); if (state.iCode) formData.append("i_code", state.iCode); formData.append("i_title", title); formData.append("json_data", jsonString); formData.append("file", blob, "thumbnail.png"); formData.append("m_code", "temp_user"); fetch('/user/interior/interiorsave', { method: 'POST', body: formData }).then(response => response.json()).then(result => { if (result.status === "ok") { if (result.iCode) state.iCode = result.iCode; alert("저장되었습니다."); } else { alert("저장 실패: " + result.message); } }).catch(err => { console.error(err); alert("서버 통신 오류"); }); };
window.saveAsFloorplan = function() { const fpTitle = prompt("평면도 템플릿 이름:", state.iTitle ? state.iTitle + " (평면도)" : "새 평면도"); if (!fpTitle) return; const saveData = createSaveDataJSON(); saveData.furnitures = []; const jsonString = JSON.stringify(saveData); const blob = captureThumbnail(); alert("평면도 데이터 생성 완료:\n" + fpTitle + "\n(백엔드 API 연결 필요)"); console.log(jsonString); };
function createSaveDataJSON() { return { meta: { height: state.wallHeight }, pillars: state.pillars.map(p => ({ x: p.position.x, z: p.position.z, size: p.size })), walls: state.walls.map(w => ({ startIndex: state.pillars.indexOf(w.start), endIndex: state.pillars.indexOf(w.end), thickness: w.thickness })), floors: state.floors.map(f => ({ x: f.mesh.position.x, z: f.mesh.position.z, w: f.width, h: f.depth })), openings: state.openings.map(o => ({ type: o.type, x: o.mesh.position.x, z: o.mesh.position.z, rot: o.mesh.rotation.y, width: o.width, height: o.height, elevation: o.elevation, hostWallIndex: state.walls.indexOf(o.hostWall) })), furnitures: state.furnitures.map(f => ({ subType: f.subType, x: f.mesh.position.x, z: f.mesh.position.z, rot: f.mesh.rotation.y, width: f.width, height: f.height, depth: f.depth })) }; }
function captureThumbnail() { renderer.render(scene, currentCamera); const screenshotData = renderer.domElement.toDataURL("image/png"); return dataURItoBlob(screenshotData); }
function dataURItoBlob(dataURI) { const byteString = atob(dataURI.split(',')[1]); const mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]; const ab = new ArrayBuffer(byteString.length); const ia = new Uint8Array(ab); for (let i = 0; i < byteString.length; i++) ia[i] = byteString.charCodeAt(i); return new Blob([ab], {type: mimeString}); }
(function loadDataFromServer() { const iCodeInput = document.getElementById('server-i-code'); const iTitleInput = document.getElementById('server-i-title'); const jsonDataInput = document.getElementById('server-json-data'); if (iCodeInput && iCodeInput.value) { state.iCode = iCodeInput.value; } if (iTitleInput && iTitleInput.value) { state.iTitle = iTitleInput.value; console.log("제목 로드:", state.iTitle); } if (jsonDataInput && jsonDataInput.value) { try { const savedData = JSON.parse(jsonDataInput.value); restoreState(savedData); if (savedData.meta && savedData.meta.height) { state.wallHeight = savedData.meta.height; document.getElementById('globalHeight').value = state.wallHeight; } } catch (e) { console.error("데이터 로딩 실패:", e); } } })();