// main.js
import { state } from './state.js'; 
import { initCore, animate, switchCamera, scene, renderer, currentCamera } from './core.js'; 
import { 
    setupEventListeners, setMode, onWallThicknessChange, onPillarSizeChange, onOpeningPropChange, 
    setGlobalHeight, switchTab, repositionFurniture, deleteFurniture 
} from './interaction.js';
import { closePanel } from './ui.js'; 
import { undo, redo } from './history.js';

// 초기화
initCore();
setupEventListeners();
animate();

// HTML 버튼 연결
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

// [수정 2] 저장 버튼 로직 (import된 변수들을 사용)
window.saveInterior = function() {
    const title = prompt("인테리어 제목을 입력하세요:", "나의 멋진 방");
    if (!title) return; // 취소

    // 1. JSON 데이터 추출
    // (순환 참조 오류 방지를 위해 필요한 데이터만 추출하여 구성)
    const saveData = {
        meta: { height: state.wallHeight },
        pillars: state.pillars.map(p => ({ x: p.position.x, z: p.position.z, size: p.size })),
        walls: state.walls.map(w => ({ 
            startIdx: state.pillars.indexOf(w.start), 
            endIdx: state.pillars.indexOf(w.end), 
            thickness: w.thickness 
        })),
        floors: state.floors.map(f => ({
            x: f.mesh.position.x, z: f.mesh.position.z, width: f.width, depth: f.depth
        })),
        openings: state.openings.map(o => ({ 
            type: o.type, x: o.mesh.position.x, z: o.mesh.position.z, rot: o.mesh.rotation.y,
            width: o.width, height: o.height, elevation: o.elevation,
            hostWallIdx: state.walls.indexOf(o.hostWall)
        })),
        furnitures: state.furnitures.map(f => ({
            subType: f.subType, 
            x: f.mesh.position.x, 
            z: f.mesh.position.z, 
            rot: f.mesh.rotation.y,
            width: f.width, height: f.height, depth: f.depth
        }))
    };

    const jsonString = JSON.stringify(saveData);

    // 2. 썸네일 캡처
    renderer.render(scene, currentCamera);
    const screenshotData = renderer.domElement.toDataURL("image/png");
    const blob = dataURItoBlob(screenshotData);

    // 3. 전송
    const formData = new FormData();
    formData.append("iTitle", title);
    formData.append("jsonData", jsonString);
    formData.append("file", blob, "thumbnail.png");
    // formData.append("mCode", "temp_user");  // *******시큐리티 연결하면 설정

    fetch('/user/interior/interiorsave', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(result => {
		console.log("저장 처리 결과 : [" + result + "]");
        if (result.trim() === "ok") {
            if (confirm("인테리어 저장이 완료되었습니다!\n이 배치를 '우리집 평면도'로 저장하시겠습니까?\n(가구를 제외한 벽/문/창문만 저장됩니다.)")) {
                alert("평면도 저장 기능은 아직 구현 중입니다. (인테리어만 저장됨)");
                window.location.href = "/";  // *******나중에 위치 설정하기
            } else {
                alert("저장되었습니다.");
                window.location.href = "/";  // *******나중에 위치 설정하기
            }
        } else {
            alert("저장 실패! 오류를 확인해주세요.");
        }
    })
    .catch(err => {
        console.error(err);
        alert("서버 통신 오류");
    });
};

// Base64 -> Blob 변환 유틸
function dataURItoBlob(dataURI) {
    const byteString = atob(dataURI.split(',')[1]);
    const mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];
    const ab = new ArrayBuffer(byteString.length);
    const ia = new Uint8Array(ab);
    for (let i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }
    return new Blob([ab], {type: mimeString});
}