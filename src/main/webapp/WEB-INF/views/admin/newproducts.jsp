<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 어드민 | 상품 등록</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 디자인 시스템 일관성 유지 */
        body {
            background-color: #fffaf5;
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            color: #4a3f35;
        }

        /* 2. 메인 컨테이너 (1열 배치를 위해 너비를 살짝 줄여 가독성 향상) */
        .admin-write-wrap {
            background: #ffffff;
            width: 90%;
            max-width: 900px; /* 1열일 때 가장 안정적인 너비 */
            margin: 60px auto 120px;
            padding: 80px 60px;
            border-radius: 35px;
            box-shadow: 0 10px 40px rgba(139, 126, 116, 0.05);
            border: 1px solid #f7ede2;
            box-sizing: border-box;
        }

        h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-weight: 700;
            color: #3d342c;
            text-align: center;
            margin-bottom: 60px;
            font-size: 2.2rem;
            letter-spacing: -0.02em;
        }

        hr {
            border: 0;
            height: 1px;
            background: #f0eeec;
            margin: -20px 0 50px;
        }

        /* 3. 1열 입력 폼 스타일 */
        .form-group {
            margin-bottom: 30px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }

        label {
            display: block;
            font-weight: 600;
            font-size: 0.95rem;
            color: #8b7e74;
            margin-bottom: 12px;
            padding-left: 5px;
        }
        
        input {
            width: 100%;
            padding: 18px 25px;
            border: 1px solid #f0eeec;
            border-radius: 12px;
            background-color: #fffdfb;
            font-size: 1rem;
            box-sizing: border-box;
            transition: all 0.3s;
            color: #4a3f35;
            font-family: inherit;
        }

        input:focus {
            outline: none;
            border-color: #8b7e74;
            box-shadow: 0 0 0 4px rgba(139, 126, 116, 0.05);
            background-color: #ffffff;
        }

        /* 4. 하단 버튼 영역 */
        .btn-area {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 60px;
        }

        .btn {
            width: 200px;
            padding: 20px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-align: center;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-submit {
            background-color: #8b7e74;
            color: white;
        }
        .btn-submit:hover {
            background-color: #4a3f35;
            transform: translateY(-2px);
        }

        .btn-cancel {
            background-color: #fff;
            color: #8b7e74;
            border: 1px solid #8b7e74;
        }
        .btn-cancel:hover {
            background-color: #fdfbf9;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <jsp:include page="../guest/Header.jsp" />

    <div class="admin-write-wrap">
        <h2>🛋️ 신규 상품 등록</h2>
        <hr>

        <form action="${pageContext.request.contextPath}/products/admin/new" method="post">
            <div class="form-group">
                <label>상품 코드</label>
                <input type="text" name="p_code" placeholder="예: CHAIR-01" required>
            </div>
            
            <div class="form-group">
                <label>상품명</label>
                <input type="text" name="p_name" placeholder="상품 이름을 입력하세요" required>
            </div>

            <div class="form-group">
                <label>가격</label>
                <input type="text" name="p_price" placeholder="숫자만 입력 (예: 150000)" required>
            </div>

            <div class="form-group">
                <label>색상</label>
                <input type="text" name="p_color" placeholder="예: Ivory, Walnut">
            </div>

            <div class="form-group">
                <label>형태 (가로/mm)</label>
                <input type="number" name="p_width" placeholder="mm 단위 입력">
            </div>

            <div class="form-group">
                <label>서브카테고리 ID</label>
                <input type="number" name="subcategoryId" placeholder="카테고리 번호" required>
            </div>

            <div class="form-group">
                <label>이미지 URL</label>
                <input type="text" name="p_image" placeholder="이미지 경로 혹은 외부 링크" required>
            </div>

            <div class="form-group">
                <label>평점 초기값</label>
                <input type="number" step="0.1" name="p_rating" placeholder="0.0 ~ 5.0">
            </div>

            <div class="btn-area">
                <button type="button" onclick="history.back();" class="btn btn-cancel">취소하기</button>
                <button type="submit" class="btn btn-submit">상품 등록 완료</button>
            </div>
        </form>
    </div>
</body>
</html>