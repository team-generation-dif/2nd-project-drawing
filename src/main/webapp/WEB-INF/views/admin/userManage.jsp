<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 관리자 | 회원 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 디자인 시스템 일관성 유지 */
        body {
            background-color: #fffaf5; 
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            color: #4a3f35;
        }

        .admin-container {
            max-width: 1200px;
            margin: 60px auto 120px;
            padding: 50px 60px;
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #f7ede2;
            box-shadow: 0 10px 30px rgba(139, 126, 116, 0.05);
        }

        .header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #8b7e74; /* 상품 페이지와 통일 */
        }

        .header-flex h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2rem;
            margin: 0;
            color: #4a3f35;
        }

        /* 2. 테이블 스타일 최적화 */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 10px;
            background: #fff;
        }

        th {
            background-color: #fcf6f0;
            color: #8b7e74;
            font-weight: 700;
            padding: 18px 15px;
            border-bottom: 1px solid #f7ede2;
            font-size: 0.95rem;
        }

        td {
            padding: 18px 15px;
            border-bottom: 1px solid #fcf6f0;
            text-align: center;
            font-size: 0.95rem;
            vertical-align: middle;
        }

        tr:hover td { background-color: #fffdfb; }

        /* 배지 및 버튼 */
        .badge { padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; }
        .badge-local { background: #eef2ff; color: #4338ca; }
        .badge-kakao { background: #fee500; color: #3c1e1e; }

        .btn-force-delete {
            background-color: #f4edea;
            color: #d9534f;
            border: 1px solid #f2e1df;
            padding: 8px 14px;
            cursor: pointer;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-force-delete:hover {
            background-color: #d9534f;
            color: white;
        }

        /* 3. [중요] 그리다 페이징 스타일 (통일) */
        .pagination-wrapper {
            margin-top: 50px;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
        }

        .grida-page-link {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            background: #fff;
            color: #8b7e74;
            text-decoration: none;
            font-weight: 600;
            border: 1px solid #f7ede2;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: all 0.3s ease;
            font-size: 0.9rem;
        }

        .grida-page-link:hover:not(.active) {
            background: #fdfbf9;
            border-color: #8b7e74;
            transform: translateY(-2px);
        }

        .grida-page-link.active {
            background: #8b7e74;
            color: #fff !important;
            border-color: #8b7e74;
            box-shadow: 0 5px 15px rgba(139, 126, 116, 0.2);
        }
    </style>
</head>
<body>
    <jsp:include page="../guest/Header.jsp" />

    <div class="admin-container">
        <div class="header-flex">
            <h2>전체 회원 목록 관리</h2>
        </div>

        <table>
            <thead>
                <tr>
                    <th>아이디</th>
                    <th>이름 (닉네임)</th>
                    <th>이메일</th>
                    <th>가입유형</th>
                    <th>권한</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="m" items="${userList}">
                    <tr>
                        <td>${m.m_id}</td>
                        <td style="font-weight: 600;">${m.m_name} (${m.m_nick})</td>
                        <td style="color: #a39485;">${m.m_email}</td>
                        <td>
                            <c:choose>
                                <c:when test="${m.login_type eq 'KAKAO'}">
                                    <span class="badge badge-kakao">카카오</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-local">일반 계정</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span style="color: ${m.m_role eq 'ROLE_ADMIN' ? '#e76f51' : '#8b7e74'}; font-weight: 600;">
                                ${m.m_role}
                            </span>
                        </td>
                        <td>
                            <button type="button" class="btn-force-delete" 
                                    onclick="if(confirm('${m.m_id}님을 강제 탈퇴시키겠습니까?')) location.href='/admin/forceDelete?m_id=${m.m_id}'">
                                강퇴
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="pagination-wrapper">
            <c:if test="${totalPages > 1}">
                
                <c:if test="${currentPage > 1}">
                    <a href="?page=${currentPage-1}" class="grida-page-link">&lt;</a>
                </c:if>

                <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
                <c:set var="endPage" value="${startPage + 4 > totalPages ? totalPages : startPage + 4}" />
                <c:if test="${endPage == totalPages && endPage - 4 > 0}">
                    <c:set var="startPage" value="${endPage - 4}" />
                </c:if>

                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <a href="?page=${i}" class="grida-page-link ${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="?page=${currentPage+1}" class="grida-page-link">&gt;</a>
                </c:if>
                
            </c:if>
        </div>
    </div>
</body>
</html>