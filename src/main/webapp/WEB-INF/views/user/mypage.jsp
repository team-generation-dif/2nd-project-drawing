<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>마이페이지 | Drawing Home</title>
    <meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName != null ? _csrf.headerName : 'X-CSRF-TOKEN'}"/>
    
    <style>
        .mypage-container { width: 500px; margin: 50px auto; padding: 30px; border: 1px solid #ddd; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .info-row { display: flex; padding: 15px 0; border-bottom: 1px solid #f0f0f0; align-items: center; }
        .info-label { width: 120px; font-weight: bold; color: #666; }
        .info-value { flex: 1; color: #333; }
        .edit-input { width: 100%; padding: 8px; display: none; border: 1px solid #ddd; border-radius: 4px; }
        .btn-group { margin-top: 30px; display: flex; gap: 10px; }
        .btn { flex: 1; padding: 12px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-edit { background:#4A90E2; color:#fff; }
        .btn-save { background:#2ecc71; color:#fff; display:none; }
        .btn-cancel { background:#95a5a6; color:#fff; display:none; }
        .delete-link { display: block; text-align: center; margin-top: 20px; color: #e74c3c; cursor: pointer; text-decoration: underline; }
        #pwConfirmArea { display:none; background:#f9f9f9; padding:20px; border-radius:8px; margin-top:10px; border:1px dashed #ccc; }
        .pw-input { width:100%; padding:10px; margin-bottom:10px; border:1px solid #ddd; border-radius:4px; }
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
            <div class="info-value">${user.m_id}</div>
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
            <div class="info-value text-data">${user.m_name}</div>
            <input type="text" name="m_name" class="edit-input" value="${user.m_name}">
        </div>

        <div class="info-row">
            <div class="info-label">닉네임</div>
            <div class="info-value text-data">${user.m_nick}</div>
            <input type="text" name="m_nick" class="edit-input" value="${user.m_nick}">
        </div>

        <div class="info-row">
            <div class="info-label">이메일</div>
            <div class="info-value text-data">${user.m_email}</div>
            <input type="email" name="m_email" class="edit-input" value="${user.m_email}">
        </div>

        <div class="info-row">
            <div class="info-label">연락처</div>
            <div class="info-value text-data">${user.m_tel}</div>
            <input type="text" name="m_tel" class="edit-input" value="${user.m_tel}">
        </div>

       <div id="pwConfirmArea">
    <p style="color:#e76f51; font-size: 0.9em;">⚠️ 본인 확인을 위해 비밀번호를 입력해주세요.</p>
    <input type="password" id="confirmPw" class="pw-input" placeholder="비밀번호 입력">
    
    <div style="display: flex; gap: 5px;">
        <button type="button" class="btn btn-edit" onclick="verifyBeforeAction()">인증하기</button>
        <button type="button" class="btn" style="background:#95a5a6; color:#fff;" onclick="cancelVerify()">취소</button>
    </div>
</div>

        <div class="btn-group">
            <button type="button" id="btnEdit" class="btn btn-edit" onclick="showPasswordInput('EDIT')">정보 수정</button>
            <button type="submit" id="btnSave" class="btn btn-save">저장하기</button>
            <button type="button" id="btnCancel" class="btn btn-cancel" onclick="toggleEditMode(false)">취소</button>
        </div>
    </form>

    <span class="delete-link" onclick="showPasswordInput('DELETE')">회원 탈퇴</span>
</div>

<script>
    let currentMode = '';

    // 1. 비밀번호 입력창 보이기
    function showPasswordInput(mode) {
        currentMode = mode;
        
        // 카카오 유저는 비번 없이 바로 수정모드 진입 (선택 사항)
        const loginType = "${user.login_type}";
        if(loginType === 'KAKAO') {
            if(mode === 'EDIT') toggleEditMode(true);
            else if(confirm("정말 탈퇴하시겠습니까?")) location.href = "/user/delete";
            return;
        }

        document.getElementById('pwConfirmArea').style.display = 'block';
        document.getElementById('btnEdit').style.display = 'none';
    }

    // 2. 비밀번호 서버 검증
 function verifyBeforeAction() {
    const pw = document.getElementById('confirmPw').value;
    if(!pw) { alert("비밀번호를 입력하세요."); return; }

    const csrfTokenMeta = document.querySelector('meta[name="_csrf"]');
    const csrfHeaderMeta = document.querySelector('meta[name="_csrf_header"]');

    // 헤더 이름과 토큰 값 추출 (공백 제거)
    const token = csrfTokenMeta ? csrfTokenMeta.content : "";
    let headerName = csrfHeaderMeta ? csrfHeaderMeta.content.trim() : "";

    // 만약 headerName이 여전히 비어있다면 기본값 강제 할당
    if (!headerName) {
        headerName = "X-CSRF-TOKEN"; 
    }

    console.log("최종 전송 헤더명:", headerName);
    console.log("최종 전송 토큰:", token);

    const headers = new Headers();
    headers.append('Content-Type', 'application/x-www-form-urlencoded');
    
    // 헤더 이름이 정상적일 때만 append
    try {
        headers.append(headerName, token);
    } catch (e) {
        console.error("헤더 생성 실패:", e);
        alert("보안 헤더 설정에 실패했습니다.");
        return;
    }

    fetch('/user/verify-password', {
        method: 'POST',
        headers: headers,
        body: 'password=' + encodeURIComponent(pw)
    })
    .then(res => {
        if (!res.ok) throw new Error(res.status);
        return res.json();
    })
    .then(data => {
        if(data.isValid) {
            alert("인증되었습니다.");
            toggleEditMode(true);
        } else {
            alert("비밀번호가 일치하지 않습니다.");
        }
    })
    .catch(err => {
        console.error("에러:", err);
        alert("서버와 통신할 수 없습니다. (DB 암호화 여부 및 로그를 확인하세요)");
    });

}

    // 3. 수정 모드 토글
function toggleEditMode(isEdit) {
    document.getElementById('pwConfirmArea').style.display = 'none';
    document.getElementById('btnEdit').style.display = isEdit ? 'none' : 'block';
    document.getElementById('btnSave').style.display = isEdit ? 'block' : 'none';
    document.getElementById('btnCancel').style.display = isEdit ? 'block' : 'none';

    const textData = document.querySelectorAll('.text-data');
    const inputs = document.querySelectorAll('.edit-input');
    const editRows = document.querySelectorAll('.edit-mode-only'); // 비밀번호 행
    
    textData.forEach(el => el.style.display = isEdit ? 'none' : 'block');
    inputs.forEach(el => el.style.display = isEdit ? 'block' : 'none');
    editRows.forEach(el => el.style.display = isEdit ? 'flex' : 'none'); // 보이기
    
    if(!isEdit) document.getElementById('confirmPw').value = '';
}

// 폼 전송 전 비밀번호 일치 확인 로직 추가
document.getElementById('updateForm').onsubmit = function() {
    const newPw = document.getElementById('new_pw').value;
    const confirmPw = document.getElementById('new_pw_confirm').value;

    if(newPw) { // 비밀번호를 입력했다면
        if(newPw !== confirmPw) {
            alert("새 비밀번호가 일치하지 않습니다.");
            return false;
        }
        if(newPw.length < 4) { // 최소 길이 체크
            alert("비밀번호는 4자 이상이어야 합니다.");
            return false;
        }
    }
    return true;
};
 // 인증 절차 취소 함수
    function cancelVerify() {
        // 1. 비밀번호 입력칸 초기화
        document.getElementById('confirmPw').value = '';
        // 2. 인증 영역 숨기기
        document.getElementById('pwConfirmArea').style.display = 'none';
        // 3. '정보 수정' 버튼 다시 보이기
        document.getElementById('btnEdit').style.display = 'block';
    }
</script>
</body>
</html>