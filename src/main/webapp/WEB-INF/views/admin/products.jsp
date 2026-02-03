<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>
</head>
<body>
<h2>상품 목록</h2>
<c:forEach var="product" items="${products}">
  <div class="product-card">
    <img src="${product.p_image}" alt="상품 이미지" />
    <p>${product.p_name}</p>
    <p>${product.p_price}</p>
    <!-- 상품 클릭 시 컨트롤러로 요청 -->
    <a href="${pageContext.request.contextPath}/products/${product.p_code}">자세히 보기</a>
  </div>
</c:forEach>
</body>
</html>
