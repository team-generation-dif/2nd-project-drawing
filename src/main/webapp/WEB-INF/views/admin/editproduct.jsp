<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 관리자 | 상품 수정</title>
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
        width: 400px;
    }
    label {
        display: block;
        margin-top: 10px;
        font-weight: bold;
    }
    input {
        width: 100%;
        padding: 8px;
        margin-top: 5px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
    button {
        margin-top: 20px;
        padding: 10px 15px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
    .error {
        color: red;
        font-size: 12px;
    }
</style>
<script>
    function validateForm() {
        const price = document.forms["editForm"]["p_price"].value;
        const rating = document.forms["editForm"]["p_rating"].value;
        const subId = document.forms["editForm"]["subcategoryId"].value;

        // 가격은 숫자만
        if (isNaN(price) || price.trim() === "") {
            alert("가격은 숫자만 입력 가능합니다.");
            return false;
        }

        // 평점은 0~5 사이 숫자
        if (rating.trim() !== "" && (isNaN(rating) || rating < 0 || rating > 5)) {
            alert("평점은 0~5 사이 숫자여야 합니다.");
            return false;
        }

        // 서브카테고리 ID는 정수
        if (isNaN(subId) || subId.trim() === "") {
            alert("서브카테고리 ID는 숫자만 입력 가능합니다.");
            return false;
        }

        return true;
    }
</script>
</head>
<body>
<h2>상품 수정</h2>

<form name="editForm" action="${pageContext.request.contextPath}/products/admin/edit" 
      method="post" onsubmit="return validateForm()">

    <!-- 상품 코드 (PK) -->
    <label for="p_code">상품 코드</label>
    <input type="text" name="p_code" value="${product.p_code}" readonly />

    <label for="p_name">상품명</label>
    <input type="text" name="p_name" value="${product.p_name}" required />

    <label for="p_color">색상</label>
    <input type="text" name="p_color" value="${product.p_color}" />

    <label for="p_width">사이즈/폭</label>
    <input type="text" name="p_width" value="${product.p_width}" />

    <label for="p_price">가격</label>
    <input type="text" name="p_price" value="${product.p_price}" required />

    <label for="p_image">이미지 URL</label>
    <input type="text" name="p_image" value="${product.p_image}" />

    <label for="p_rating">평점</label>
    <input type="text" name="p_rating" value="${product.p_rating}" />

    <label for="subcategoryId">서브카테고리 ID</label>
    <input type="text" name="subcategoryId" value="${product.subcategoryId}" />

    <button type="submit">수정 완료</button>
</form>

</body>
</html>
