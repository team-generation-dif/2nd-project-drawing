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
const CATEGORY_COLORS = {
    1: 0x8D6E63, // 예: 소파 (갈색)
    2: 0xEF9A9A, // 예: 침대 (분홍)
    3: 0x90CAF9, // 예: 책상 (파랑)
    4: 0xA5D6A7, // 예: 수납장 (초록)
};
const DEFAULT_COLOR = 0xE0E0E0; // 매핑 안 된 것들 (베이지/회색)

export function resetUI() {
    inputEl.style.display = 'none'; 
    inputEl.value = ''; 
    infoTooltip.style.display = 'none';
    propertyPanel.classList.remove('open');
}

export function deselectObject() {
    if (state.selectedObject) {
        const obj = state.selectedObject;

        // [핵심] 아까 저장해둔 '원래 색상'이 있으면 그걸로 복구!
        if (obj.mesh && obj.mesh.material && obj.tempOriginalColor !== undefined) {
            obj.mesh.material.color.setHex(obj.tempOriginalColor);
            
            // 사용 끝난 임시 저장값 삭제 (깔끔하게)
            delete obj.tempOriginalColor;
        } 
        // (안전장치) 만약 저장된 색이 없으면 기존 로직대로 처리
        else if (obj.isWall) {
             obj.mesh.material.color.setHex(COLORS.WALL);
        } else if (obj.isPillar) {
             obj.mesh.material.color.setHex(COLORS.PILLAR);
        }
    }
    
    state.selectedObject = null;
    propertyPanel.classList.remove('open');
}

export function selectObject(d) {
    // 1. 기존 선택 해제
    deselectObject();

    state.selectedObject = d;

    if (d.mesh && d.mesh.material) {
        // [핵심 수정] 현재 객체가 '하이라이트(Hover)' 상태인지 확인
        // 하이라이트 상태라면 mesh의 현재 색(연두색)이 아니라, state에 저장된 '진짜 원래 색'을 가져와야 함
        if (state.hoveredObject === d.mesh && state.originalHex !== undefined && state.originalHex !== null) {
            d.tempOriginalColor = state.originalHex;
        } else {
            // 하이라이트 상태가 아니면 현재 색을 저장
            d.tempOriginalColor = d.mesh.material.color.getHex();
        }

        // 선택 색상 적용
        const selectColor = (typeof COLORS !== 'undefined' && COLORS.SELECT) ? COLORS.SELECT : 0x66BB6A;
        d.mesh.material.color.setHex(selectColor);
    }

    const propTitle = document.getElementById('propTitle');
    let titleText = "";
    
    if (d.type === 'furniture') {
        if (d.mesh && d.mesh.userData && d.mesh.userData.name) {
            titleText = d.mesh.userData.name;
        } else if (d.name) {
            titleText = d.name;
        } else if (FURNITURE_DATA[d.subType]) {
            titleText = FURNITURE_DATA[d.subType].name;
        } else {
            titleText = d.subType;
        }
    } else if (d.isWall) {
        titleText = "🧱 벽 (Wall)";
    } else if (d.isPillar) {
        titleText = "🏛️ 기둥 (Pillar)";
    }

    if (propTitle) propTitle.innerText = titleText;

    if (typeof updatePanelUI === 'function') {
        updatePanelUI(d);
    }

    propertyPanel.classList.add('open');
}

export function updatePanelUI(d) {
    propContent.innerHTML = '';
    
    if (d.type === 'furniture') { 
        // [수정] 이름 결정 로직: 1순위(메쉬 저장값) -> 2순위(데이터값) -> 3순위(상수값) -> 4순위(기본값)
        let displayName = d.subType;

        if (d.mesh && d.mesh.userData && d.mesh.userData.name) {
            displayName = d.mesh.userData.name; // 아까 저장한 "엔틱 책상" 등이 여기 들어있음
        } else if (d.name) {
            displayName = d.name;
        } else if (FURNITURE_DATA[d.subType]) {
            displayName = FURNITURE_DATA[d.subType].name;
        }

        // 제목 업데이트
        propTitle.innerText = `🪑 ${displayName} 속성`;

        // [수정] 가구 규격 입력 활성화 (이름 칸에도 displayName 적용)
        propContent.innerHTML = `
            <div class="prop-group"><label class="prop-label">이름</label><input type="text" class="prop-input" value="${displayName}" readonly></div>
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
export function loadFurnitureList(categoryId) {
    const listContainer = document.getElementById('furniture-list');
    listContainer.innerHTML = '<p style="text-align:center;">로딩 중...</p>';
	let url;
	if (categoryId === 'favorites') {
        url = '/user/interior/favlist'; // 찜 목록 API
    } else {
        url = '/user/interior/prodlist?categoryId=' + categoryId; // 기존 API
    }
	
    fetch(url) 
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
                const img = prod.p_image || '/images/no-img.png';

                // 카드 생성
                const card = document.createElement('div');
                card.className = 'furn-card';
                card.style.cssText = 'border:1px solid #eee; margin-bottom:5px; padding:5px; cursor:pointer; display:flex; align-items:center; gap:10px;';
                card.innerHTML = `
                    <img src="${img}" style="width:50px; height:50px; object-fit:cover;">
                    <div>
                        <div style="font-size:12px; font-weight:bold;">${prod.p_name}</div>
                        <div style="font-size:11px; color:#666;">${w/10}x${d/10}x${h/10} (cm)</div>
                    </div>
                `;

                // [핵심] 클릭 시 해당 가구의 규격으로 모드 변경
                card.onclick = () => {
					// 카테고리별 색상
					const myColor = CATEGORY_COLORS[prod.subcategoryId] || DEFAULT_COLOR;
					// 선택된 가구 스펙을 state에 임시 저장 (interaction.js에서 사용)
                    state.activeFurnitureSpecs = {
                        id: prod.p_code, // DB PK
						name: prod.p_name,
                        width: w,
                        height: h,
                        depth: d,
                        color: myColor // 기본 색상 (나중에 이미지 텍스처 입히기 가능)
                    };
                    
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