<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 내 아뜰리에</title>
</head>
<body>
	<%@ include file="../../guest/Header.jsp" %>
	<div class="container">
		<h2>내 라이브러리</h2>
		<div>
			<a href="/user/interior/draw">새 인테리어</a>
		</div>
		<div class="">
			<c:forEach var="list" items="${dto}">
				<div class="card">
					<a href="/user/interior/draw?i_code=${list.i_code}">
						<div class="thumb-img"><img src="${list.i_image}"></div>
						<p>${list.i_title}
					</a>
					<p><small>${list.i_date}</small>
					<a href="/user/interior/delete?i_code=${list.i_code}" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
				</div>
			</c:forEach>
		</div>
	</div>
</body>
</html>