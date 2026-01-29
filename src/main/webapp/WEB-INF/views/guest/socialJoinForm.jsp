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
   <input type="hidden" id="csrfToken" name="${_csrf.parameterName}" value="${_csrf.token}">

   <input type="hidden" id="m_id_hidden" name="m_id" value="${m_id}">
   
            <div class="input-group">
                <label>성함</label>
                <input type="text" name="m_name" placeholder="실명을 입력해주세요" required>
            </div>

            <div class="input-group">
    <label>활동 닉네임</label>
    <input type="text" name="m_nick" id="m_nick"
           placeholder="아뜰리에에서 사용할 이름" required
           onblur="checkDuplicate('nick')">
    <small id="nick-msg"></small>
</div>


            <div class="input-group">
    <label>이메일</label>
    <input type="email" name="m_email" id="m_email"
           placeholder="example@drawing.com" required
           onblur="checkDuplicate('email')">
    <small id="email-msg"></small>
</div>


            <div class="input-group">
    <label>연락처</label>
    <input type="text" name="m_tel" id="m_tel"
           placeholder="010-0000-0000"
           onblur="checkDuplicate('tel')">
    <small id="tel-msg"></small>
</div>

            <button type="submit" class="btn-submit" id="submitBtn" disabled>
    가입 완료하고 시작하기
</button>

            
        </form>

        <div class="footer-info">
            © 그리다 아뜰리에. 모든 정보는 안전하게 보호됩니다.
        </div>
    </div>
<script>
const csrfToken = document.getElementById('csrfToken').value;
const m_id = document.getElementById('m_id_hidden').value;

let checkStatus = {
    nick: false,
    email: false,
    tel: true
};

function checkDuplicate(type) {
    let value, msgEl;

    // 1. 타입에 따른 값과 메시지 엘리먼트 설정
    if (type === 'nick') {
        value = document.getElementById('m_nick').value;
        msgEl = document.getElementById('nick-msg');
    } else if (type === 'email') {
        value = document.getElementById('m_email').value;
        msgEl = document.getElementById('email-msg');
    } else if (type === 'tel') {
        value = document.getElementById('m_tel').value;
        msgEl = document.getElementById('tel-msg');
        if (!value) { 
            checkStatus.tel = true;
            updateSubmit();
            msgEl.innerText = '';
            return;
        }
    }

    // 2. 서버로 요청 보내기
    fetch('/guest/checkDuplicateSocial', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': csrfToken
        },
        body: new URLSearchParams({
            m_id: m_id,
            type: type,   // 예: 'nick'
            value: value  // 예: '홍길동'
        })
    })
    .then(res => res.text())
    .then(result => {
        console.log("서버 응답 결과:", result); // 크롬 F12 콘솔에서 확인 가능

        if (result === 'OK') {
            msgEl.innerText = '✔ 사용 가능한 정보입니다';
            msgEl.style.color = '#4caf50';
            checkStatus[type] = true;
        } else if (result === 'DUPLICATE') {
            msgEl.innerText = '✖ 이미 사용 중입니다';
            msgEl.style.color = '#e53935';
            checkStatus[type] = false;
        } else {
            msgEl.innerText = '⚠ 올바른 값을 입력해주세요';
            msgEl.style.color = '#ffa000';
            checkStatus[type] = false;
        }
        updateSubmit();
    })
    .catch(err => {
        console.error("fetch 오류 발생:", err);
        msgEl.innerText = '서버 통신 오류';
    });
}

function updateSubmit() {
    const btn = document.getElementById('submitBtn');
    btn.disabled = !(checkStatus.nick && checkStatus.email && checkStatus.tel);
}
</script>


</body>
</html>