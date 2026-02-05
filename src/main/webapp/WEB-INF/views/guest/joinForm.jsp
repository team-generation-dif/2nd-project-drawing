<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 | 회원가입</title>
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

        .join-wrapper {
            background: #ffffff;
            width: 100%;
            max-width: 420px;
            padding: 50px 30px;
            border-radius: 40px;
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

        .msg {
            display: block;
            font-size: 0.75rem;
            margin-top: 6px;
            margin-left: 10px;
            min-height: 15px;
        }
        .error { color: #e76f51; }
        .success { color: #8ab17d; }

        /* 버튼 스타일 추가 */
        .btn-inline {
            position: absolute;
            right: 8px;
            top: 32px;
            padding: 8px 15px;
            border-radius: 12px;
            border: none;
            background-color: #8b7e74;
            color: #fff;
            font-size: 0.8rem;
            cursor: pointer;
        }

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
        }

        .back-link {
            text-align: center;
            margin-top: 25px;
            font-size: 0.85rem;
        }
    </style>

    <script>
        // 1. 전역 상태 변수
        let status = { id: false, pw: false, name: false, nick: false, email: false, tel: false };
        let emailVerified = false;

        // 🛡️ CSRF 설정 (Spring Security 환경 필수)
        $(function() {
            const token = $("input[name='${_csrf.parameterName}']").val();
            const header = "X-CSRF-TOKEN";
            
            $.ajaxSetup({
                beforeSend: function(xhr) {
                    if(token) xhr.setRequestHeader(header, token);
                }
            });
        });

        $(document).ready(function() {
            // 아이디 체크
            $("#m_id").on("blur", function() {
                const val = $(this).val().trim();
                if(!/^[a-z0-9]{4,12}$/.test(val)) {
                    $("#idMsg").text("4~12자 소문자/숫자만 가능").attr("class", "msg error");
                    status.id = false;
                    return;
                }
                checkDuplicate("id", val, "#idMsg", "아이디");
            });

            // 비밀번호 체크
            $("#m_passwd").on("blur", function() {
                const regex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,16}$/;
                status.pw = checkRegex($(this), regex, "#pwMsg", "8~16자 영문/숫자 조합");
            });

            // 이름 체크
            $("#m_name").on("blur", function() {
                status.name = checkRegex($(this), /^[가-힣]{2,5}$/, "#nameMsg", "한글 2~5자");
            });

            // 닉네임 체크
            $("#m_nick").on("blur", function() {
                const val = $(this).val().trim();
                if(val.length < 2) {
                    $("#nickMsg").text("2자 이상 입력").attr("class", "msg error");
                    status.nick = false;
                    return;
                }
                checkDuplicate("nick", val, "#nickMsg", "닉네임");
            });

            // 이메일 체크
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

            // 전화번호 체크
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

        function checkDuplicate(type, value, msgId, label) {
            let data = {};
            data["m_" + type] = value;
            
            $.post("/guest/checkDuplicateJoin", data, function(res) {
                if(res === "OK") {
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

        // 📩 인증번호 발송
        function sendEmailAuth() {
            const email = $("#m_email").val().trim();
            if (!status.email) {
                alert("중복되지 않은 올바른 이메일을 입력해주세요.");
                return;
            }

            $.post("/email/send-auth", { m_email: email }, function(res) {
                if (res === "OK") {
                    $("#emailAuthBox").show();
                    $("#authMsg").text("인증번호가 발송되었습니다.").attr("class", "msg success");
                    alert("인증번호를 발송했습니다.");
                } else {
                    alert("메일 발송 실패. 서버 로그를 확인하세요.");
                }
            });
        }

        // ✅ 인증번호 확인 (404 해결 버전)
        function verifyEmailAuth() {
            const email = $("#m_email").val().trim();
            const authNum = $("#authNum").val().trim();

            if (!authNum) {
                alert("인증번호를 입력하세요.");
                return;
            }

            $.post("/email/verify-auth", {
                m_email: email,
                auth_num: authNum
            }, function(res) {
                if (res === "OK") {
                    emailVerified = true;
                    $("#authMsg").text("인증 완료되었습니다.").attr("class", "msg success");
                    $("#m_email").attr("readonly", true);
                    $("#authNum").attr("disabled", true);
                    alert("인증 성공!");
                } else {
                    $("#authMsg").text("인증번호가 틀렸습니다.").attr("class", "msg error");
                }
            }).fail(function() {
                alert("서버 응답 오류 (404 또는 500)");
            });
        }

        function validateForm() {
            if (!status.id || !status.pw || !status.name || !status.nick || !status.email || !status.tel) {
                alert("입력 정보를 다시 확인해주세요.");
                return false;
            }
            if (!emailVerified) {
                alert("이메일 인증이 완료되지 않았습니다.");
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
                <button type="button" class="btn-inline" onclick="sendEmailAuth()">인증요청</button>
                <span id="emailMsg" class="msg"></span>
            </div>

            <div class="input-box" id="emailAuthBox" style="display:none;">
                <label>인증번호</label>
                <input type="text" id="authNum" placeholder="6자리 입력">
                <button type="button" class="btn-inline" onclick="verifyEmailAuth()">확인</button>
                <span id="authMsg" class="msg"></span>
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
        </div>
    </div>
</body>
</html>