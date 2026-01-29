<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>마이페이지 | Drawing Home</title>
    <style>
        .mypage-container { width: 500px; margin: 50px auto; padding: 30px; border: 1px solid #ddd; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .info-row { display: flex; padding: 15px 0; border-bottom: 1px solid #f0f0f0; align-items: center; }
        .info-label { width: 120px; font-weight: bold; color: #666; }
        .info-value { flex: 1; color: #333; }
        
        .edit-input { width: 100%; padding: 8px; box-sizing: border-box; display: none; } /* 처음엔 숨김 */
        
        .btn-group { margin-top: 30px; display: flex; gap: 10px; }
        .btn { flex: 1; padding: 12px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-edit-mode { background-color: #4A90E2; color: white; }
        .btn-save { background-color: #2ecc71; color: white; display: none; }
        .btn-cancel { background-color: #95a5a6; color: white; display: none; }
        
        .delete-link { display: block; text-align: center; margin-top: 20px; color: #e74c3c; cursor: pointer; font-size: 0.9em; text-decoration: underline; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/Header.jsp" />

    <div class="mypage-container">
        <h2>내 정보 확인</h2>
        
        <form id="updateForm" action="/user/update" method="post">
            <div class="info-row">
                <div class="info-label">아이디</div>
                <div class="info-value">${user.m_id}</div>
                <input type="hidden" name="m_id" value="${user.m_id}">
            </div>

           <div class="info-row">
    <div class="info-label">이름</div>
    <div class="info-value text-data">${user.m_name}</div>
    <input type="text" name="m_name" class="edit-input" value="${user.m_name}" required>
</div>

            <div class="info-row">
                <div class="info-label">닉네임</div>
                <div class="info-value text-data">${user.m_nick}</div>
                <input type="text" name="m_nick" class="edit-input" value="${user.m_nick}" required>
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

            <div class="btn-group">
                <button type="button" id="btnEdit" class="btn btn-edit-mode" onclick="toggleEditMode(true)">정보 수정</button>
                
                <button type="submit" id="btnSave" class="btn btn-save">저장하기</button>
                <button type="button" id="btnCancel" class="btn btn-cancel" onclick="toggleEditMode(false)">취소</button>
            </div>
        </form>

        <span class="delete-link" onclick="askDelete()">회원 탈퇴를 원하시나요?</span>
    </div>

    <script>
        function toggleEditMode(isEdit) {
            const textData = document.querySelectorAll('.text-data');
            const inputs = document.querySelectorAll('.edit-input');
            const btnEdit = document.getElementById('btnEdit');
            const btnSave = document.getElementById('btnSave');
            const btnCancel = document.getElementById('btnCancel');

            if (isEdit) {
                // 수정 모드 활성화
                textData.forEach(el => el.style.display = 'none');
                inputs.forEach(el => el.style.display = 'block');
                btnEdit.style.display = 'none';
                btnSave.style.display = 'block';
                btnCancel.style.display = 'block';
            } else {
                // 조회 모드 복귀
                textData.forEach(el => el.style.display = 'block');
                inputs.forEach(el => el.style.display = 'none');
                btnEdit.style.display = 'block';
                btnSave.style.display = 'none';
                btnCancel.style.display = 'none';
            }
        }

        function askDelete() {
            if (confirm("정말 탈퇴하시겠습니까? 그동안의 3D 인테리어 배치 정보가 모두 사라집니다.")) {
                location.href = "/user/delete";
            }
        }
    </script>
</body>
</html>