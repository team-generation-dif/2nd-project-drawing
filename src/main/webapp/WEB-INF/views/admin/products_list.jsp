<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 관리자 | 상품 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@700&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
<style>
    body { 
        background-color: #fffaf5; 
        font-family: 'Pretendard', sans-serif; 
        margin: 0; 
        color: #4a3f35;
    }

    /* 관리자 페이지 레이아웃 */
    .admin-main-content {
        max-width: 1200px;
        margin: 60px auto 100px;
        padding: 0 40px;
        box-sizing: border-box;
    }

    /* 제목 영역 - 회원목록과 동일 */
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

    .admin-header .stats {
        font-size: 0.95rem;
        color: #8b7e74;
    }

    /* 테이블 디자인 - 그리다 회원목록 스타일 */
    .product-table { 
        width: 100%; 
        border-collapse: separate; 
        border-spacing: 0;
        background: #fff; 
        border-radius: 20px; 
        overflow: hidden; 
        box-shadow: 0 10px 30px rgba(139, 126, 116, 0.05);
        border: 1px solid #f7ede2;
    }

    th { 
        background-color: #fcf6f0; 
        color: #8b7e74;
        font-weight: 700; 
        padding: 20px;
        border-bottom: 1px solid #f7ede2;
        font-size: 0.9rem;
        text-transform: uppercase;
    }

    td { 
        padding: 18px 20px; 
        text-align: center; 
        border-bottom: 1px solid #fcf6f0; 
        font-size: 0.95rem;
        vertical-align: middle;
    }

    tr:last-child td { border-bottom: none; }
    tr:hover { background-color: #fffdfb; }

    /* 이미지 스타일 */
    .p-thumb {
        width: 65px;
        height: 65px;
        border-radius: 12px;
        object-fit: cover;
        border: 1px solid #f7ede2;
    }

    /* 버튼 스타일 - 통일 */
    .btn-group { display: flex; gap: 8px; justify-content: center; }
    
    .btn { 
        padding: 9px 16px; 
        border: none; 
        border-radius: 8px; 
        cursor: pointer; 
        font-size: 0.85rem; 
        font-weight: 600;
        text-decoration: none;
        transition: 0.3s;
    }
    
    .btn-edit { background-color: #8b7e74; color: #fff; }
    .btn-edit:hover { background-color: #4a3f35; }
    
    .btn-delete { background-color: #fdfaf8; color: #d9534f; border: 1px solid #f2e1df; }
    .btn-delete:hover { background-color: #d9534f; color: #fff; }

    /* 상품 가격 및 정보 강조 */
    .price-text { color: #e76f51; font-weight: 700; }
    .cate-badge { font-size: 11px; color: #abb3bb; display: block; margin-bottom: 3px; }

    /* 페이징 - 회원목록과 동일 */
    .pagination-wrapper {
        margin-top: 50px;
        display: flex;
        justify-content: center;
        gap: 8px;
    }

    .page-link {
        width: 40px;
        height: 40px;
        border-radius: 12px;
        background: #fff;
        color: #8b7e74;
        text-decoration: none;
        font-weight: 600;
        border: 1px solid #f7ede2;
        display: flex;
        justify-content: center;
        align-items: center;
        transition: 0.3s;
    }

    .page-link.active {
        background: #8b7e74;
        color: #fff;
        border-color: #8b7e74;
    }

    .page-link:hover:not(.active) {
        border-color: #8b7e74;
        transform: translateY(-2px);
    }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/guest/Header.jsp" />

<div class="admin-main-content">
    <div class="admin-header">
        <h2>📋 상품 통합 관리</h2>
        <div class="stats">
            전체 상품 수 <strong>${products.size()}</strong>개 | 
            <a href="${pageContext.request.contextPath}/products/admin/write" style="color:#e76f51; font-weight:bold; text-decoration:none; margin-left:10px;">+ 새 상품 등록</a>
        </div>
    </div>

    <table class="product-table">
        <thead>
            <tr>
                <th width="80">이미지</th>
                <th style="text-align:left; padding-left:30px;">상품명 정보</th>
                <th width="180">색상/사이즈</th>
                <th width="130">판매가</th>
                <th width="100">평점</th>
                <th width="180">카테고리</th>
                <th width="150">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="product" items="${products}">
                <tr>
                    <td>
                        <c:if test="${not empty product.p_image}">
                            <img src="${product.p_image}" alt="${product.p_name}" class="p-thumb" />
                        </c:if>
                    </td>
                    <td style="text-align: left; padding-left: 30px;">
                        <div style="font-weight: 700; color: #3d342c;">${product.p_name}</div>
                        <div style="font-size: 12px; color: #aaa; margin-top: 4px;">코드: ${product.p_code}</div>
                    </td>
                    <td>
                        <span style="font-weight: 600;">${product.p_color}</span><br>
                        <span style="font-size: 13px; color: #8b7e74;">${product.p_size}</span>
                    </td>
                    <td class="price-text">${product.p_price}원</td>
                    <td style="font-weight: 600; color: #f1c40f;">⭐ ${product.p_rating}</td>
                    <td>
                        <span class="cate-badge">${product.categoryName}</span>
                        <span style="font-weight: 600;">${product.subcategoryName}</span>
                    </td>
                    <td>
                        <div class="btn-group">
                            <a href="${pageContext.request.contextPath}/products/admin/edit/${product.p_code}" class="btn btn-edit">수정</a>
                            <a href="javascript:void(0);" onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/products/admin/delete/${product.p_code}';" class="btn btn-delete">삭제</a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="pagination-wrapper">
        <c:if test="${totalPages > 1}">
            <c:if test="${currentPage > 1}">
                <a href="?page=${currentPage-1}&size=${size}" class="page-link">&lt;</a>
            </c:if>

            <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
            <c:set var="endPage" value="${startPage + 4 > totalPages ? totalPages : startPage + 4}" />

            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                <a href="?page=${i}&size=${size}" class="page-link ${i == currentPage ? 'active' : ''}">${i}</a>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <a href="?page=${currentPage+1}&size=${size}" class="page-link">&gt;</a>
            </c:if>
        </c:if>
    </div>
</div>

</body>
</html>