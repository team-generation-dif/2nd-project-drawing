<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>챗봇 지식 등록 - 관리자</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container { max-width: 800px; margin-top: 50px; }
        .card-header { background-color: #0d6efd; color: white; font-weight: bold; }
        .preview-img { max-width: 200px; margin-top: 10px; display: none; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card shadow">
            <div class="card-header">
                챗봇 답변(지식) 신규 등록
            </div>
            <div class="card-body">
               <form action="/admin/chatbot_insert" method="post" enctype="multipart/form-data">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

    <div class="mb-3">
        <label for="question" class="form-label">질문 키워드</label>
        <input type="text" class="form-control" id="question" name="keyword" 
               placeholder="예: 배송 문의, 교환 방법 등" required>
    </div>

    <div class="mb-3">
        <label for="content" class="form-label">답변 내용</label>
        <textarea class="form-control" id="content" name="response_msg" rows="6" 
                  placeholder="챗봇이 대답할 내용을 상세히 적어주세요." required></textarea>
    </div>

    <div class="mb-3">
        <label for="file" class="form-label">답변 이미지 업로드</label>
        <input type="file" class="form-control" id="file" name="file" accept="image/*" onchange="previewImage(this)">
        <img id="imagePreview" class="preview-img shadow-sm border">
    </div>

    <div class="mb-3">
        <label for="link_url" class="form-label">이동 링크 URL (선택)</label>
        <input type="text" class="form-control" id="link_url" name="link_url" placeholder="https://... 상품 링크">
    </div>

    <div class="d-flex justify-content-between mt-4">
        <button type="button" class="btn btn-secondary" onclick="history.back();">취소</button>
        <button type="submit" class="btn btn-primary">등록하기</button>
    </div>
</form>
            </div>
        </div>
    </div>

    <script>
        // 파일을 선택했을 때 미리보기 화면을 보여주는 함수
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = 'none';
            }
        }
    </script>
</body>
</html>