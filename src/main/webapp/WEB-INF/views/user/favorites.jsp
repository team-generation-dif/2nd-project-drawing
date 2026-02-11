<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 내 찜 목록</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
<style>
    body { background-color: #fffaf5; font-family: 'Pretendard', sans-serif; color: #4a3f35; margin: 0; }
    /* 1. 메인 컨테이너 상단 여백 축소 */
.main-container {
    width: 90%;
    max-width: 1100px;
    margin: 30px auto 100px; /* 기존 상단 60px -> 30px로 축소 */
}

/* 2. 메인 타이틀 하단 여백 축소 */
h2.main-title {
    font-family: 'Nanum Myeongjo', serif;
    font-size: 2rem;
    text-align: center;
    margin-bottom: 20px; /* 기존 50px -> 20px로 축소 */
}

/* 3. 상단 메뉴와 리스트 사이 여백 축소 */
.category-menu {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 30px; /* 기존 50px -> 30px로 축소 */
}

/* 4. 카테고리 섹션 상단 여백 제거/축소 */
.category-section {
    margin-top: 10px; /* 기존 60px -> 10px로 축소 */
    padding-bottom: 0px;
}

/* 5. 하위 카테고리 제목 상하 간격 축소 */
.subcategory-title {
    font-size: 1rem;
    margin: 5px 0 10px 0; /* 상단 5px, 하단 10px로 아주 좁게 설정 */
    color: #8b7e74;
    font-weight: 600;
}
    h2.main-title { font-family: 'Nanum Myeongjo', serif; font-size: 2rem; text-align: center; margin-bottom: 50px; }

    /* 상단 메뉴 */
    .category-menu { display: flex; justify-content: center; flex-wrap: wrap; gap: 12px; margin-bottom: 50px; }
    .category-item { background: #ffffff; padding: 12px 24px; border-radius: 50px; font-weight: 600; cursor: pointer; border: 1px solid #eee1d5; transition: 0.3s; }
    .category-item:hover { background: #8b7e74; color: #fff; }

    /* 섹션 및 구분선 */
    .category-section { margin-top: 60px; padding-bottom: 20px; }
    .category-title { 
    font-family: 'Nanum Myeongjo', serif; 
    font-size: 1.5rem; 
    margin-bottom: 3px; /* 간격 축소 */
    display: block; 
    color: #4a3f35; 
}
    
    /* 하위 카테고리 이름 및 아이콘 */
    .subcategory-group { 
    margin-bottom: 20px; /* 기존 40px에서 20px로 축소 */
}
.subcategory-title { 
    font-size: 1.05rem; 
    margin: 10px 0 10px 0; /* 상단 10px, 하단 10px로 축소 */
    color: #8b7e74; 
    font-weight: 600; 
    display: flex; 
    align-items: center; 
}
    .subcategory-title::before { content: '📂'; margin-right: 8px; }

    /* 상품 그리드 */
    .product-grid { 
    display: grid; 
    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); 
    gap: 20px; /* 카드 사이 간격도 살짝 축소 */
    border-top: 1px solid #eee1d5; 
    padding-top: 15px; /* 선과 카드 사이 여백 축소 */
}
    
    .product-card { background: #ffffff; padding: 20px; border-radius: 25px; border: 1px solid #f7ede2; transition: 0.3s; box-shadow: 0 10px 25px rgba(139, 126, 116, 0.05); text-align: center; }
    .product-card:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(139, 126, 116, 0.1); }
    .product-card img { width: 100%; aspect-ratio: 1 / 1; object-fit: cover; border-radius: 18px; margin-bottom: 15px; }
    .price-tag { font-weight: 700; color: #e76f51; font-size: 1.1rem; margin: 10px 0; }
    .wishlist-btn { width: 100%; padding: 10px; border: none; border-radius: 12px; background-color: #eeeae7; color: #8b7e74; font-weight: 600; cursor: pointer; margin-top: 10px; }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/guest/Header.jsp" />

<div class="main-container">
    <h2 class="main-title">✨ 내가 찜한 아이템</h2>

    <div class="category-menu">
        <c:forEach var="cat" items="${categories}">
            <div class="category-item" onclick="location.href='#cat-${cat.name}'">${cat.name}</div>
        </c:forEach>
    </div>

    <div class="favorites-list">
        <c:set var="currentCat" value=""/>
        <c:set var="currentSub" value=""/>

        <c:forEach var="product" items="${favorites}" varStatus="status">
            
            <%-- 1. 상위 카테고리가 바뀔 때 --%>
            <c:if test="${currentCat != product.categoryName}">
                <%-- 이전 카테고리의 그리드와 그룹 태그 닫기 --%>
                <c:if test="${not empty currentCat}"></div></div></c:if>
                
                <div class="category-section" id="cat-${product.categoryName}">
                    <span class="category-title">📂 ${product.categoryName}</span>
                <c:set var="currentCat" value="${product.categoryName}"/>
                <c:set var="currentSub" value=""/> <%-- 카테고리 바뀌면 서브도 초기화 --%>
            </c:if>

            <%-- 2. 하위 카테고리가 바뀔 때 --%>
            <c:if test="${currentSub != product.subcategoryName}">
                <%-- 이전 서브 카테고리의 그리드 태그만 닫기 --%>
                <c:if test="${not empty currentSub}"></div></div></c:if>
                
                <div class="subcategory-group">
                    <div class="subcategory-title">${product.subcategoryName}</div>
                    <div class="product-grid"> <%-- 여기서 그리드 시작 --%>
                <c:set var="currentSub" value="${product.subcategoryName}"/>
            </c:if>

            <%-- 3. 상품 카드 출력 --%>
            <div class="product-card">
                <a href="${product.p_url}" target="_blank" style="text-decoration:none; color:inherit;">
                    <img src="${pageContext.request.contextPath}${product.p_image}" alt="${product.p_name}" />
                    <h4 style="margin: 0; font-size: 1rem; height: 2.4em; overflow: hidden;">${product.p_name}</h4>
                    <p class="price-tag">${product.p_price} 원</p>
                    <p style="font-size:0.85rem; color:#bcaaa4; margin-bottom: 10px;">⭐ ${product.p_rating}</p>
                </a>
                <form action="/products/favorites/remove" method="post">
                    <input type="hidden" name="p_code" value="${product.p_code}" />
                    <button type="submit" class="wishlist-btn">♥ 찜 해제</button>
                </form>
            </div>
            
            <%-- 4. 마지막 요소일 때 모든 열린 태그 닫기 --%>
            <c:if test="${status.last}">
                </div></div></div>
            </c:if>
        </c:forEach>
    </div>
</div>

<footer style="text-align: center; padding: 60px 0; color: #bcaaa4; font-size: 0.9rem; background-color: #fffaf5;">
    <p>&copy; 2026 그리다. 모든 권리가 보호됩니다.</p>
</footer>

</body>
</html>