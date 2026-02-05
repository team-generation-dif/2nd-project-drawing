<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 | 공지사항</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 기본 배경 및 폰트 설정 (게시글 상세와 통일) */
        body {
            background-color: #fffaf5; /* 따뜻한 아이보리 */
            font-family: 'Pretendard', sans-serif;
            color: #5d5a58;
            margin: 0;
            padding: 0; /* 헤더가 있으므로 상단 패딩 제거 */
        }

        /* 2. 메인 컨테이너 (detail-wrapper 스타일 계승) */
        .notice-wrapper {
            background: #ffffff;
            width: 100%;
            max-width: 760px; /* 게시글 상세와 동일한 폭 */
            margin: 80px auto; /* 중앙 정렬 및 여백 */
            padding: 50px 40px;
            border-radius: 40px; /* 시그니처 곡률 */
            box-shadow: 0 15px 35px rgba(139, 126, 116, 0.1);
            border: 1px solid #f7ede2;
            box-sizing: border-box;
        }

        /* 3. 상단 타이틀 영역 (header-area 스타일 계승) */
        .notice-header {
            text-align: center;
            margin-bottom: 45px;
            border-bottom: 1px solid #fcf6f0;
            padding-bottom: 30px;
        }

        .notice-title {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2.2rem; /* 게시글 상세와 동일 크기 */
            color: #4a3f35;
            margin-bottom: 15px;
            line-height: 1.3;
        }

        .notice-meta {
            font-size: 0.9rem;
            color: #bcaaa4; /* 연한 브라운 */
        }

        /* 4. 본문 영역 (content-text 스타일 계승) */
        .notice-content {
            font-size: 1.05rem;
            line-height: 1.9;
            color: #5d5a58;
            white-space: pre-wrap;
            min-height: 300px;
            padding: 0 10px;
        }

        /* 5. 하단 버튼 영역 (action-buttons 스타일 계승) */
        .action-buttons {
            margin-top: 50px;
            display: flex;
            justify-content: center;
            gap: 12px;
        }

        .btn {
            padding: 12px 28px;
            border-radius: 18px; /* 버튼 곡률 통일 */
            border: 1px solid #eee;
            cursor: pointer;
            font-size: 0.95rem;
            font-weight: 600;
            transition: 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        /* 버튼 컬러 시스템 적용 */
        .btn-list { 
            background-color: #fafafa; 
            color: #8b7e74; 
            border: 1px solid #eee;
        }
        
        .btn-edit { 
            background-color: #fff; 
            border-color: #ffccbb; 
            color: #e76f51; /* 수정 버튼 포인트 컬러 */
        }
        
        .btn-delete { 
            background-color: #8b7e74; 
            color: #fff; 
            border: none; 
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(139, 126, 116, 0.1);
        }

        .admin-controls {
            display: flex;
            gap: 12px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/guest/Header.jsp" />

    <div class="notice-wrapper">
        <header class="notice-header">
            <h1 class="notice-title">${notice.n_title}</h1>
            <div class="notice-meta">
                작성자. 관리자 <span style="margin: 0 10px; color:#f7ede2;">|</span> No. ${notice.n_code}
            </div>
        </header>

        <div class="notice-content">
            ${notice.n_content}
        </div>

        <div class="action-buttons">
            <a href="/notice/list" class="btn btn-list">목록으로</a>

            <sec:authorize access="hasRole('ADMIN')">
                <div class="admin-controls">
                    <a href="/admin/notice_edit?n_code=${notice.n_code}" class="btn btn-edit">공지 수정</a>
                    <button type="button" class="btn btn-delete" 
                            onclick="if(confirm('이 공지사항을 정말 삭제하시겠습니까?')) location.href='/admin/notice_delete?n_code=${notice.n_code}'">
                        공지 삭제
                    </button>
                </div>
            </sec:authorize>
        </div>
    </div>
</body>
</html>