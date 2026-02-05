<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
    h3 {
        margin-top: 30px;
        color: #444;
    }
    /* 하위 카테고리 카드 */
    .subcategory-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        margin-bottom: 40px;
    }
    .subcategory-card {
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 10px;
        width: 150px;
        padding: 10px;
        text-align: center;
        transition: box-shadow 0.3s;
    }
    .subcategory-card:hover {
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .subcategory-card img {
        width: 100px;
        height: 100px;
        border-radius: 8px;
        object-fit: cover;
        margin-bottom: 8px;
    }
    .subcategory-card p {
        margin: 0;
        font-size: 14px;
        color: #333;
        font-weight: bold;
    }
    /* 상품 카드 */
    .product-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
    }
    .product-card {
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 10px;
        width: 220px;
        padding: 15px;
        text-align: center;
        transition: box-shadow 0.3s;
    }
    .product-card:hover {
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .product-card img {
        width: 180px;
        height: 180px;
        border-radius: 8px;
        object-fit: cover;
        margin-bottom: 10px;
    }
    .product-card h4 {
        margin: 10px 0 5px;
        font-size: 16px;
        color: #333;
    }
    .product-card p {
        margin: 5px 0;
        color: #555;
    }
    .product-link {
        text-decoration: none;
        color: inherit;
        cursor: pointer; /* ✅ 손 모양 커서 */
    }
    .wishlist-btn {
        margin-top: 10px;
        padding: 6px 12px;
        background-color: #ff4081;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 14px;
        cursor: pointer;
    }
    .wishlist-btn:hover {
        background-color: #e91e63;
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
<h3>하위 카테고리</h3>
<div class="subcategory-grid">
    <c:forEach var="sub" items="${subcategories}">
        <div class="subcategory-card">
            <a href="/products/subcategories/${sub.subcategoryId}">
                <img src="${sub.url}" alt="${sub.name}" />
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
    <div class="product-card">
        <c:choose>
            <c:when test="${not empty product.p_url}">
                <!-- ✅ 이미지+상품명 클릭 시 외부 URL 이동 -->
                <a href="${product.p_url}" target="_blank" class="product-link">
                    <img src="${pageContext.request.contextPath}${product.p_image}" alt="${product.p_name}" />
                    <h4>${product.p_name}</h4>
                </a>
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}${product.p_image}" alt="${product.p_name}" />
                <h4>${product.p_name}</h4>
            </c:otherwise>
        </c:choose>

        <p><strong>${product.p_price}</strong> 원</p>
        <p>⭐ ${product.p_rating}</p>

        <!-- 찜하기 버튼 -->
        <form action="/products/favorites/add" method="post">
            <input type="hidden" name="p_code" value="${product.p_code}" />
            <button type="submit" class="wishlist-btn">♡ 찜하기</button>
        </form>
    </div>
</c:forEach>


</body>
</html>
