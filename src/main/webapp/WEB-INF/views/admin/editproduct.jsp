<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 관리자 | 상품 수정</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
<style>
    body { background-color: #fdfbf9; font-family: 'Pretendard', -apple-system, sans-serif; color: #4a3f35; margin: 0; padding: 0; }
    .form-container { background: #fff; width: 90%; max-width: 800px; margin: 60px auto 120px; padding: 80px 60px; border-radius: 20px;
        box-shadow: 0 10px 40px rgba(139,126,116,0.05); border: 1px solid rgba(231,224,217,0.5); box-sizing: border-box; }
    h2 { font-family: 'Nanum Myeongjo', serif; font-weight: 700; color: #3d342c; text-align: center; margin-bottom: 60px; font-size: 2.2rem; }
    .form-group { margin-bottom: 30px; }
    label { display: block; font-weight: 600; font-size: 0.95rem; color: #8b7e74; margin-bottom: 12px; padding-left: 5px; }
    input[type="text"], select { width: 100%; padding: 20px 25px; border: 1px solid #f0eeec; border-radius: 12px; background-color: #fff;
        font-size: 1rem; transition: all 0.3s; color: #4a3f35; font-family: inherit; }
    input:focus, select:focus { outline: none; border-color: #8b7e74; box-shadow: 0 0 0 4px rgba(139,126,116,0.05); background-color: #fffdfb; }
    .submit-btn { width: 100%; padding: 20px; margin-top: 40px; background-color: #8b7e74; color: white; border: none; border-radius: 12px;
        font-weight: 700; font-size: 1.1rem; cursor: pointer; transition: all 0.3s; }
    .submit-btn:hover { background-color: #766b62; transform: translateY(-2px); }
    .flex-row { display: flex; gap: 20px; }
    .flex-row .form-group { flex: 1; }
</style>
<script>
    // 상위 카테고리 선택 시 서브카테고리 필터링
    function filterSubcategories() {
        const selectedCategory = document.getElementById("categoryId").value;
        const subSelect = document.getElementById("subcategoryId");
        const options = subSelect.options;

        for (let i = 0; i < options.length; i++) {
            const option = options[i];
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
    <h2>✏️ 상품 수정</h2>

    <form action="${pageContext.request.contextPath}/products/admin/update" method="post">
    	<!-- 상품 코드 (PK, hidden으로 전달) -->
    	<input type="hidden" name="p_code" value="${product.p_code}" />

    	<!-- 상품명 -->
    	<div class="form-group">
        	<label for="p_name">상품명</label>
        	<input type="text" name="p_name" value="${product.p_name}" required />
    	</div>

        <!-- 색상 / 사이즈 -->
        <div class="flex-row">
            <div class="form-group">
                <label for="p_color">색상</label>
                <input type="text" name="p_color" value="${product.p_color}" />
            </div>
            <div class="form-group">
                <label for="p_size">사이즈/폭</label>
                <input type="text" name="p_size" value="${product.p_size}" />
            </div>
        </div>

        <!-- 가격 -->
        <div class="form-group">
            <label for="p_price">가격 (원)</label>
            <input type="text" name="p_price" value="${product.p_price}" required />
        </div>

        <!-- 이미지 -->
        <div class="form-group">
            <label for="p_image">이미지 URL</label>
            <input type="text" name="p_image" value="${product.p_image}" />
        </div>

        <!-- 평점 -->
        <div class="form-group">
            <label for="p_rating">평점 (0.0 ~ 5.0)</label>
            <input type="text" name="p_rating" value="${product.p_rating}" />
        </div>

        <!-- 카테고리 선택 (작성 페이지와 동일) -->
        <div class="form-group">
            <label for="categoryId">상위 카테고리</label>
            <select id="categoryId" name="categoryId" onchange="filterSubcategories()" required>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.categoryId}" 
                        <c:if test="${cat.categoryId == product.categoryId}">selected</c:if>>
                        ${cat.name}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="subcategoryId">서브카테고리</label>
            <select id="subcategoryId" name="subcategoryId" required>
                <c:forEach var="sub" items="${subcategories}">
                    <option value="${sub.subcategoryId}" data-category="${sub.categoryId}"
                        <c:if test="${sub.subcategoryId == product.subcategoryId}">selected</c:if>>
                        ${sub.name}
                    </option>
                </c:forEach>
            </select>
        </div>

        <!-- 외부 상품 URL -->
        <div class="form-group">
            <label for="p_url">외부 상품 URL</label>
            <input type="text" name="p_url" value="${product.p_url}" />
        </div>

        <button type="submit" class="submit-btn">수정 완료</button>
    </form>
</div>
</body>
</html>
