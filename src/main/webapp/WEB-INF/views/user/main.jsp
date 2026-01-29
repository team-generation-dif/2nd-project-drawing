<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 아뜰리에</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@700&family=Pretendard:wght@300;400;600;700&display=swap');

        body { 
            background-color: #fffaf5; font-family: 'Pretendard', sans-serif; 
            margin: 0; color: #4a3f35; line-height: 1.6;
        }

        /* 1. 상단 감성 배너 섹션 */
        .hero-section {
            width: 100%; padding: 60px 0 100px;
            display: flex; flex-direction: column; align-items: center;
            position: relative; overflow: hidden;
        }

        .watercolor-bg {
            position: absolute; top: 0; right: -10%; width: 60%; height: 100%;
            background: radial-gradient(circle, #f7ede2 0%, rgba(255, 250, 245, 0) 70%);
            filter: blur(60px); z-index: 1;
        }

        .hero-canvas {
            position: relative; z-index: 5;
            width: 90%; max-width: 1100px; padding: 80px 60px;
            background: white; border-radius: 50px;
            box-shadow: 0 20px 50px rgba(139, 126, 116, 0.1);
            background-image: url('https://www.transparenttextures.com/patterns/paper-fibers.png');
            text-align: left;
        }

        .hero-canvas h1 { font-family: 'Nanum Myeongjo', serif; font-size: 3rem; margin: 0; color: #4a3f35; }
        .hero-canvas p { font-size: 1.1rem; color: #8b7e74; margin: 25px 0 40px; }

        .btn-draw-start {
            display: inline-flex; align-items: center; gap: 10px;
            background: #e76f51; color: white; padding: 18px 45px;
            border-radius: 40px; font-weight: 700; text-decoration: none;
            box-shadow: 0 10px 25px rgba(231, 111, 81, 0.3); transition: 0.3s;
        }
        .btn-draw-start:hover { transform: translateY(-3px); background: #d65d40; }

        .category-nav { display: flex; gap: 15px; margin-top: 40px; z-index: 10; }
        .cat-item {
            background: white; padding: 12px 25px; border-radius: 30px;
            text-decoration: none; color: #8b7e74; font-weight: 600; font-size: 0.9rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); transition: 0.3s;
        }

        /* 2. 섹션 스타일 */
        .section-box { max-width: 1156px; margin: 80px auto; padding: 0 20px; }
        .section-header { margin-bottom: 35px; }
        .section-header h2 { font-family: 'Nanum Myeongjo', serif; font-size: 24px; margin: 0; }
        .section-header p { color: #abb3bb; font-size: 14px; margin: 5px 0 0; }

        .story-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
        .story-card { height: 300px; border-radius: 25px; overflow: hidden; position: relative; cursor: pointer; background: #eee; }
        .story-card img { width: 100%; height: 100%; object-fit: cover; transition: 0.5s; }
        .story-overlay { position: absolute; bottom: 0; width: 100%; padding: 20px; background: linear-gradient(transparent, rgba(0,0,0,0.6)); color: white; box-sizing: border-box; }

        .prod-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 30px; }
        .prod-card { text-decoration: none; color: inherit; }
        .prod-img { width: 100%; aspect-ratio: 1; border-radius: 25px; object-fit: cover; transition: 0.3s; }
        .prod-price { font-weight: 700; font-size: 1.1rem; color: #e76f51; }

        /* 3. 챗봇 버튼 & 창 통합 스타일 */
        .bot-btn {
            position: fixed; bottom: 40px; right: 40px; width: 65px; height: 65px;
            background: #e76f51; border-radius: 30px 30px 5px 30px;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 10px 20px rgba(231, 111, 81, 0.3); cursor: pointer; z-index: 1000;
            transition: transform 0.3s;
        }
        .bot-btn:hover { transform: scale(1.05); }

        .chatbot-window {
            position: fixed; bottom: 120px; right: 40px;
            width: 350px; height: 500px;
            background: white; border-radius: 30px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
            display: none; flex-direction: column; overflow: hidden; z-index: 1000;
            border: 1px solid #f7ede2; animation: fadeInUp 0.3s ease;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .chatbot-header { background: #e76f51; color: white; padding: 20px; font-weight: 700; display: flex; justify-content: space-between; align-items: center; }
        .chat-content { flex: 1; padding: 20px; overflow-y: auto; background: #fffaf5; display: flex; flex-direction: column; gap: 10px; }
        
        .msg { max-width: 80%; padding: 12px 16px; border-radius: 20px; font-size: 14px; line-height: 1.5; word-break: break-all; }
        .bot-msg { background: #eee1d5; color: #4a3f35; align-self: flex-start; border-bottom-left-radius: 5px; }
        .user-msg { background: #e76f51; color: white; align-self: flex-end; border-bottom-right-radius: 5px; }

        .chat-input-area { padding: 15px; background: white; border-top: 1px solid #eee1d5; display: flex; gap: 10px; }
        .chat-input-area input { flex: 1; border: 1px solid #eee1d5; padding: 10px 15px; border-radius: 20px; outline: none; }
        .btn-send { background: #e76f51; color: white; border: none; width: 40px; height: 40px; border-radius: 50%; cursor: pointer; }
    </style>
</head>
<body>
    <jsp:include page="../common/Header.jsp" />

    <section class="hero-section">
        <div class="watercolor-bg"></div>
        <div class="hero-canvas">
            <h1>나만의 아뜰리에,<br>그리다에서 시작하세요.</h1>
            <p>당신의 공간을 더 가치 있게 만드는<br>마스터의 큐레이션을 만나보세요.</p>
            <a href="/user/draw" class="btn-draw-start">지금 공간 그리기 시작 ✨</a>
        </div>
        <nav class="category-nav">
            <a href="?c=1" class="cat-item">🛋️ 거실</a>
            <a href="?c=2" class="cat-item">🛏️ 침실</a>
            <a href="?c=3" class="cat-item">🍽️ 주방</a>
            <a href="?c=4" class="cat-item">✨ 3D배치</a>
        </nav>
    </section>

    <section class="section-box">
        <div class="section-header">
            <h2>작가님들의 공간 이야기</h2>
            <p>서로의 영감을 나누는 온라인 집들이</p>
        </div>
        <div class="story-grid">
            <c:forEach var="post" items="${communityList}" varStatus="status">
                <c:if test="${status.index < 4}">
                    <div class="story-card" onclick="location.href='/community/detail?id=${post.id}'">
                        <img src="${post.mainImg}">
                        <div class="story-overlay">
                            <small>@${post.writerNick}</small>
                            <div style="font-weight: 600;">${post.title}</div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </section>

    <section class="section-box">
        <div class="section-header">
            <h2>오늘의 추천 오보즈</h2>
            <p>마스터가 엄선한 가구 큐레이션</p>
        </div>
        <div class="prod-grid">
            <c:forEach var="item" items="${productList}" varStatus="status">
                <c:if test="${status.index < 8}">
                    <a href="${item.p_link}" class="prod-card">
                        <img src="${item.p_img}" class="prod-img">
                        <div class="prod-info">
                            <div style="font-size: 12px; color: #abb3bb;">${item.p_brand}</div>
                            <div style="font-size: 14px; margin: 4px 0;">${item.p_name}</div>
                            <div class="prod-price">${item.p_price}원</div>
                        </div>
                    </a>
                </c:if>
            </c:forEach>
        </div>
    </section>

    <div class="bot-btn" id="chatbotOpenBtn">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="white">
            <path d="M12 2C6.48 2 2 6.48 2 12c0 3.69 2.01 6.91 5 8.63V22l3.5-2h1.5c5.52 0 10-4.48 10-10S17.52 2 12 2z"/>
        </svg>
    </div>

    <div class="chatbot-window" id="chatbotWindow">
        <div class="chatbot-header">
            <span>🎨 그리다 아뜰리에 봇</span>
            <span id="closeChat" style="cursor:pointer; font-size: 20px;">&times;</span>
        </div>
        <div class="chat-content" id="chatContent">
            <div class="msg bot-msg">안녕하세요! "그리다 아뜰리에"에 오신 것을 환영합니다. 무엇을 도와드릴까요?</div>
        </div>
        <div class="chat-input-area">
            <input type="text" id="chatInput" placeholder="메시지를 입력하세요..." autocomplete="off">
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

    chatBtn.addEventListener('click', () => {
        chatWindow.style.display =
            chatWindow.style.display === 'flex' ? 'none' : 'flex';
        chatInput.focus();
    });

    closeChat.addEventListener('click', () => {
        chatWindow.style.display = 'none';
    });

    function appendMessage(type, text) {
        const div = document.createElement('div');
        div.className = 'msg ' + (type === 'user' ? 'user-msg' : 'bot-msg');
        div.textContent = text;
        chatContent.appendChild(div);
        chatContent.scrollTop = chatContent.scrollHeight;
    }

    function sendMessage() {
        const text = chatInput.value.trim();
        if (!text) return;

        appendMessage('user', text);
        chatInput.value = '';

        fetch('/api/chatbot/search?keyword=' + encodeURIComponent(text))
            .then(res => res.json())
            .then(data => {
                if (data && data.response_msg) {
                    appendMessage('bot', data.response_msg);
                } else {
                    appendMessage('bot', '아직 준비되지 않은 질문이에요 😢');
                }
            })
            .catch(() => {
                appendMessage('bot', '잠시 서버가 불안정해요. 다시 시도해주세요!');
            });
    }

    sendBtn.addEventListener('click', sendMessage);
    chatInput.addEventListener('keypress', e => {
        if (e.key === 'Enter') sendMessage();
    });
});
</script>

</body>
</html>