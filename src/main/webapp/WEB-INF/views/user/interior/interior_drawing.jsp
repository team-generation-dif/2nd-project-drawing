<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>3D 인테리어 에디터</title>
<style>
    /* 1. 기본 테마 설정 */
    :root {
        --grida-bg: #fdfbf9;
        --grida-taupe: #8b7e74;
        --grida-dark: #3d342c;
        --grida-border: #f0eeec;
        --grida-accent: #d97d6a; /* 테라코타 포인트 */
    }

    body { 
        margin: 0; 
        overflow: hidden; 
        font-family: 'Pretendard', -apple-system, sans-serif; 
        background-color: var(--grida-bg);
        color: var(--grida-dark);
        user-select: none; 
    }

    /* 2. 패널 스타일 (공지사항 카드 스타일 계승) */
    .panel {
        background: rgba(255, 255, 255, 0.98);
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(139, 126, 116, 0.1);
        border: 1px solid rgba(231, 224, 217, 0.5);
        backdrop-filter: blur(10px);
    }

   #sidebar {
    position: absolute; 
    top: 15px; /* 25px -> 15px */
    left: 20px; 
    z-index: 100;
    display: flex; 
    gap: 12px;
}
    #tab-bar {
        display: flex; flex-direction: column; gap: 8px;
    }
    
    /* 탭 버튼 스타일 */
    .tab-btn {
        width: 55px; height: 55px; padding: 0;
        font-size: 22px; border-radius: 12px;
        background: #fff; border: 1px solid var(--grida-border);
        cursor: pointer; color: var(--grida-taupe);
        transition: all 0.3s;
    }
    .tab-btn.active-tab {
        background: var(--grida-taupe); color: white; border-color: var(--grida-taupe);
        box-shadow: 0 4px 12px rgba(139, 126, 116, 0.2);
    }

#controls { 
    width: 250px; 
    padding: 20px;
    /* 화면 높이에서 더 여유있게 차감 (90vh 정도가 적당합니다) */
    max-height: 90vh; 
    overflow-y: auto; 
    display: flex;
    flex-direction: column;
}
/* 스크롤바를 조금 더 얇고 예쁘게 만들기 (선택사항) */
#controls::-webkit-scrollbar {
    width: 4px;
}
#controls::-webkit-scrollbar-thumb {
    background: var(--grida-border);
    border-radius: 10px;
}
    
    h3 {
        font-family: 'Nanum Myeongjo', serif;
        font-size: 1.4rem;
        margin-bottom: 25px;
        color: var(--grida-dark);
        border-bottom: 1px solid var(--grida-border);
        padding-bottom: 15px;
    }
    hr { margin: 8px 0 !important; }
h3 { margin-bottom: 15px; padding-bottom: 10px; }

    /* 3. 버튼 및 입력 필드 (공지사항/상품등록 스타일) */
    button {
        display: block; width: 100%; margin-bottom: 6px; padding: 10px;
        cursor: pointer; background: #fff; border: 1px solid var(--grida-border); 
        border-radius: 10px; font-weight: 600; color: var(--grida-taupe); 
        transition: all 0.2s; font-family: inherit;
    }
    button:hover { 
        background: var(--grida-bg); 
        border-color: var(--grida-taupe);
        transform: translateY(-1px);
    }
    button.active { 
        background: var(--grida-taupe); color: white; 
        border-color: var(--grida-taupe); 
    }
    
    .view-switch { 
        background: #fff; 
        color: var(--grida-taupe); 
        border: 1px solid var(--grida-border); 
    }
    .view-switch:first-child { border-radius: 10px 0 0 10px; }
    .view-switch:last-child { border-radius: 0 10px 10px 0; border-left: none; }

    .input-label { 
        font-size: 0.85rem; color: var(--grida-taupe); 
        margin-bottom: 8px; display: block; font-weight: bold; 
    }
    .input-field, select { 
        width: 100%; padding: 12px; border: 1px solid var(--grida-border); 
        border-radius: 8px; background-color: #fff; color: var(--grida-dark);
        font-family: inherit;
    }
    .input-field:focus, select:focus {
        outline: none; border-color: var(--grida-taupe);
        box-shadow: 0 0 0 3px rgba(139, 126, 116, 0.05);
    }

    /* 4. 가구 목록 영역 */
#furniture-list {
    height: auto !important; /* HTML에 박힌 스타일 무시 */
    max-height: 250px !important; /* 최대 높이를 줄여 하단 버튼 공간 확보 */
    overflow-y: auto; 
    border: 1px solid var(--grida-border); 
    border-radius: 10px; 
    padding: 10px;
    background: #fafafa;
}
    /* 스크롤바 커스텀 */
    #furniture-list::-webkit-scrollbar { width: 5px; }
    #furniture-list::-webkit-scrollbar-thumb { background: var(--grida-border); border-radius: 10px; }

    /* 5. 우측 속성 패널 */
    #propertyPanel {
        position: absolute; top: 25px; right: -350px;
        width: 300px; padding: 30px; z-index: 100;
        transition: right 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.1);
    }
    #propertyPanel.open { right: 25px; }
    
    .prop-header { 
        font-family: 'Nanum Myeongjo', serif;
        font-size: 1.3rem; font-weight: bold; margin-bottom: 20px; 
        border-bottom: 1px solid var(--grida-border); padding-bottom: 15px; 
    }

    /* 6. 특수 요소 (길이 입력창 등) */
    #lengthInput {
        position: absolute; display: none; z-index: 99;
        width: 110px; padding: 10px; text-align: center; font-weight: bold;
        border: 1px solid var(--grida-taupe); border-radius: 25px;
        background: rgba(255, 255, 255, 0.95); box-shadow: 0 4px 15px rgba(0,0,0,0.1); 
        font-size: 14px; color: var(--grida-dark);
    }

    /* 하단 주요 액션 버튼 */
    .save-btn { background: var(--grida-taupe) !important; color: white !important; }
    .template-btn { background: #fff !important; color: var(--grida-taupe) !important; border: 1px solid var(--grida-taupe) !important; }
    .back-btn { background: #fff !important; color: var(--grida-accent) !important; border: 1px solid #f9e8e4 !important; }
</style>
</head>
<body>
	
    <div id="sidebar">
        <div id="tab-bar">
            <button class="tab-btn active-tab" id="tab-btn-build" onclick="switchTab('build')" title="도면 에디터">🏗️</button>
            <button class="tab-btn" id="tab-btn-furniture" onclick="switchTab('furniture')" title="가구 배치">🪑</button>
        </div>

        <div id="controls" class="panel">
            <h3 style="margin-top:0;">Interior Editor</h3>
            <input type="hidden" id="server-i-code" value="${loaded.i_code}">
            <input type="hidden" id="server-i-title" value="${loaded.i_title}">
			<textarea id="server-json-data" style="display:none;">${loaded.json_data}</textarea>
            <div class="btn-group">
                <button onclick="undo()" title="Undo">↩️</button>
                <button onclick="redo()" title="Redo">↪️</button>
            </div>
            
            <div class="btn-group">
                <button onclick="switchView('2D')" class="view-switch">2D</button>
                <button onclick="switchView('3D')" class="view-switch">3D</button>
            </div>

            <div id="menu-build">
                <div class="input-group">
                    <label class="input-label">층고 (mm)</label>
                    <input type="number" class="input-field" id="globalHeight" value="2400" step="100" onchange="setGlobalHeight(this.value)">
                </div>
                <hr style="border:0; border-top:1px solid #eee; margin:10px 0;">
                <button onclick="setMode('select')" id="btn-select">👆 선택/이동</button>
                <button onclick="setMode('draw')" id="btn-draw">🧱 벽 그리기</button>
                <button onclick="setMode('room')" id="btn-room">🏠 방 만들기</button>
                <button onclick="setMode('pillar')" id="btn-pillar">🏛️ 기둥</button>
                <div class="btn-group">
                    <button onclick="setMode('door')" id="btn-door">🚪 문</button>
                    <button onclick="setMode('window')" id="btn-window">🪟 창문</button>
                </div>
            </div>

            <div id="menu-furniture" style="display: none;">
                <label class="input-label">가구 목록</label>
                <select id="furn-category-select" onchange="loadFurnitureList(this.value)" style="width:100%; padding:8px; margin-bottom:10px;">
                	<option value="favorites">찜 목록</option>
			        <option value="1">거실 (소파/테이블)</option>
			        <option value="4">침실 (침대)</option>
			        <option value="2">다이닝 (식탁)</option>
			    </select>
			
			    <div id="furniture-list" style="height: 400px; overflow-y: auto; border: 1px solid #ddd; padding: 5px;">
			        <div style="text-align:center; padding:20px; color:#999;">카테고리를 선택하세요</div>
    			</div>
            </div>

            <button onclick="setMode('delete')" id="btn-delete" style="color:#d32f2f; border-color:#ffcdd2; margin-top:10px;">🗑️ 삭제</button>
            <hr style="margin: 10px 0;">
   			<button onclick="saveInterior()" class="save-btn">💾 저장하기</button>
<button onclick="saveAsFloorplan()" class="template-btn">📐 평면도 템플릿 저장</button>
<button onclick="history.back()" class="back-btn">뒤로 가기</button>
        </div>
    </div>
    
    <div id="propertyPanel" class="panel">
        <div class="prop-header" id="propTitle">속성</div>
        <div id="propContent"></div>
        <div style="margin-top: 20px; text-align: right;">
            <button onclick="closePanel()" style="width: auto; display: inline-block; padding: 6px 15px; font-size: 13px;">닫기</button>
        </div>
    </div>
    
    <input type="text" id="lengthInput" placeholder="Length" autocomplete="off">
    <div id="infoTooltip"></div>

    <script type="importmap">
        {
            "imports": {
                "three": "https://unpkg.com/three@0.160.0/build/three.module.js",
                "three/addons/": "https://unpkg.com/three@0.160.0/examples/jsm/"
            }
        }
    </script>

    <script type="module" src="/JS/interior/main.js"></script>
</body>
</html>