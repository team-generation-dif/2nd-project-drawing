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
        /* 1. 디자인 시스템 통일 */
        body {
            background-color: #fffaf5;
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            color: #4a3f35;
        }

        .notice-detail-wrap {
            max-width: 900px;
            margin: 60px auto 120px;
            padding: 0 20px;
        }

        .notice-card {
            background: #ffffff;
            border-radius: 35px;
            border: 1px solid #f7ede2;
            box-shadow: 0 10px 40px rgba(139, 126, 116, 0.05);
            padding: 60px 50px;
            box-sizing: border-box;
        }

        /* 2. 상단 타이틀 영역 */
        .notice-header {
            border-bottom: 2px solid #fcf6f0;
            padding-bottom: 30px;
            margin-bottom: 40px;
        }

        .notice-header h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2rem;
            color: #3d342c;
            margin: 0 0 15px 0;
            line-height: 1.4;
        }

        .notice-info {
            font-size: 0.9rem;
            color: #a39485;
            display: flex;
            gap: 20px;
        }

        /* 3. 본문 영역 */
        .notice-content {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #4a3f35;
            min-height: 300px;
            white-space: pre-wrap; /* 줄바꿈 유지 */
        }

        /* 4. 버튼 영역 */
        .btn-group {
            margin-top: 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn {
            padding: 14px 28px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-list {
            background-color: #fff;
            color: #8b7e74;
            border: 1px solid #8b7e74;
        }
        .btn-list:hover { background-color: #fdfbf9; }

        .admin-controls {
            display: flex;
            gap: 10px;
        }

        .btn-edit {
            background-color: #8b7e74;
            color: white;
        }
        .btn-edit:hover { background-color: #4a3f35; transform: translateY(-2px); }

        .btn-delete {
            background-color: #fff0f0;
            color: #ff4d4f;
            border: 1px solid #ffccc7;
        }
        .btn-delete:hover { background-color: #ff4d4f; color: white; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/guest/Header.jsp" />

    <div class="notice-detail-wrap">
        <article class="notice-card">
            <header class="notice-header">
                <h2>${notice.n_title}</h2>
                <div class="notice-info">
                    <span>관리자</span>
                    <span>No. ${notice.n_code}</span>
                </div>
            </header>

            <div class="notice-content">
                ${notice.n_content}
            </div>

            <div class="btn-group">
                <a href="/notice/list" class="btn btn-list">목록으로</a>

                <div class="admin-controls">
                    <sec:authorize access="hasRole('ADMIN')">
                        <a href="/admin/notice_edit?n_code=${notice.n_code}" class="btn btn-edit">수정하기</a>
                        <a href="javascript:void(0);" 
                           onclick="if(confirm('이 공지사항을 삭제하시겠습니까?')) location.href='/admin/notice_delete?n_code=${notice.n_code}'" 
                           class="btn btn-delete">삭제하기</a>
                    </sec:authorize>
                </div>
            </div>
        </article>
    </div>
</body>
</html>