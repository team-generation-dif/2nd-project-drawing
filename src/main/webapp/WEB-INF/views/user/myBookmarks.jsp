<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 | 북마크</title>
    <style>
/* 1. 기본 레이아웃 및 폰트 세팅 */
body { 
    background-color: #fffaf5; 
    font-family: 'Pretendard', sans-serif; 
    margin: 0; 
    color: #4a3f35; 
}

.container { 
    max-width: 1200px; /* 매거진 비율을 위해 살짝 조정 */
    margin: 0 auto; 
    padding: 100px 20px;  
}

/* 2. 페이지 헤더 (목록 페이지와 통일감) */
.page-header { 
    margin-bottom: 60px; 
    border-bottom: 1px solid #f7ede2; 
    padding-bottom: 30px; 
}

.page-header h2 { 
    font-family: 'Nanum Myeongjo', serif; 
    font-size: 2.2rem; 
    color: #3d342c; 
    margin: 0; 
    letter-spacing: -0.02em;
}

.page-header p { 
    color: #8b7e74; 
    font-size: 1rem; 
    margin-top: 12px; 
}

/* 3. 그리드 및 카드 디자인 (목록 페이지 스타일 계승) */
.photo-grid { 
    display: grid; 
    grid-template-columns: repeat(3, 1fr); 
    gap: 40px; 
}

.photo-card { 
    background: #fff;
    border-radius: 30px; 
    overflow: hidden;
    box-shadow: 0 10px 30px rgba(139, 126, 116, 0.05);
    transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    border: 1px solid #f7ede2;
    cursor: pointer;
}

.photo-card:hover { 
    transform: translateY(-12px); 
    box-shadow: 0 20px 45px rgba(139, 126, 116, 0.12);
}

.photo-img-wrap { 
    position: relative; 
    width: 100%; 
    aspect-ratio: 1 / 1.1; /* 보관함은 격자 형태가 예쁘므로 비율 살짝 조정 */
    overflow: hidden; 
}

.photo-img-wrap img { 
    width: 100%; height: 100%; object-fit: cover; 
    transition: transform 0.8s ease;
}

.photo-card:hover .photo-img-wrap img {
    transform: scale(1.05);
}

/* 4. 오버레이 및 북마크 버튼 */
.photo-overlay { 
    position: absolute; bottom: 0; left: 0; right: 0; 
    padding: 25px 20px; 
    background: linear-gradient(transparent, rgba(61, 52, 44, 0.7)); 
    display: flex; justify-content: space-between; align-items: center; 
}
        .user-info { display: flex; align-items: center; gap: 8px; color: white; }
        .user-thumb { width: 24px; height: 24px; border-radius: 50%; background: #fff; }
.user-nick { 
    font-size: 0.9rem; font-weight: 600; color: #fff; 
    text-shadow: 0 1px 4px rgba(0,0,0,0.3);
}

.btn-bookmark { 
    background: rgba(255, 255, 255, 0.9); 
    backdrop-filter: blur(5px);
    border: 1px solid #ffccbb; 
    width: 38px; height: 38px;
    border-radius: 50%;
    cursor: pointer; 
    display: flex; justify-content: center; align-items: center;
    transition: 0.3s;
}
.btn-bookmark:hover {
    transform: scale(1.1);
    background: #fff;
}
        .btn-bookmark svg { filter: drop-shadow(0 1px 2px rgba(0,0,0,0.3)); transition: 0.2s; }

        /* 데이터가 없을 때 */
       .empty-container { 
    text-align: center; padding: 120px 0; 
    background: #fff; border-radius: 40px; border: 1px dashed #dcd0c5;
}
        .empty-container p { font-size: 18px; color: #abb3bb; }
        .btn-go-main { 
    display: inline-block; margin-top: 25px; 
    padding: 15px 35px; background: #8b7e74; color: white; 
    text-decoration: none; border-radius: 18px; font-weight: 700; 
    transition: 0.3s;
}
.btn-go-main:hover { background: #4a3f35; transform: translateY(-3px); }
.pagination {
    margin-top: 80px;
    display: flex; justify-content: center; gap: 8px; align-items: center;
}

.pagination a {
    width: 44px; height: 44px;
    border-radius: 14px;
    background: #fff; color: #8b7e74;
    text-decoration: none; font-weight: 600;
    border: 1px solid #f7ede2;
    display: flex; justify-content: center; align-items: center;
    transition: all 0.3s ease;
}

.pagination a.active {
    background-color: #8b7e74;
    color: #ffffff !important;
    border-color: #8b7e74;
    box-shadow: 0 5px 15px rgba(139, 126, 116, 0.2);
}

.pagination a:hover:not(.active) {
    background-color: #fdfbf9;
    border-color: #8b7e74;
    transform: translateY(-2px);
}
/* 이전/다음 글자 스타일 */
.pagination .nav-btn {
    border: none;
    font-size: 14px;
    width: auto;
    padding: 0 10px;
}
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/guest/Header.jsp" />

    <div class="container">
        <div class="page-header">
            <h2>북마크</h2>
            <p>나의 영감이 된 인테리어 게시물을 모아보세요.</p>
        </div>

        <c:choose>
            <c:when test="${not empty bookmarkList}">
<div class="photo-grid">
    <c:forEach var="post" items="${bookmarkList}"> <div class="photo-card" onclick="location.href='/user/detail?b_code=${post.b_code}'">
            <div class="photo-img-wrap">
                <img src="/upload/${post.b_image}" alt="${post.b_title}">
                <div class="photo-overlay">
                    <div class="user-info">
                        <div class="user-thumb"></div>
                        <span class="user-nick">
                            ${post.m_nick} <small style="font-size: 0.75em; opacity: 0.8; margin-left: 5px;">작성자</small>
                        </span>
                    </div>
                    <button class="btn-bookmark" onclick="toggleBookmark(event, '${post.b_code}', this)">
                        <span style="font-size: 20px; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));">🔖</span>
                    </button>
                </div>
            </div>
            <div class="photo-info" style="padding: 15px 5px;">
                <div class="photo-title" style="font-weight: 700; color: #4a3f35; font-size: 16px;">
                    ${post.b_title} </div>
            </div>
        </div>
    </c:forEach>
</div>
            </c:when>
            <c:otherwise>
                <div class="empty-container">
                    <p>아직 찜한 인테리어가 없네요!</p>
                    <a href="/" class="btn-go-main">예쁜 인테리어 보러가기</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
<div class="pagination">
    <c:if test="${paging.prev}">
        <a href="/user/myBookmarks?page=${paging.startPage - 1}">이전</a>
    </c:if>
    
    <c:forEach var="num" begin="${paging.startPage}" end="${paging.endPage}">
        <a href="/user/myBookmarks?page=${num}" class="${paging.page == num ? 'active' : ''}">${num}</a>
    </c:forEach>
    
    <c:if test="${paging.next}">
        <a href="/user/myBookmarks?page=${paging.endPage + 1}">다음</a>
    </c:if>
</div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    function toggleBookmark(event, b_code, element) {
        event.stopPropagation(); // 카드 클릭 상세 이동 방지
        
        // 사용 편의를 위해 confirm은 선택사항입니다. 
        // 보관함에서는 바로 삭제되는 것이 흐름상 자연스러울 수 있습니다.
        if(!confirm("북마크를 해제하시겠습니까?")) return;

        $.ajax({
            url: '/user/toggleBookmark', // 컨트롤러와 주소 맞춤
            type: 'POST',
            data: { b_code: b_code },
            success: function(res) {
                // 컨트롤러가 반환하는 값(0: 삭제, 1: 추가)에 따라 처리
                if(res == 0) { 
                    // [해결] 찜 목록 페이지이므로 즉시 카드 제거
                    $(element).closest('.photo-card').fadeOut(300, function() {
                        $(this).remove();
                        
                        // 만약 모든 카드가 사라졌다면 빈 화면 처리를 위해 새로고침
                        if($('.photo-card').length === 0) {
                            location.reload();
                        }
                    });
                }
            },
            error: function() {
                alert("처리 중 오류가 발생했습니다.");
            }
        });
    }
    </script>
</body>
</html>