<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 상품 목록</title>
<style>
    body { background-color: #fdfbf9; font-family: 'Pretendard', sans-serif; color: #4a3f35; margin: 0; padding: 30px; }
    h2 { text-align: center; margin-bottom: 40px; font-family: 'Nanum Myeongjo', serif; }
    table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; }
    th, td { padding: 15px; text-align: center; border-bottom: 1px solid #eee; }
    th { background-color: #f0eeec; font-weight: 700; }
    tr:hover { background-color: #faf7f5; }
    .btn { padding: 6px 12px; border: none; border-radius: 6px; cursor: pointer; font-size: 0.9rem; }
    .btn-edit { background-color: #8b7e74; color: #fff; }
    .btn-delete { background-color: #d9534f; color: #fff; }
</style>
</head>
<body>
<h2>📋 상품 목록</h2>

<table>
    <thead>
    <tr>
        <th>이미지</th>
        <th>상품명</th>
        <th>색상</th>
        <th>사이즈</th>
        <th>가격</th>
        <th>평점</th>
        <th>상위 카테고리</th>
        <th>서브카테고리</th>
        <th>관리</th>
    </tr>
</thead>
<tbody>
    <c:forEach var="product" items="${products}">
        <tr>
            <td>            
            	<!-- 이미지 썸네일 -->
                <c:if test="${not empty product.p_image}">
                    <img src="${product.p_image}" alt="${product.p_name}" style="width:80px; height:auto; border-radius:8px;" />
                </c:if>
            </td>
            <td>${product.p_name}</td>
            <td>${product.p_color}</td>
            <td>${product.p_size}</td>
            <td>${product.p_price}</td>
            <td>${product.p_rating}</td>
            <td>
                <c:choose>
                    <c:when test="${not empty product.categoryName}">${product.categoryName}</c:when>
                    <c:otherwise><span style="color:#aaa;">미분류</span></c:otherwise>
                </c:choose>
            </td>
            <td>
                <c:choose>
                    <c:when test="${not empty product.subcategoryName}">${product.subcategoryName}</c:when>
                    <c:otherwise><span style="color:#aaa;">미분류</span></c:otherwise>
                </c:choose>
            </td>
            <td>
                <a href="${pageContext.request.contextPath}/products/admin/edit/${product.p_code}" class="btn btn-edit">수정</a>
                <a href="${pageContext.request.contextPath}/products/admin/delete/${product.p_code}" class="btn btn-delete">삭제</a>
            </td>
        </tr>
    </c:forEach>
</tbody>
</table>

<!-- 페이징 -->
<c:set var="startPage" value="${currentPage-2}" />
<c:set var="endPage" value="${currentPage+2}" />

<!-- 최소값 보정 -->
<c:if test="${startPage < 1}">
    <c:set var="startPage" value="1" />
</c:if>
<c:if test="${endPage > totalPages}">
    <c:set var="endPage" value="${totalPages}" />
</c:if>

<div style="text-align:center; margin-top:20px;">
    <c:if test="${totalPages > 1}">
        <!-- 처음 / 이전 -->
        <c:if test="${currentPage > 1}">
            <a href="${pageContext.request.contextPath}/products/admin/list?page=1&size=${size}">« 처음</a>
            <a href="${pageContext.request.contextPath}/products/admin/list?page=${currentPage-1}&size=${size}">이전</a>
        </c:if>

        <!-- 현재 페이지 기준 앞뒤 2개만 표시 -->
        <c:forEach var="i" begin="${startPage}" end="${endPage}">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span style="font-weight:bold; color:#8b7e74;">${i}</span>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/products/admin/list?page=${i}&size=${size}"
                       style="margin:0 5px; text-decoration:none; color:#4a3f35;">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <!-- 다음 / 마지막 -->
        <c:if test="${currentPage < totalPages}">
            <a href="${pageContext.request.contextPath}/products/admin/list?page=${currentPage+1}&size=${size}">다음</a>
            <a href="${pageContext.request.contextPath}/products/admin/list?page=${totalPages}&size=${size}">마지막 »</a>
        </c:if>
    </c:if>
</div>

</div>
</body>
</html>
