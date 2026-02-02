<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 취향 기록하기</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
<style>
    /* 1. 전체 배경 및 초기화 */
    body {
        background-color: #fdfbf9; /* 헤더 배경과 어울리는 웜 화이트 */
        font-family: 'Pretendard', -apple-system, sans-serif;
        color: #4a3f35;
        margin: 0;
        padding: 0;
        display: block; /* 흐름을 위해 block으로 변경 */
    }

    /* 2. 메인 컨테이너 (헤더 가로폭과 동기화) */
    .write-wrapper {
        background: #ffffff;
        width: 90%;           /* 모바일 대응 */
        max-width: 1100px;    /* ★ 헤더의 가로 너비와 똑같이 맞추세요 (예: 1000px, 1100px, 1200px) */
        margin: 60px auto 120px; /* 좌우 auto로 중앙 정렬 */
        padding: 80px 60px;   /* 내부 여백을 넓혀서 여유롭게 */
        border-radius: 20px;  /* 헤더 스타일과 어울리는 곡률 */
        box-shadow: 0 10px 40px rgba(139, 126, 116, 0.05);
        border: 1px solid rgba(231, 224, 217, 0.5);
        box-sizing: border-box;
    }

    h2 {
        font-family: 'Nanum Myeongjo', serif;
        font-weight: 700;
        color: #3d342c;
        text-align: center;
        margin-bottom: 60px;
        font-size: 2.2rem;
        letter-spacing: -0.02em;
    }

    /* 3. 사진 업로드 영역 (너비 100% 활용) */
    .file-upload-box {
        margin-bottom: 50px;
        text-align: center;
    }

    #image-wrapper { 
        position: relative; 
        border: 1px solid #f0e9e2; 
        border-radius: 16px;
        display: block;      /* 가로를 꽉 채우기 위해 block으로 변경 */
        cursor: crosshair; 
        background: #fafafa; 
        width: 100%;         /* 부모 너비에 꽉 참 */
        min-height: 500px;   /* 높이 확보 */
        overflow: hidden;
        transition: all 0.4s ease;
    }

    #preview-img { width: 100%; display: block; }

    /* 4. 감성 태그 포인트 */
    .tag-dot { 
        position: absolute; 
        width: 16px; height: 16px; 
        background: #8b7e74;
        border: 3px solid #fff; 
        border-radius: 50%; 
        transform: translate(-50%, -50%); 
        z-index: 10; 
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    /* 5. 입력 폼 (전체 너비 일치) */
    .input-group { margin-bottom: 30px; }
    
    input[type="text"], textarea {
        width: 100%;
        padding: 22px 28px;
        border: 1px solid #f0eeec;
        border-radius: 12px;
        background-color: #fff;
        font-size: 1.1rem;
        box-sizing: border-box;
        transition: all 0.3s;
        color: #4a3f35;
    }

    input:focus, textarea:focus {
        outline: none;
        border-color: #8b7e74;
        box-shadow: 0 0 0 4px rgba(139, 126, 116, 0.05);
    }

    /* 6. 하단 버튼 (중앙 정렬) */
    .action-buttons {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin-top: 60px;
    }

    .btn {
        width: 200px;      /* 버튼이 너무 넓어지지 않게 고정폭 */
        padding: 20px;
        border-radius: 12px;
        font-weight: 700;
        font-size: 1rem;
        cursor: pointer;
        transition: all 0.3s;
        border: none;
        text-align: center;
        text-decoration: none;
    }

    .btn-submit { background-color: #8b7e74; color: white; }
    .btn-cancel { background-color: #fff; color: #8b7e74; border: 1px solid #8b7e74; }

    /* 7. 사진 선택 버튼 (알약 모양) */
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
    }
    #file-input {
    display: none; /* 실제 기능은 작동하지만 화면에서는 숨깁니다 */
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/guest/Header.jsp" />
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