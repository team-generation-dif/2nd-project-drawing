<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 어드민 | 공지사항 작성</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 전체 배경 및 초기화 (통일성 유지) */
        body {
            background-color: #fdfbf9; /* 웜 화이트 */
            font-family: 'Pretendard', -apple-system, sans-serif;
            color: #4a3f35;
            margin: 0;
            padding: 0;
        }

        /* 2. 메인 컨테이너 (취향 기록하기와 동일한 1100px) */
        .admin-write-wrap {
            background: #ffffff;
            width: 90%;
            max-width: 1100px;
            margin: 60px auto 120px;
            padding: 80px 60px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(139, 126, 116, 0.05);
            border: 1px solid rgba(231, 224, 217, 0.5);
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

        /* 3. 입력 폼 스타일 */
        .form-group {
            margin-bottom: 30px;
            max-width: 900px;
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
        
        input[type="text"], textarea {
            width: 100%;
            padding: 22px 28px;
            border: 1px solid #f0eeec;
            border-radius: 12px;
            background-color: #fff;
            font-size: 1.1rem;
            box-sizing: border-box;
            transition: all 0.3s;
            color: #4a3f35;
            font-family: inherit;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #8b7e74;
            box-shadow: 0 0 0 4px rgba(139, 126, 116, 0.05);
            background-color: #fffdfb;
        }

        textarea {
            min-height: 400px;
            line-height: 1.8;
            resize: vertical;
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
            border-radius: 12px;
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

        /* 등록하기 버튼 (메인 포인트 컬러) */
        .btn-save {
            background-color: #8b7e74;
            color: white;
        }
        .btn-save:hover {
            background-color: #4a3f35;
            transform: translateY(-2px);
        }

        /* 취소 버튼 (테두리 스타일) */
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
    <jsp:include page="/WEB-INF/views/guest/Header.jsp" />

    <div class="admin-write-wrap">
        <h2>📢 새 공지사항 작성</h2>
        <hr>

        <form action="/admin/notice_insert" method="post">
            <div class="form-group">
                <label>공지 제목</label>
                <input type="text" name="n_title" placeholder="제목을 입력하세요" required>
            </div>
            
            <div class="form-group">
                <label>공지 내용</label>
                <textarea name="n_content" placeholder="공지할 내용을 상세히 입력해주세요" required></textarea>
            </div>

            <div class="btn-area">
                <a href="/notice/list" class="btn btn-cancel">취소</a>
                <button type="submit" class="btn btn-save">등록하기</button>
            </div>
        </form>
    </div>
</body>
</html>