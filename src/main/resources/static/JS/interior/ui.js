// ui.js
import { state } from './state.js';
import { COLORS, FURNITURE_DATA } from './constants.js';
import { setMode } from './interaction.js';

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
        if (state.selectedObject.type === 'furniture') {
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
    deselectObject();
    state.selectedObject = d;
    if (!d.type) d.mesh.material.color.setHex(COLORS.SELECT);
    updatePanelUI(d);
    propertyPanel.classList.add('open');
}

export function updatePanelUI(d) {
    propContent.innerHTML = '';
    
    if (d.type === 'furniture') { 
        const info = FURNITURE_DATA[d.subType];
        const name = info ? info.name : d.subType;
        propTitle.innerText = `🪑 ${name} 속성`;
        // [수정] 가구 규격 입력 활성화 (onchange 이벤트 추가)
        propContent.innerHTML = `
            <div class="prop-group"><label class="prop-label">이름</label><input type="text" class="prop-input" value="${name}" readonly></div>
            <div class="prop-group"><label class="prop-label">너비 (W)</label><input type="number" class="prop-input" value="${d.width}" onchange="window.onFurniturePropChange('width', this.value)"></div>
            <div class="prop-group"><label class="prop-label">높이 (H)</label><input type="number" class="prop-input" value="${d.height}" onchange="window.onFurniturePropChange('height', this.value)"></div>
            <div class="prop-group"><label class="prop-label">깊이 (D)</label><input type="number" class="prop-input" value="${d.depth}" onchange="window.onFurniturePropChange('depth', this.value)"></div>
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

// 가구 목록 로드 함수
export function loadFurnitureList(subcategoryId) {
    const listContainer = document.getElementById('furniture-list');
    listContainer.innerHTML = '<p style="text-align:center;">로딩 중...</p>';

    // API 호출 (ProductsController에서 만든 주소)
    // 주의: 실제 DB의 category_id 구조에 맞춰 파라미터 조정 필요
    fetch('/user/interior/prodlist?subcategoryId=' + subcategoryId) 
        .then(res => res.json())
        .then(data => {
            listContainer.innerHTML = '';
            
            if (!data || data.length === 0) {
                listContainer.innerHTML = '<p style="text-align:center;">상품이 없습니다.</p>';
                return;
            }

            data.forEach(prod => {
                // p_width, p_depth, p_height가 null이면 기본값 처리
                const w = prod.p_width || 1000;
                const h = prod.p_height || 1000;
                const d = prod.p_depth || 1000;
                const img = prod.p_image || '/img/no-img.png';

                // 카드 생성
                const card = document.createElement('div');
                card.className = 'furn-card';
                card.style.cssText = 'border:1px solid #eee; margin-bottom:5px; padding:5px; cursor:pointer; display:flex; align-items:center; gap:10px;';
                card.innerHTML = `
                    <img src="${img}" style="width:50px; height:50px; object-fit:cover;">
                    <div>
                        <div style="font-size:12px; font-weight:bold;">${prod.p_name}</div>
                        <div style="font-size:11px; color:#666;">${w}x${d}x${h}</div>
                    </div>
                `;

                // [핵심] 클릭 시 해당 가구의 규격으로 모드 변경
                card.onclick = () => {
                    // 선택된 가구 스펙을 state에 임시 저장 (interaction.js에서 사용)
                    state.activeFurnitureSpecs = {
                        id: prod.p_code, // DB PK
                        width: w,
                        height: h,
                        depth: d,
                        color: 0x8d6e63 // 기본 색상 (나중에 이미지 텍스처 입히기 가능)
                    };
                    
                    // 기존: setMode('furniture', 'desk') -> 'desk'라는 문자열로 상수를 찾았음
                    // 변경: 'custom' 타입으로 보내고, 상세 스펙은 state.activeFurnitureSpecs 사용
                    setMode('furniture', 'custom'); 
                };

                listContainer.appendChild(card);
            });
        })
        .catch(err => {
            console.error(err);
            listContainer.innerHTML = '<p style="text-align:center;">불러오기 실패</p>';
        });
}