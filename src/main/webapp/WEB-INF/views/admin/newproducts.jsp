<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<style>
    body {
        font-family: '맑은 고딕', sans-serif;
        background-color: #f9f9f9;
        padding: 30px;
    }
    h2 {
        color: #333;
        margin-bottom: 20px;
    }
    form {
        background: #fff;
        padding: 20px;
        border-radius: 10px;
        border: 1px solid #ddd;
        width: 450px;
    }
    label {
        display: block;
        margin-top: 10px;
        font-weight: bold;
    }
    input, select {
        width: 100%;
        padding: 8px;
        margin-top: 5px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
    button {
        margin-top: 20px;
        padding: 10px 15px;
        background-color: #2196F3;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
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
<h2>상품 등록</h2>

<form name="newForm" action="${pageContext.request.contextPath}/products/admin/new" 
      method="post" onsubmit="return validateForm()">

    <label for="p_code">상품 코드</label>
    <input type="text" name="p_code" required />

    <label for="p_name">상품명</label>
    <input type="text" name="p_name" required />

    <label for="p_color">색상</label>
    <input type="text" name="p_color" />

    <label for="p_width">사이즈/폭</label>
    <input type="text" name="p_width" />

    <label for="p_price">가격</label>
    <input type="text" name="p_price" required />

    <label for="p_image">이미지 URL</label>
    <input type="text" name="p_image" />

    <label for="p_rating">평점</label>
    <input type="text" name="p_rating" />

    <!-- ✅ 상위 카테고리 선택 -->
    <label for="categoryId">상위 카테고리</label>
    <select id="categoryId" name="categoryId" onchange="filterSubcategories()" required>
        <c:forEach var="cat" items="${categories}">
            <option value="${cat.categoryId}">${cat.name}</option>
        </c:forEach>
    </select>

    <!-- ✅ 서브카테고리 선택 (data-category로 상위 카테고리 연결) -->
    <label for="subcategoryId">서브카테고리</label>
    <select id="subcategoryId" name="subcategoryId" required>
        <c:forEach var="sub" items="${subcategories}">
            <option value="${sub.subcategoryId}" data-category="${sub.categoryId}">
                ${sub.name}
            </option>
        </c:forEach>
    </select>


    <!-- ✅ 외부 URL (상품 상세 페이지 연결) -->
    <label for="externalUrl">외부 상품 URL</label>
    <input type="text" name="externalUrl" placeholder="예: https://www.ikea.com/kr/ko/p/..." />

    <button type="submit">등록 완료</button>
</form>

</body>
</html>
