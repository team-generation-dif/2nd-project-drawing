<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 관리</title>
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
    .product-card {
        display: inline-block;
        width: 200px;
        margin: 15px;
        padding: 10px;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 10px;
        text-align: center;
    }
    .product-card img {
        width: 150px;
        height: 150px;
        border-radius: 10px;
    }
    .product-card button {
        margin: 5px;
        padding: 5px 10px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
    .edit-btn {
        background-color: #4CAF50;
        color: white;
    }
    .delete-btn {
        background-color: #f44336;
        color: white;
    }
</style>
<script>
    // 삭제 확인 팝업
    function confirmDelete(url) {
        if (confirm("정말 삭제하시겠습니까?")) {
            window.location.href = url;
        }
    }
</script>
</head>
<body>
<h2>상품 목록</h2>

<!-- 상품 목록 출력 -->
<c:forEach var="product" items="${products}">
  <div class="product-card">
    <img src="${product.p_image}" alt="상품 이미지" />
    <p>${product.p_name}</p>
    <p>${product.p_price}원</p>
    <a href="${pageContext.request.contextPath}/products/${product.p_code}">자세히 보기</a>
    <br/>

    <!-- 수정 버튼 -->
    <a href="${pageContext.request.contextPath}/products/admin/edit/${product.p_code}">
        <button class="edit-btn">수정</button>
    </a>

    <!-- 삭제 버튼 (확인 팝업 추가) -->
    <button class="delete-btn"
        onclick="confirmDelete('${pageContext.request.contextPath}/products/admin/delete/${product.p_code}')">
        삭제
    </button>
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
