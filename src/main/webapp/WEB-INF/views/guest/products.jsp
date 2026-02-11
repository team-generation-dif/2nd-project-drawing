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
        padding: 20px 20px 10px; /* 상단 여백 40px, 좌우 20px, 하단 100px */
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
        margin: 20px 0 20px;
        color: #8b7e74;
    }

    /* 하위 카테고리 그리드 */
    .subcategory-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        margin-bottom: 20px;
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
    /* 페이징 스타일 */
.pagination {
    display: flex;
    justify-content: center;
    gap: 8px;
    margin: 50px 0;
}

.pagination a {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    border-radius: 8px;
    background: #fff;
    border: 1px solid #dee2e6;
    color: #4a3f35;
    text-decoration: none;
    font-weight: 600;
    transition: 0.3s;
}

.pagination a:hover {
    background-color: #fff0ed;
    border-color: #e76f51;
    color: #e76f51;
}

.pagination a.active {
    background-color: #e76f51;
    border-color: #e76f51;
    color: white;
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
   </div>

   <!-- 상품 목록 -->
   <div class="container">
    <h3>상품 목록</h3>
    <div class="product-grid">
        <c:forEach var="product" items="${products}">
            <div class="product-card">
                <c:choose>
                    <c:when test="${not empty product.p_url}">
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

                <p class="price-tag">${product.p_price} 원</p>
                <p class="rating-tag">⭐ ${product.p_rating}</p>

                <form action="/products/favorites/add" method="post">
                    <input type="hidden" name="p_code" value="${product.p_code}" />
                    <button type="submit" class="wishlist-btn">♡ 찜하기</button>
                </form>
            </div>
        </c:forEach>
    </div>

<div class="pagination-container" style="margin-top: 80px; text-align: center; margin-bottom: 100px;">
    <div class="pagination-grida">
        
        <c:if test="${currentPage > 1}">
            <a href="?page=${currentPage - 1}" class="grida-page-link">&lt;</a>
        </c:if>

        <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
        <c:set var="endPage" value="${startPage + 4 > totalPages ? totalPages : startPage + 4}" />
        
        <c:if test="${endPage == totalPages && endPage - 4 > 0}">
            <c:set var="startPage" value="${endPage - 4}" />
        </c:if>

        <c:forEach var="i" begin="${startPage}" end="${endPage}">
            <a href="?page=${i}" class="grida-page-link ${i == currentPage ? 'active' : ''}">
                ${i}
            </a>
        </c:forEach>

        <c:if test="${currentPage < totalPages}">
            <a href="?page=${currentPage + 1}" class="grida-page-link">&gt;</a>
        </c:if>
        
    </div>
</div>

<style>
/* 클래스명을 'grida-page-link'로 새로 정의해서 기존 스타일과 충돌을 방지합니다 */
.pagination-grida {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 8px;
}

.grida-page-link {
    width: 44px;
    height: 44px;
    border-radius: 14px; /* 인테리어 페이지와 동일한 곡률 */
    background: #fff;
    color: #8b7e74; /* 차분한 브라운 */
    text-decoration: none;
    font-weight: 600;
    border: 1px solid #f7ede2; /* 연한 베이지 테두리 */
    display: flex;
    justify-content: center;
    align-items: center;
    transition: all 0.3s ease;
}

.grida-page-link:hover:not(.active) {
    background: #fdfbf9;
    border-color: #8b7e74;
    transform: translateY(-2px);
}

.grida-page-link.active {
    background: #8b7e74; /* 활성화된 버튼 색상 */
    color: #fff !important;
    border-color: #8b7e74;
    box-shadow: 0 5px 15px rgba(139, 126, 116, 0.2);
}
</style>

<jsp:include page="/WEB-INF/views/guest/footer.jsp" />
</body>
</html>
