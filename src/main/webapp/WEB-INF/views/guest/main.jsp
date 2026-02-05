<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | Home</title>
<style>
@import
	url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@700&family=Pretendard:wght@300;400;600;700&display=swap')
	;

body {
	background-color: #fffaf5;
	font-family: 'Pretendard', sans-serif;
	margin: 0;
	color: #4a3f35;
	line-height: 1.6;
}

/* 1. 상단 감성 배너 섹션 */
.hero-section {
	width: 100%;
	padding: 60px auto 120px;
	display: flex;
	flex-direction: column;
	align-items: center;
	position: relative;
	overflow: hidden;
}

.watercolor-bg {
	position: absolute;
	top: 0;
	right: -10%;
	width: 60%;
	height: 100%;
	background: radial-gradient(circle, #f7ede2 0%, rgba(255, 250, 245, 0)
		70%);
	filter: blur(60px);
	z-index: 1;
}

.hero-canvas {
	position: relative;
	z-index: 5;
	width: 90%;
	max-width: 1200px;
	padding: 50px 60px;
	background: white;
	border-radius: 50px;
	box-shadow: 0 20px 50px rgba(139, 126, 116, 0.1);
	background-image:
		url('https://www.transparenttextures.com/patterns/paper-fibers.png');
	text-align: left;
}
.hero-canvas h1,
.dashboard-text h2,
.section-header h2,
.header-text h2 {
    font-family: 'Nanum Myeongjo', serif !important;
    font-weight: 700 !important;
    color: #4a3f35;
}
.hero-canvas h1 {
	font-family: 'Nanum Myeongjo', serif;
	font-size: 3rem;
	margin: 0;
	color: #4a3f35;
}

.hero-canvas p {
	font-size: 1.1rem;
	color: #8b7e74;
	margin: 25px 0 40px;
}

.btn-draw-start {
	display: inline-flex;
	align-items: center;
	gap: 10px;
	background: #e76f51;
	color: white;
	padding: 18px 45px;
	border-radius: 40px;
	font-weight: 700;
	text-decoration: none;
	box-shadow: 0 10px 25px rgba(231, 111, 81, 0.3);
	transition: 0.3s;
}

.btn-draw-start:hover {
	transform: translateY(-3px);
	background: #d65d40;
}

/* 카테고리 네비게이션 */
.category-nav {
	display: flex;
	gap: 15px;
	margin-top: 40px;
	z-index: 10;
}

.cat-item {
	background: white;
	padding: 12px 25px;
	border-radius: 30px;
	text-decoration: none;
	color: #8b7e74;
	font-weight: 600;
	font-size: 0.9rem;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
	transition: 0.3s;
}

/* 2. 섹션 스타일 */
.section-box {
	max-width: 1300px;
	margin: 0 auto;
	padding: 0 40px;
	box-sizing: border-box;
}

.section-header {
    max-width: 360px;        /* 🔥 카드 폭과 동일하게 */
    margin-left: 0;
    display: flex;
    justify-content: space-between;
}


.section-header h2 {
	font-family: 'Nanum Myeongjo', serif;
	font-size: 24px;
	margin: 0;
}

.section-header p {
	color: #abb3bb;
	font-size: 14px;
	margin: 5px 0 0;
}

.story-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 25px;
}

.story-card {
	height: 320px;
	border-radius: 25px;
	overflow: hidden;
	position: relative;
	cursor: pointer;
	background: #fdfaf8;;
}

.story-card img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	transition: 0.5s;
}

.story-overlay {
	position: absolute;
	bottom: 0;
	width: 100%;
	padding: 20px;
	background: linear-gradient(transparent, rgba(0, 0, 0, 0.6));
	color: white;
	box-sizing: border-box;
}

.prod-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 30px;
}

.prod-card {
	text-decoration: none;
	color: inherit;
}

.prod-img {
	width: 100%;
	aspect-ratio: 1;
	border-radius: 25px;
	object-fit: cover;
	transition: 0.3s;
}

.prod-price {
	font-weight: 700;
	font-size: 1.1rem;
	color: #e76f51;
}

/* 3. 챗봇 버튼 & 창 통합 스타일 */
.bot-btn {
	position: fixed;
	bottom: 40px;
	right: 40px;
	width: 65px;
	height: 65px;
	background: #e76f51;
	border-radius: 30px 30px 5px 30px;
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 10px 20px rgba(231, 111, 81, 0.3);
	cursor: pointer;
	z-index: 1000;
	transition: transform 0.3s;
}

.bot-btn:hover {
	transform: scale(1.05);
}

.chatbot-window {
	position: fixed;
	bottom: 120px;
	right: 40px;
	width: 350px;
	height: 500px;
	background: white;
	border-radius: 30px;
	box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
	display: none;
	flex-direction: column;
	overflow: hidden;
	z-index: 1000;
	border: 1px solid #f7ede2;
	animation: fadeInUp 0.3s ease;
}

@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.chatbot-header {
	background: #e76f51;
	color: white;
	padding: 20px;
	font-weight: 700;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.chat-content {
	flex: 1;
	padding: 20px;
	overflow-y: auto;
	background: #fffaf5;
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.msg {
	max-width: 80%;
	padding: 12px 16px;
	border-radius: 20px;
	font-size: 14px;
	line-height: 1.5;
	word-break: break-all;
}

.bot-msg {
	background: #eee1d5;
	color: #4a3f35;
	align-self: flex-start;
	border-bottom-left-radius: 5px;
}

.user-msg {
	background: #e76f51;
	color: white;
	align-self: flex-end;
	border-bottom-right-radius: 5px;
}

.chat-input-area {
	padding: 15px;
	background: white;
	border-top: 1px solid #eee1d5;
	display: flex;
	gap: 10px;
}

.chat-input-area input {
	flex: 1;
	border: 1px solid #eee1d5;
	padding: 10px 15px;
	border-radius: 20px;
	outline: none;
}

.btn-send {
	background: #e76f51;
	color: white;
	border: none;
	width: 40px;
	height: 40px;
	border-radius: 50%;
	cursor: pointer;
}

/* 챗봇 말풍선 공통 */
.msg {
	max-width: 80%;
	padding: 12px 16px;
	border-radius: 20px;
	font-size: 14px;
	line-height: 1.5;
	word-break: break-all;
	margin-bottom: 10px;
	display: flex;
	flex-direction: column; /* 텍스트와 이미지를 세로로 정렬 */
}

/* 봇 메시지: 배경 베이지, 글자는 반드시 짙은 갈색 */
.bot-msg {
	background-color: #eee1d5 !important;
	color: #4a3f35 !important;
	align-self: flex-start;
}

/* 유저 메시지: 배경 주황, 글자는 반드시 흰색 */
.user-msg {
	background-color: #e76f51 !important;
	color: #ffffff !important;
	align-self: flex-end;
}

/* 텍스트가 보이지 않는 현상 방지 */
.msg span {
	color: inherit !important;
	display: block;
	min-height: 1.2em; /* 최소 높이 확보 */
}

/* 챗봇 이미지 스타일 */
.bot-msg img {
	width: 100%;
	max-width: 200px; /* 너무 크지 않게 조절 */
	height: auto;
	border-radius: 10px;
	margin-top: 8px;
	display: block;
	border: 1px solid #ddd;
}
/* 새로운 대시보드 레이아웃 여백 보강 */
.dashboard-layout {
    width: 100% !important;
    box-sizing: border-box !important;
    display: block !important;    /* flex가 설정되어 있다면 해제 */
}

.dashboard-container {
    width: 100%;
    display: flex;
    justify-content: center !important;
    align-items: center;

    padding: 60px 60px;   /* 좌우 동일 */
    box-sizing: border-box;
	transform: translateX(-15px);
    background: #ffffff;
    border-radius: 30px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.04);
    gap: 80px;
}


.dashboard-text {
    flex: 1 1 0 !important;
    max-width: 420px;
    border-left: 3px solid #e76f51;
    padding-left: 40px;
}

.dashboard-text .tag {
	color: #e76f51;
	font-weight: 700;
	font-size: 0.9rem;
	letter-spacing: 4px;
	text-transform: uppercase;
}

.dashboard-text h2 {
    font-size: 40px; /* 폰트 크기를 살짝 줄여서 콤팩트하게 */
    line-height: 1.2;
    margin-bottom: 8px;
}

.dashboard-text p {
    font-size: 20px;
    margin: 0;
}

.explore-hint {
	font-size: 0.9rem;
	color: #abb3bb;
	font-weight: 500;
}

.dashboard-visual {
    flex: 1 1 0 !important;
    max-width: 520px !important;  /* 🔥 600 → 520 */
    margin-right: 20px;           /* 🔥 시각 중심 보정 */
    
    display: grid !important;
    grid-template-columns: repeat(3, 1fr) !important;
    gap: 15px !important;
}



.dash-item {
	text-decoration: none;
	text-align: center;
	transition: 0.3s;
}

.dash-img-wrapper {
    width: 100%;
    /* aspect-ratio를 1:1이 아닌 가로가 긴 4:3 또는 16:9 느낌으로 설정 */
    aspect-ratio: 4 / 3; 
    border-radius: 15px;
    overflow: hidden;
}

.dash-img-wrapper img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.dash-item-overlay {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(231, 111, 81, 0.6);
	display: flex;
	align-items: center;
	justify-content: center;
	opacity: 0;
	transition: 0.3s;
}

.dash-item-overlay span {
	color: white;
	border: 1px solid white;
	padding: 5px 15px;
	border-radius: 20px;
	font-size: 12px;
}

.dash-item:hover .dash-img-wrapper img {
	transform: scale(1.1);
}

.dash-item:hover .dash-item-overlay {
	opacity: 1;
}

/* 카테고리 이름 (거실, 다이닝, 주방 등) 스타일 수정 */
.dash-item-name {
    display: block;
    text-align: center;
    
    /* 1. 폰트를 다시 나눔명조로 고정 */
    font-family: 'Nanum Myeongjo', serif !important;
    
    /* 2. 보라색을 지우고 테마 색상(짙은 갈색)으로 변경 */
    color: #4a3f35 !important;
    
    /* 3. 크기와 굵기 조절 */
    font-size: 15px; 
    font-weight: 700;
    
    /* 4. 이미지와의 간격 */
    margin-top: 10px;
    
    /* 5. 링크 밑줄 제거 */
    text-decoration: none !important;
}

/* 마우스 올렸을 때 색상 변화 (선택사항) */
.dash-item:hover .dash-item-name {
    color: #e76f51 !important; /* 주황색 포인트 */
}

/* 반응형 처리 */
@media ( max-width : 992px) {
	.dashboard-container {
		flex-direction: column;
		padding: 40px;
	}
	.dashboard-text {
		border-left: none;
		border-bottom: 2px solid #e76f51;
		padding: 0 0 20px 0;
		text-align: center;
	}
}
/* 섹션 헤더 정렬 */
.section-header-flex {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-bottom: 30px;
    /* 만약 제목도 너무 붙어 보인다면 여기서 추가 padding을 줄 수 있습니다 */
}
.header-text h2 { font-size: 20px; font-weight: 700; margin: 0; color: #2f3438; }
.header-text p { font-size: 14px; color: #828c94; margin: 5px 0 0; }
.text-more-link { font-size: 14px; font-weight: 700; color: #35c5f0; text-decoration: none; }

/* 가로 스크롤 컨테이너 */
.photo-scroll-container {
    display: flex;
    gap: 20px;
    overflow-x: auto;
    padding-bottom: 10px;
    justify-content: flex-start;
    scrollbar-width: none; /* 파이어폭스 */
}
.photo-scroll-container::-webkit-scrollbar { display: none; } /* 크롬, 사파리 */

/* 사진 카드 디자인 */
.photo-card {
    flex: 0 0 calc(20% - 12px); /* 한 화면에 5개 노출 기준 */
    min-width: 200px;
    cursor: pointer;
}

.photo-img-wrap {
    position: relative;
    width: 100%;
    aspect-ratio: 3 / 4; /* 오늘의 집 특유의 세로 비율 */
    border-radius: 8px;
    overflow: hidden;
}

.photo-img-wrap img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s;
}

.photo-card:hover img { transform: scale(1.05); }

/* 사진 위 유저 정보 */
.photo-overlay-top {
    position: absolute;
    bottom: 15px;
    left: 15px;
    z-index: 2;
}
.photo-recommend-section {
    width: 100% !important;
    max-width: 1200px !important; /* 위 대시보드 박스(max-width)와 똑같은 값으로 설정 */
    margin: 0 auto !important;    /* 화면 중앙 정렬 (이게 없어서 왼쪽에 붙는 것임) */
    padding: 60px 40px 120px 40px !important; /* 좌우 패딩을 40px 정도로 주어 여유 확보 */
    box-sizing: border-box !important;
}
.user-info { display: flex; align-items: center; gap: 8px; }
.user-thumb { 
    width: 24px; height: 24px; 
    border-radius: 50%; background: #ddd; 
    border: 1.5px solid white;
}
.user-nick { color: white; font-size: 13px; font-weight: 700; text-shadow: 0 1px 4px rgba(0,0,0,0.4); }

/* 북마크 버튼 */
.btn-bookmark {
    position: absolute;
    bottom: 15px;
    right: 15px;
    background: none;
    border: none;
    cursor: pointer;
    filter: drop-shadow(0 1px 4px rgba(0,0,0,0.4));
}

/* 더보기 카드 */
.more-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: #f7f9fa;
    border-radius: 8px;
    aspect-ratio: 3 / 4;
    color: #828c94;
    font-weight: 700;
}
.more-circle {
    width: 40px; height: 40px;
    border-radius: 50%;
    background: white;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/guest/Header.jsp" />


	<section class="section-box dashboard-layout"
		style="margin-top: 20px !important;">
		<div class="dashboard-container">
			<div class="dashboard-text">
				<span class="tag">COLLECTION</span>
				<h2>
					공간의 분위기를<br>결정하는 큐레이션
				</h2>
				<p>취향에 맞는 카테고리를 선택해보세요.</p>
			</div>

			<div class="dashboard-visual">
				<c:forEach var="category" items="${categories}" varStatus="status">

					<a href="/products/categories/${category.categoryId}"
						class="dash-item">
						<div class="dash-img-wrapper">
							<img src="${category.image}" alt="${category.name}" />
						</div> <span class="dash-item-name">${category.name}</span>
					</a>

				</c:forEach>
			</div>
		</div>
	</section>

	<section class="section-box photo-recommend-section">
		<div class="section-header-flex">
			<div class="header-text">
				<h2>이런 인테리어 찾고 있나요?</h2>
				<p>좋아하실 만한 인테리어 콘텐츠를 추천해드려요</p>
			</div>
			<a href="/guest/list" class="text-more-link">더보기</a>
		</div>

		<div class="photo-scroll-container">
			<c:forEach var="post" items="${communityList}" varStatus="status">
				<c:if test="${status.index < 5}">
					<div class="photo-card" data-bcode="${post.b_code}" onclick="location.href='/user/detail?b_code=${post.b_code}'">
						<div class="photo-img-wrap">
							<img src="/upload/${post.b_image}" alt="${post.b_title}">

							<div class="photo-overlay-top">
								<div class="user-info">
									<div class="user-thumb"></div>
									<span class="user-nick">${post.m_nick}</span>
								</div>
							</div>
<button class="btn-bookmark">
    <svg width="24" height="24" viewBox="0 0 24 24" 
         fill="${post.isBookmarked ? '#e76f51' : 'none'}" 
         stroke="${post.isBookmarked ? '#e76f51' : 'white'}" 
         stroke-width="2">
        <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
    </svg>
</button>
						</div>
					</div>
				</c:if>
			</c:forEach>

			<div class="photo-card more-card"
				onclick="location.href='/guest/list'">
				<div class="more-circle">
					<svg width="24" height="24" viewBox="0 0 24 24" fill="none"
						stroke="#666" stroke-width="2">
                    <path d="M9 18l6-6-6-6"></path>
                </svg>
				</div>
				<span>더보기</span>
			</div>
		</div>
	</section>

	<!-- 챗봇 버튼 & 창 -->
	<div class="bot-btn" id="chatbotOpenBtn">
		<svg width="28" height="28" viewBox="0 0 24 24" fill="white">
        <path
				d="M12 2C6.48 2 2 6.48 2 12c0 3.69 2.01 6.91 5 8.63V22l3.5-2h1.5c5.52 0 10-4.48 10-10S17.52 2 12 2z" />
    </svg>
	</div>

	<div class="chatbot-window" id="chatbotWindow">
		<div class="chatbot-header">
			<span>🎨 그리다 아뜰리에 봇</span>
			<div style="display: flex; gap: 10px; align-items: center;">
				<span id="exitChat"
					style="cursor: pointer; font-size: 12px; border: 1px solid white; padding: 2px 5px; border-radius: 5px;">종료</span>
				<span id="closeChat" style="cursor: pointer; font-size: 20px;">&times;</span>
			</div>
		</div>
		<div class="chat-content" id="chatContent">
			<div class="msg bot-msg">안녕하세요! "그리다 아뜰리에"에 오신 것을 환영합니다. 무엇을
				도와드릴까요?</div>
		</div>
		<div class="chat-input-area">
			<input type="text" id="chatInput" placeholder="메시지를 입력하세요..."
				autocomplete="off">
			<button class="btn-send" id="sendBtn">▲</button>
		</div>
	</div>

	<script>
document.addEventListener('DOMContentLoaded', function() {
    const chatBtn = document.getElementById('chatbotOpenBtn');
    const chatWindow = document.getElementById('chatbotWindow');
    const closeChat = document.getElementById('closeChat');
    const chatInput = document.getElementById('chatInput');
    const sendBtn = document.getElementById('sendBtn');
    const chatContent = document.getElementById('chatContent');
    const exitChat = document.getElementById('exitChat');

    chatBtn.addEventListener('click', () => {
        chatWindow.style.display = (chatWindow.style.display === 'flex') ? 'none' : 'flex';
        if(chatWindow.style.display === 'flex') chatInput.focus();
    });

    closeChat.addEventListener('click', () => chatWindow.style.display = 'none');
    exitChat.addEventListener('click', () => {
        if (confirm("대화를 종료하시겠습니까?")) {
            // 종료 메시지 출력
            appendMessage('bot', '챗봇이 종료되었습니다. 이용해 주셔서 감사합니다.');
            
            // 입력창 비활성화
            chatInput.disabled = true;
            chatInput.placeholder = "종료된 대화입니다.";
            sendBtn.disabled = true;

            // 2초 뒤 창 닫기
            setTimeout(() => {
                chatWindow.style.display = 'none';
            }, 2000);
        }
    });
    function appendMessage(type, text, imgUrl, linkUrl) {
        const div = document.createElement('div');
        div.className = 'msg ' + (type === 'user' ? 'user-msg' : 'bot-msg');

        // 텍스트가 있을 경우 span 태그로 감싸서 명확히 삽입
        if(text) {
            const span = document.createElement('span');
            span.innerText = text; // innerHTML 대신 innerText 권장 (보안 및 텍스트 유지)
            span.style.display = "block";
            div.appendChild(span);
        }

        // 이미지 처리
        if(imgUrl && imgUrl.trim() !== "" && imgUrl !== "null") {
            const img = document.createElement('img');
            img.src = imgUrl.startsWith('http') ? imgUrl : '/upload/' + imgUrl;
            img.style.width = "100%";
            img.style.borderRadius = "10px";
            img.style.marginTop = "8px";
            img.onerror = function() { this.style.display = 'none'; }; // 이미지 로드 실패 시 숨김
            div.appendChild(img);
        }

     // 상세 페이지 링크 처리 (이 부분 스타일만 살짝 보강하세요)
        if(linkUrl && linkUrl.trim() !== "" && linkUrl !== "null") {
            const a = document.createElement('a');
            a.href = linkUrl;
            a.target = "_blank";
            a.innerText = "상세보기 →";
            // color: white !important; 추가 (글자가 안 보일 때 대비)
            a.style.cssText = "display:inline-block; margin-top:8px; padding:5px 12px; background:#e76f51; color:white !important; border-radius:15px; text-decoration:none; font-size:11px; font-weight:bold;";
            div.appendChild(a);
        }

        chatContent.appendChild(div);
        chatContent.scrollTop = chatContent.scrollHeight;
    }
 // 챗봇 창이 열릴 때 내 이전 질문에 대한 답변이 있는지 체크
    function checkManualAnswers() {
        fetch('/chatbot/my_manual_answers') // 본인의 ID로 답변 완료된 내역 조회 API
        .then(res => res.json())
        .then(data => {
            data.forEach(item => {
                appendMessage('bot', `[답변 도착] 질문: ${item.chat_message} \n답변: ${item.admin_answer}`);
            });
        });
    }

    function sendMessage() {
        const text = chatInput.value.trim();
        if(!text) return;

        appendMessage('user', text);
        chatInput.value = '';

        fetch('/chatbot/send', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ chat_message: text })
        })
        .then(res => res.json())
        .then(data => {
            // 1. 서버에서 데이터 꺼내기
            const msg = data.response_msg;
            const img = data.img_url;
            const link = data.link_url; // 확인하신 키값으로 매핑!

            // 2. 인자 4개를 순서대로 전달 (타입, 메시지, 이미지, 링크)
            appendMessage('bot', msg, img, link);
        })
        .catch(err => {
            console.error("서버 에러:", err);
            appendMessage('bot', '서버와 연결할 수 없습니다.');
        });
    }

    sendBtn.addEventListener('click', sendMessage);
    chatInput.addEventListener('keypress', e => { if(e.key === 'Enter') sendMessage(); });
});
document.querySelectorAll('.btn-bookmark').forEach(button => {
    button.addEventListener('click', function(e) {
        e.stopPropagation(); 
        
        const svg = this.querySelector('svg');
        const card = this.closest('.photo-card');
        const b_code = card.getAttribute('data-bcode');

        // 1. 로그인 체크 (세션 m_id 확인)
        const loginId = "${sessionScope.m_id}";
        if (!loginId) {
            alert("로그인이 필요한 서비스입니다.");
            location.href = "/guest/loginForm";
            return;
        }

        // 2. 서버 전송 (URL을 /user/toggleBookmark로 통일)
        const formData = new URLSearchParams();
        formData.append('b_code', b_code);

        fetch('/user/toggleBookmark', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        })
        .then(res => res.json())
        .then(status => {
            // 서버 응답이 1(추가) 또는 0(삭제)인 경우
            if (status == 1) {
                svg.setAttribute('fill', '#e76f51');
                svg.setAttribute('stroke', '#e76f51');
                // alert("🔖 북마크에 추가되었습니다."); // 취향에 따라 알림 추가
            } else if (status == 0) {
                svg.setAttribute('fill', 'none');
                svg.setAttribute('stroke', 'white');
                // alert("🔖 북마크가 해제되었습니다.");
            }
        })
        .catch(err => {
            console.error("에러 발생:", err);
            alert("처리 중 오류가 발생했습니다.");
        });
    });
});
</script>


</body>
</html>