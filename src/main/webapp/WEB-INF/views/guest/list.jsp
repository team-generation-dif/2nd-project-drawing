<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 | 인테리어 둘러보기</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
       /* 1. 디자인 시스템 일관성 및 여백 최적화 */
body { 
    background-color: #fffaf5; 
    font-family: 'Pretendard', sans-serif; 
    margin: 0; 
    color: #4a3f35; 
}

.container { 
    max-width: 1200px; /* 매거진 비율을 위해 살짝 조정 */
    margin: 0 auto; 
   padding: 60px 20px 100px; 
}

/* 2. 상단 타이틀 영역 (감성적인 자간과 라인 높이) */
.page-title-area { 
        display: flex; 
        justify-content: space-between; 
        border-bottom: 1px solid #f7ede2; /* <- 바로 이 부분! */
        align-items: flex-end; 
        margin-bottom: 60px; /* 게시글과의 간격을 위해 대폭 줄임 */
        padding-bottom: 30px;
    }

    .page-title-area h2 { 
        font-family: 'Nanum Myeongjo', serif; 
        font-size: 2.2rem; /* 관리자 페이지와 통일감을 위해 살짝 조절 */
        color: #3d342c; 
        margin: 0;
        letter-spacing: -0.03em;
    }

.page-title-area p {
    font-size: 1.05rem;
    color: #8b7e74;
    margin-top: 12px;
    font-weight: 500;
}

/* 3. 사진 올리기 버튼 (상세 페이지의 btn-edit/delete 느낌 계승) */
.btn-write { 
    padding: 16px 32px;
    background: #8b7e74; 
    color: white; 
    border: none; 
    border-radius: 20px; /* 상세 페이지 버튼 곡률과 통일 */
    cursor: pointer; 
    font-weight: 700; 
    font-size: 0.95rem;
    transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
    box-shadow: 0 10px 20px rgba(139, 126, 116, 0.12);
}

.btn-write:hover { 
    background: #4a3f35;
    transform: translateY(-3px);
    box-shadow: 0 15px 30px rgba(139, 126, 116, 0.2);
}

/* 4. 보드 그리드 시스템 */
/* 그리드 상단 여백 제거 */
    .board-grid { 
        display: grid; 
        grid-template-columns: repeat(3, 1fr); 
        gap: 40px; 
        margin-top: 0; 
    }

/* 5. 카드 디자인 (상세 페이지 카드와 패밀리 룩) */
.board-card { 
    background: #fff;
    border-radius: 30px; /* 상세 페이지 이미지 곡률과 통일 */
    overflow: hidden; 
    box-shadow: 0 10px 30px rgba(139, 126, 116, 0.05); 
    transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    cursor: pointer;
    border: 1px solid #f7ede2;
    position: relative;
}

.board-card:hover { 
    transform: translateY(-12px);
    box-shadow: 0 20px 45px rgba(139, 126, 116, 0.12);
}

/* 6. 이미지 영역 */
.img-wrapper { 
    width: 100%; 
    height: 320px; 
    overflow: hidden; 
    position: relative;
}

.img-wrapper img { 
    width: 100%; height: 100%; object-fit: cover; 
    transition: transform 0.8s cubic-bezier(0.2, 0, 0.2, 1);
}

.board-card:hover .img-wrapper img {
    transform: scale(1.05);
}

.tag-count {
    position: absolute; top: 20px; left: 20px; /* 왼쪽으로 이동하여 북마크와 대칭 */
    background: rgba(255, 255, 255, 0.85); 
    backdrop-filter: blur(8px);
    color: #8b7e74;
    padding: 6px 14px; border-radius: 12px; 
    font-size: 11px; font-weight: 800;
    text-transform: uppercase;
}

/* 7. 북마크 버튼 (감성 디테일 업그레이드) */
.bookmark-btn {
    position: absolute;
    bottom: 20px;
    right: 20px;
    z-index: 10;
    background: rgba(255, 255, 255, 0.85);
    backdrop-filter: blur(8px);
    width: 42px;
    height: 42px;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    transition: all 0.3s ease;
    border: 1px solid rgba(231, 211, 191, 0.3);
}

.heart-icon {
    font-size: 1.2rem;
    color: #d1cdc7;
    transition: all 0.3s ease;
}

.bookmark-btn.active {
    background: #fff;
    border-color: #ffccbb;
}

.bookmark-btn.active .heart-icon {
    color: #e76f51 !important; /* 상세페이지 수정버튼과 동일한 포인트 컬러 */
    filter: none;
    opacity: 1;
}

/* 8. 정보 텍스트 (타이포그래피 정돈) */
.info-wrapper { 
    padding: 25px 30px; 
}

.info-wrapper .title { 
    font-size: 1.15rem; 
    font-weight: 700; 
    color: #4a3f35; 
    margin-bottom: 10px; 
    letter-spacing: -0.01em;
}

.info-wrapper .author { 
    color: #bcaaa4; 
    font-size: 0.88rem; 
    font-weight: 500;
    display: flex; 
    align-items: center; 
}

.info-wrapper .author::before { 
    content: ''; 
    width: 15px; height: 1px; 
    background: #f7ede2; 
    margin-right: 10px; 
}

/* 9. 페이지네이션 (둥글고 차분한 감성) */
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 80px;
    gap: 8px;
}

.page-link {
    width: 44px;
    height: 44px;
    border-radius: 14px; /* 살짝 둥근 사각형으로 변경하여 현대적 느낌 */
    background: #fff;
    color: #8b7e74;
    text-decoration: none;
    font-weight: 600;
    border: 1px solid #f7ede2;
    display: flex;
    justify-content: center;
    align-items: center;
    transition: all 0.3s ease;
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
/* 북마크 버튼 스타일 */
.bookmark-btn {
    position: absolute;
    bottom: 20px;
    right: 20px;
    z-index: 10;
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(4px);
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    transition: all 0.3s ease;
    border: 1px solid rgba(231, 211, 191, 0.5);
}
/* 북마크 버튼 기본 상태 */
.bookmark-btn .heart-icon {
    font-size: 1.4rem;
    color: #d1cdc7; /* 기본 연한 회색 */
    filter: grayscale(100%); /* 아이콘 자체 색상 제거 */
    opacity: 0.6;
    transition: all 0.3s ease;
}

/* [해결 3] 활성화(active) 상태일 때 색상 변경 */
.bookmark-btn.active .heart-icon {
    color: #8b7e74 !important; /* 강조할 브라운 색상 */
    filter: grayscale(0%); /* 본래 색상 노출 */
    opacity: 1;
    transform: scale(1.2); /* 살짝 커지는 효과 */
}

/* 호버 효과 */
.bookmark-btn:hover .heart-icon {
    transform: scale(1.1);
    opacity: 1;
}
.bookmark-btn:hover {
    transform: scale(1.1);
    background: #fff;
}

.heart-icon {
    font-size: 1.2rem;
    transition: transform 0.2s ease;
    user-select: none; /* 드래그 방지 */
}

.bookmark-btn.active .heart-icon {
    animation: pulse 0.3s ease-in-out;
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.3); }
    100% { transform: scale(1); }
}
</style>
</head>
<body>
   <jsp:include page="/WEB-INF/views/guest/Header.jsp" />

<div class="container">
    <div class="page-title-area">
        <div class="title-text">
            <h2>취향을 그리다.</h2>
            <p style="color: #8b7e74; margin-top: 8px;">다른 이들의 소중한 공간을 만나보세요</p>
        </div>
        <button class="btn-write" onclick="location.href='/user/write'">+ 사진 올리기</button>
    </div>



    <div class="board-grid">
        <c:forEach items="${list}" var="b">
            <div class="board-card" onclick="location.href='/user/detail?b_code=${b.b_code}'">
    <div class="img-wrapper">
        <img src="/upload/${b.b_image}" onerror="this.src='https://placehold.co/600x800/fcf6f0/8b7e74?text=Grida+Interior'">
        <div class="tag-count">INTERIOR</div>
        
        <div class="bookmark-btn ${b.isBookmarked ? 'active' : ''}" 
     onclick="handleBookmark(event, '${b.b_code}', this)">
    <span class="heart-icon">🔖</span> 
</div>
    </div>
    <div class="info-wrapper">
        <div class="title">${b.b_title}</div>
        <div class="author">작성자 : ${b.m_nick}</div>
    </div>
</div>
        </c:forEach>
    </div>

    <div class="pagination">
    <c:if test="${paging.prev}">
        <a href="/guest/list?page=${paging.startPage - 1}" class="page-link">&lt;</a>
    </c:if>

    <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="num">
        <a href="/guest/list?page=${num}" class="page-link ${paging.page == num ? 'active' : ''}">
            ${num}
        </a>
    </c:forEach>

    <c:if test="${paging.next}">
        <a href="/guest/list?page=${paging.endPage + 1}" class="page-link">&gt;</a>
    </c:if>
</div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
function handleBookmark(event, b_code, element) {
    // 상세 페이지 이동 방지
    if (event && event.stopPropagation) {
        event.stopPropagation();
    } else {
        window.event.cancelBubble = true;
    }

    // [중요] 세션 아이디 확인 (따옴표 필수)
    const loginId = "${sessionScope.m_id}";
    
    // 로그인이 안 되어 있는 경우 (빈 문자열이거나 null일 때)
    if (loginId === "" || loginId === null || loginId === "undefined") {
        alert("로그인이 필요한 서비스입니다.");
        location.href = "/guest/loginForm";
        return;
    }

    const $el = $(element);

    $.ajax({
        url: '/user/toggleBookmark',
        type: 'POST',
        data: { b_code: b_code },
        // 스프링 시큐리티 사용 시 필요 (에러 발생 시 주석 해제)
        /* beforeSend: function(xhr) {
            xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        }, */
        success: function(status) {
            // 서버에서 넘어오는 status 값이 숫자든 문자든 처리 가능하도록 == 사용
            if (status == 1) { 
                $el.addClass('active');
                alert("🔖 북마크에 추가되었습니다.");
            } else if (status == 0) {
                $el.removeClass('active');
                
                // 북마크 페이지(/user/myBookmarks)라면 카드 숨기기
                if (window.location.pathname.indexOf('myBookmarks') !== -1) {
                    $el.closest('.board-card').fadeOut(300);
                } else {
                    alert("🔖 북마크가 해제되었습니다.");
                }
            } else if (status == -1) {
                alert("로그인이 만료되었습니다. 다시 로그인해주세요.");
                location.href = "/guest/loginForm";
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX Error:", error);
            alert("통신 에러가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
    });
}
</script>

<jsp:include page="/WEB-INF/views/guest/footer.jsp" />
</body>
</html>