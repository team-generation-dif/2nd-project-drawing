<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 어드민 | 공지사항 목록</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 디자인 시스템 통일 */
        body {
            background-color: #fffaf5;
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            color: #4a3f35;
        }

        .admin-container {
            max-width: 1100px;
            margin: 60px auto;
            padding: 50px 60px;
            background: #ffffff;
            border-radius: 35px;
            border: 1px solid #f7ede2;
            box-shadow: 0 10px 30px rgba(139, 126, 116, 0.05);
            box-sizing: border-box;
        }

        /* 2. 헤더 섹션 */
        .header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding-bottom: 25px;
            border-bottom: 2px solid #fcf6f0;
        }

        .header-flex h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2rem;
            margin: 0;
            color: #3d342c;
            letter-spacing: -0.02em;
        }

        /* 3. 글쓰기 버튼 (관리자용) */
        .btn-write {
            text-decoration: none;
            background-color: #8b7e74;
            color: white;
            padding: 12px 28px;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 12px rgba(139, 126, 116, 0.15);
        }

        .btn-write:hover {
            background-color: #4a3f35;
            transform: translateY(-2px);
        }

        /* 4. 테이블 스타일 최적화 */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        th {
            background-color: #fcf6f0;
            color: #8b7e74;
            font-weight: 600;
            padding: 20px 15px;
            border-bottom: 2px solid #f7ede2;
            font-size: 0.95rem;
            text-transform: uppercase;
        }

        td {
            padding: 20px 15px;
            border-bottom: 1px solid #fcf6f0;
            text-align: center;
            font-size: 1rem;
            transition: background 0.2s;
        }

        tr:hover td {
            background-color: #fffdfb;
        }

        /* 제목 링크 스타일 */
        .notice-link {
            text-decoration: none;
            color: #4a3f35;
            font-weight: 500;
            transition: color 0.2s;
            display: block;
            text-align: left;
            padding-left: 20px;
        }

        .notice-link:hover {
            color: #e76f51; /* 포인트 컬러로 강조 */
        }

        .date-col {
            color: #a39485;
            font-size: 0.9rem;
        }

        .empty-msg {
            padding: 100px 0 !important;
            color: #ccc;
            font-style: italic;
        }

        /* 번호 배지 스타일 */
        .no-badge {
            color: #bcaaa4;
            font-size: 0.85rem;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/guest/Header.jsp" />

    <div class="admin-container">
        <div class="header-flex">
            <h2>📢 공지사항</h2>
            <sec:authorize access="hasRole('ADMIN')">
                <a href="/admin/notice_write" class="btn-write">+ 새 공지 작성</a>
            </sec:authorize>
        </div>

        <table>
            <thead>
                <tr>
                    <th style="width: 12%">번호</th>
                    <th style="width: 63%">제목</th>
                    <th style="width: 25%">작성일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="notice" items="${list}">
                            <tr>
                                <td><span class="no-badge">${notice.n_code}</span></td>
                                <td>
                                    <a href="/notice/detail?n_code=${notice.n_code}" class="notice-link">
                                        ${notice.n_title}
                                    </a>
                                </td>
                                <td class="date-col">
                                    <fmt:formatDate value="${notice.n_date}" pattern="yyyy. MM. dd"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="3" class="empty-msg">등록된 공지사항이 아직 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</body>
</html>