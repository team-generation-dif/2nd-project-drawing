<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>인테리어 목록</title>
    <style>
        /* 1. 기본 배경 및 폰트 */
        body {
            background-color: #fffaf5; /* 그리다 시그니처 아이보리 */
            font-family: 'Pretendard', sans-serif;
            color: #5d5a58;
            margin: 0;
            padding: 0; /* 헤더가 sticky이므로 상단 패딩 제거 */
        }

        .container { 
            max-width: 1100px; 
            margin: 0 auto; 
            padding: 40px 20px; /* 본문 상하 여백 부여 */
        }

        /* 2. 페이지 타이틀 영역 (기존 header 클래스 수정) */
        .page-title-area { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 40px; 
        }

        .page-title-area h2 { 
            font-family: 'Nanum Myeongjo', serif; 
            font-size: 1.8rem; 
            color: #4a3f35; 
            margin: 0;
        }

        /* 3. 사진 올리기 버튼 */
        .btn-write { 
            padding: 12px 25px; 
            background: #8b7e74; 
            color: white; 
            border: none; 
            border-radius: 18px; 
            cursor: pointer; 
            font-weight: 600; 
            transition: 0.3s;
            box-shadow: 0 4px 10px rgba(139, 126, 116, 0.2);
        }

        .btn-write:hover { 
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(139, 126, 116, 0.3);
        }

        /* 4. 카드 그리드 및 카드 스타일 (기존과 동일) */
        .board-grid { 
            display: grid; 
            grid-template-columns: repeat(3, 1fr); 
            gap: 35px; 
        }

        .board-card { 
            background: #fff;
            border-radius: 30px; 
            overflow: hidden; 
            box-shadow: 0 10px 25px rgba(139, 126, 116, 0.08); 
            transition: all 0.3s ease;
            cursor: pointer;
            border: 1px solid #f7ede2;
        }

        .board-card:hover { 
            transform: translateY(-10px); 
            box-shadow: 0 15px 35px rgba(139, 126, 116, 0.15);
        }

        .img-wrapper { 
            width: 100%; 
            height: 300px; 
            overflow: hidden; 
            position: relative;
            background-color: #fcfcfc;
        }

        .img-wrapper img { 
            width: 100%; height: 100%; object-fit: cover; 
            transition: transform 0.5s ease;
        }

        .tag-count {
            position: absolute; top: 15px; right: 15px;
            background: rgba(255, 255, 255, 0.85); 
            backdrop-filter: blur(4px);
            color: #8b7e74;
            padding: 6px 12px; border-radius: 12px; 
            font-size: 11px; font-weight: 800;
        }

        .info-wrapper { padding: 20px 25px; }
        .info-wrapper .title { 
            font-size: 1.1rem; font-weight: 700; color: #4a3f35; 
            margin-bottom: 10px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; 
        }
        .info-wrapper .author { color: #bcaaa4; font-size: 0.85rem; display: flex; align-items: center; }
        .info-wrapper .author::before { content: '작성자. '; margin-right: 4px; }
    </style>
</head>
<body>
   <jsp:include page="/WEB-INF/views/guest/Header.jsp" />

    <div class="container">
        <div class="page-title-area">
            <h2>게시판 둘러보기</h2>
            <button class="btn-write" onclick="location.href='/user/write'">사진 올리기</button>
        </div>

        <div class="board-grid">
            <c:forEach items="${list}" var="b">
                <div class="board-card" onclick="location.href='/user/detail?b_code=${b.b_code}'">
                    <div class="img-wrapper">
                        <img src="/upload/${b.b_image}" alt="게시글 이미지" onerror="this.src='https://via.placeholder.com/300x250?text=No+Image'">
                        <div class="tag-count">TAG</div>
                    </div>
                    <div class="info-wrapper">
                        <div class="title">${b.b_title}</div>
                        <div class="author">${b.m_nick}</div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>