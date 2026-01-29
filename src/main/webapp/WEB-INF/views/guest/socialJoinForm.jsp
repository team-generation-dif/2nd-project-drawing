<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 | 추가 정보 입력</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600&display=swap');

        body {
            background-color: #fffaf5; /* 부드러운 아이보리 배경 */
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #4a3f35;
        }

        .join-card {
            background: #ffffff;
            width: 100%;
            max-width: 450px;
            padding: 50px;
            border-radius: 40px;
            border: 1px solid #f7ede2;
            box-shadow: 0 15px 35px rgba(139, 126, 116, 0.1);
            text-align: center;
        }

        .join-card h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 1.8rem;
            margin-bottom: 10px;
            color: #4a3f35;
        }

        .join-card p {
            font-size: 0.95rem;
            color: #8b7e74;
            margin-bottom: 35px;
        }

        /* 폼 요소 스타일 */
        .input-group {
            text-align: left;
            margin-bottom: 20px;
        }

        .input-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 8px;
            margin-left: 5px;
            color: #8b7e74;
        }

        .input-group input {
            width: 100%;
            padding: 15px;
            border-radius: 15px;
            border: 1px solid #f7ede2;
            background-color: #fdfcfb;
            box-sizing: border-box;
            font-family: inherit;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .input-group input:focus {
            outline: none;
            border-color: #ffccbb;
            background-color: #ffffff;
            box-shadow: 0 0 8px rgba(255, 204, 187, 0.4);
        }

        /* 제출 버튼 */
        .btn-submit {
            width: 100%;
            padding: 16px;
            margin-top: 20px;
            border: none;
            border-radius: 15px;
            background-color: #8b7e74;
            color: white;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-submit:hover {
            background-color: #4a3f35;
            transform: translateY(-2px);
        }

        /* 하단 안내 */
        .footer-info {
            margin-top: 25px;
            font-size: 0.8rem;
            color: #ccc;
        }
    </style>
</head>
<body>

    <div class="join-card">
        <h2>거의 다 왔어요!</h2>
        <p>작가님의 멋진 활동을 위해<br>조금 더 자세한 정보가 필요해요.</p>

        <form action="/guest/socialJoin" method="post">
            <input type="hidden" name="m_id" value="${m_id}">
            
            <div class="input-group">
                <label>성함</label>
                <input type="text" name="m_name" placeholder="실명을 입력해주세요" required>
            </div>

            <div class="input-group">
                <label>활동 닉네임</label>
                <input type="text" name="m_nick" placeholder="아뜰리에에서 사용할 이름" required>
            </div>

            <div class="input-group">
                <label>이메일</label>
                <input type="email" name="m_email" placeholder="example@drawing.com" required>
            </div>

            <div class="input-group">
                <label>연락처</label>
                <input type="text" name="m_tel" placeholder="010-0000-0000">
            </div>

            <button type="submit" class="btn-submit">가입 완료하고 시작하기</button>
        </form>

        <div class="footer-info">
            © 그리다 아뜰리에. 모든 정보는 안전하게 보호됩니다.
        </div>
    </div>

</body>
</html>