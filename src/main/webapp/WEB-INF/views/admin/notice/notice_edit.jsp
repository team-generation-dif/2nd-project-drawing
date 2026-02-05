<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 관리자 | 공지사항 수정</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 전체 배경 및 초기화 (기록하기 페이지와 동일) */
        body {
            background-color: #fdfbf9; /* 헤더와 어울리는 웜 화이트 */
            font-family: 'Pretendard', -apple-system, sans-serif;
            color: #4a3f35;
            margin: 0;
            padding: 0;
        }

        /* 2. 메인 컨테이너 (기록하기 페이지의 .write-wrapper와 동일하게 설정) */
        .admin-write-wrap {
            background: #ffffff;
            width: 90%;
            max-width: 1200px; /* 취향 기록하기 페이지와 동일한 너비 */
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

        /* 구분선 */
        hr {
            border: 0;
            height: 1px;
            background: #f0eeec;
            margin: -20px 0 50px;
        }

        /* 3. 입력 폼 (기록하기 페이지 스타일 적용) */
        .form-group {
            margin-bottom: 30px;
            max-width: 900px; /* 입력창이 너무 넓어지지 않게 가이드 */
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

        /* 4. 하단 버튼 (기록하기 페이지와 동일한 크기 및 컬러) */
        .btn-area {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 60px;
        }

        .btn {
            width: 200px; /* 버튼 고정폭 통일 */
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

        /* 수정 완료 (기록 완료와 동일색상) */
        .btn-update {
            background-color: #8b7e74;
            color: white;
        }
        .btn-update:hover {
            background-color: #766b62;
            transform: translateY(-2px);
        }

        /* 삭제 버튼 (취소와 동일한 스타일이되 붉은 포인트) */
        .btn-delete {
            background-color: #fff;
            color: #d97d6a; /* 세련된 테라코타 레드 */
            border: 1px solid #d97d6a;
        }
        .btn-delete:hover {
            background-color: #fffcfb;
            box-shadow: 0 4px 12px rgba(217, 125, 106, 0.1);
            transform: translateY(-2px);
        }

    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/guest/Header.jsp" />

    <div class="admin-write-wrap">
        <h2>✏️ 공지사항 수정</h2>


        <form action="/admin/notice_update" method="post">
            <input type="hidden" name="n_code" value="${dto.n_code}">
            
            <div class="form-group">
                <label>공지 제목</label>
                <input type="text" name="n_title" value="${dto.n_title}" required placeholder="제목을 입력하세요">
            </div>
            
            <div class="form-group">
                <label>공지 내용</label>
                <textarea name="n_content" required placeholder="내용을 입력하세요">${dto.n_content}</textarea>
            </div>

            <div class="btn-area">
                <a href="javascript:void(0);" onclick="confirmDelete()" class="btn btn-delete">삭제하기</a>
                <button type="submit" class="btn btn-update">수정 완료</button>
            </div>
        </form>
    </div>

    <script>
        function confirmDelete() {
            if(confirm("정말로 이 공지사항을 삭제하시겠습니까?")) {
                location.href = "/admin/notice_delete?n_code=${dto.n_code}";
            }
        }
    </script>
</body>
</html>