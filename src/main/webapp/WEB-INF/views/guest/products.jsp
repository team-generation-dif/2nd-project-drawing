<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>
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
    .subcategory-grid, .product-grid {
        margin-bottom: 40px;
    }
    .subcategory-grid div, .product-grid div {
        display: inline-block;
        margin: 10px;
        text-align: center;
    }
    .subcategory-grid img {
        width: 100px;
        height: 100px;
        border-radius: 20px;
    }
    .product-grid img {
        width: 150px;
        height: 150px;
        border-radius: 10px;
    }
</style>
</head>
<body>

<!-- 타이틀: 카테고리 or 서브카테고리 이름 -->
<h2>
  <c:choose>
    <c:when test="${not empty category}">
      ${category.name}
    </c:when>
    <c:otherwise>
      ${subcategory.name}
    </c:otherwise>
  </c:choose>
</h2>

<!-- 하위 카테고리 목록 (카테고리 페이지에서만 출력) -->
<c:if test="${not empty subcategories}">
<div class="subcategory-grid">
    <c:forEach var="sub" items="${subcategories}">
        <div>
            <a href="/products/subcategories/${sub.subcategoryId}">
                <img src="${sub.image}" alt="${sub.name}" />
                <p>${sub.name}</p>
            </a>
        </div>
    </c:forEach>
</div>
</c:if>

<!-- 상품 목록 -->
<h3>상품 목록</h3>
<div class="product-grid">
    <c:forEach var="product" items="${products}">
        <div>
            <img src="${product.p_image}" alt="${product.p_name}" />
            <h4>${product.p_name}</h4>
            <p>${product.p_price}원</p>
            <p>⭐ ${product.p_rating}</p>
        </div>
    </c:forEach>
</div>

</body>
</html>
