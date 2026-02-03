<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 | 작가 상세 정보</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600&display=swap');

        body {
            background-color: #fffaf5;
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            color: #4a3f35;
        }

        .detail-wrapper {
            max-width: 550px;
            margin: 80px auto;
            padding: 0 20px;
        }

        .detail-card {
            background: #ffffff;
            border-radius: 40px;
            box-shadow: 0 15px 35px rgba(139, 126, 116, 0.08);
            border: 1px solid #f7ede2;
            padding: 50px;
            position: relative;
            overflow: hidden;
        }

        /* 상단 장식 라인 */
        .detail-card::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 8px;
            background: linear-gradient(to right, #ffccbb, #8b7e74);
        }

        .detail-card h3 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 1.8rem;
            text-align: center;
            margin-bottom: 40px;
            color: #4a3f35;
        }

        .info-group {
            margin-bottom: 25px;
        }

        .info-row {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #fcf8f5;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .label {
            font-weight: 600;
            width: 100px;
            color: #8b7e74;
            font-size: 0.9rem;
        }

        .value {
            flex: 1;
            color: #5d5a58;
            font-size: 1rem;
        }

        /* 권한 배지 스타일 */
        .role-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: bold;
            background-color: #f7ede2;
            color: #8b7e74;
        }

        .btn-area {
            margin-top: 40px;
            text-align: center;
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .btn {
            padding: 12px 30px;
            border-radius: 20px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            border: none;
            text-decoration: none;
        }

        .btn-back {
            background-color: #eee;
            color: #777;
        }

        .btn-back:hover {
            background-color: #e2e2e2;
        }

        .btn-edit {
            background-color: #8b7e74;
            color: white;
        }

        .btn-edit:hover {
            background-color: #6d5d6e;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <jsp:include page="../guest/Header.jsp" />

    <div class="detail-wrapper">
        <div class="detail-card">
            <h3>작가 상세 정보</h3>
            
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
                    <span class="value">${user.m_email}</span>
                </div>
                <div class="info-row">
                    <span class="label">권한</span>
                    <span class="value">
                        <span class="role-badge">${user.m_role}</span>
                    </span>
                </div>
            </div>

            <div class="btn-area">
                <button class="btn btn-back" onclick="history.back()">목록으로</button>
            </div>
        </div>
    </div>
</body>
</html>