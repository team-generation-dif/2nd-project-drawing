<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
   /* 상단 카테고리 메뉴 */
.category-menu {
    display: grid;
    grid-template-columns: repeat(6, 1fr); /* ✅ 6개 열 */
    gap: 10px;
    margin: 20px auto;
    width: 90%;
    text-align: center;
}

.category-item {
    background: #f0f0f0;
    padding: 10px;
    border-radius: 6px;
    font-weight: bold;
    cursor: pointer;
}

/* 세로 찜 목록 */
.favorites-list {
    margin: 30px auto;
    width: 80%;
}

.category-title {
    font-size: 20px;
    font-weight: bold;
    margin-top: 20px;
    color: #222;
}

.subcategory-title {
    font-size: 16px;
    font-weight: bold;
    margin: 10px 0 5px 20px;
    color: #555;
}

.product-card {
    display: inline-block;
    width: 150px; /* ✅ 카드 크기 줄임 */
    margin: 10px;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 6px;
    text-align: center;
    background: #fff;
}
.product-card img {
    width: 100%;
    height: auto;
    border-radius: 4px;
}

</style>

<h2 style="text-align:center;">내 찜 목록*</h2>

<!-- 상위 카테고리 메뉴 -->
<div class="category-menu">
    <c:forEach var="cat" items="${categories}">
        <div class="category-item">
            📂 ${cat.name}
        </div>
    </c:forEach>
</div>

<!-- 찜 목록 (세로 구조) -->
<div class="favorites-list">
    <c:set var="currentCat" value=""/>
    <c:set var="currentSub" value=""/>

    <c:forEach var="product" items="${favorites}">
        <!-- 상위 카테고리 변경 시 출력 -->
        <c:if test="${currentCat != product.categoryName}">
            <h2 class="category-title">📂 ${product.categoryName}</h2>
            <c:set var="currentCat" value="${product.categoryName}"/>
            <c:set var="currentSub" value=""/>
        </c:if>

        <!-- 하위 카테고리 변경 시 출력 -->
        <c:if test="${currentSub != product.subcategoryName}">
            <h3 class="subcategory-title">🗂 ${product.subcategoryName}</h3>
            <c:set var="currentSub" value="${product.subcategoryName}"/>
        </c:if>

        <!-- 상품 카드 -->
        <div class="product-card">
            <img src="${product.p_image}" alt="${product.p_name}" />
            <h4>${product.p_name}</h4>
            <p><strong>${product.p_price}</strong> 원</p>
            <p>⭐ ${product.p_rating}</p>
            <form action="/products/favorites/remove" method="post">
                <input type="hidden" name="p_code" value="${product.p_code}" />
                <button type="submit" class="wishlist-btn">♥ 찜 해제</button>
            </form>
        </div>
    </c:forEach>
</div>

