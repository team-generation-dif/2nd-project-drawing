<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header class="main-header">
    <sec:authorize access="hasRole('ADMIN')">
        <a href="/admin/main" class="logo">Drawing Admin</a>
    </sec:authorize>
    <sec:authorize access="hasRole('USER')">
        <a href="/user/main" class="logo">Drawing Home</a>
    </sec:authorize>

  <nav>
    <ul class="nav-menu">
        <%-- [1] 관리자 전용 메뉴 : URL에 /admin/이 포함된 경우에만 노출 --%>
        <c:if test="${fn:contains(pageContext.request.requestURI, '/admin/')}">
            <sec:authorize access="hasRole('ADMIN')">
                <li><a href="#">상품등록</a></li>
                <li><a href="#">평면도등록</a></li>
                <li><a href="#">3D가구등록</a></li>
                <li class="divider"></li>
            </sec:authorize>
        </c:if>

        <%-- [2] 유저 전용 메뉴 : URL에 /admin/이 포함되지 않은 모든 경우 --%>
        <c:if test="${!fn:contains(pageContext.request.requestURI, '/admin/')}">
            <li><a href="/user/list">게시판</a></li>
            <li><a href="/notice/list">공지사항</a></li>
            <li><a href="/user/interior/myDraw">3D인테리어</a></li>
            <li><a href="#">찜목록</a></li>
            
        </c:if>
    </ul>
</nav>

    <div class="user-area">
    <span class="nickname">
        <a href="/user/mypage" class="nickname-link" title="내 정보 보기">
            <strong>${sessionScope.nickname}</strong>
        </a>님 
        (<span class="role-badge"><sec:authentication property="authorities"/></span>)
    </span>
    
    <form action="/logout" method="post" style="display:inline;">
        <button type="submit" class="logout-btn">로그아웃</button>
    </form>
</div>
</header>

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

    /* 로고 스타일 */
    .logo {
        font-family: 'Nanum Myeongjo', serif;
        font-size: 1.5rem;
        font-weight: bold;
        text-decoration: none;
        color: #4a3f35; /* 기본 브라운 */
    }

    /* 메뉴 전체를 감싸는 ul 태그 */
.nav-menu {
    list-style: none;
    display: flex;
    align-items: center;
    /* [조율 1] 메뉴 아이템 사이의 간격을 넓힙니다 (기존 30px -> 45px 추천) */
    gap: 45px; 
    margin: 0;
    padding: 0;
}

.nav-menu a {
    text-decoration: none;
    color: #8b7e74;
    font-weight: 500;
    font-size: 1rem; /* 글자 크기도 살짝 키우면 더 시원해 보입니다 */
    transition: 0.2s;
    /* [조율 2] 글자 자체의 자간(글자 사이 간격)을 조율합니다 */
    letter-spacing: -0.5px; 
}

/* 관리자/유저 구분선 스타일 */
.divider {
    color: #ddd;
    margin: 0 -15px; /* 구분선 주위의 간격은 좁게 설정 */
    font-size: 0.8rem;
    cursor: default;
}

/* 유저-관리자 전환 버튼 (강조용) */
.highlight-btn {
    background-color: #f7ede2;
    padding: 8px 16px; /* 버튼 안쪽 여백을 넓혀서 글자가 꽉 차지 않게 함 */
    border-radius: 20px;
    margin-left: 10px; /* 앞의 메뉴와 좀 더 떨어지게 설정 */
}

    .nav-menu a:hover {
        color: #4a3f35;
    }

    /* 유저 정보 영역 */
    .user-area {
        display: flex;
        align-items: center;
        gap: 15px;
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

    /* 어드민 전용 스타일 강조 */
    <sec:authorize access="hasRole('ADMIN')">
    .main-header { border-bottom: 3px solid #8b7e74; } /* 차가운 레드보다 따뜻한 딥브라운 추천 */
    .logo { color: #8b7e74; }
    .nav-menu a { color: #8b7e74; }
    </sec:authorize>
    /* 닉네임 링크 스타일 */
.nickname-link {
    text-decoration: none; /* 밑줄 제거 */
    color: #4a3f35;       /* 기존 브라운 색상 유지 */
    transition: 0.3s;
}

.nickname-link:hover {
    color: #e76f51;       /* 마우스 올렸을 때 강조색 (오렌지/레드 계열) */
    text-decoration: underline; /* 마우스 올렸을 때만 밑줄 */
}
/* 관리자-유저 전환 버튼 강조 */
.highlight-btn {
    background-color: #f7ede2;
    padding: 5px 10px;
    border-radius: 8px;
    font-weight: bold !important;
    color: #8b7e74 !important;
}

.highlight-btn:hover {
    background-color: #8b7e74;
    color: white !important;
}

.divider {
    color: #ddd;
    padding: 0 10px;
    cursor: default;
}
</style>