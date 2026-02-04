# wall_extractor.py
import cv2
import numpy as np
import sys
import json
import traceback


# 여백 제거 및 내용물 영역 크롭 함수
def crop_whitespace(img):
    try:
        # 1. 흑백 변환 및 반전 (배경이 흰색이라고 가정)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        # 2. 이진화: 아주 연한 회색(250)보다 밝은건 다 배경(0)으로, 나머지는 내용물(255)로
        # THRESH_BINARY_INV: 흰색 배경을 검은색으로, 그려진 선을 흰색으로 바꿈
        _, thresh = cv2.threshold(gray, 240, 255, cv2.THRESH_BINARY_INV)

        # 3. 내용물(흰색 픽셀)의 좌표 찾기
        points = cv2.findNonZero(thresh)

        if points is not None:
            # 4. 최소 사각형(Bounding Box) 구하기
            x, y, w, h = cv2.boundingRect(points)

            # 너무 작은 노이즈만 잡힌 경우(100픽셀 미만)는 크롭하지 않음
            if w < 100 or h < 100:
                return img

            # 5. 약간의 여백(Padding)을 줘서 크롭 (벽이 잘리지 않게)
            padding = 10
            h_img, w_img = img.shape[:2]

            x1 = max(0, x - padding)
            y1 = max(0, y - padding)
            x2 = min(w_img, x + w + padding)
            y2 = min(h_img, y + h + padding)

            return img[y1:y2, x1:x2]

        return img  # 내용물을 못 찾으면 원본 반환

    except Exception:
        return img  # 에러나면 원본 반환


def extract_walls(image_path, real_width_mm):
    try:
        # 1. 이미지 로드
        stream = open(image_path.encode("utf-8"), "rb")
        bytes = bytearray(stream.read())
        numpyarray = np.asarray(bytes, dtype=np.uint8)
        img = cv2.imdecode(numpyarray, cv2.IMREAD_UNCHANGED)

        if img is None:
            print(json.dumps([]))
            return

        # [핵심 수정] 여백 제거 수행! ✂️
        # 이제 img 변수에는 흰 배경이 잘려나간 '알맹이'만 남습니다.
        img = crop_whitespace(img)

        # 2. 스케일 계산 (이제 w는 '여백 없는 실제 도면의 너비'입니다)
        h, w = img.shape[:2]

        try:
            real_width_mm = float(real_width_mm)
            SCALE = real_width_mm / w
        except:
            SCALE = 20.0

        # 3. K-Means (색상 단순화) - K=8 유지
        if len(img.shape) == 2:
            data = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR).reshape((-1, 3))
        else:
            data = img.reshape((-1, 3))

        data = np.float32(data)
        criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 10, 1.0)
        K = 8
        _, label, center = cv2.kmeans(data, K, None, criteria, 10, cv2.KMEANS_RANDOM_CENTERS)

        center = np.uint8(center)
        brightness = np.sum(center, axis=1)

        # 어두운 색상 추출 (기준값 150)
        wall_clusters = np.where(brightness < 150)[0]
        if len(wall_clusters) == 0:
            wall_clusters = [np.argmin(brightness)]

        mask = np.isin(label.flatten(), wall_clusters)
        result_mask = mask.reshape((h, w)).astype(np.uint8) * 255

        # 4. 전처리 (Morphology)
        kernel = np.ones((3, 3), np.uint8)
        opening = cv2.morphologyEx(result_mask, cv2.MORPH_OPEN, kernel, iterations=1)
        closing = cv2.morphologyEx(opening, cv2.MORPH_CLOSE, kernel, iterations=2)

        # 5. 뼈대화 (Skeletonization)
        if hasattr(cv2, 'ximgproc'):
            skeleton = cv2.ximgproc.thinning(closing)
        else:
            skeleton = custom_thinning(closing)

        # 6. 선분 감지
        # 이미지가 크롭되어 작아졌을 수 있으므로 최소 길이 비율 조정
        min_len = int(w * 0.02)
        if min_len < 10: min_len = 10

        lines = cv2.HoughLinesP(skeleton, 1, np.pi / 180, threshold=20, minLineLength=min_len, maxLineGap=15)

        walls = []
        cx, cy = w // 2, h // 2

        if lines is not None:
            for line in lines:
                x1, y1, x2, y2 = line[0]

                # 좌표 변환 및 정수형(int) 처리
                walls.append({
                    "x1": int((x1 - cx) * SCALE),
                    "z1": int((y1 - cy) * SCALE),
                    "x2": int((x2 - cx) * SCALE),
                    "z2": int((y2 - cy) * SCALE)
                })

        print(json.dumps(walls))

    except Exception as e:
        error_msg = {
            "error": str(e),
            "trace": traceback.format_exc()
        }
        print(json.dumps([error_msg]))


# 수동 뼈대화 함수
def custom_thinning(img):
    size = np.size(img)
    skeleton = np.zeros(img.shape, np.uint8)
    element = cv2.getStructuringElement(cv2.MORPH_CROSS, (3, 3))
    done = False
    while not done:
        eroded = cv2.erode(img, element)
        temp = cv2.dilate(eroded, element)
        temp = cv2.subtract(img, temp)
        skeleton = cv2.bitwise_or(skeleton, temp)
        img = eroded.copy()
        zeros = size - cv2.countNonZero(img)
        if zeros == size: done = True
    return skeleton


if __name__ == "__main__":
    if len(sys.argv) > 1:
        img_path = sys.argv[1]
        real_w = sys.argv[2] if len(sys.argv) > 2 else 15000
        extract_walls(img_path, real_w)
    else:
        print(json.dumps([]))