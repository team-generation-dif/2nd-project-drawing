<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 내 삶을 그리는 인테리어</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@700&family=Pretendard:wght@300;500&display=swap');

    body, html {
        margin: 0;
        padding: 0;
        font-family: 'Pretendard', sans-serif;
        background-color: #fffaf5; /* 미세한 핑크빛이 도는 포근한 화이트 */
        color: #555;
        scroll-behavior: smooth;
    }

    /* 상단 네비게이션 */
    nav {
        padding: 20px 50px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: rgba(255, 250, 245, 0.8);
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .logo {
        font-family: 'Nanum Myeongjo', serif;
        font-size: 1.8rem;
        color: #8b7e74;
        letter-spacing: 2px;
    }

    /* 히어로 섹션 */
    .hero {
        height: 90vh;
        display: flex;
        align-items: center;
        padding: 0 10%;
        background: url('https://images.unsplash.com/photo-1494438639946-1ebd1d20bf85?auto=format&fit=crop&w=1200&q=80') no-repeat center right;
        background-size: 55% auto;
    }

    .hero-text {
        width: 45%;
    }

    .hero-text h1 {
        font-family: 'Nanum Myeongjo', serif;
        font-size: 4rem;
        line-height: 1.2;
        color: #4a3f35;
        margin-bottom: 20px;
    }

    .hero-text p {
        font-size: 1.1rem;
        line-height: 1.8;
        color: #8b7e74;
        margin-bottom: 30px;
    }

    /* 가구/인테리어 카드 섹션 */
    .section-title {
        text-align: center;
        font-family: 'Nanum Myeongjo', serif;
        font-size: 2rem;
        margin: 80px 0 40px;
        color: #4a3f35;
    }

    .grid-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 30px;
        padding: 0 10%;
        margin-bottom: 100px;
    }

    .content-card {
        background: #fff;
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 10px 20px rgba(0,0,0,0.03);
        transition: 0.3s;
    }

    .content-card:hover { transform: translateY(-5px); }

    .content-card img {
        width: 100%;
        height: 250px;
        object-fit: cover;
    }

    .card-info {
        padding: 20px;
    }

    .card-info h4 { margin: 0 0 10px; color: #4a3f35; }
    .card-info p { margin: 0; font-size: 0.9rem; color: #999; }

    /* 푸터 버튼 */
    .start-box {
        background-color: #f7ede2;
        padding: 80px 0;
        text-align: center;
        border-radius: 50px 50px 0 0;
    }

    .btn {
        padding: 15px 45px;
        margin: 10px;
        border-radius: 50px;
        border: none;
        font-size: 1rem;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        transition: 0.3s;
    }

    .btn-main { background-color: #8b7e74; color: white; }
    .btn-sub { background-color: white; color: #8b7e74; border: 1px solid #8b7e74; }
    .btn:hover { transform: scale(1.05); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
</style>
</head>
<body>

    <nav>
        <div class="logo">그리다.</div>
        <div>
            <a href="${pageContext.request.contextPath}/guest/loginForm" style="text-decoration:none; color:#8b7e74; margin-right:20px;">로그인</a>
            <a href="${pageContext.request.contextPath}/guest/joinForm" class="btn btn-main" style="padding:10px 25px;">시작하기</a>
        </div>
    </nav>

    <div class="hero">
        <div class="hero-text">
            <h1>취향을<br>그리다</h1>
            <p>단순한 가구 배치를 넘어,<br>당신의 하루가 그려지는 공간을 제안합니다.<br>따뜻한 온기가 있는 인테리어 가이드, '그리다'</p>
            <a href="#explore" class="btn btn-sub">가구 둘러보기</a>
        </div>
    </div>

    <h2 class="section-title" id="explore">오늘의 기록, 오늘의 공간</h2>
    <div class="grid-container">
        <div class="content-card">
            <img src="https://images.unsplash.com/photo-1540518614846-7eded433c457?auto=format&fit=crop&w=500&q=60" alt="거실">
            <div class="card-info">
                <h4>오후의 햇살이 머무는 거실</h4>
                <p>#우드인테리어 #내추럴스타일</p>
            </div>
        </div>
        <div class="content-card">
            <img src="https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=500&q=60" alt="서재">
            <div class="card-info">
                <h4>집중을 그리는 나만의 서재</h4>
                <p>#홈오피스 #모던빈티지</p>
            </div>
        </div>
        <div class="content-card">
            <img src="https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&fit=crop&w=500&q=60" alt="침실">
            <div class="card-info">
                <h4>꿈을 그리는 포근한 침실</h4>
                <p>#화이트인테리어 #미니멀리즘</p>
            </div>
        </div>
    </div>

    <div class="start-box">
        <h2 style="font-family: 'Nanum Myeongjo', serif; margin-bottom: 30px;">당신의 공간을 그릴 준비가 되셨나요?</h2>
        <a href="${pageContext.request.contextPath}/guest/joinForm" class="btn btn-main">지금 시작하기</a>
    </div>

</body>
</html>