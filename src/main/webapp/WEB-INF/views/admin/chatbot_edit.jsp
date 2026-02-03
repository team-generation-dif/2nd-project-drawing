<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>시나리오 수정</title>
    <style>
        .form-wrap { max-width: 600px; margin: 50px auto; padding: 30px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .input-group { margin-bottom: 20px; }
        label { font-weight: bold; color: #555; }
        input, textarea { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; }
        .btn-submit { background: #2a9d8f; color: white; border: none; padding: 12px; width: 100%; border-radius: 8px; cursor: pointer; font-weight: bold; }
        
        /* 이미지 미리보기 스타일 */
        .preview-box { margin-top: 10px; padding: 10px; border: 1px dashed #ccc; border-radius: 8px; text-align: center; }
        .preview-img { max-width: 100%; max-height: 200px; border-radius: 5px; }
        .current-info { font-size: 12px; color: #666; margin-bottom: 5px; }
    </style>
</head>
<body>
<jsp:include page="../guest/Header.jsp" />
    <div class="form-wrap">
        <h2>✏️ 시나리오 수정</h2>
        <form action="/admin/chatbot_update" method="post" enctype="multipart/form-data">
            <input type="hidden" name="q_code" value="${dto.q_code}">
            
            <div class="input-group">
                <label>매칭 키워드</label>
                <input type="text" name="keyword" value="${dto.keyword}" required>
            </div>
            
            <div class="input-group">
                <label>자동 응답 메시지</label>
                <textarea name="response_msg" rows="5" required>${dto.response_msg}</textarea>
            </div>

            <div class="input-group">
                <label>이미지 수정 (파일 선택)</label>
                <input type="file" name="file" accept="image/*" onchange="previewImage(this)">
                
                <div class="preview-box">
                    <c:choose>
                        <c:when test="${not empty dto.img_url}">
                            <div class="current-info">현재 등록된 이미지: ${dto.img_url}</div>
                            <img id="imagePreview" src="/upload/${dto.img_url}" class="preview-img">
                        </c:when>
                        <c:otherwise>
                            <div class="current-info">등록된 이미지가 없습니다.</div>
                            <img id="imagePreview" src="" class="preview-img" style="display:none;">
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="input-group">
                <label>이동 링크 URL (선택)</label>
                <input type="text" name="link_url" value="${dto.link_url}" placeholder="https://... 상품 링크">
            </div>
            
            <button type="submit" class="btn-submit">수정 완료</button>
            <button type="button" onclick="history.back()" style="background:#8b7e74; margin-top:10px;" class="btn-submit">취소</button>
        </form>
    </div>

    <script>
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'inline-block';
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>