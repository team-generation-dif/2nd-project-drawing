<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 관리자 | CSV상품등록</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
<style>
    /* 1. 기본 배경 및 폰트 */
    body {
        background-color: #fffaf5;
        font-family: 'Pretendard', sans-serif;
        color: #4a3f35;
        margin: 0;
        padding: 0;
    }

    /* 2. 메인 컨테이너 - 상단 여백 소폭 감소 */
    .admin-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 60px 40px; /* 기존 80px에서 60px로 줄임 */
    }

    /* 3. 상단 헤더 섹션 - 하단 간격(margin-bottom) 대폭 감소 */
    .admin-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        margin-bottom: 30px; /* 기존 50px에서 30px로 줄여 h2와 카드 사이 밀착 */
        padding: 0 10px;
    }

    .admin-header h2 {
        font-family: 'Nanum Myeongjo', serif;
        font-size: 2.2rem; /* 크기를 살짝 줄여 공간 확보 */
        margin: 0;
        color: #3d342c;
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
    <jsp:include page="/WEB-INF/views/guest/Header.jsp" />
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