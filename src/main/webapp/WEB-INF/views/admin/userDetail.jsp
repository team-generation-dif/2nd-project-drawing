<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 관리자 | 작가 상세 정보</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 디자인 시스템 통일 */
        body {
            background-color: #fffaf5;
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            color: #4a3f35;
        }

        .detail-wrapper {
            max-width: 600px; /* 가독성을 위해 살짝 조절 */
            margin: 80px auto;
            padding: 0 20px;
        }

        .detail-card {
            background: #ffffff;
            border-radius: 35px; /* 관리자 페이지 곡률 통일 */
            box-shadow: 0 15px 40px rgba(139, 126, 116, 0.06);
            border: 1px solid #f7ede2;
            padding: 60px 50px;
            position: relative;
            overflow: hidden;
        }

        /* 상단 포인트 라인 - 브랜드 컬러로 세련되게 */
        .detail-card::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 6px;
            background: #8b7e74;
        }

        .detail-card h3 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2rem;
            text-align: center;
            margin-bottom: 50px;
            color: #3d342c;
            letter-spacing: -0.02em;
        }

        /* 정보 행 레이아웃 */
        .info-group {
            margin-bottom: 20px;
        }

        .info-row {
            display: flex;
            align-items: center;
            padding: 20px 10px;
            border-bottom: 1px solid #fcf6f0;
            transition: background 0.2s;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .label {
            font-weight: 600;
            width: 110px;
            color: #8b7e74;
            font-size: 0.95rem;
        }

        .value {
            flex: 1;
            color: #4a3f35;
            font-size: 1.05rem;
        }

        /* 권한 배지 스타일 통일 */
        .role-badge {
            display: inline-block;
            padding: 5px 14px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 700;
            background-color: #fcf6f0;
            color: #e76f51; /* 포인트 컬러 */
            border: 1px solid #f9e8de;
        }

        /* 버튼 영역 */
        .btn-area {
            margin-top: 50px;
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .btn {
            width: 140px;
            padding: 15px 0;
            border-radius: 25px;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-align: center;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-back {
            background-color: #fff;
            color: #8b7e74;
            border: 1px solid #8b7e74;
        }

        .btn-back:hover {
            background-color: #fdfbf9;
        }

        .btn-edit {
            background-color: #8b7e74;
            color: white;
        }

        .btn-edit:hover {
            background-color: #4a3f35;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <jsp:include page="../guest/Header.jsp" />

    <div class="detail-wrapper">
        <div class="detail-card">
            <h3>회원 상세 정보</h3>
            
            <div class="info-group">
                <div class="info-row">
                    <span class="label">아이디</span>
                    <span class="value">${user.m_id}</span>
                </div>
                <div class="info-row">
                    <span class="label">이름</span>
                    <span class="value">${user.m_name}</span>
                </div>
                <div class="info-row">
                    <span class="label">닉네임</span>
                    <span class="value">${user.m_nick}</span>
                </div>
                <div class="info-row">
                    <span class="label">이메일</span>
                    <span class="value" style="color: #a39485;">${user.m_email}</span>
                </div>
                <div class="info-row">
                    <span class="label">권한</span>
                    <span class="value">
                        <span class="role-badge">
                            <c:choose>
                                <c:when test="${user.m_role eq 'ROLE_ADMIN'}">ROLE_ADMIN</c:when>
                                <c:otherwise>ROLE_USER</c:otherwise>
                            </c:choose>
                        </span>
                    </span>
                </div>
            </div>

            <div class="btn-area">
                <a href="javascript:history.back()" class="btn btn-back">목록으로</a>
                <a href="/admin/userEdit?m_id=${user.m_id}" class="btn btn-edit">정보 수정</a>
            </div>
        </div>
    </div>
</body>
</html>