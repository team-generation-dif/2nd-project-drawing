// ui.js
import { state } from './state.js';
import { COLORS, FURNITURE_DATA } from './constants.js';

// HTML Elements
const propertyPanel = document.getElementById('propertyPanel');
const propTitle = document.getElementById('propTitle');
const propContent = document.getElementById('propContent');
const inputEl = document.getElementById('lengthInput');
const infoTooltip = document.getElementById('infoTooltip');

export function resetUI() {
    inputEl.style.display = 'none'; 
    inputEl.value = ''; 
    infoTooltip.style.display = 'none';
    propertyPanel.classList.remove('open');
}

export function deselectObject() {
    if (state.selectedObject) {
        // 색상 복구 (가구일 경우 원래 색상, 아니면 기본 색상)
        if (state.selectedObject.type === 'furniture') {
             // 가구는 개별 색상이 있으므로 FURNITURE_DATA에서 찾아야 함
             const info = FURNITURE_DATA[state.selectedObject.subType];
             if(info) state.selectedObject.mesh.material.color.setHex(info.color);
        } else if (!state.selectedObject.type) {
            state.selectedObject.mesh.material.color.setHex(state.selectedObject.isWall ? COLORS.WALL : COLORS.PILLAR);
        }
    }
    state.selectedObject = null;
    propertyPanel.classList.remove('open');
}

export function selectObject(d) {
    deselectObject(); // 기존 선택 해제
    state.selectedObject = d;
    
    // 선택 하이라이트 (초록색)
    d.mesh.material.color.setHex(COLORS.SELECT);
    
    updatePanelUI(d);
    propertyPanel.classList.add('open');
}

export function updatePanelUI(d) {
    propContent.innerHTML = '';
    
    if (d.type === 'furniture') { // [NEW] 가구 속성 패널
        const info = FURNITURE_DATA[d.subType];
        const name = info ? info.name : d.subType;
        propTitle.innerText = `🪑 ${name} 속성`;
        propContent.innerHTML = `
            <div class="prop-group"><label class="prop-label">이름</label><input type="text" class="prop-input" value="${name}" readonly></div>
            <div class="prop-group"><label class="prop-label">너비 (W)</label><input type="text" class="prop-input" value="${d.width} mm" readonly></div>
            <div class="prop-group"><label class="prop-label">높이 (H)</label><input type="text" class="prop-input" value="${d.height} mm" readonly></div>
            <div class="prop-group"><label class="prop-label">깊이 (D)</label><input type="text" class="prop-input" value="${d.depth} mm" readonly></div>
            <div style="margin-top: 15px; display: flex; gap: 5px;">
                <button onclick="window.repositionFurniture()" style="flex:1; background:#2196F3; color:white; border:none;">재배치</button>
                <button onclick="window.deleteFurniture()" style="flex:1; background:#f44336; color:white; border:none;">삭제</button>
            </div>
        `;
    } else if (d.isWall) {
        propTitle.innerText = "🧱 벽 속성"; 
        const len = Math.round(d.start.position.distanceTo(d.end.position));
        propContent.innerHTML = `
            <div class="prop-group"><label class="prop-label">길이 (mm)</label><input type="text" class="prop-input" value="${len}" readonly></div>
            <div class="prop-group"><label class="prop-label">두께 (mm)</label><input type="number" class="prop-input" value="${d.thickness}" onchange="window.onWallThicknessChange(this.value)"></div>`;
    } else if (d.isPillar) {
        propTitle.innerText = "🏛️ 기둥 속성";
        propContent.innerHTML = `
            <div class="prop-group"><label class="prop-label">크기</label><input type="number" class="prop-input" value="${d.size}" onchange="window.onPillarSizeChange(this.value)"></div>`;
    } else if (d.type === 'door' || d.type === 'window') {
        propTitle.innerText = (d.type === 'door') ? "🚪 문 속성" : "🪟 창문 속성";
        propContent.innerHTML = `
            <div class="prop-group"><label class="prop-label">너비 (mm)</label><input type="number" class="prop-input" value="${d.width}" onchange="window.onOpeningPropChange('width', this.value)"></div>
            <div class="prop-group"><label class="prop-label">높이 (mm)</label><input type="number" class="prop-input" value="${d.height}" onchange="window.onOpeningPropChange('height', this.value)"></div>
            <div class="prop-group"><label class="prop-label">바닥 띄움 (Elevation)</label><input type="number" class="prop-input" value="${d.elevation}" onchange="window.onOpeningPropChange('elevation', this.value)"></div>
        `;
    }
}

export function closePanel() {
    deselectObject();
}

export function switchTabUI(tabName) {
    const buildMenu = document.getElementById('menu-build');
    const furnMenu = document.getElementById('menu-furniture');
    const btnBuild = document.getElementById('tab-btn-build');
    const btnFurn = document.getElementById('tab-btn-furniture');

    if (tabName === 'build') {
        buildMenu.style.display = 'block';
        furnMenu.style.display = 'none';
        btnBuild.classList.add('active-tab');
        btnFurn.classList.remove('active-tab');
    } else {
        buildMenu.style.display = 'none';
        furnMenu.style.display = 'block';
        btnBuild.classList.remove('active-tab');
        btnFurn.classList.add('active-tab');
    }
}