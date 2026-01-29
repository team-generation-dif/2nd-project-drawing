<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 | 환영합니다!</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600&display=swap');

        body {
            background-color: #fffaf5;
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #5d5a58;
        }

        .success-card {
            background: #ffffff;
            width: 100%;
            max-width: 400px;
            padding: 60px 30px;
            border-radius: 40px;
            text-align: center;
            box-shadow: 0 15px 35px rgba(139, 126, 116, 0.1);
            border: 1px solid #f7ede2;
        }

        .welcome-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            display: block;
        }

        h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2rem;
            color: #4a3f35;
            margin-bottom: 15px;
        }

        p {
            font-size: 1rem;
            color: #8b7e74;
            line-height: 1.6;
            margin-bottom: 40px;
        }

        .btn-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .btn {
            padding: 16px;
            border-radius: 20px;
            font-size: 1rem;
            font-weight: bold;
            text-decoration: none;
            transition: 0.3s;
            display: block;
        }

        .btn-login {
            background-color: #8b7e74;
            color: white;
        }

        .btn-login:hover {
            background-color: #6d5d6e;
            transform: translateY(-2px);
        }

        .btn-home {
            background-color: #fff;
            color: #8b7e74;
            border: 1px solid #8b7e74;
        }

        .btn-home:hover {
            background-color: #fdf8f3;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="success-card">
        <span class="welcome-icon">🎨</span>
        <h2>반가워요!</h2>
        <p>이제 '그리다'와 함께<br>당신만의 포근한 공간을 그려보세요.</p>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/guest/loginForm" class="btn btn-login">로그인하러 가기</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">홈으로 돌아가기</a>
        </div>
    </div>
</body>
</html>