<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 관리</title>
</head>
<body>
<h2>상품 목록</h2>

<!-- 상품 목록 출력 -->
<c:forEach var="product" items="${products}">
  <div class="product-card">
    <img src="${product.p_image}" alt="상품 이미지" />
    <p>${product.p_name}</p>
    <p>${product.p_price}</p>
    <a href="${pageContext.request.contextPath}/products/${product.p_code}">자세히 보기</a>
  </div>
</c:forEach>

<hr/>

<!-- CSV 업로드 폼 -->
<h3>CSV 파일로 상품 대량 등록</h3>
<form action="${pageContext.request.contextPath}/products/admin/upload" method="post" enctype="multipart/form-data">
    <label for="file">CSV 파일 선택:</label>
    <input type="file" name="file" accept=".csv" required />
    <button type="submit">업로드</button>
</form>

<!-- 업로드 결과 메시지 -->
<c:if test="${not empty message}">
    <p style="color:green;">${message}</p>
</c:if>

<!-- 개별 등록 버튼 -->
<a href="${pageContext.request.contextPath}/products/admin/new">
    <button>개별 상품 등록</button>
</a>
</body>
</html>
