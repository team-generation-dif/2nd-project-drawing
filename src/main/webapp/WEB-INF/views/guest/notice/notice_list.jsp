<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>공지사항 목록</title>
    <style>
        .container { max-width: 1000px; margin: 50px auto; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border-bottom: 1px solid #eee; padding: 15px; text-align: left; }
        th { background-color: #f8f9fa; color: #8b7e74; }
        .btn-write { float: right; padding: 10px 20px; background: #e76f51; color: #fff; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/guest/Header.jsp" />
    <div class="container">
        <h2>📢 공지사항</h2>
       <sec:authorize access="hasRole('ADMIN')">
            <a href="/admin/notice_write" class="btn-write">글쓰기</a>
        </sec:authorize>

        <table>
            <thead>
                <tr>
                    <th style="width: 10%">번호</th>
                    <th style="width: 60%">제목</th>
                    <th style="width: 30%">작성일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="notice" items="${list}">
                            <tr>
                                <td>${notice.n_code}</td>
                                <td>
                                    <a href="/notice/detail?n_code=${notice.n_code}" style="text-decoration:none; color:#4a3f35;">
                                        ${notice.n_title}
                                    </a>
                                </td>
                                <td><fmt:formatDate value="${notice.n_date}" pattern="yyyy-MM-dd"/></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="3" style="text-align:center; padding:50px;">등록된 공지사항이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</body>
</html>