// constants.js
export const SNAP_RADIUS = 200;
export const DEFAULT_WALL_THICKNESS = 100;
export const DEFAULT_PILLAR_SIZE = 150; 
export const ROTATION_STEP = Math.PI / 12; // [NEW] 15도

export const COLORS = {
    WALL: 0x8d6e63,
    PILLAR: 0x5d4037,
    SELECT: 0x4CAF50,
    HOVER_SELECT: 0x81C784,
    HOVER_DELETE: 0xE57373,
    DOOR: 0x8D6E63,
    WINDOW: 0x87CEEB,
    FURNITURE: 0x3F51B5, 
    COLLISION: 0xFF0000, 
    VALID: 0x00FF00
};

export const FURNITURE_DATA = {
    'desk': { name: '책상', width: 1200, height: 750, depth: 600, color: 0x8d6e63 },
    'chair': { name: '의자', width: 500, height: 900, depth: 500, color: 0x555555 }
};