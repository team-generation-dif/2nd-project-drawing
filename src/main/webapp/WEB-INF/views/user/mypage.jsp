<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>그리다 | 마이페이지</title>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName != null ? _csrf.headerName : 'X-CSRF-TOKEN'}"/>
    
    <style>
        /* 1. 배경 및 대시보드 너비 확장 */
        body {
            background-color: #fffaf5;
            font-family: 'Pretendard', sans-serif;
            color: #5d5a58;
            margin: 0;
        }

        .mypage-container {
            max-width: 650px; /* 기존 500px에서 650px로 확장하여 시원한 개방감 부여 */
            margin: 80px auto;
            padding: 60px 70px; /* 내부 여백을 늘려 대시보드가 꽉 차 보이지 않게 조절 */
            background: #ffffff;
            border-radius: 40px;
            box-shadow: 0 15px 35px rgba(139, 126, 116, 0.08);
            border: 1px solid #f7ede2;
            box-sizing: border-box;
        }

        h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2rem;
            color: #4a3f35;
            text-align: center;
            margin-bottom: 50px;
            letter-spacing: -0.02em;
        }

        /* 2. 정보 행 정렬 최적화 (오른쪽 쏠림 방지) */
        .info-row {
            display: flex;
            padding: 22px 0;
            border-bottom: 1px solid #fcf6f0;
            align-items: center; /* 라벨과 값의 세로 중앙 정렬 */
            min-height: 70px;
            box-sizing: border-box;
        }

        .info-label {
            width: 140px; /* 라벨 폭을 충분히 확보 */
            font-weight: 700;
            color: #8b7e74;
            font-size: 1rem;
            flex-shrink: 0; /* 라벨 너비 고정 */
        }

        .info-value {
            flex: 1; /* 나머지 공간을 모두 차지하여 왼쪽 정렬 효과 */
            color: #4a3f35;
            font-size: 1.05rem;
            font-weight: 500;
            display: flex;
            align-items: center;
        }

        /* 3. 입력창 디자인 (텍스트 겹침 방지) */
        .edit-input {
            width: 100%;
            padding: 14px 20px;
            border: 1.5px solid #f2e8df;
            border-radius: 15px;
            background-color: #fdfbf9;
            font-family: 'Pretendard', sans-serif;
            font-size: 1rem;
            color: #5d5a58;
            box-sizing: border-box;
            transition: all 0.3s ease;
            display: none; /* 기본적으로 숨김 (스크립트 제어) */
        }

        .edit-input:focus {
            outline: none;
            border-color: #8b7e74;
            background-color: #fff;
            box-shadow: 0 0 0 3px rgba(139, 126, 116, 0.05);
        }

        /* 4. 본인 인증 영역 */
        #pwConfirmArea {
            display: none;
            background: #fdfbf9;
            padding: 35px;
            border-radius: 25px;
            margin-top: 30px;
            border: 1px dashed #e2ddd9;
            text-align: center;
        }

        .pw-input {
            width: 100%;
            padding: 14px;
            margin: 15px 0;
            border: 1px solid #f2e8df;
            border-radius: 12px;
            text-align: center;
            font-size: 1rem;
        }

        /* 5. 버튼 그룹 스타일 */
        .btn-group {
            margin-top: 50px;
            display: flex;
            gap: 15px;
        }

        .btn {
            flex: 1;
            padding: 18px;
            border-radius: 20px;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
            font-weight: 700;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-edit { background: #8b7e74; color: #fff; }
        .btn-save { background: #e76f51; color: #fff; display: none; }
        .btn-cancel { background: #eeeae7; color: #8b7e74; display: none; }

        .btn:hover {
            transform: translateY(-2px);
            filter: brightness(0.95);
            box-shadow: 0 5px 15px rgba(139, 126, 116, 0.15);
        }

        /* 6. 하단 탈퇴 링크 */
        .delete-link {
            display: block;
            text-align: center;
            margin-top: 40px;
            color: #bcaaa4;
            font-size: 0.9rem;
            cursor: pointer;
            text-decoration: underline;
            text-underline-offset: 4px;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/guest/Header.jsp" />

<div class="mypage-container">
    <h2>내 정보 확인</h2>

    <form id="updateForm" action="/user/update" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <div class="info-row">
            <div class="info-label">아이디</div>
            <div class="info-value" style="color:#b7ada6;">${user.m_id}</div>
            <input type="hidden" name="m_id" value="${user.m_id}">
        </div>

        <div class="info-row edit-mode-only" style="display:none;">
            <div class="info-label">새 비밀번호</div>
            <div class="info-value">
                <input type="password" name="m_passwd" id="new_pw" class="edit-input" placeholder="변경할 비밀번호 입력">
            </div>
        </div>

        <div class="info-row edit-mode-only" style="display:none;">
            <div class="info-label">비밀번호 확인</div>
            <div class="info-value">
                <input type="password" id="new_pw_confirm" class="edit-input" placeholder="비밀번호 재입력">
            </div>
        </div>

        <div class="info-row">
            <div class="info-label">이름</div>
            <div class="info-value">
                <span class="text-data">${user.m_name}</span>
                <input type="text" name="m_name" class="edit-input" value="${user.m_name}">
            </div>
        </div>

        <div class="info-row">
            <div class="info-label">닉네임</div>
            <div class="info-value">
                <span class="text-data">${user.m_nick}</span>
                <input type="text" name="m_nick" class="edit-input" value="${user.m_nick}">
            </div>
        </div>

       <div class="info-row">
    <div class="info-label">이메일</div>
    <div class="info-value">
        <span style="color:#b7ada6;">${user.m_email}</span>
        <input type="hidden" name="m_email" value="${user.m_email}">
    </div>
</div>

        <div class="info-row">
            <div class="info-label">연락처</div>
            <div class="info-value">
                <span class="text-data">${user.m_tel}</span>
                <input type="text" name="m_tel" class="edit-input" value="${user.m_tel}">
            </div>
        </div>

        <div id="pwConfirmArea">
            <p style="color:#e76f51; font-weight:600; margin-bottom:15px;">⚠️ 본인 확인을 위해 비밀번호를 입력해주세요.</p>
            <input type="password" id="confirmPw" class="pw-input" placeholder="비밀번호 입력">
            <div style="display: flex; gap: 10px;">
                <button type="button" class="btn btn-edit" onclick="verifyBeforeAction()">인증하기</button>
                <button type="button" class="btn" style="background:#95a5a6; color:#fff;" onclick="cancelVerify()">취소</button>
            </div>
        </div>

        <div class="btn-group">
            <button type="button" id="btnEdit" class="btn btn-edit" onclick="showPasswordInput('EDIT')">정보 수정</button>
            <button type="submit" id="btnSave" class="btn btn-save" style="flex:2">저장하기</button>
            <button type="button" id="btnCancel" class="btn btn-cancel" style="flex:1" onclick="toggleEditMode(false)">취소</button>
        </div>
    </form>

    <span class="delete-link" onclick="showPasswordInput('DELETE')">회원 탈퇴</span>
</div>

<script>
    // [사용자님의 기존 스크립트 그대로 유지]
    let currentMode = '';

    function showPasswordInput(mode) {
        currentMode = mode;
        const loginType = "${user.login_type}";
        if(loginType === 'KAKAO') {
            if(mode === 'EDIT') toggleEditMode(true);
            else if(confirm("정말 탈퇴하시겠습니까?")) location.href = "/user/delete";
            return;
        }
        document.getElementById('pwConfirmArea').style.display = 'block';
        document.getElementById('btnEdit').style.display = 'none';
    }

    function verifyBeforeAction() {
        const pw = document.getElementById('confirmPw').value;
        if(!pw) { alert("비밀번호를 입력하세요."); return; }
        const csrfTokenMeta = document.querySelector('meta[name="_csrf"]');
        const csrfHeaderMeta = document.querySelector('meta[name="_csrf_header"]');
        const token = csrfTokenMeta ? csrfTokenMeta.content : "";
        let headerName = csrfHeaderMeta ? csrfHeaderMeta.content.trim() : "X-CSRF-TOKEN";

        const headers = new Headers();
        headers.append('Content-Type', 'application/x-www-form-urlencoded');
        headers.append(headerName, token);

        fetch('/user/verify-password', {
            method: 'POST',
            headers: headers,
            body: 'password=' + encodeURIComponent(pw)
        })
        .then(res => res.json())
        .then(data => {
            if(data.isValid) {
                alert("인증되었습니다.");
                if(currentMode === 'EDIT') toggleEditMode(true);
                else if(confirm("정말 탈퇴하시겠습니까?")) location.href = "/user/delete";
            } else {
                alert("비밀번호가 일치하지 않습니다.");
            }
        })
        .catch(err => alert("서버 통신 오류"));
    }

    function toggleEditMode(isEdit) {
        document.getElementById('pwConfirmArea').style.display = 'none';
        document.getElementById('btnEdit').style.display = isEdit ? 'none' : 'block';
        document.getElementById('btnSave').style.display = isEdit ? 'block' : 'none';
        document.getElementById('btnCancel').style.display = isEdit ? 'block' : 'none';

        const textData = document.querySelectorAll('.text-data');
        const inputs = document.querySelectorAll('.edit-input');
        const editRows = document.querySelectorAll('.edit-mode-only');
        
        textData.forEach(el => el.style.display = isEdit ? 'none' : 'block');
        inputs.forEach(el => {
            if(!el.classList.contains('pw-input')) el.style.display = isEdit ? 'block' : 'none';
        });
        editRows.forEach(el => el.style.display = isEdit ? 'flex' : 'none');
        
        if(!isEdit) document.getElementById('confirmPw').value = '';
    }

    document.getElementById('updateForm').onsubmit = function() {
        const newPw = document.getElementById('new_pw').value;
        const confirmPw = document.getElementById('new_pw_confirm').value;
        if(newPw) {
            if(newPw !== confirmPw) { alert("새 비밀번호가 일치하지 않습니다."); return false; }
            if(newPw.length < 4) { alert("비밀번호는 4자 이상이어야 합니다."); return false; }
        }
        return true;
    };

    function cancelVerify() {
        document.getElementById('confirmPw').value = '';
        document.getElementById('pwConfirmArea').style.display = 'none';
        document.getElementById('btnEdit').style.display = 'block';
    }
</script>
</body>
</html>