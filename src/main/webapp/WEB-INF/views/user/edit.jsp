<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>그리다 | 게시글 수정</title>
<style>
/* 1. 기본 배경 및 폰트 (목록 페이지와 동일) */
body {
    background-color: #fffaf5; /* 그리다 시그니처 아이보리 */
    font-family: 'Pretendard', sans-serif;
    color: #5d5a58;
    margin: 0;
    padding: 60px 20px;
}

/* 2. 메인 컨테이너 (카드 스타일) */
#combinedForm {
    max-width: 650px;
    margin: 0 auto;
    background: #ffffff;
    padding: 50px;
    border-radius: 30px; /* 목록 카드와 동일한 곡률 */
    box-shadow: 0 10px 25px rgba(139, 126, 116, 0.08);
    border: 1px solid #f7ede2;
}

h2 {
    font-family: 'Nanum Myeongjo', serif; /* 목록 헤더와 동일 */
    font-size: 1.8rem;
    color: #4a3f35;
    text-align: center;
    margin-bottom: 40px;
}

/* 3. 입력 필드 디자인 */
label {
    display: block;
    font-size: 0.9rem;
    font-weight: 700;
    margin-bottom: 10px;
    color: #8b7e74;
    padding-left: 5px;
}

input[type="text"], 
textarea {
    width: 100%;
    padding: 15px 20px;
    margin-bottom: 30px;
    border: 1px solid #f7ede2;
    border-radius: 18px; /* 통일감 있는 둥근 모서리 */
    background-color: #fcfcfc;
    font-size: 1rem;
    color: #5d5a58;
    box-sizing: border-box;
    transition: all 0.3s ease;
}

input:focus, textarea:focus {
    outline: none;
    border-color: #8b7e74;
    background-color: #fff;
}

/* 4. 이미지 및 태그 영역 */
#image-container {
    position: relative;
    border-radius: 20px;
    overflow: hidden;
    margin-bottom: 35px;
    border: 1px solid #f7ede2;
    background: #fcfcfc;
    line-height: 0;
}

#target-image {
    width: 100%;
    height: auto;
    cursor: crosshair;
}

/* 태그 포인트 (브라운 톤으로 변경) */
.tag-point {
    position: absolute;
    width: 14px;
    height: 14px;
    background: #8b7e74; /* 포인트 브라운 */
    border: 3px solid #fff;
    border-radius: 50%;
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    cursor: pointer;
    transform: translate(-50%, -50%);
    z-index: 10;
}

/* 5. 버튼 그룹 (사진 올리기 버튼 스타일 계승) */
.button-group {
    display: flex;
    gap: 12px;
}

button {
    flex: 2;
    background: #8b7e74; /* 버튼 색상 통일 */
    color: white;
    border: none;
    padding: 16px;
    border-radius: 18px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: 0.3s;
    box-shadow: 0 4px 10px rgba(139, 126, 116, 0.2);
}

button:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(139, 126, 116, 0.3);
}

.btn-cancel {
    flex: 1;
    background: #eeeae7;
    color: #8b7e74;
    text-decoration: none;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 18px;
    font-weight: 600;
}

.btn-cancel:hover {
    background: #e2ddd9;
}
</style>
</head>
<body>
    <form action="${pageContext.request.contextPath}/user/boardUpdate" method="post" enctype="multipart/form-data" id="combinedForm">
    <input type="hidden" name="b_image" value="${board.b_image}">
    <h2>게시글 수정</h2>
    
    <input type="hidden" name="b_code" value="${board.b_code}">
    <input type="hidden" name="tagData" id="tagData">

    <label>제목</label>
    <input type="text" name="b_title" value="${board.b_title}">
    
    <label>태그 수정 (이미지 클릭 시 태그 추가/삭제)</label>
    <div id="image-container">
        <img src="/upload/${board.b_image}" id="target-image">
        <div id="tag-display-area"></div>
    </div>
    
    <label>이미지 교체</label>
<input type="file" name="file" id="file-input" onchange="previewImage(this)">
    
    <label>내용</label>
    <textarea name="b_content" rows="5">${board.b_content}</textarea>
    
    <div class="button-group">
        <button type="button" onclick="submitAllData()">수정 완료</button>
        <a href="/user/detail?b_code=${board.b_code}" class="btn-cancel">취소</a>
    </div>
</form>
<script>
    // 1. 기존 태그 로드 (t_code 포함 확인)
    let tagList = [
        <c:forEach var="t" items="${tags}" varStatus="status">
            { 
                t_code: '${t.t_code}', 
                x_coord: '${t.x_coord}', 
                y_coord: '${t.y_coord}', 
                t_name: '${t.t_name}', 
                t_url: '${t.t_url}' 
            }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    // 2. 태그 추가 (이미지 클릭)
    document.getElementById('target-image').onclick = function(e) {
        const rect = this.getBoundingClientRect();
        const x = (e.clientX - rect.left) / rect.width * 100;
        const y = (e.clientY - rect.top) / rect.height * 100;
        
        const name = prompt("상품명을 입력하세요:");
        const url = prompt("상품 링크(URL)를 입력하세요:");
        
        if(name && url) {
            // 신규 태그는 t_code를 빈 값으로 추가
            tagList.push({ t_code: '', x_coord: x.toFixed(2), y_coord: y.toFixed(2), t_name: name, t_url: url });
            drawTags();
        }
    };

    // 3. 태그 그리기 및 삭제
    function drawTags() {
    const area = document.getElementById('tag-display-area');
    area.innerHTML = '';
    tagList.forEach((tag, index) => {
        const dot = document.createElement('div');
        dot.className = 'tag-point';
        dot.style.left = tag.x_coord + '%';
        dot.style.top = tag.y_coord + '%';
        
        // CSS 말풍선과 연동될 속성 추가
        dot.setAttribute('data-name', tag.t_name); 
        dot.title = "클릭 시 삭제"; 
        
        dot.onclick = (e) => {
            e.stopPropagation();
            if(confirm(`'${tag.t_name}' 태그를 삭제할까요?`)) {
                tagList.splice(index, 1);
                drawTags();
            }
        };
        area.appendChild(dot);
    });
}

    // 4. 통합 전송 함수 (중괄호 오타 수정됨!)
    function submitAllData() {
        // 데이터 타입을 확실히 String으로 매칭
        const data = tagList.map(tag => ({
            t_code: tag.t_code ? String(tag.t_code) : "", 
            t_name: String(tag.t_name),
            t_url: String(tag.t_url),
            x_coord: String(tag.x_coord),
            y_coord: String(tag.y_coord)
        }));
        
        console.log("전송될 JSON:", JSON.stringify(data)); // 디버깅용
        document.getElementById('tagData').value = JSON.stringify(data);
        document.getElementById('combinedForm').submit();
    } // <-- 여기서 불필요한 중괄호가 하나 더 있었던 것을 지웠습니다.

    drawTags();
 // 이미지 미리보기 함수
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();

            reader.onload = function(e) {
                // 1. 이미지 소스를 선택한 파일의 데이터로 변경
                const targetImage = document.getElementById('target-image');
                targetImage.src = e.target.result;
                
                // 2. (선택사항) 사진이 바뀌면 태그 위치가 맞지 않을 수 있으므로 
                // 태그를 초기화하고 싶다면 아래 주석을 해제하세요.
                /*
                if(confirm("새 이미지를 선택하면 기존 태그가 초기화됩니다. 계속하시겠습니까?")) {
                    tagList = [];
                    drawTags();
                }
                */
            };

            reader.readAsDataURL(input.files[0]);
        }
    }
</script>
</body>
</html>