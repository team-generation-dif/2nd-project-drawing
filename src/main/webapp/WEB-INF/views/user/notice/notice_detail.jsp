<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="content">${notice.n_content}</div>

<c:if test="${not empty sessionScope.adminId}">
    <button onclick="location.href='/admin/notice_edit?n_code=${notice.n_code}'">수정</button>
    <button onclick="if(confirm('삭제할까요?')) location.href='/admin/notice_delete?n_code=${notice.n_code}'">삭제</button>
</c:if>
<div class="btn-group">
    <a href="/notice/list">목록으로</a>
    
    <c:if test="${not empty sessionScope.adminId}">
        <a href="/admin/notice_edit?n_code=${notice.n_code}">수정하기</a>
        <a href="javascript:void(0);" onclick="if(confirm('삭제할까요?')) location.href='/admin/notice_delete?n_code=${notice.n_code}'">삭제하기</a>
    </c:if>
</div>
</body>
</html>