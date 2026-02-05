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
        	<li><a href="${pageContext.request.contextPath}/products/admin/list">상품 관리</a></li>      	
            <li><a href="${pageContext.request.contextPath}/products/admin/new">상품등록</a></li>
            <li><a href="${pageContext.request.contextPath}/products/admin/upload-page">CSV 업로드</a></li>
            <li><a href="/notice/list">공지사항</a></li>
            <li class="divider"></li>
        </sec:authorize>
    </c:if>

    <!-- 일반 사용자 + 게스트 메뉴 -->
   <c:if test="${!fn:contains(pageContext.request.requestURI, '/admin/')}">
    <li><a href="/guest/list">게시판</a></li>
    <li><a href="/notice/list">공지사항</a></li>
    <li><a href="/user/interior/myDraw" class="need-login">3D인테리어</a></li>
    <li><a href="#" class="need-login">찜목록</a></li>
    <li><a href="/user/myBookmarks" class="need-login">북마크</a></li>
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
@import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css');
@import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@700;800&display=swap');

:root {
    --primary-color: #332d26; /* 가독성을 위해 조금 더 짙은 브라운 */
    --secondary-color: #6d625b; /* 보조 텍스트도 선명하게 조정 */
    --accent-color: #d35400;
    --bg-white: #ffffff;
    --border-soft: #f0ede9;
    --transition: all 0.25s ease-in-out;
}

/* 헤더 전체 레이아웃 */
.main-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    /* 윈도우 대화면 가독성을 위해 좌우 여백을 넓게 확보 */
    padding: 0 8%; 
    height: 85px;
    background-color: rgba(255, 255, 255, 0.98);
    border-bottom: 1px solid var(--border-soft);
    position: sticky;
    top: 0;
    z-index: 1000;
    font-family: 'Pretendard', sans-serif;
}

/* 로고 섹션 */
.logo {
    font-family: 'Nanum Myeongjo', serif;
    font-size: 2rem; 
    font-weight: 800;
    text-decoration: none;
    color: var(--primary-color);
    letter-spacing: -0.5px;
    flex-shrink: 0;
}

/* 네비게이션 - 중앙 집중도를 분산시키기 위해 배치 조정 */
nav {
    flex: 1;
    display: flex;
    justify-content: center; /* 메뉴들을 중앙으로 */
    min-width: 0; /* 플렉스 박스 뭉개짐 방지 */
}

.nav-menu {
    list-style: none;
    display: flex;
    align-items: center;
    /* 글자가 커진 만큼 gap을 살짝 조정 (clamp 활용) */
    gap: clamp(40px, 5vw, 100px); 
    margin: 0;
    padding: 0;
}

.nav-menu li a {
    text-decoration: none;
    color: var(--secondary-color);
    font-weight: 700; /* 조금 더 두껍게 변경하여 존재감 부여 */
    font-size: 1.2rem; /* 1.05rem에서 1.2rem으로 상향 */
    letter-spacing: 0.02em; /* 글자 사이 간격을 살짝 벌려 가독성 확보 */
    display: inline-block; 
    position: relative;
    padding: 8px 0;
    transition: color 0.2s ease;
}

.nav-menu li a:hover {
    color: var(--primary-color);
}

.nav-menu li a::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 0; /* 평소에는 너비 0 */
    height: 2px;
    background-color: var(--primary-color);
    /* transition 속성을 삭제하여 애니메이션을 없앱니다 */
}

.nav-menu li a:hover::after {
    width: 100%; /* 글자 너비만큼 100% 채움 */
}

/* 사용자 영역 섹션 */
.user-area {
    display: flex;
    align-items: center;
    gap: 16px;
    flex-shrink: 0;
}

.nickname {
    font-size: 1.1rem; /* 0.95rem -> 1.1rem */
    color: var(--primary-color);
    font-weight: 500;
}

.nickname strong {
    font-weight: 700;
    color: var(--primary-color);
}

.role-badge {
    font-size: 12px;
    color: #8b7e74;
    background: #f7ede2;
    padding: 3px 12px;
    border-radius: 4px; /* 조금 더 각진 세련된 느낌 */
    margin-left: 4px;
    font-weight: 600;
    text-transform: uppercase;
}

/* 버튼 가독성 및 클릭 영역 확보 */
.logout-btn, .login-btn, .signup-btn {
    all: unset;
    cursor: pointer;
    font-size: 1em;
    font-weight: 600;
    padding: 10px 24px;
    border-radius: 8px;
    transition: var(--transition);
    text-align: center;
}

.login-btn {
    color: var(--secondary-color);
    border: 1px solid #e0ddd9;
}

.login-btn:hover {
    background: #faf9f8;
    color: var(--primary-color);
    border-color: var(--secondary-color);
}

.signup-btn {
    background-color: var(--primary-color);
    color: #ffffff !important;
}

.signup-btn:hover {
    background-color: #000000;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}

.logout-btn {
    background-color: #f8f8f8;
    color: #888 !important;
    border: 1px solid #eee;
}

.logout-btn:hover {
    background-color: #fff1f0;
    color: #e74c3c !important;
    border-color: #ffcfcc;
}
</style>