<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CSV 업로드</title>
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
    .form-container {
        background: #fff;
        padding: 30px;
        border: 1px solid #ddd;
        border-radius: 10px;
        max-width: 500px;
        margin: auto;
    }
    .success {
        color: green;
        font-weight: bold;
        margin-bottom: 15px;
    }
    .error {
        color: red;
        font-weight: bold;
        margin-bottom: 15px;
    }
</style>
</head>
<body>
<div class="form-container">
    <h2>📂 CSV 파일 업로드</h2>

    <!-- 업로드 결과 메시지 -->
    <c:if test="${not empty message}">
        <p class="success">${message}</p>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <p class="error">${errorMessage}</p>
    </c:if>

    <!-- 업로드 폼 -->
    <form action="${pageContext.request.contextPath}/products/admin/upload" 
          method="post" enctype="multipart/form-data">
        <label for="file">CSV 파일 선택:</label>
        <input type="file" name="file" accept=".csv" required />
        <button type="submit">업로드</button>
    </form>

    <hr/>

    <!-- 상품 목록으로 돌아가기 -->
    <a href="${pageContext.request.contextPath}/products/admin/list">
        <button>상품 목록으로 돌아가기</button>
    </a>
</div>
</body>
</html>
