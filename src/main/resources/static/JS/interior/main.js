// main.js
import { state } from './state.js'; 
import { initCore, animate, switchCamera, scene, renderer, currentCamera } from './core.js'; 
import { 
    setupEventListeners, setMode, onWallThicknessChange, onPillarSizeChange, onOpeningPropChange, 
    setGlobalHeight, switchTab, repositionFurniture, deleteFurniture 
} from './interaction.js';
import { closePanel } from './ui.js'; 
import { undo, redo, restoreState } from './history.js';

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

// 데이터 로딩 로직 (페이지 로드 시 자동 실행)
(function loadDataFromServer() {
    const iCodeInput = document.getElementById('server-i-code');
	const iTitleInput = document.getElementById('server-i-title');
    const jsonDataInput = document.getElementById('server-json-data');
	
    // 1. i_code가 존재하면 state에 등록 (수정 모드 활성화)
    if (iCodeInput && iCodeInput.value) {
        state.iCode = iCodeInput.value;
        console.log("수정 모드 진입. ID:", state.iCode);
    }
	
	// 제목 로딩
	if (iTitleInput && iTitleInput.value) {
	    state.iTitle = iTitleInput.value;
	    console.log("제목 로드:", state.iTitle);
	}

    // 2. JSON 데이터가 존재하면 파싱해서 화면 복구
    if (jsonDataInput && jsonDataInput.value) {
        try {
            const savedData = JSON.parse(jsonDataInput.value);
            restoreState(savedData);
            
            // 층고 설정 복구 (meta 데이터가 있다면)
            if (savedData.meta && savedData.meta.height) {
                state.wallHeight = savedData.meta.height;
                document.getElementById('globalHeight').value = state.wallHeight;
            }

            console.log("데이터 복구 완료!");

        } catch (e) {
            console.error("데이터 로딩 실패:", e);
        }
    }
})();

// 저장 버튼 로직 (import된 변수들을 사용)
window.saveInterior = function() {
    let title = state.iTitle;
	// 제목이 없으면(첫 저장) 물어봄
    if (!title) {
        title = prompt("인테리어 제목을 입력하세요:", "나의 멋진 방");
        if (!title) return; // 취소
        state.iTitle = title; // 상태에 저장
    }

    // 1. JSON 데이터 추출
    // (순환 참조 오류 방지를 위해 필요한 데이터만 추출하여 구성)
    const saveData = createSaveDataJSON();
    const jsonString = JSON.stringify(saveData);
	const blob = captureThumbnail();

    // 3. 전송
    const formData = new FormData();
	if (state.iCode) {
		formData.append("i_code", state.iCode);
	}
    formData.append("i_title", title);
    formData.append("json_data", jsonString);
    formData.append("file", blob, "thumbnail.png");
    formData.append("m_code", "temp_user");

    fetch('/user/interior/interiorsave', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(result => {
		console.log("저장 처리 결과 : [" + result + "]");
        if (result.status === "ok") {
            if (result.iCode) {
                state.iCode = result.iCode;
                console.log("저장된 인테리어 번호 :" , state.iCode);
            }
            alert("저장되었습니다.");
        } else {
            alert("저장 실패! 오류를 확인해주세요.");
        }
    })
    .catch(err => {
        console.error(err);
        alert("서버 통신 오류");
    });
};

// 평면도 템플릿 저장 (별도 버튼) 아직 SQL 안만듦!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
window.saveAsFloorplan = function() {
    // 평면도 저장은 보통 이름이 필요하므로 매번 묻거나, 자동 생성할 수 있음
    const fpTitle = prompt("평면도 템플릿 이름:", state.iTitle ? state.iTitle + " (평면도)" : "새 평면도");
    if (!fpTitle) return;

    // 가구 제외하고 벽/문/창문만 저장하는 로직이 필요할 수 있음.
    // 여기서는 일단 전체 저장 로직과 동일하게 구성 (백엔드에서 처리하거나 여기서 필터링)
    const saveData = createSaveDataJSON();
    // 가구 제거 (평면도니까)
    saveData.furnitures = []; 
    
    const jsonString = JSON.stringify(saveData);
    const blob = captureThumbnail(); // 2D 뷰로 전환 후 찍는 게 좋을 수도 있음

    alert("평면도 데이터 생성 완료:\n" + fpTitle + "\n(백엔드 API 연결 필요)");
    console.log(jsonString);
};

// 내부 함수: JSON 데이터 생성
function createSaveDataJSON() {
    return {
        meta: { height: state.wallHeight },
        pillars: state.pillars.map(p => ({ x: p.position.x, z: p.position.z, size: p.size })),
        walls: state.walls.map(w => ({ 
            startIndex: state.pillars.indexOf(w.start), 
            endIndex: state.pillars.indexOf(w.end), 
            thickness: w.thickness 
        })),
        floors: state.floors.map(f => ({
            x: f.mesh.position.x, z: f.mesh.position.z, w: f.width, h: f.depth
        })),
        openings: state.openings.map(o => ({ 
            type: o.type, x: o.mesh.position.x, z: o.mesh.position.z, rot: o.mesh.rotation.y,
            width: o.width, height: o.height, elevation: o.elevation,
            hostWallIndex: state.walls.indexOf(o.hostWall)
        })),
        furnitures: state.furnitures.map(f => ({
            subType: f.subType, 
            x: f.mesh.position.x, z: f.mesh.position.z, rot: f.mesh.rotation.y,
            width: f.width, height: f.height, depth: f.depth
        }))
    };
}

// 내부 함수: 썸네일 캡처
function captureThumbnail() {
    renderer.render(scene, currentCamera);
    const screenshotData = renderer.domElement.toDataURL("image/png");
    return dataURItoBlob(screenshotData);
}

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