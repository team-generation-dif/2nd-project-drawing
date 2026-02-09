<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 관리자 | 상품 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
<style>
    /* 1. 기본 테마 설정 */
    body { 
        background-color: #fffaf5; 
        font-family: 'Pretendard', sans-serif; 
        color: #4a3f35; 
        margin: 0; 
        padding: 50px 20px; 
    }

    .admin-container {
        max-width: 1300px;
        margin: 0 auto;
    }

    h2 { 
        text-align: left; 
        margin-bottom: 40px; 
        font-family: 'Nanum Myeongjo', serif; 
        font-size: 2rem;
        border-bottom: 2px solid #8b7e74;
        padding-bottom: 20px;
    }

    /* 2. 테이블 디자인 (세련된 매거진 느낌) */
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
        padding: 20px 15px;
        border-bottom: 1px solid #f7ede2;
    }

    td { 
        padding: 18px 15px; 
        text-align: center; 
        border-bottom: 1px solid #fcf6f0; 
        font-size: 0.95rem;
    }

    tr:last-child td { border-bottom: none; }
    tr:hover { background-color: #fffdfb; }

    /* 3. 관리 버튼 스타일 */
    .btn-group { display: flex; gap: 6px; justify-content: center; }
    
    .btn { 
        padding: 8px 14px; 
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
    
    .btn-delete { background-color: #f4edea; color: #d9534f; border: 1px solid #f2e1df; }
    .btn-delete:hover { background-color: #d9534f; color: #fff; }

    /* 4. [중요] 그리다 페이징 스타일 (게시판 디자인 계승) */
    .pagination-wrapper {
        margin-top: 50px;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 8px;
    }

    .page-link {
        width: 40px;
        height: 40px;
        border-radius: 12px; /* 둥근 사각형 */
        background: #fff;
        color: #8b7e74;
        text-decoration: none;
        font-weight: 600;
        border: 1px solid #f7ede2;
        display: flex;
        justify-content: center;
        align-items: center;
        transition: all 0.3s ease;
        font-size: 0.9rem;
    }

    .page-link:hover:not(.active) {
        background: #fdfbf9;
        border-color: #8b7e74;
        transform: translateY(-2px);
    }

    .page-link.active {
        background: #8b7e74;
        color: #fff !important;
        border-color: #8b7e74;
        box-shadow: 0 5px 15px rgba(139, 126, 116, 0.2);
    }

    .page-nav {
        font-weight: 800;
        color: #8b7e74;
        padding: 0 10px;
        text-decoration: none;
    }
</style>
</head>
<body>

<div class="admin-container">
    <h2>📋 상품 통합 관리</h2>

    <table class="product-table">
        <thead>
            <tr>
                <th>이미지</th>
                <th>상품명</th>
                <th>색상/사이즈</th>
                <th>가격</th>
                <th>평점</th>
                <th>카테고리</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="product" items="${products}">
                <tr>
                    <td>
                        <c:if test="${not empty product.p_image}">
                            <img src="${product.p_image}" alt="${product.p_name}" style="width:60px; height:60px; border-radius:10px; object-fit: cover; border: 1px solid #eee;" />
                        </c:if>
                    </td>
                    <td style="font-weight: 600; color: #3d342c;">${product.p_name}</td>
                    <td><span style="color: #8b7e74;">${product.p_color}</span> / ${product.p_size}</td>
                    <td style="color: #e76f51; font-weight: 700;">${product.p_price}원</td>
                    <td>⭐ ${product.p_rating}</td>
                    <td>
                        <small style="display:block; color:#aaa;">${product.categoryName}</small>
                        <strong>${product.subcategoryName}</strong>
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
            <c:if test="${endPage == totalPages && endPage - 4 > 0}"><c:set var="startPage" value="${endPage - 4}" /></c:if>

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