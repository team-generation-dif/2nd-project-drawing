<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 | 당신의 공간을 그리다</title>
    <style>
        /* 폰트 및 배경 설정 */
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600&display=swap');

        body {
            background-color: #fffaf5; /* 따뜻한 아이보리 */
            font-family: 'Pretendard', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            color: #5d5a58;
        }

        .login-wrapper {
            background: #ffffff;
            width: 100%;
            max-width: 400px;
            padding: 50px 30px;
            border-radius: 40px; /* 가입페이지와 통일감 */
            box-shadow: 0 15px 35px rgba(139, 126, 116, 0.1);
            border: 1px solid #f7ede2;
            text-align: center;
        }

        .header {
            margin-bottom: 35px;
        }

        .header h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2.2rem;
            color: #4a3f35;
            margin: 0;
        }

        .header p {
            font-size: 0.9rem;
            color: #8b7e74;
            margin-top: 10px;
        }

        /* 입력 폼 스타일 */
        .input-box {
            margin-bottom: 12px;
        }

        .input-box input {
            width: 100%;
            padding: 16px 20px;
            border: 1.5px solid #eee;
            border-radius: 20px;
            background-color: #fafafa;
            font-size: 0.95rem;
            transition: all 0.3s;
            box-sizing: border-box;
        }

        .input-box input:focus {
            outline: none;
            border-color: #ffccbb;
            background-color: #fff;
            box-shadow: 0 4px 10px rgba(255, 204, 187, 0.2);
        }

        /* 일반 로그인 버튼 */
        .login-submit-btn {
            width: 100%;
            padding: 16px;
            background-color: #8b7e74;
            color: white;
            border: none;
            border-radius: 20px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }

        .login-submit-btn:hover {
            background-color: #6d5d6e;
            transform: translateY(-2px);
        }

        /* 구분선 */
        .divider {
            margin: 30px 0;
            border-top: 1px solid #f2e9e1;
            position: relative;
        }

        .divider span {
            position: absolute;
            top: -10px;
            left: 50%;
            transform: translateX(-50%);
            background: #fff;
            padding: 0 15px;
            color: #ccc;
            font-size: 0.8rem;
            letter-spacing: 1px;
        }

        /* 카카오 버튼 */
        .kakao-btn {
            background-color: #FEE500;
            color: #3C1E1E;
            padding: 15px;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.95rem;
            transition: 0.3s;
        }

        .kakao-btn:hover {
            background-color: #fada0a;
            transform: translateY(-2px);
        }

        .footer-links {
            margin-top: 30px;
            font-size: 0.85rem;
        }

        .footer-links a {
            color: #8b7e74;
            text-decoration: none;
            transition: 0.2s;
        }

        .footer-links a:hover {
            color: #4a3f35;
            font-weight: bold;
        }

        .footer-links .sep {
            color: #eee;
            margin: 0 10px;
        }
    </style>
</head>
<body>
    <div class="login-wrapper">
        <div class="header">
            <h2>그리다.</h2>
            <p>만나서 반가워요!</p>
        </div>
        
        <form action="${pageContext.request.contextPath}/j_spring_security_check" method="post">
            <div class="input-box">
                <input type="text" name="j_username" placeholder="아이디" required>
            </div>
            <div class="input-box">
                <input type="password" name="j_password" placeholder="비밀번호" required>
            </div>
            <button type="submit" class="login-submit-btn">로그인</button>
        </form>

        <div class="divider"><span>간편 로그인</span></div>

        <a href="${pageContext.request.contextPath}/oauth2/authorization/kakao" class="kakao-btn">
            카카오 계정으로 계속하기
        </a>

        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/guest/joinForm">회원가입</a>
            <span class="sep">|</span>
            <a href="${pageContext.request.contextPath}/">홈으로</a>
        </div>
    </div>
</body>
</html>