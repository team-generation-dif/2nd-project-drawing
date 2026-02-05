<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 관리자 | 회원 관리</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600&display=swap');

        body {
            background-color: #fffaf5; /* 전체 배경 아이보리 톤 */
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
            border: 2px solid #f7ede2;
            box-shadow: 0 10px 30px rgba(139, 126, 116, 0.05);
        }

        /* 상단 헤더 섹션 */
        .header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #fcf6f0;
        }

        .header-flex h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 1.8rem;
            margin: 0;
            color: #4a3f35;
        }

        /* 버튼 스타일 */
        .btn-user-page {
            text-decoration: none;
            background-color: #8b7e74;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 0.9rem;
            transition: 0.3s;
        }

        .btn-user-page:hover {
            background-color: #4a3f35;
            transform: translateY(-2px);
        }

        /* 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 10px;
        }

        th {
            background-color: #fcf6f0;
            color: #8b7e74;
            font-weight: 600;
            padding: 15px;
            border-bottom: 2px solid #f7ede2;
            font-size: 0.95rem;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #fcf6f0;
            text-align: center;
            font-size: 0.9rem;
            vertical-align: middle;
        }

        tr:hover td {
            background-color: #fffdfb;
        }

        /* 상세보기 링크 */
        .link-detail {
            color: #e76f51;
            text-decoration: none;
            font-weight: 600;
            border-bottom: 1px solid transparent;
        }

        .link-detail:hover {
            border-bottom: 1px solid #e76f51;
        }

        /* 배지 스타일 */
        .badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .badge-local { background: #eef2ff; color: #4338ca; }
        .badge-kakao { background: #fee500; color: #3c1e1e; }

        /* 강퇴 버튼 */
        .btn-force-delete {
            background-color: #fff0f0;
            color: #ff4d4f;
            border: 1px solid #ffccc7;
            padding: 6px 12px;
            cursor: pointer;
            border-radius: 15px;
            font-size: 0.8rem;
            transition: 0.2s;
        }

        .btn-force-delete:hover {
            background-color: #ff4d4f;
            color: white;
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
                    <th>상세</th>
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
    <c:when test="${m.login_type eq 'NORMAL'}">
        <span class="badge badge-local">일반 계정</span>
    </c:when>
    <c:when test="${m.login_type eq 'KAKAO'}">
        <span class="badge badge-kakao">카카오</span>
    </c:when>
    <c:otherwise>
        <span class="badge badge-local">일반 계정</span>
    </c:otherwise>
</c:choose>

                        </td>
                        <td>
                            <span style="color: ${m.m_role eq 'ROLE_ADMIN' ? '#e76f51' : '#8b7e74'}">
                                ${m.m_role}
                            </span>
                        </td>
                        <td>
                            <a href="/admin/userDetail?m_id=${m.m_id}" class="link-detail">조회</a>
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
    </div>
</body>
</html>