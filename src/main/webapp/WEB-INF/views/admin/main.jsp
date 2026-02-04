<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 어드민 | 관리 센터</title>
<style>
/* 헤더와 폰트 통일 및 추가 가독성 확보 */
@import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@700;800&family=Pretendard:wght@400;600;700&display=swap');

:root {
    --primary-color: #332d26;    /* 헤더 딥 브라운 */
    --secondary-color: #6d625b;  /* 보조 브라운 */
    --bg-warm: #fcfaf8;          /* 은은한 크림 베이지 */
    --card-white: #ffffff;
    --accent-coral: #d98d73;     /* 포인트 테라코타 */
    --border-soft: #f0ede9;
}

body {
    background-color: var(--card-white);
    font-family: 'Pretendard', sans-serif;
    margin: 0;
    color: var(--primary-color);
    -webkit-font-smoothing: antialiased;
}

/* 본문 영역 - 윈도우 창을 가득 채우면서도 아늑하게 */
.admin-wrapper {
    background: radial-gradient(circle at top right, #fffdfb 0%, #f7f3ef 100%);
    min-height: calc(100vh - 85px);
    padding: 60px 0 100px 0;
}

.admin-container {
    max-width: 1560px; /* 창 크기에 맞춰 조금 더 넓게 */
    margin: 0 auto;
    padding: 0 32px;
}

/* 상단 요약 섹션 - 여백과 폰트 상향 */
.summary-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-bottom: 60px;
    padding-bottom: 30px;
    border-bottom: 2px solid var(--border-soft);
}

.summary-header h1 {
    font-family: 'Nanum Myeongjo', serif;
    font-size: 2.8rem; /* 더 크게 상향 */
    font-weight: 800;
    margin: 0;
    letter-spacing: -1px;
}

.summary-header p {
    font-size: 1.2rem; /* 환영 인사 크기 상향 */
    margin-top: 15px;
    color: var(--secondary-color);
}

/* 카드 그리드 - 2열로 배치하여 공간을 꽉 채움 */
.admin-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 40px; /* 살짝 넉넉하게 */
}

/* 데스크톱 큰 화면용 */
@media (min-width: 1600px) {
    .admin-grid {
        grid-template-columns: repeat(3, 1fr);
    }
}


.admin-card {
    background: var(--card-white);
    padding: 45px;
    border-radius: 40px; /* 더 둥글고 부드럽게 */
    border: 1px solid var(--border-soft);
    text-decoration: none;
    color: inherit;
    transition: all 0.4s cubic-bezier(0.23, 1, 0.32, 1);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    position: relative;
    overflow: hidden;
}

/* 카드 호버 효과 - 가구처럼 묵직한 입체감 */
.admin-card:hover {
    transform: translateY(-12px);
    box-shadow: 0 30px 60px rgba(74, 63, 53, 0.08);
    border-color: var(--secondary-color);
}

.admin-card h3 {
    font-family: 'Nanum Myeongjo', serif;
    font-size: 1.8rem; /* 제목 크기 상향 */
    margin: 0 0 20px 0;
    color: var(--primary-color);
}

.admin-card p {
    font-size: 1.05rem; /* 설명 글자 상향 */
    color: var(--secondary-color);
    margin: 0;
    line-height: 1.7;
    word-break: keep-all;
}

/* 카드 하단 정보 섹션 */
.card-footer {
    margin-top: 35px;
    text-align: right;
    font-weight: 700;
    font-size: 1rem;
    color: var(--accent-coral);
    letter-spacing: 0.5px;
}

/* 이동 버튼 커스텀 */
.btn-notice {
    display: inline-block;
    margin-top: 25px;
    padding: 12px 28px;
    background-color: var(--bg-warm);
    color: var(--secondary-color);
    border-radius: 50px;
    text-decoration: none;
    font-size: 0.95rem;
    font-weight: 700;
    transition: 0.3s;
    border: 1px solid var(--border-soft);
}

.btn-notice:hover {
    background-color: var(--primary-color);
    color: #fff;
    border-color: var(--primary-color);
}

/* 상단 유저페이지 이동 버튼 */
.nav-to-user {
    text-decoration: none;
    display: inline-block;
    padding: 12px 24px;
    background-color: var(--primary-color);
    color: white !important;
    border-radius: 50px;
    font-size: 1rem;
    font-weight: 600;
    transition: 0.3s;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.nav-to-user:hover {
    background-color: #000;
    transform: scale(1.05);
}
</style>
</head>
<body>
    <jsp:include page="../guest/Header.jsp" />

    <div class="admin-wrapper">
        <div class="admin-container">
            <div class="summary-header">
    <div>
        <h1>관리자 아뜰리에</h1>
        <p style="color: #8b7e74; margin-top: 10px;">환영합니다, 마스터님.</p>
    </div>
    <div style="text-align: right;">
        <a href="/guest/main" style="text-decoration: none; display: inline-block; padding: 10px 18px; background-color: #8b7e74; color: white; border-radius: 25px; font-size: 0.9rem; margin-bottom: 10px;">
            유저 페이지로 이동
        </a>
        <br>
        <span style="font-size: 0.8rem; color: #ccc;">마지막 접속: 2026.01.26</span>
    </div>
</div>

            <div class="admin-grid">
                <div class="admin-card">
                    <div>
                        <h3>📢 공지사항 작성</h3>
                        <p>중요한 소식을 작가님들에게 전달하세요. <br>이벤트, 점검, 가이드라인 변경 내용을 공지할 수 있습니다.</p>
                    </div>
                    <div>
                        <a href="/admin/notice_write" class="btn-notice">새 공지 등록</a>
                    </div>
                </div>

                <a href="/admin/userManage" class="admin-card">
                    <div>
                        <h3>👥 회원 관리</h3>
                        <p>가입된 모든 사용자 정보를 조회하고 권한을 설정합니다.<br>블랙리스트 관리 및 활동 내역을 확인하세요.</p>
                    </div>
                    <div class="card-footer">총 ${totalUsers}명 활동 중</div>
                </a>

                <a href="/guest/list" class="admin-card">
                    <div>
                        <h3>🖼 작품 모니터링</h3>
                        <p>업로드된 3D 인테리어 및 게시글을 관리합니다.<br>서비스 규정에 어긋나는 콘텐츠를 관리하세요.</p>
                    </div>
                    <div class="card-footer">오늘 ${todayWorks}건 업로드</div>
                </a>

                <a href="/admin/chatbot_mgmt" class="admin-card">
    <div>
        <h3>🤖 챗봇 관리</h3>
        <p>사용자의 궁금증을 실시간으로 해결합니다.<br>고객의 질문 데이터를 분석하고 학습시킵니다.</p>
    </div>
   <div class="card-footer" style="color: #e76f51;">
    오늘 총 ${todayChatCount}회 사용됨</div>
</a>
            </div>
        </div>
    </div>
</body>
</html>