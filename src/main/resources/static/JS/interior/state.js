// state.js
import * as THREE from 'three';

export const state = {
    mode: 'select',
    isDrawing: false,
    startPillar: null,
    previewObject: null,
    
    activeFurnitureId: null,
    
    // [NEW] 가구 드래그 관련 상태
    draggingFurniture: null, 
    dragStartPos: null,      
    dragStartRotation: 0,
    
    isUserTyping: false,
    lastMouseEvent: null,
    draggingPillar: null,
    selectedObject: null,
    hoveredObject: null,
    originalHex: null,

    isPanning: false,
    panStartMouse: new THREE.Vector2(),

    pillars: [],
    walls: [],
    floors: [],
    openings: [],
    furnitures: [],

    wallHeight: 2400
};