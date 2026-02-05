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

    /* 4. 상품 그리드 - 카드 사이 간격 유지하며 위쪽 여백 최적화 */
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
        gap: 30px; /* 간격을 40px에서 30px로 조정하여 조밀하게 배치 */
    }

    .product-card {
        background: #ffffff;
        border-radius: 40px;
        padding: 20px; /* 패딩 소폭 감소 */
        box-shadow: 0 10px 30px rgba(139, 126, 116, 0.05);
        border: 1px solid #f7ede2;
        transition: all 0.3s ease;
    }

    .product-card img {
        width: 100%;
        height: 200px; /* 이미지 높이 조절 */
        object-fit: cover;
        border-radius: 25px;
        margin-bottom: 15px;
    }

    /* 5. 정보 및 버튼 */
    .product-info { text-align: left; padding: 0 5px; }
    .product-name { font-size: 1.05rem; font-weight: 700; margin-bottom: 5px; }
    .product-price { font-size: 1.1rem; color: #e76f51; font-weight: 700; margin-bottom: 15px; }

    .card-actions { display: flex; gap: 8px; }
    .btn-small {
        flex: 1;
        padding: 10px;
        border-radius: 12px;
        font-size: 0.85rem;
        font-weight: 600;
        border: none;
        cursor: pointer;
    }
    .btn-edit { background: #8b7e74; color: #fff; }
    .btn-delete { background: #f4eeea; color: #b7ada6; }

    /* 6. 하단 관리 영역 - 위쪽 여백(margin-top) 및 내부 패딩 감소 */
    .admin-footer {
        background: #fff;
        padding: 35px; /* 기존 50px에서 줄임 */
        border-radius: 40px;
        border: 1px solid #f7ede2;
        text-align: center;
        margin-top: 50px; /* 상품 리스트와의 간격을 80px에서 50px로 줄임 */
    }

    .upload-box {
        background: #fdfbf9;
        border: 2px dashed #eee1d5;
        border-radius: 25px;
        padding: 25px; /* 내부 여백 줄임 */
        margin: 20px 0;
    }

    .btn-primary {
        background: #e76f51;
        color: #fff;
        padding: 14px 35px;
        border-radius: 50px;
        font-size: 1rem;
        font-weight: 700;
        border: none;
        cursor: pointer;
    }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/guest/Header.jsp" />

<div class="admin-container">
    <header class="admin-header">
        <div>
            <h2>CSV등록하기</h2>
            <p style="color: #bcaaa4; margin-top: 10px;">등록된 취향 아이템들을 관리하세요.</p>
        </div>
        <a href="${pageContext.request.contextPath}/products/admin/new" class="btn-primary" style="text-decoration: none;">+ 개별상품 등록</a>
    </header>

    <div class="product-grid">
        <c:forEach var="product" items="${products}">
            <div class="product-card">
                <img src="${product.p_image}" alt="item">
                <div class="product-info">
                    <div class="product-name">${product.p_name}</div>
                    <div class="product-price">${product.p_price}원</div>
                    <a href="${pageContext.request.contextPath}/products/${product.p_code}" style="color:#bcaaa4; font-size:0.8rem; text-decoration:none;">View Detail →</a>
                </div>
                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/products/admin/edit/${product.p_code}" class="btn-small btn-edit">수정</a>
                    <button class="btn-small btn-delete" onclick="confirmDelete('${product.p_code}')">삭제</button>
                </div>
            </div>
        </c:forEach>
    </div>

    <footer class="admin-footer">
        <h3>Bulk Registration</h3>
        <p style="color: #8b7e74;">CSV 파일을 사용하여 여러 상품을 한 번에 등록할 수 있습니다.</p>
        
        <div class="upload-box">
            <form action="${pageContext.request.contextPath}/products/admin/upload" method="post" enctype="multipart/form-data">
                <label for="csv-upload" class="custom-file-upload">✦ CSV 파일 선택하기</label>
                <input type="file" id="csv-upload" name="file" accept=".csv" required />
                <button type="submit" class="btn-small btn-edit" style="width: auto; padding: 15px 30px;">업로드 실행</button>
            </form>
        </div>
        
        <c:if test="${not empty message}">
            <div style="color: #e76f51; font-weight: 600;">${message}</div>
        </c:if>
    </footer>
</div>

<script>
    function confirmDelete(code) {
        if(confirm("정말 이 아이템을 삭제하시겠습니까?")) {
            location.href = "${pageContext.request.contextPath}/products/admin/delete/" + code;
        }
    }
</script>

</body>
</html>