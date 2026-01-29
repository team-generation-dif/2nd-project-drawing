<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 취향 기록하기</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
<style>
    /* 1. 기본 배경 및 폰트 설정 (상세보기와 통일) */
    body {
        background-color: #fffaf5;
        font-family: 'Pretendard', sans-serif;
        color: #5d5a58;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 60px 20px;
        margin: 0;
    }

    /* 2. 메인 컨테이너 */
    .write-wrapper {
        background: #ffffff;
        width: 100%;
        max-width: 700px;
        padding: 50px 40px;
        border-radius: 40px;
        box-shadow: 0 15px 35px rgba(139, 126, 116, 0.1);
        border: 1px solid #f7ede2;
        box-sizing: border-box;
    }

    h2 {
        font-family: 'Nanum+Myeongjo', serif;
        color: #4a3f35;
        text-align: center;
        margin-bottom: 40px;
        font-size: 1.8rem;
    }

    /* 3. 사진 업로드 및 미리보기 영역 */
    .file-upload-box {
        margin-bottom: 30px;
        text-align: center;
    }

    #image-wrapper { 
        position: relative; 
        border: 2px dashed #e7e0d9; 
        border-radius: 24px;
        display: inline-block; 
        cursor: crosshair; 
        background: #fafafa; 
        min-width: 100%; 
        min-height: 300px;
        overflow: hidden;
        line-height: 0;
        transition: 0.3s;
    }

    #image-wrapper:hover { border-color: #8b7e74; }
    #preview-img { width: 100%; display: block; border-radius: 20px; }

    /* 4. 감성 태그 포인트 디자인 (상세보기와 통일) */
    .tag-dot { 
        position: absolute; 
        width: 22px; height: 22px; 
        background: rgba(139, 126, 116, 0.8);
        border: 2px solid #fff; 
        border-radius: 50%; 
        transform: translate(-50%, -50%); 
        z-index: 10; 
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }
    
    .tag-dot::after {
        content: '';
        position: absolute;
        top: 50%; left: 50%;
        transform: translate(-50%, -50%);
        width: 6px; height: 6px;
        background: #fff;
        border-radius: 50%;
    }

    /* 5. 입력 폼 스타일 */
    .input-group { margin-bottom: 20px; }
    
    input[type="text"], textarea {
        width: 100%;
        padding: 15px 20px;
        border: 1px solid #eee;
        border-radius: 16px;
        background-color: #fafafa;
        font-family: 'Pretendard', sans-serif;
        font-size: 1rem;
        box-sizing: border-box;
        transition: 0.3s;
    }

    input:focus, textarea:focus {
        outline: none;
        border-color: #ffccbb;
        background-color: #fff;
        box-shadow: 0 0 0 4px rgba(255, 204, 187, 0.1);
    }

    .info-text {
        color: #bcaaa4;
        font-size: 0.85rem;
        margin: 10px 0 25px 5px;
        display: block;
    }

    /* 6. 버튼 스타일 */
    .action-buttons {
        display: flex;
        gap: 12px;
        margin-top: 30px;
    }

    .btn {
        flex: 1;
        padding: 16px;
        border-radius: 18px;
        font-weight: 700;
        font-size: 1rem;
        cursor: pointer;
        transition: 0.3s;
        border: none;
        text-align: center;
        text-decoration: none;
    }

    .btn-submit { background-color: #8b7e74; color: white; }
    .btn-cancel { background-color: #fafafa; color: #8b7e74; border: 1px solid #eee; }

    .btn:hover { transform: translateY(-2px); opacity: 0.9; }

    /* 파일 인풋 커스텀 */
    #file-input { display: none; }
    .file-label {
        display: inline-block;
        padding: 10px 20px;
        background: #fff;
        border: 1px solid #8b7e74;
        color: #8b7e74;
        border-radius: 12px;
        cursor: pointer;
        margin-bottom: 15px;
        font-weight: 600;
    }
</style>
</head>
<body>

<div class="write-wrapper">
    <h2>취향을 그리다</h2>

    <form action="/user/insert?${_csrf.parameterName}=${_csrf.token}" method="post" id="writeForm" enctype="multipart/form-data">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        
        <div class="file-upload-box">
            <label for="file-input" class="file-label">✦ 사진 선택하기</label>
            <input type="file" id="file-input" name="file" onchange="loadImage(event)" required>
            
            <div id="image-wrapper" onclick="addTag(event)">
                <img id="preview-img" src="">
                <div id="placeholder-text" style="position:absolute; top:50%; left:50%; transform:translate(-50%, -50%); color:#bcaaa4; line-height: 1.6;">
                    선택한 사진이 여기에 표시됩니다.<br>사진 클릭 시 상품 태그를 달 수 있어요.
                </div>
            </div>
            <span class="info-text">* 사진 속 사물을 클릭하여 정보를 남겨보세요.</span>
        </div>

        <div class="input-group">
            <input type="text" name="b_title" placeholder="기록의 제목을 적어주세요" required>
        </div>
        
        <div class="input-group">
            <textarea name="b_content" placeholder="이 공간에는 어떤 이야기가 담겨 있나요?" style="height:150px;"></textarea>
        </div>
        
        <input type="hidden" name="tagData" id="tagJson">

        
        <div class="action-buttons">
            <a href="/user/list" class="btn btn-cancel">취소</a>
            <button type="button" class="btn btn-submit" onclick="submitFinal()">기록 완료</button>
        </div>
    </form>
</div>

<script>
    let tagArray = [];

    function loadImage(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const preview = document.getElementById('preview-img');
                preview.src = e.target.result;
                document.getElementById('placeholder-text').style.display = 'none';
                
                // 새로운 이미지를 불러올 때 기존 태그 초기화
                tagArray = [];
                const dots = document.querySelectorAll('.tag-dot');
                dots.forEach(dot => dot.remove());
            };
            reader.readAsDataURL(file);
        }
    }

    function addTag(event) {
        const img = document.getElementById('preview-img');
        if (!img.src || img.getAttribute('src') === "") { 
            alert("먼저 사진을 선택해주세요!"); 
            return; 
        }

        const rect = event.currentTarget.getBoundingClientRect();
        const x = ((event.clientX - rect.left) / rect.width) * 100;
        const y = ((event.clientY - rect.top) / rect.height) * 100;
        
        const name = prompt("이 상품의 이름은 무엇인가요?");
        const link = prompt("구매처나 정보 링크(URL)가 있다면 적어주세요.", "http://");
        
        if(name && link) {
            tagArray.push({ 
                x_coord: x.toFixed(2), 
                y_coord: y.toFixed(2), 
                t_name: name,
                t_url: link 
            });
            
            const dot = document.createElement('div');
            dot.className = 'tag-dot';
            dot.style.left = x + '%'; 
            dot.style.top = y + '%';
            dot.title = name;
            event.currentTarget.appendChild(dot);
        }
    }

    function submitFinal() {
        const form = document.getElementById('writeForm');
        if (!form.b_title.value.trim()) { alert("제목을 입력해주세요."); return; }
        if (!document.getElementById('file-input').files[0]) { alert("사진을 선택해주세요."); return; }

        document.getElementById('tagJson').value = JSON.stringify(tagArray);
        form.submit();
    }
</script>
</body>

</html>