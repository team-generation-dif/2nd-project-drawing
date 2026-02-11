<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 관리자 | CSV 상품 등록</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@700&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
<style>
    /* 1. 기본 배경 및 공통 레이아웃 */
    body {
        background-color: #fffaf5;
        font-family: 'Pretendard', sans-serif;
        color: #4a3f35;
        margin: 0;
        padding: 0;
    }

    .admin-main-content {
        max-width: 1200px;
        margin: 60px auto 100px;
        padding: 0 40px;
        box-sizing: border-box;
    }

    /* 2. 상단 헤더 섹션 - 이전 페이지들과 동일 */
    .admin-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 40px;
        border-bottom: 2px solid #8b7e74;
        padding-bottom: 20px;
    }

    .admin-header h2 {
        font-family: 'Nanum Myeongjo', serif;
        font-size: 2.2rem;
        margin: 0;
        color: #4a3f35;
    }

    /* 3. 업로드 폼 카드 스타일 */
    .upload-card {
        background: #fff;
        padding: 50px 40px;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(139, 126, 116, 0.05);
        border: 1px solid #f7ede2;
        max-width: 600px; /* 폼 너비 조정 */
        margin: 0 auto;
        text-align: center;
    }

    .upload-info {
        color: #8b7e74;
        font-size: 0.95rem;
        margin-bottom: 30px;
        line-height: 1.6;
    }

    /* 4. 파일 입력창 커스텀 */
    .file-input-wrapper {
        margin-bottom: 25px;
    }

    input[type="file"] {
        width: 100%;
        padding: 12px;
        border: 1px solid #f7ede2;
        border-radius: 10px;
        background: #fcf6f0;
        color: #8b7e74;
        cursor: pointer;
        box-sizing: border-box;
    }

    /* 5. 버튼 스타일 - 그리다 테마 통일 */
    .btn-submit {
        background-color: #8b7e74;
        color: #fff;
        padding: 15px 30px;
        border: none;
        border-radius: 12px;
        font-weight: 700;
        font-size: 1rem;
        cursor: pointer;
        transition: 0.3s;
        width: 100%;
        margin-bottom: 15px;
    }

    .btn-submit:hover {
        background-color: #4a3f35;
        transform: translateY(-2px);
    }

    .btn-back {
        display: inline-block;
        color: #8b7e74;
        text-decoration: none;
        font-weight: 600;
        font-size: 0.9rem;
        padding: 10px;
        transition: 0.3s;
    }

    .btn-back:hover {
        color: #e76f51;
    }

    /* 6. 메시지 스타일 */
    .message {
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 25px;
        font-weight: 600;
        font-size: 0.9rem;
    }
    .success { background-color: #f0f9f0; color: #2d6a4f; border: 1px solid #d8ead8; }
    .error { background-color: #fff5f5; color: #c53030; border: 1px solid #fed7d7; }

    hr {
        border: 0;
        border-top: 1px solid #f7ede2;
        margin: 25px 0;
    }
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/guest/Header.jsp" />

    <div class="admin-main-content">
        <div class="admin-header">
            <h2>📂 CSV 상품 등록</h2>
            <div style="font-size: 0.9rem; color: #8b7e74;">관리자 전용 업로드 모드</div>
        </div>

        <div class="upload-card">
            <div class="upload-info">
                <strong>CSV 파일을 업로드하여 상품을 대량으로 등록하세요.</strong><br>
                파일 형식(.csv)과 데이터 양식을 다시 한번 확인해 주세요.
            </div>

            <c:if test="${not empty message}">
                <div class="message success">✨ ${message}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="message error">⚠️ ${errorMessage}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/ products/admin/upload" 
                  method="post" enctype="multipart/form-data">
                
                <div class="file-input-wrapper">
                    <input type="file" name="file" accept=".csv" required />
                </div>
                
                <button type="submit" class="btn-submit">상품 데이터 업로드 시작</button>
            </form>

            <hr/>

            <a href="${pageContext.request.contextPath}/products/admin/list" class="btn-back">
                ← 상품 목록으로 돌아가기
            </a>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/guest/footer.jsp" />
</body>
</html>