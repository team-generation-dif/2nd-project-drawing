<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 관리자 | 상품 등록</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 전체 배경 및 초기화 (공지사항 페이지 스타일) */
        body {
            background-color: #fdfbf9; /* 웜 화이트 */
            font-family: 'Pretendard', -apple-system, sans-serif;
            color: #4a3f35;
            margin: 0;
            padding: 0;
        }

        /* 2. 메인 컨테이너 (공지사항 .admin-write-wrap 스타일) */
        .form-container {
            background: #ffffff;
            width: 90%;
            max-width: 1200px; /* 폼에 적당한 너비 */
            margin: 60px auto 120px;
            padding: 80px 60px;
            border-radius: 20px;
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

        hr {
            border: 0;
            height: 1px;
            background: #f0eeec;
            margin: -20px 0 50px;
        }

        /* 3. 입력 폼 스타일 */
        .form-group {
            margin-bottom: 30px;
            max-width: 100%;
        }

        label {
            display: block;
            font-weight: 600;
            font-size: 0.95rem;
            color: #8b7e74; /* 토프 브라운 */
            margin-bottom: 12px;
            padding-left: 5px;
        }
        
        input[type="text"], select {
            width: 100%;
            padding: 20px 25px;
            border: 1px solid #f0eeec;
            border-radius: 12px;
            background-color: #fff;
            font-size: 1rem;
            box-sizing: border-box;
            transition: all 0.3s;
            color: #4a3f35;
            font-family: inherit;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #8b7e74;
            box-shadow: 0 0 0 4px rgba(139, 126, 116, 0.05);
            background-color: #fffdfb;
        }

        /* 4. 하단 버튼 (공지사항 버튼 스타일) */
        .submit-btn {
            width: 100%;
            padding: 20px;
            margin-top: 40px;
            background-color: #8b7e74; /* 공지사항 수정완료 버튼색 */
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s;
            font-family: inherit;
        }

        .submit-btn:hover {
            background-color: #766b62;
            transform: translateY(-2px);
        }

        .submit-btn:active {
            transform: scale(0.98);
        }

        /* 사이즈/색상 나란히 배치 */
        .flex-row {
            display: flex;
            gap: 20px;
        }
        .flex-row .form-group {
            flex: 1;
        }
    </style>
<script>
    function validateForm() {
        const form = document.forms["newForm"];
        const code = form["p_code"].value;
        const price = form["p_price"].value;
        const rating = form["p_rating"].value;
        const subId = form["subcategoryId"].value;

        if (isNaN(code) || code.trim() === "") {
            alert("상품 코드는 숫자만 입력 가능합니다.");
            return false;
        }
        if (isNaN(price) || price.trim() === "") {
            alert("가격은 숫자만 입력 가능합니다.");
            return false;
        }
        if (rating.trim() !== "" && (isNaN(rating) || rating < 0 || rating > 5)) {
            alert("평점은 0~5 사이 숫자여야 합니다.");
            return false;
        }
        if (isNaN(subId) || subId.trim() === "") {
            alert("서브카테고리 ID는 숫자만 입력 가능합니다.");
            return false;
        }
        return true;
    }
    
 	// ✅ 상위 카테고리 선택 시 해당 서브카테고리만 표시
    function filterSubcategories() {
        const selectedCategory = document.getElementById("categoryId").value;
        const subSelect = document.getElementById("subcategoryId");
        const options = subSelect.options;

        for (let i = 0; i < options.length; i++) {
            const option = options[i];
            console.log("selected:", selectedCategory, "option:", option.getAttribute("data-category")); // ✅ 디버깅
            if (option.getAttribute("data-category") === selectedCategory) {
                option.style.display = "block";
            } else {
                option.style.display = "none";
            }
        }
        // 첫 번째 맞는 서브카테고리 자동 선택
        for (let i = 0; i < options.length; i++) {
            if (options[i].style.display === "block") {
                subSelect.selectedIndex = i;
                break;
            }
        }
    }    
      
</script>
</head>
<body>
    <jsp:include page="../guest/Header.jsp" />

    <div class="form-container">
        <h2>📦 새 상품 등록</h2>

        <form name="newForm" action="${pageContext.request.contextPath}/products/admin/new" 
              method="post" onsubmit="return validateForm()">
              
			<!-- 서버단 중복검사 에러 메시지 -->				
			<c:if test="${not empty errorMessage}">
    			<div style="color:red; font-weight:bold; margin-bottom:20px;">
        			${errorMessage}
    				</div>
				</c:if>
														
            <div class="form-group">
                <label for="p_name">상품명</label>
                <input type="text" name="p_name" placeholder="상품 이름을 입력하세요" required />                           
            </div>

            <div class="form-group" style="display: flex; gap: 15px;">
                <div style="flex: 1;">
                    <label for="p_color">색상</label>
                    <input type="text" name="p_color" placeholder="예: 화이트" />
                </div>
                <div style="flex: 1;">
                    <label for="p_width">사이즈/폭</label>
                    <input type="text" name="p_size" placeholder="예: 120x60x60" />
                </div>
            </div>

            <div class="form-group">
                <label for="p_price">가격 (원)</label>
                <input type="text" name="p_price" placeholder="예: 45000" required />              
            </div>

            <div class="form-group">
                <label for="p_image">이미지 URL</label>
                <input type="text" name="p_image" placeholder="http://..." />
            </div>

            <div class="form-group">
                <label for="p_rating">평점 (0.0 ~ 5.0)</label>
                <input type="text" name="p_rating" placeholder="예: 4.5" />           
            </div>

            <div class="form-group">
                <label for="categoryId">상위 카테고리</label>
                <select id="categoryId" name="categoryId" onchange="filterSubcategories()" required>
                    <option value="" disabled selected>상위 카테고리 선택</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.categoryId}">${cat.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="subcategoryId">서브카테고리</label>
                <select id="subcategoryId" name="subcategoryId" required>
                    <option value="" disabled selected>먼저 상위 카테고리를 선택하세요</option>
                    <c:forEach var="sub" items="${subcategories}">
                        <option value="${sub.subcategoryId}" data-category="${sub.categoryId}">
                            ${sub.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

           <div class="form-group">
    			<label for="p_url">외부 상품 URL</label>
    			<input type="text" name="p_url" placeholder="이케아 공식 홈페이지 링크 등" />
		   </div>

            <button type="submit" class="submit-btn">등록 완료</button>
        </form>
    </div>
</body>
</html>