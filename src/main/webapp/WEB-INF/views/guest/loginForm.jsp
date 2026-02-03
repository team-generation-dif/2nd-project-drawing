<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 | 당신의 공간을 그리다</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600&display=swap');

        body {
            background-color: #fffaf5;
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
            border-radius: 40px;
            box-shadow: 0 15px 35px rgba(139, 126, 116, 0.1);
            border: 1px solid #f7ede2;
            text-align: center;
        }

        .header h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2.2rem;
            color: #4a3f35;
            margin: 0;
        }

        .header p { font-size: 0.9rem; color: #8b7e74; margin: 10px 0 35px; }

        .input-box { margin-bottom: 12px; position: relative; }

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

        .login-submit-btn:hover { background-color: #6d5d6e; transform: translateY(-2px); }

        .divider { margin: 30px 0; border-top: 1px solid #f2e9e1; position: relative; }
        .divider span {
            position: absolute; top: -10px; left: 50%; transform: translateX(-50%);
            background: #fff; padding: 0 15px; color: #ccc; font-size: 0.8rem;
        }

        .kakao-btn {
            background-color: #FEE500; color: #3C1E1E; padding: 15px;
            text-decoration: none; display: flex; align-items: center;
            justify-content: center; border-radius: 20px; font-weight: bold; transition: 0.3s;
        }

        .footer-links { margin-top: 30px; font-size: 0.85rem; }
        .footer-links a { color: #8b7e74; text-decoration: none; }
        .footer-links .sep { color: #eee; margin: 0 10px; }

        /* 모달 스타일 */
        .modal {
            display: none; 
            position: fixed; 
            z-index: 9999; 
            left: 0; top: 0; width: 100%; height: 100%; 
            background-color: rgba(0,0,0,0.5);
            justify-content: center; align-items: center;
        }

        .modal-content {
            background-color: #fff;
            padding: 40px 30px;
            border-radius: 30px;
            width: 90%;
            max-width: 360px;
            position: relative;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            text-align: center;
        }

        .close {
            position: absolute; right: 20px; top: 15px;
            font-size: 28px; color: #aaa; cursor: pointer;
        }

        .modal-content h3 { font-family: 'Nanum Myeongjo', serif; color: #4a3f35; margin-bottom: 20px; }
        
        .temp-pw-box {
            margin-top: 15px;
            padding: 15px;
            background-color: #fff0eb;
            border-radius: 15px;
            color: #e76f51;
            font-weight: bold;
            display: none;
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
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
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
            <a href="javascript:void(0)" onclick="openModal('findId')">아이디 찾기</a>
            <span class="sep">|</span>
            <a href="javascript:void(0)" onclick="openModal('findPw')">비밀번호 찾기</a>
            <span class="sep"></span><br>
            <a href="${pageContext.request.contextPath}/">홈으로</a>
        </div>
    </div>

    <div id="authModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3 id="modalTitle">아이디 찾기</h3>
            
            <div class="input-box">
                <input type="email" id="modal_email" placeholder="가입한 이메일 입력">
            </div>
            <button type="button" class="login-submit-btn" id="sendBtn" onclick="handleAuth()">인증번호 전송</button>
            
            <div id="authSection" style="display:none; margin-top:15px; border-top: 1px dashed #eee; padding-top: 20px;">
                <div class="input-box">
                    <input type="text" id="auth_num" placeholder="인증번호 6자리">
                </div>
                <button type="button" class="login-submit-btn" id="verifyBtn" style="background-color:#6d5d6e;">인증 및 확인</button>
                <div id="tempPwResult" class="temp-pw-box"></div>
            </div>
        </div>
    </div>

    <input type="hidden" id="csrf_token" value="${_csrf.token}" />

    <script>
        let currentMode = ''; 

        function openModal(mode) {
            currentMode = mode;
            document.getElementById('modalTitle').innerText = (mode === 'findId' ? '아이디 찾기' : '비밀번호 찾기');
            document.getElementById('authModal').style.display = 'flex';
            document.getElementById('authSection').style.display = 'none';
            document.getElementById('tempPwResult').style.display = 'none';
            document.getElementById('modal_email').value = '';
            document.getElementById('auth_num').value = '';
        }

        function closeModal() {
            document.getElementById('authModal').style.display = 'none';
        }

        // 1. 인증번호 전송
        function handleAuth() {
            const email = document.getElementById('modal_email').value;
            if(!email) { alert("이메일을 입력해주세요."); return; }

            fetch("/email/send-auth", {
                method: "POST",
                headers: { 
                    "Content-Type": "application/x-www-form-urlencoded",
                    "X-CSRF-TOKEN": document.getElementById('csrf_token').value 
                },
                body: "m_email=" + encodeURIComponent(email)
            }).then(res => {
                if(res.ok) {
                    alert("인증번호가 발송되었습니다.");
                    document.getElementById('authSection').style.display = 'block';
                } else {
                    alert("가입되지 않은 이메일이거나 오류가 발생했습니다.");
                }
            });
        }

        // 2. 인증 확인 및 결과 처리 (아이디 또는 임시비밀번호 표시)
        document.getElementById('verifyBtn').onclick = function() {
            const email = document.getElementById('modal_email').value;
            const code = document.getElementById('auth_num').value;
            const url = (currentMode === 'findId' ? "/email/verify-find-id" : "/email/verify-find-pw");

            fetch(url, {
                method: "POST",
                headers: { 
                    "Content-Type": "application/x-www-form-urlencoded",
                    "X-CSRF-TOKEN": document.getElementById('csrf_token').value 
                },
                body: "m_email=" + encodeURIComponent(email) + "&auth_num=" + encodeURIComponent(code)
            })
            .then(async res => {
                const data = await res.text(); // 서버가 보낸 아이디 또는 임시비밀번호 텍스트
                
                if (res.ok) {
                    if(currentMode === 'findId') {
                        alert("찾으시는 아이디는 [" + data + "] 입니다.");
                        closeModal();
                    } else {
                        // ★ 임시 비밀번호를 팝업으로 보여줌
                        alert("인증 성공! 임시 비밀번호가 발급되었습니다.\n임시 비밀번호: " + data);
                        
                        // 화면에도 표시
                        const resultBox = document.getElementById('tempPwResult');
                        resultBox.innerHTML = "임시 비밀번호: " + data + "<br><small>로그인 후 즉시 변경해주세요!</small>";
                        resultBox.style.display = 'block';
                        
                        document.getElementById('verifyBtn').innerText = "로그인하러 가기";
                        document.getElementById('verifyBtn').onclick = () => location.reload();
                    }
                } else {
                    alert("인증번호가 틀렸거나 만료되었습니다.");
                }
            })
            .catch(err => alert("통신 오류가 발생했습니다."));
        };

        window.onclick = function(event) {
            if (event.target == document.getElementById('authModal')) closeModal();
        }
    </script>
</body>
</html>