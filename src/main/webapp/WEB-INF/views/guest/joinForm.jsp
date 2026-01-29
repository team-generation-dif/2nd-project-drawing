<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 | 취향을 그리다</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
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

        .join-wrapper {
            background: #ffffff;
            width: 100%;
            max-width: 420px;
            padding: 50px 30px;
            border-radius: 40px; /* 아주 둥근 모서리 */
            box-shadow: 0 15px 35px rgba(139, 126, 116, 0.1);
            border: 1px solid #f7ede2;
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .header h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2rem;
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
            margin-bottom: 22px;
            position: relative;
        }

        .input-box label {
            display: block;
            font-weight: 600;
            font-size: 0.85rem;
            margin-bottom: 8px;
            margin-left: 5px;
            color: #8b7e74;
        }

        .input-box input {
            width: 100%;
            padding: 14px 18px;
            border: 1.5px solid #eee;
            border-radius: 18px;
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

        /* 유효성 메시지 */
        .msg {
            display: block;
            font-size: 0.75rem;
            margin-top: 6px;
            margin-left: 10px;
            min-height: 15px;
        }
        .error { color: #e76f51; } /* 따뜻한 느낌의 오렌지 레드 */
        .success { color: #8ab17d; } /* 따뜻한 느낌의 올리브 그린 */

        /* 가입 버튼 */
        .join-btn {
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
            margin-top: 20px;
        }

        .join-btn:hover {
            background-color: #6d5d6e;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .back-link {
            text-align: center;
            margin-top: 25px;
            font-size: 0.85rem;
        }

        .back-link a {
            color: #8b7e74;
            text-decoration: none;
            border-bottom: 1px solid #8b7e74;
        }
    </style>



<script>
    let status = { id: false, pw: false, name: false, nick: false, email: false, tel: false };

    $(document).ready(function() {
        // 아이디 중복 체크 (기존 유지)
        $("#m_id").on("blur", function() {
            const val = $(this).val().trim();
            if(!/^[a-z0-9]{4,12}$/.test(val)) {
                $("#idMsg").text("4~12자 소문자/숫자만 가능").attr("class", "msg error");
                status.id = false;
                return;
            }
            checkDuplicate("id", val, "#idMsg", "아이디");
        });

        // 비밀번호 (정규식 체크만)
        $("#m_passwd").on("blur", function() {
            const regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$/;
            status.pw = checkRegex($(this), regex, "#pwMsg", "8~16자 영문/숫자 조합");
        });

        // 이름 (정규식 체크만)
        $("#m_name").on("blur", function() {
            status.name = checkRegex($(this), /^[가-힣]{2,5}$/, "#nameMsg", "한글 2~5자");
        });

        // 닉네임 중복 체크 (추가)
        $("#m_nick").on("blur", function() {
            const val = $(this).val().trim();
            if(val.length < 2) {
                $("#nickMsg").text("2자 이상 입력").attr("class", "msg error");
                status.nick = false;
                return;
            }
            checkDuplicate("nick", val, "#nickMsg", "닉네임");
        });

        // 이메일 중복 체크 (추가)
        $("#m_email").on("blur", function() {
            const val = $(this).val().trim();
            const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if(!regex.test(val)) {
                $("#emailMsg").text("올바른 형식이 아닙니다.").attr("class", "msg error");
                status.email = false;
                return;
            }
            checkDuplicate("email", val, "#emailMsg", "이메일");
        });

        // 전화번호 중복 체크 (추가)
        $("#m_tel").on("blur", function() {
            const val = $(this).val().trim();
            const regex = /^01[016789]-\d{3,4}-\d{4}$/;
            if(!regex.test(val)) {
                $("#telMsg").text("010-0000-0000 형식").attr("class", "msg error");
                status.tel = false;
                return;
            }
            checkDuplicate("tel", val, "#telMsg", "전화번호");
        });
    });

    // 서버 중복 체크 공통 함수
    function checkDuplicate(type, value, msgId, label) {
        $.get("/guest/checkDuplicate", { type: type, value: value }, function(res) {
            if(res === "ok") {
                $(msgId).text("사용 가능한 " + label + "입니다.").attr("class", "msg success");
                status[type] = true;
            } else {
                $(msgId).text("이미 사용 중인 " + label + "입니다.").attr("class", "msg error");
                status[type] = false;
            }
        });
    }

    function checkRegex(obj, regex, msgId, errorMsg) {
        if(!regex.test(obj.val().trim())) {
            $(msgId).text(errorMsg).attr("class", "msg error");
            return false;
        }
        $(msgId).text("확인되었습니다.").attr("class", "msg success");
        return true;
    }

    function validateForm() {
        if(!Object.values(status).every(v => v === true)) {
            alert("입력 양식을 확인하거나 중복 체크를 완료해주세요.");
            return false;
        }
        return true;
    }
</script>
</head>
<body>
    <div class="join-wrapper">
        <div class="header">
            <h2>그리다.</h2>
            <p>당신의 소중한 공간을 그려보세요</p>
        </div>

        <form action="/guest/join" method="post" onsubmit="return validateForm()">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="input-box">
                <label>아이디</label>
                <input type="text" id="m_id" name="m_id" placeholder="ID를 입력하세요" required>
                <span id="idMsg" class="msg"></span>
            </div>

            <div class="input-box">
                <label>비밀번호</label>
                <input type="password" id="m_passwd" name="m_passwd" placeholder="비밀번호를 입력하세요" required>
                <span id="pwMsg" class="msg"></span>
            </div>

            <div class="input-box">
                <label>이름</label>
                <input type="text" id="m_name" name="m_name" placeholder="실명 입력" required>
                <span id="nameMsg" class="msg"></span>
            </div>

            <div class="input-box">
                <label>닉네임</label>
                <input type="text" id="m_nick" name="m_nick" placeholder="사용할 닉네임" required>
                <span id="nickMsg" class="msg"></span>
            </div>

            <div class="input-box">
                <label>이메일</label>
                <input type="email" id="m_email" name="m_email" placeholder="example@grida.com" required>
                <span id="emailMsg" class="msg"></span>
            </div>

            <div class="input-box">
                <label>전화번호</label>
                <input type="text" id="m_tel" name="m_tel" placeholder="010-0000-0000" required>
                <span id="telMsg" class="msg"></span>
            </div>

            <button type="submit" class="join-btn">가입 시작하기</button>
        </form>

        <div class="back-link">
    이미 계정이 있으신가요? <a href="${pageContext.request.contextPath}/guest/loginForm">로그인하기</a>
    <span style="color:#eee; margin: 0 10px;">|</span>
    <a href="${pageContext.request.contextPath}/">홈으로</a>
</div>
    </div>
</body>
</html>