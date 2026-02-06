<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 상품 목록</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@700&family=Pretendard:wght@400;600;700&display=swap');

    body {
        font-family: 'Pretendard', sans-serif;
        background-color: #fffaf5; /* 메인 페이지와 동일한 배경색 */
        margin: 0;
        padding: 0;
        color: #4a3f35;
        line-height: 1.6;
    }

    /* 전체 컨테이너: 메인 페이지의 대시보드와 너비를 맞춤 */
    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 40px 20px 100px; /* 상단 여백 40px, 좌우 20px, 하단 100px */
        box-sizing: border-box;
    }

    h2 {
        font-family: 'Nanum Myeongjo', serif;
        font-size: 2rem;
        color: #4a3f35;
        margin-bottom: 30px;
    }

    h3 {
        font-size: 1.2rem;
        font-weight: 700;
        margin: 40px 0 20px;
        color: #8b7e74;
    }

    /* 하위 카테고리 그리드 */
    .subcategory-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        margin-bottom: 50px;
    }

    .subcategory-card {
        background: #fff;
        border-radius: 15px;
        width: calc(16.66% - 13px); /* 6개씩 배치 */
        min-width: 120px;
        padding: 15px 10px;
        text-align: center;
        box-shadow: 0 4px 15px rgba(0,0,0,0.03);
        transition: 0.3s;
        text-decoration: none;
    }

    .subcategory-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(231, 111, 81, 0.1);
    }

    .subcategory-card img {
        width: 80px;
        height: 80px;
        border-radius: 50%; /* 동그란 아이콘 스타일 */
        object-fit: cover;
        margin-bottom: 10px;
    }

    .subcategory-card p {
        margin: 0;
        font-size: 14px;
        color: #4a3f35;
        font-weight: 600;
    }

    /* 상품 그리드 */
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 30px;
    }

    .product-card {
        background: #fff;
        border-radius: 20px;
        padding: 15px;
        transition: 0.3s;
        position: relative;
        overflow: hidden;
        box-shadow: 0 5px 15px rgba(0,0,0,0.02);
    }

    .product-card:hover {
        box-shadow: 0 15px 30px rgba(0,0,0,0.08);
    }

    .product-card img {
        width: 100%;
        aspect-ratio: 1 / 1;
        border-radius: 15px;
        object-fit: cover;
        margin-bottom: 15px;
    }

    .product-card h4 {
        margin: 10px 0;
        font-size: 16px;
        font-weight: 600;
        color: #2f3438;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .product-card p {
        margin: 5px 0;
        font-size: 15px;
    }
    .product-link {
        text-decoration: none;
        color: inherit;
        cursor: pointer; /* ✅ 손 모양 커서 */
    }
/*    .wishlist-btn {
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
        background-color: #e91e63; */

    .price-tag {
        color: #e76f51;
        font-weight: 800;
        font-size: 1.1rem;
    }

    .rating-tag {
        color: #ffb400;
        font-size: 13px;
    }

    /* 버튼 스타일 */
    .btn-group {
        display: flex;
        gap: 8px;
        margin-top: 15px;
    }

    .btn-view {
        flex: 2;
        padding: 8px;
        background-color: #e76f51;
        color: white;
        text-decoration: none;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 700;
        text-align: center;
    }

    .wishlist-btn {
        flex: 1;
        padding: 8px;
        background: #f7f9fa;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        cursor: pointer;
        font-size: 13px;
        color: #828c94;
    }

    .wishlist-btn:hover {
        background: #fff0ed;
        color: #e76f51;
    }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/guest/Header.jsp" />

    <div class="container"> <h2>
          <c:choose>
            <c:when test="${not empty category}">${category.name}</c:when>
            <c:otherwise>${subcategory.name}</c:otherwise>
          </c:choose>
        </h2>

        <c:if test="${not empty subcategories}">
            <h3>하위 카테고리</h3>
            <div class="subcategory-grid">
                <c:forEach var="sub" items="${subcategories}">
                    <a href="/products/subcategories/${sub.subcategoryId}" class="subcategory-card">
                        <img src="${sub.url}" alt="${sub.name}" />
                        <p>${sub.name}</p>
                    </a>
                </c:forEach>
            </div>
        </c:if>

        <h3>상품 목록</h3>
        <div class="product-grid">
            <c:forEach var="product" items="${products}">
                <div class="product-card">
                    <img src="${product.p_image}" alt="${product.p_name}" />
                    <h4>${product.p_name}</h4>
                    <p class="price-tag">${product.p_price} 원</p>
                    <p class="rating-tag">⭐ ${product.p_rating}</p>
                    
                    <div class="btn-group">
                        <c:if test="${not empty product.p_url}">
                            <a href="${product.p_url}" target="_blank" class="btn-view">상세보기</a>
                        </c:if>
                        
                        <form action="/products/favorites/add" method="post" style="flex:1;">
                            <input type="hidden" name="p_code" value="${product.p_code}" />
                            <button type="submit" class="wishlist-btn">♡</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
	</div>

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
