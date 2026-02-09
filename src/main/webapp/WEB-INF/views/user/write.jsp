<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 인테리어 기록하기</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
<style>
    /* 1. 전체 배경 및 초기화 */
    body {
        background-color: #fffaf5;
        font-family: 'Pretendard', sans-serif;
        color: #4a3f35;
        margin: 0;
    }

    /* 2. 메인 컨테이너 */
    .write-wrapper {
        background: #ffffff;
        width: 90%;
        max-width: 900px;
        margin: 60px auto 120px;
        padding: 60px 50px;
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

    /* 3. 사진 업로드 영역 */
    .file-upload-box {
        margin-bottom: 40px;
        text-align: center;
    }

    /* [수정] 이미지를 중앙 정렬하는 부모 박스 */
    #image-wrapper { 
        position: relative; 
        border: 2px dashed #eee1d5; 
        border-radius: 25px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: crosshair; 
        background: #fdfbf9; 
        width: 100%;         
        min-height: 400px;
        overflow: hidden;
        transition: all 0.3s ease;
    }

    /* [추가] 이미지와 태그가 동기화될 실제 영역 */
    .img-container {
        position: relative;
        display: inline-block;
        max-width: 100%;
    }

    #preview-img { 
        max-width: 100%; 
        height: auto; 
        display: block; 
        border-radius: 23px;
    }

    /* 4. 감성 태그 포인트 */
    .tag-dot { 
        position: absolute; 
        width: 14px; height: 14px; 
        background: #e76f51; 
        border: 3px solid #fff; 
        border-radius: 50%; 
        transform: translate(-50%, -50%); 
        z-index: 10; 
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        animation: pulse 2s infinite;
    }

    @keyframes pulse {
        0% { transform: translate(-50%, -50%) scale(1); }
        50% { transform: translate(-50%, -50%) scale(1.2); }
        100% { transform: translate(-50%, -50%) scale(1); }
    }

    /* 5. 입력 폼 디자인 */
    .input-group { margin-bottom: 25px; }
    
    input[type="text"], textarea {
        width: 100%;
        padding: 18px 22px;
        border: 1.5px solid #f2e8df;
        border-radius: 18px;
        background-color: #fdfbf9;
        font-size: 1rem;
        box-sizing: border-box;
        transition: all 0.3s;
        color: #4a3f35;
    }

    input:focus, textarea:focus {
        outline: none;
        border-color: #8b7e74;
        background-color: #fff;
        box-shadow: 0 0 0 4px rgba(139, 126, 116, 0.05);
    }

    /* 6. 버튼 */
    .action-buttons {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-top: 50px;
    }

    .btn {
        width: 180px;
        padding: 18px;
        border-radius: 20px;
        font-weight: 700;
        font-size: 1rem;
        cursor: pointer;
        transition: all 0.3s ease;
        border: none;
        text-align: center;
        text-decoration: none;
    }

    .btn-submit { background-color: #8b7e74; color: white; }
    .btn-cancel { background-color: #eeeae7; color: #8b7e74; }

    #file-input {
        position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px;
        overflow: hidden; clip: rect(0, 0, 0, 0); border: 0;
    }

    .file-label {
        display: inline-block;
        padding: 14px 30px;
        background: #8b7e74;
        color: #fff;
        border-radius: 50px;
        cursor: pointer;
        margin-bottom: 25px;
        font-size: 0.95rem;
        transition: 0.3s;
        font-weight: 600;
    }

    .info-text { display: block; margin-top: 15px; font-size: 0.85rem; color: #bcaaa4; }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/guest/Header.jsp" />
<div class="write-wrapper">
    <h2>🎨 나의 인테리어</h2>

    <form action="/user/insert?${_csrf.parameterName}=${_csrf.token}" method="post" id="writeForm" enctype="multipart/form-data">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        
        <div class="file-upload-box">
            <label for="file-input" class="file-label">✦ 사진 선택하기</label>
            <input type="file" id="file-input" name="file" onchange="loadImage(event)" required>
            
            <div id="image-wrapper">
                <div class="img-container" id="img-container" onclick="addTag(event)">
                    <img id="preview-img" src="">
                    <div id="placeholder-text" style="position:absolute; top:50%; left:50%; transform:translate(-50%, -50%); color:#bcaaa4; line-height: 1.6; white-space:nowrap;">
                        선택한 사진이 여기에 표시됩니다.<br>사진 클릭 시 상품 태그를 달 수 있어요.
                    </div>
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
            <a href="/guest/list" class="btn btn-cancel">취소</a>
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
                
                // 새로운 이미지 불러올 시 기존 태그 초기화
                tagArray = [];
                const dots = document.querySelectorAll('.tag-dot');
                dots.forEach(dot => dot.remove());
            };
            reader.readAsDataURL(file);
        }
    }

    function addTag(event) {
        const img = document.getElementById('preview-img');
        const container = document.getElementById('img-container');

        if (!img.src || img.getAttribute('src') === "") { 
            alert("먼저 사진을 선택해주세요!"); 
            return; 
        }

        // [수정] 기준점을 wrapper가 아닌 container(이미지 크기)로 변경
        const rect = container.getBoundingClientRect();
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
            
            // [수정] 태그를 이미지 컨테이너에 추가 (이미지와 함께 움직임)
            container.appendChild(dot);
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