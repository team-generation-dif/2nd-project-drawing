<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내가 찜한 사진 - 그리다 아뜰리에</title>
    <style>
        /* 기본 레이아웃 유지 */
        body { background-color: #fffaf5; font-family: 'Pretendard', sans-serif; margin: 0; color: #4a3f35; }
        .container { max-width: 1200px; margin: 60px auto; padding: 0 40px; }
        
        /* 헤더 부분 */
        .page-header { margin-bottom: 40px; border-bottom: 1px solid #eee1d5; padding-bottom: 20px; }
        .page-header h2 { font-family: 'Nanum Myeongjo', serif; font-size: 28px; color: #4a3f35; margin: 0; }
        .page-header p { color: #8b7e74; font-size: 15px; margin-top: 8px; }

        /* 그리드 시스템 (3단 배열) */
        .photo-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; }

        /* 카드 디자인 */
        .photo-card { cursor: pointer; transition: transform 0.3s ease; }
        .photo-card:hover { transform: translateY(-8px); }
        .photo-img-wrap { position: relative; width: 100%; aspect-ratio: 3 / 4; border-radius: 15px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.05); }
        .photo-img-wrap img { width: 100%; height: 100%; object-fit: cover; }

        /* 카드 위 정보 및 버튼 */
        .photo-overlay { position: absolute; bottom: 0; left: 0; right: 0; padding: 20px; background: linear-gradient(transparent, rgba(0,0,0,0.5)); display: flex; justify-content: space-between; align-items: center; }
        .user-info { display: flex; align-items: center; gap: 8px; color: white; }
        .user-thumb { width: 24px; height: 24px; border-radius: 50%; background: #fff; }
        .user-nick { font-size: 14px; font-weight: 600; text-shadow: 0 1px 2px rgba(0,0,0,0.3); }

        .btn-bookmark { background: none; border: none; cursor: pointer; padding: 5px; }
        .btn-bookmark svg { filter: drop-shadow(0 1px 2px rgba(0,0,0,0.3)); transition: 0.2s; }

        /* 데이터가 없을 때 */
        .empty-container { text-align: center; padding: 100px 0; }
        .empty-container p { font-size: 18px; color: #abb3bb; }
        .btn-go-main { display: inline-block; margin-top: 20px; padding: 12px 30px; background: #e76f51; color: white; text-decoration: none; border-radius: 25px; font-weight: 700; }
   /* 페이징 스타일 - 이미지 디자인 통일 버전 */
.pagination {
    margin-top: 50px;
    display: flex;
    justify-content: center;
    gap: 15px; /* 원 사이의 간격 */
    align-items: center;
}

.pagination a {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 40px;  /* 원형을 위한 고정 크기 */
    height: 40px;
    text-decoration: none;
    font-size: 16px;
    font-weight: 600;
    color: #8b7e74; /* 기본 숫자 색상 */
    border-radius: 50%; /* 완전한 원형 */
    border: 1px solid #f2e8df; /* 연한 베이지색 테두리 */
    background-color: #ffffff;
    transition: all 0.3s ease;
}

/* 현재 활성화된 페이지 (제공해주신 이미지의 1번 스타일) */
.pagination a.active {
    background-color: #8e8071; /* 이미지의 갈색 톤 */
    color: #ffffff !important; /* 흰색 글자 */
    border-color: #8e8071;
}

/* 마우스 호버 시 */
.pagination a:hover:not(.active) {
    background-color: #fcf9f6;
    border-color: #8e8071;
    color: #8e8071;
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
                    <p>아직 찜한 사진이 없네요!</p>
                    <a href="/" class="btn-go-main">예쁜 사진 보러가기</a>
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