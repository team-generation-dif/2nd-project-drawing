<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>${category.name}</h2>

<!-- 하위 카테고리 목록 -->
<div class="subcategory-grid">
    <c:forEach var="sub" items="${subcategories}">
        <div style="text-align:center; display:inline-block; margin:10px;">
            <a href="/products/subcategories/${sub.subcategoryId}">
                <img src="${sub.image}" alt="${sub.name}" style="width:100px; height:100px; border-radius:20px;" />
                <p>${sub.name}</p>
            </a>
        </div>
    </c:forEach>
</div>

<hr/>

<!-- 상품 목록 -->
<h3>상품 목록</h3>
<div class="product-grid">
    <c:forEach var="product" items="${products}">
        <div class="product-item" style="display:inline-block; margin:15px; text-align:center;">
            <img src="${product.p_image}" alt="${product.p_name}" style="width:150px; height:150px; border-radius:10px;" />
            <h4>${product.p_name}</h4>
            <p>${product.p_price}원</p>
            <p>⭐ ${product.p_rating}</p>
        </div>
    </c:forEach>
</div>
</body>
</html>