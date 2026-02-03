<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 어드민 | 관리 센터</title>
    <style>
        /* 헤더와 폰트 통일 */
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600&display=swap');

        body {
            background-color: #ffffff; /* 헤더와 같은 흰색 배경으로 시작 */
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            color: #4a3f35;
        }

        /* 본문 배경만 살짝 아이보리로 깔아주기 */
        .admin-wrapper {
            background-color: #fffaf5; 
            min-height: calc(100vh - 80px); /* 헤더 높이 제외 */
            padding: 40px 0;
        }

        .admin-container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 30px;
        }

        /* 상단 요약 섹션 */
        .summary-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 1px solid #f7ede2;
        }

        .summary-header h1 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 2rem;
            margin: 0;
            color: #4a3f35;
        }

        /* 카드 그리드 */
        .admin-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr); /* 2열 배치로 시원하게 */
            gap: 25px;
        }

        .admin-card {
            background: #ffffff;
            padding: 35px;
            border-radius: 35px; /* 헤더의 부드러운 느낌과 통일 */
            border: 1px solid #f7ede2;
            text-decoration: none;
            color: inherit;
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .admin-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(139, 126, 116, 0.1);
            border-color: #ffccbb;
        }

        .admin-card h3 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 1.5rem;
            margin: 0 0 15px 0;
            color: #8b7e74;
        }

        .admin-card p {
            font-size: 0.95rem;
            color: #a39485;
            margin: 0;
            line-height: 1.6;
        }

        /* 카드 우측 하단 숫자 포인트 */
        .card-footer {
            margin-top: 25px;
            text-align: right;
            font-weight: 600;
            font-size: 0.9rem;
            color: #e76f51;
        }

        .btn-notice {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #f7ede2;
            color: #8b7e74;
            border-radius: 20px;
            text-decoration: none;
            font-size: 0.85rem;
            transition: 0.3s;
        }

        .btn-notice:hover {
            background-color: #8b7e74;
            color: #fff;
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
                        <h3>📢 공지사항 관리</h3>
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