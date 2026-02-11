<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>그리다 | 게시글 수정</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
<style>
/* 1. 기본 배경 및 폰트 */
body {
    background-color: #fffaf5; /* 그리다 시그니처 아이보리 */
    font-family: 'Pretendard', sans-serif;
    color: #5d5a58;
    margin: 0;
    padding: 60px 20px;
}

/* 2. 메인 컨테이너 */
#combinedForm {
    max-width: 650px;
    margin: 0 auto;
    background: #ffffff;
    padding: 50px;
    border-radius: 30px;
    box-shadow: 0 10px 25px rgba(139, 126, 116, 0.08);
    border: 1px solid #f7ede2;
}

h2 {
    font-family: 'Nanum Myeongjo', serif;
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
    border-radius: 18px;
    background-color: #fcfcfc;
    font-size: 1rem;
    color: #5d5a58;
    box-sizing: border-box;
    transition: all 0.3s ease;
}

/* 4. 이미지 및 태그 영역 (수정 핵심) */
#image-container {
    position: relative; /* 자식인 tag-display-area의 기준점 */
    border-radius: 20px;
    overflow: hidden;
    margin-bottom: 35px;
    border: 1px solid #f7ede2;
    background: #fcfcfc;
    line-height: 0; /* 이미지 하단 미세 공백 제거 */
}

#target-image {
    width: 100%;
    height: auto;
    display: block;
    cursor: crosshair;
}

/* 태그가 배치되는 절대 영역 */
#tag-display-area {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none; /* 중요: 이 영역이 이미지 클릭을 방해하지 않음 */
}

/* 태그 포인트 스타일 */
.tag-point {
    position: absolute;
    width: 16px;
    height: 16px;
    background: #8b7e74;
    border: 2px solid #fff;
    border-radius: 50%;
    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    cursor: pointer;
    transform: translate(-50%, -50%);
    z-index: 100;
    pointer-events: auto; /* 태그 자체는 클릭이 가능해야 삭제됨 */
}

/* 5. 버튼 그룹 */
.button-group {
    display: flex;
    gap: 12px;
}

button {
    flex: 2;
    background: #8b7e74;
    color: white;
    border: none;
    padding: 16px;
    border-radius: 18px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: 0.3s;
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
</style>
</head>
<body>

<form action="${pageContext.request.contextPath}/user/boardUpdate" method="post" enctype="multipart/form-data" id="combinedForm">
    <input type="hidden" name="b_image" value="${board.b_image}">
    <input type="hidden" name="b_code" value="${board.b_code}">
    <input type="hidden" name="tagData" id="tagData">

    <h2>게시글 수정</h2>

    <label>제목</label>
    <input type="text" name="b_title" value="${board.b_title}">
    
    <label>태그 수정 (이미지 클릭 시 태그 추가)</label>
    <div id="image-container">
        <img src="/upload/${board.b_image}" id="target-image">
        <div id="tag-display-area"></div>
    </div>
    
    <label>이미지 교체</label>
    <input type="file" name="file" id="file-input" onchange="previewImage(this)" style="margin-bottom: 30px;">
    
    <label>내용</label>
    <textarea name="b_content" rows="5">${board.b_content}</textarea>
    
    <div class="button-group">
        <button type="button" onclick="submitAllData()">수정 완료</button>
        <a href="/user/detail?b_code=${board.b_code}" class="btn-cancel">취소</a>
    </div>
</form>

<script>
    // 1. 데이터 초기화 (JSTL 리스트를 JS 배열로 변환)
let tagList = [];
    
    try {
        <c:forEach var="t" items="${tags}">
            tagList.push({
                t_code: "${t.t_code}", 
                // escapeXml="false"와 백틱(String Interpolation)을 조합하거나 
                // 값을 안전하게 문자열로 감쌉니다.
                x_coord: parseFloat("${t.x_coord}") || 0,
                y_coord: parseFloat("${t.y_coord}") || 0,
                t_name: `<c:out value="${t.t_name}" />`, 
                t_url: `<c:out value="${t.t_url}" />`
            });
        </c:forEach>
        console.log("태그 데이터 로드 완료:", tagList);
    } catch (e) {
        console.error("데이터 로드 중 문법 오류 발생:", e);
    }

    // 2. 이미지 클릭 이벤트 리스너
    document.getElementById('target-image').addEventListener('click', function(e) {
        const rect = this.getBoundingClientRect();
        
        // 클릭 좌표를 % 단위로 계산 (정확도 향상)
        const x = (e.clientX - rect.left) / rect.width * 100;
        const y = (e.clientY - rect.top) / rect.height * 100;
        
        const name = prompt("상품명을 입력하세요:");
        if(!name) return;
        
        const url = prompt("상품 링크(URL)를 입력하세요:");
        if(!url) return;
        
        // 새 태그 추가 (t_code는 빈값)
        tagList.push({ 
            t_code: '', 
            x_coord: x.toFixed(2), 
            y_coord: y.toFixed(2), 
            t_name: name, 
            t_url: url 
        });
        
        drawTags();
    });

    // 3. 태그 화면 렌더링 함수
    function drawTags() {
        const area = document.getElementById('tag-display-area');
        area.innerHTML = ''; // 초기화
        
        tagList.forEach((tag, index) => {
            const dot = document.createElement('div');
            dot.className = 'tag-point';
            dot.style.left = tag.x_coord + '%';
            dot.style.top = tag.y_coord + '%';
            dot.title = tag.t_name;
            
            // 삭제 기능 (클릭 시)
            dot.onclick = (e) => {
                e.preventDefault();
                e.stopPropagation(); // 이미지 클릭 이벤트 전파 방지
                if(confirm(`'${tag.t_name}' 태그를 삭제할까요?`)) {
                    tagList.splice(index, 1);
                    drawTags();
                }
            };
            area.appendChild(dot);
        });
    }

    // 4. 전체 데이터 전송 함수
    function submitAllData() {
        // 태그 데이터를 JSON 문자열로 변환하여 hidden input에 삽입
        const formattedData = tagList.map(tag => ({
            t_code: tag.t_code || "", 
            t_name: String(tag.t_name),
            t_url: String(tag.t_url),
            x_coord: String(tag.x_coord),
            y_coord: String(tag.y_coord)
        }));
        
        document.getElementById('tagData').value = JSON.stringify(formattedData);
        document.getElementById('combinedForm').submit();
    }

    // 5. 이미지 미리보기 (파일 선택 시)
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('target-image').src = e.target.result;
                // 새로운 사진이므로 기존 태그 위치가 맞지 않을 수 있음을 알림
                if(tagList.length > 0) {
                    alert("사진이 교체되었습니다. 기존 태그의 위치를 확인해 주세요.");
                }
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // 페이지 로드 시 기존 태그 그리기
    window.onload = function() {
        drawTags();
    };
</script>
</body>
</html>