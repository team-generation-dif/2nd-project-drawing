<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 취향을 담다</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">

<style>
    /* 1. 기본 배경 및 폰트 설정 */
    body {
        background-color: #fffaf5; /* 따뜻한 아이보리 */
        font-family: 'Pretendard', sans-serif;
        color: #5d5a58;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 60px 20px;
        margin: 0;
    }

    /* 2. 메인 컨테이너 */
    .detail-wrapper {
        background: #ffffff;
        width: 100%;
        max-width: 760px;
        padding: 50px 40px;
        border-radius: 40px;
        box-shadow: 0 15px 35px rgba(139, 126, 116, 0.1);
        border: 1px solid #f7ede2;
        box-sizing: border-box;
    }

    /* 3. 이미지 영역: 태그 위치 이탈 방지 핵심 */
    #image-container { 
        position: relative; 
        display: inline-block; /* 컨테이너가 이미지 크기에 딱 맞게 함 */
        width: 100%;
        max-width: 100%;
        border-radius: 30px;
        overflow: hidden;
        margin-bottom: 35px;
        line-height: 0; /* 하단 미세 공백 제거 */
    }
    
    #image-container img {
        width: 100%;
        height: auto;
        display: block;
    }

    /* 4. 감성 태그 스타일 (수정된 최종본) */
    .tag-dot-wrapper { 
        position: absolute; 
        z-index: 100; 
        transform: translate(-50%, -50%);
        padding: 15px; /* 마우스 반응 범위 확장 */
    }
    
    .tag-dot {
        width: 26px; height: 26px; 
        background: rgba(255, 255, 255, 0.6);
        backdrop-filter: blur(4px);
        border: 2px solid #fff; 
        border-radius: 50%; 
        cursor: pointer;
        box-shadow: 0 4px 10px rgba(139, 126, 116, 0.2);
        display: flex; align-items: center; justify-content: center; 
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    
    .tag-dot::after {
        content: '';
        width: 6px; height: 6px;
        background-color: #8b7e74;
        border-radius: 50%;
    }

    .tag-info {
        display: none; 
        position: absolute; 
        bottom: 55px; 
        left: 50%; 
        transform: translateX(-50%) translateY(10px);
        background: #fff; 
        padding: 20px 25px;
        border-radius: 24px;
        box-shadow: 0 12px 30px rgba(139, 126, 116, 0.15); 
        min-width: 160px;
        text-align: center; 
        z-index: 110;
        opacity: 0;
        transition: all 0.3s ease;
    }

    /* 마우스 이동 시 꺼짐 방지 다리 */
    .tag-info::after {
        content: '';
        position: absolute;
        bottom: -30px;
        left: 0;
        width: 100%;
        height: 35px;
        background: transparent;
    }

    .tag-name { 
        font-size: 1rem; 
        font-weight: 700; 
        color: #4a3f35; 
        margin-bottom: 12px;
        display: block; 
        line-height: 1.2;
        white-space: nowrap;
    }

    .tag-link { 
        font-size: 0.85rem; 
        color: #8b7e74; 
        text-decoration: none; 
        border-bottom: 1.5px solid #ffccbb; 
        padding-bottom: 2px;
        display: inline-block;
        font-weight: 600;
    }

    /* Hover 효과 */
    .tag-dot-wrapper:hover .tag-info { 
        display: block; opacity: 1; transform: translateX(-50%) translateY(0);
    }
    
    .tag-dot-wrapper:hover .tag-dot { 
        background: #8b7e74; border-color: #8b7e74; transform: scale(1.15); 
    }
    .tag-dot-wrapper:hover .tag-dot::after { background-color: #fff; }

    /* 5. 텍스트 영역 */
    .header-area { text-align: center; margin-bottom: 35px; }
    .content-title { 
        font-family: 'Nanum Myeongjo', serif; 
        font-size: 2.2rem; 
        color: #4a3f35; 
        margin-bottom: 15px; 
    }
    .content-meta { font-size: 0.9rem; color: #bcaaa4; }
    
    .content-text { 
        font-size: 1.05rem; 
        line-height: 1.9; 
        color: #5d5a58; 
        white-space: pre-wrap;
        margin-top: 35px;
        padding: 0 10px;
    }

    /* 6. 하단 버튼 영역 */
    .action-buttons { 
        margin-top: 50px; 
        display: flex; 
        justify-content: center; 
        gap: 15px; 
    }
    
    .btn {
        padding: 12px 28px; 
        border-radius: 18px; 
        border: 1px solid #eee;
        cursor: pointer; 
        font-size: 0.95rem; 
        font-weight: 600; 
        transition: 0.3s; 
        text-decoration: none;
        display: inline-block;
    }

    .btn-list { background-color: #fafafa; color: #8b7e74; }
    .btn-edit { background-color: #fff; border-color: #ffccbb; color: #e76f51; }
    .btn-delete { background-color: #8b7e74; color: #fff; border: none; }

    .btn:hover { 
        transform: translateY(-2px); 
        box-shadow: 0 5px 15px rgba(139, 126, 116, 0.1); 
    }
</style>
</head>
<body>

<div class="detail-wrapper">
    <div class="header-area">
        <div class="content-title">${board.b_title}</div>
        <div class="content-meta">
            작성자. ${board.m_nick} <span style="margin: 0 10px; color:#f7ede2;">|</span> ${board.b_date}
        </div>
    </div>

    <div id="image-container">
        <img src="/upload/${board.b_image}">
        
        <c:forEach var="tag" items="${tags}">
            <div class="tag-dot-wrapper" style="left: ${tag.x_coord}%; top: ${tag.y_coord}%;">
                <div class="tag-dot"></div>
                <div class="tag-info">
                    <span class="tag-name">${tag.t_name}</span>
                    <c:if test="${not empty tag.t_url}">
                        <a href="${tag.t_url}" target="_blank" class="tag-link">가구 정보 보기</a>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="content-text">${board.b_content}</div>

    <div class="action-buttons">
        <a href="/guest/list" class="btn btn-list">목록으로</a>
        <c:if test="${loginId eq board.m_id}">
            <a href="/user/edit?b_code=${board.b_code}" class="btn btn-edit">게시글 수정</a>
            <button type="button" class="btn btn-delete" onclick="fnDelete('${board.b_code}')">게시글 삭제</button>
        </c:if>
    </div>
</div>

<script>
function fnDelete(b_code) {
    if(confirm("이 소중한 기록을 정말 삭제하시겠습니까?")) {
        location.href = "/user/boardDelete?b_code=" + b_code;
    }
}
</script>

</body>
</html>