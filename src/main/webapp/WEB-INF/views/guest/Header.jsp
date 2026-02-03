<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header class="main-header">

    <!-- 로고 -->
    <sec:authorize access="hasRole('ADMIN')">
        <a href="/admin/main" class="logo">Drawing Admin</a>
    </sec:authorize>

    <sec:authorize access="!hasRole('ADMIN')">
        <a href="/" class="logo">Drawing Home</a>
    </sec:authorize>

<nav>
<ul class="nav-menu">

    <!-- 관리자 전용 메뉴 -->
    <c:if test="${fn:contains(pageContext.request.requestURI, '/admin/')}">
        <sec:authorize access="hasRole('ADMIN')">
            <li><a href="#">상품등록</a></li>
            <li><a href="#">평면도등록</a></li>
            <li><a href="#">3D가구등록</a></li>
            <li class="divider">|</li>
        </sec:authorize>
    </c:if>

    <!-- 일반 사용자 + 게스트 메뉴 -->
   <c:if test="${!fn:contains(pageContext.request.requestURI, '/admin/')}">
    <li><a href="/guest/list">게시판</a></li>
    <li><a href="/notice/list">공지사항</a></li>
    <li><a href="/user/interior/myDraw" class="need-login">3D인테리어</a></li>
    <li><a href="#" class="need-login">찜목록</a></li>
</c:if>


</ul>
</nav>

<!-- 로그인 사용자 영역 -->
<sec:authorize access="isAuthenticated()">
<div class="user-area">
    <span class="nickname">
        <a href="/user/mypage" class="nickname-link">
            <strong>${sessionScope.nickname}</strong>
        </a>님
        (<span class="role-badge"><sec:authentication property="authorities"/></span>)
    </span>

    <form action="/logout" method="post" style="display:inline;">
        <button type="submit" class="logout-btn">로그아웃</button>
    </form>
</div>
</sec:authorize>

<!-- 게스트 영역 -->
<sec:authorize access="isAnonymous()">
<div class="user-area">
    <a href="/guest/loginForm" class="login-btn">로그인</a>
   <a href="/guest/joinForm" class="signup-btn">회원가입</a>

</div>
</sec:authorize>

</header>

<!-- 게스트 로그인 차단 스크립트 -->
<sec:authorize access="isAnonymous()">
<script>
document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll(".need-login").forEach(el => {
        el.addEventListener("click", function(e) {
            e.preventDefault();
            alert("로그인이 필요한 서비스입니다.");
            window.location.href = "/guest/loginForm";
;
        });
    });
});
</script>
</sec:authorize>


<style>
@import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600&display=swap');

.main-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 50px;
    background-color: #ffffff;
    box-shadow: 0 2px 10px rgba(139, 126, 116, 0.05);
    font-family: 'Pretendard', sans-serif;
    position: sticky;
    top: 0;
    z-index: 1000;
}

.logo {
    font-family: 'Nanum Myeongjo', serif;
    font-size: 1.5rem;
    font-weight: bold;
    text-decoration: none;
    color: #4a3f35;
}

.nav-menu {
    list-style: none;
    display: flex;
    align-items: center;
    gap: 45px;
    margin: 0;
    padding: 0;
}

.nav-menu a {
    text-decoration: none;
    color: #8b7e74;
    font-weight: 500;
    font-size: 1rem;
    letter-spacing: -0.5px;
    transition: 0.2s;
}

.nav-menu a:hover {
    color: #4a3f35;
}

.divider {
    color: #ddd;
}

.user-area {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 0.9rem;
}

.nickname { color: #4a3f35; }

.role-badge {
    font-size: 10px;
    color: #8b7e74;
    background: #f7ede2;
    padding: 2px 8px;
    border-radius: 10px;
    margin-left: 5px;
}

.logout-btn {
    background: none;
    border: 1px solid #eee;
    padding: 5px 12px;
    border-radius: 15px;
    color: #999;
    cursor: pointer;
    font-size: 0.8rem;
    transition: 0.2s;
}

.logout-btn:hover {
    background-color: #fff1f1;
    color: #e76f51;
    border-color: #ffccbb;
}

.nickname-link {
    text-decoration: none;
    color: #4a3f35;
}

.nickname-link:hover {
    color: #e76f51;
    text-decoration: underline;
}

/* 로그인 / 회원가입 버튼 */
.login-btn, .signup-btn {
    text-decoration: none;
    border: 1px solid #ddd;
    padding: 6px 12px;
    border-radius: 12px;
    font-size: 0.8rem;
    color: #8b7e74;
    transition: 0.2s;
}

.login-btn:hover, .signup-btn:hover {
    background: #f7ede2;
}
</style>
