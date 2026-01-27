<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>3D 인테리어 에디터</title>
    <style>
        body { margin: 0; overflow: hidden; font-family: 'Malgun Gothic', sans-serif; user-select: none; }
        
        .panel {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            backdrop-filter: blur(5px);
        }

        /* [NEW] 사이드바 레이아웃 */
        #sidebar {
            position: absolute; top: 20px; left: 20px; z-index: 100;
            display: flex; gap: 10px;
        }
        
        #tab-bar {
            display: flex; flex-direction: column; gap: 5px;
        }
        
        .tab-btn {
            width: 50px; height: 50px; padding: 0;
            font-size: 20px; border-radius: 8px;
            background: #fff; border: 1px solid #ddd;
            cursor: pointer; color: #666;
        }
        .tab-btn.active-tab {
            background: #4CAF50; color: white; border-color: #4CAF50;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        #controls { 
            width: 220px; padding: 15px;
        }
        
        /* 공통 버튼 스타일 */
        button {
            display: block; width: 100%; margin-bottom: 8px; padding: 10px;
            cursor: pointer; background: #fff; border: 1px solid #ddd; border-radius: 6px;
            font-weight: 600; color: #444; transition: all 0.2s;
        }
        button:hover { background: #f5f5f5; border-color: #bbb; }
        button.active { background: #4CAF50; color: white; border-color: #4CAF50; box-shadow: 0 2px 5px rgba(76,175,80,0.3); }
        
        .btn-group { display: flex; gap: 5px; margin-bottom: 8px; }
        .btn-group button { margin-bottom: 0; font-size: 13px; }
        .view-switch { background: #e3f2fd; color: #1565c0; border: 1px solid #90caf9; }
        
        .input-group { margin-bottom: 10px; }
        .input-label { font-size: 12px; color: #666; margin-bottom: 4px; display: block; font-weight: bold; }
        .input-field { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }

        /* 우측 속성 패널 */
        #propertyPanel {
            position: absolute; top: 20px; right: -320px;
            width: 280px; padding: 20px; z-index: 100;
            transition: right 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        #propertyPanel.open { right: 20px; }
        
        .prop-header { font-size: 18px; font-weight: bold; margin-bottom: 15px; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .prop-group { margin-bottom: 15px; }
        .prop-label { font-size: 13px; color: #666; display: block; margin-bottom: 5px; font-weight: bold; }
        .prop-input { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; font-size: 14px; }
        
        #lengthInput {
            position: absolute; display: none; z-index: 99;
            width: 100px; padding: 8px; text-align: center; font-weight: bold;
            border: 2px solid #4CAF50; border-radius: 20px;
            background: rgba(255, 255, 255, 0.9); box-shadow: 0 4px 10px rgba(0,0,0,0.2); font-size: 14px;
        }
        #infoTooltip {
            position: absolute; display: none; pointer-events: none;
            background: rgba(0, 0, 0, 0.8); color: white;
            padding: 6px 10px; border-radius: 4px; font-size: 12px; white-space: nowrap; z-index: 98;
        }
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
                <button onclick="setMode('furniture', 'desk')" id="btn-desk">🪑 책상 (1200)</button>
                <button onclick="setMode('furniture', 'chair')" id="btn-chair">💺 의자</button>
                
                <div style="font-size: 11px; color: #666; margin-top: 15px;">
                    * <b>Q / E</b> : 회전<br>
                    * <b>클릭</b> : 배치<br>
                    * <b>우클릭</b> : 취소
                </div>
            </div>

            <button onclick="setMode('delete')" id="btn-delete" style="color:#d32f2f; border-color:#ffcdd2; margin-top:10px;">🗑️ 삭제</button>
            <hr style="margin: 10px 0;">
   			<button onclick="saveInterior()" style="background: #2196F3; color: white;">💾 저장하기</button>
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