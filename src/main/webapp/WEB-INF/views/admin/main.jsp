<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 관리자 | 데이터 분석 센터</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@800&family=Pretendard:wght@400;600;700&display=swap');

        :root {
            --sidebar-width: 260px; /* 사이드바 너비 살짝 조절 */
            --primary-brown: #332d26;
            --accent-coral: #e76f51;
            --bg-warm: #fdfbf9;
            --border-color: #f0ede9;
        }

        body { background: var(--bg-warm); font-family: 'Pretendard', sans-serif; margin: 0; padding-top: 80px; }

        /* 1. 상단 헤더 */
        .header-container { position: fixed; top: 0; left: 0; width: 100%; height: 80px; background: #fff; border-bottom: 1px solid var(--border-color); z-index: 1000; }

        /* 2. 사이드바 (여백 확보) */
        .sidebar { 
            width: var(--sidebar-width); 
            position: fixed; top: 80px; left: 0; bottom: 0; 
            background: #fff; border-right: 1px solid var(--border-color); 
            padding: 30px 15px; /* 내부 패딩 증가 */
            box-sizing: border-box;
        }
        .nav-link { 
            text-decoration: none; color: #6d625b; font-weight: 600; padding: 16px 20px; 
            display: flex; align-items: center; border-radius: 14px; margin-bottom: 8px; transition: 0.3s; 
        }
        .nav-link:hover, .nav-link.active { background: #fff1f0; color: var(--accent-coral); box-shadow: 0 4px 10px rgba(231, 111, 81, 0.1); }

        /* 3. 메인 콘텐츠 (사이드바와의 간격 대폭 확보) */
        .main-content { 
            margin-left: calc(var(--sidebar-width) + 40px); /* 사이드바 너비 + 40px 추가 간격 */
            padding: 40px 60px 40px 20px; /* 오른쪽과 상단 여백 넉넉히 */
            max-width: 1400px;
        }

        /* 4. 상단 통계 카드 */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 25px; margin-bottom: 40px; }
        .stat-card { background: #fff; padding: 28px; border-radius: 24px; border: 1px solid var(--border-color); box-shadow: 0 8px 20px rgba(0,0,0,0.02); }
        .stat-val { font-size: 2.2rem; font-weight: 800; color: var(--primary-brown); margin: 12px 0; }

        /* 5. 분석 섹션 레이아웃 */
        .dashboard-row { display: grid; grid-template-columns: 1.5fr 1fr; gap: 35px; align-items: start; }
        .card { background: #fff; border-radius: 28px; padding: 35px; border: 1px solid var(--border-color); box-shadow: 0 10px 30px rgba(0,0,0,0.03); }

        /* 6. 격자형 달력 디자인 보정 (숫자 노출 보장) */
        .cal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px solid var(--accent-coral); padding-bottom: 15px; }
        .cal-grid { 
            display: grid; 
            grid-template-columns: repeat(7, 1fr); 
            border-top: 1px solid #f0f0f0; 
            border-left: 1px solid #f0f0f0; 
        }
        .cal-cell {
            height: 75px; /* 높이 증가 */
            padding: 12px; 
            border-right: 1px solid #f0f0f0; 
            border-bottom: 1px solid #f0f0f0;
            font-size: 1.1rem; /* 숫자 크기 키움 */
            color: #333;
            font-weight: 500;
            display: flex;
            align-items: flex-start;
            justify-content: flex-start;
            position: relative;
            background: #fff;
        }
        .cal-day-label { 
            height: 45px; background: #faf8f6; font-weight: 700; color: var(--accent-coral); 
            align-items: center; justify-content: center; font-size: 0.9rem;
        }
        .cal-cell.today { background: #fff1f0; color: var(--accent-coral); font-weight: 800; }
        .cal-cell.today::after { 
            content: 'Today'; position: absolute; bottom: 8px; right: 10px; 
            font-size: 0.75rem; background: var(--accent-coral); color: #fff; 
            padding: 3px 7px; border-radius: 6px; 
        }
    </style>
</head>
<body>

    <header class="header-container">
        <jsp:include page="../guest/Header.jsp" />
    </header>

    <nav class="sidebar">
        <ul style="list-style: none; padding: 0; margin: 0;">
            <li><a href="#" class="nav-link active">🏠 대시보드 센터</a></li>
            <li><a href="/admin/notice_write" class="nav-link">📢 공지사항 관리</a></li>
            <li><a href="/admin/userManage" class="nav-link">👥 회원 정보 관리</a></li>
            <li><a href="/guest/list" class="nav-link">🖼 콘텐츠 모니터링</a></li>
            <li><a href="/admin/chatbot_mgmt" class="nav-link">🤖 AI 챗봇 학습</a></li>
            <li><a href="/" class="nav-link">🎨 회원페이지</a></li>
        </ul>
    </nav>

    <main class="main-content">
        <h1 style="font-family: 'Nanum Myeongjo'; font-size: 2.2rem; margin-bottom: 40px; color: var(--primary-brown);">데이터 분석 센터</h1>

        <div class="stats-grid">
            <div class="stat-card">
                <span style="color:#8b7e74; font-weight:600; font-size: 0.95rem;">전체 회원수</span>
                <div class="stat-val">${totalUsers}명</div>
                <span style="color: #2ecc71; font-size: 0.85rem; font-weight: 700;">● 실시간 누적</span>
            </div>
            <div class="stat-card">
                <span style="color:#8b7e74; font-weight:600; font-size: 0.95rem;">신규 회원 (오늘)</span>
                <div class="stat-val">${newUsersToday}명</div>
                <span style="color: var(--accent-coral); font-size: 0.85rem; font-weight: 700;">▲ 갱신 완료</span>
            </div>
            <div class="stat-card">
                <span style="color:#8b7e74; font-weight:600; font-size: 0.95rem;">오늘의 게시글</span>
                <div class="stat-val">${todayWorks}건</div>
                <span style="color: #2ecc71; font-size: 0.85rem; font-weight: 700;">▲ NEW</span>
            </div>
            <div class="stat-card">
                <span style="color:#8b7e74; font-weight:600; font-size: 0.95rem;">챗봇 이용 횟수</span>
                <div class="stat-val">${todayChatCount}회</div>
                <span style="color: var(--accent-coral); font-size: 0.85rem; font-weight: 700;">Active</span>
            </div>
        </div>

        <div class="dashboard-row">
            <div class="card">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:30px;">
                    <span style="font-weight:700; font-size: 1.2rem;">📊 실시간 가구 조회 트렌드</span>
                    <button onclick="location.reload()" style="padding:8px 16px; border-radius:10px; border:1px solid #ddd; background:#fff; cursor:pointer; font-weight: 600;">새로고침</button>
                </div>
                <div style="height: 420px;"><canvas id="trendChart"></canvas></div>
            </div>

            <div class="card">
                <div class="cal-header">
                    <button onclick="moveMonth(-1)" style="border:none; background:none; cursor:pointer; font-size:1.4rem;">◀</button>
                    <span id="monthDisplay" style="font-weight: 800; font-size: 1.4rem; letter-spacing: -0.5px;"></span>
                    <button onclick="moveMonth(1)" style="border:none; background:none; cursor:pointer; font-size:1.4rem;">▶</button>
                </div>
                <div class="cal-grid" id="calendarBody">
                    </div>
            </div>
        </div>
    </main>

    <script>
    /* 차트 초기화 */
    const ctx = document.getElementById('trendChart').getContext('2d');
    let trendChart;

    // 실시간 데이터 가져오기
    function loadFurnitureTrends() {
        fetch('/admin/furnitureTrends')
            .then(response => response.json())
            .then(data => {
                const labels = Object.keys(data);   // ["소파", "침대", "테이블"...]
                const values = Object.values(data); // [15000, 12000, 9000...]

                // 차트가 이미 있으면 업데이트, 없으면 생성
                if (trendChart) {
                    trendChart.data.labels = labels;
                    trendChart.data.datasets[0].data = values;
                    trendChart.update();
                } else {
                    trendChart = new Chart(ctx, {
                        type: 'bar', // 막대 그래프로 변경 (선 그래프는 'line')
                        data: {
                            labels: labels,
                            datasets: [{
                                label: '검색량',
                                data: values,
                                backgroundColor: 'rgba(231, 111, 81, 0.6)',
                                borderColor: '#e76f51',
                                borderWidth: 2
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales: {
                                y: { beginAtZero: true }
                            }
                        }
                    });
                }
            })
            .catch(err => console.error('API 오류:', err));
    }

    // 페이지 로드 시 실행
    loadFurnitureTrends();

    // 10초마다 자동 갱신
    setInterval(loadFurnitureTrends, 10000);

        /* 2. 달력 숫자 렌더링 로직 (수정됨) */
        let currDate = new Date();

        function renderCalendar() {
            const y = currDate.getFullYear();
            const m = currDate.getMonth();
            
            document.getElementById('monthDisplay').innerText = y + "." + String(m + 1).padStart(2, '0');

            const body = document.getElementById('calendarBody');
            body.innerHTML = ''; // 초기화

            // 요일 출력
            ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].forEach(d => {
                const dayCell = document.createElement('div');
                dayCell.className = 'cal-cell cal-day-label';
                dayCell.textContent = d;
                body.appendChild(dayCell);
            });

            const firstDay = new Date(y, m, 1).getDay();
            const lastDate = new Date(y, m + 1, 0).getDate();

            // 이전 달 공백
            for (let i = 0; i < firstDay; i++) {
                const emptyCell = document.createElement('div');
                emptyCell.className = 'cal-cell';
                emptyCell.style.background = '#fcfcfc';
                body.appendChild(emptyCell);
            }

            // 이번 달 날짜 숫자 삽입
            const today = new Date();
            for (let i = 1; i <= lastDate; i++) {
                const dateCell = document.createElement('div');
                const isToday = (i === today.getDate() && m === today.getMonth() && y === today.getFullYear());
                
                dateCell.className = isToday ? 'cal-cell today' : 'cal-cell';
                dateCell.textContent = i;
                body.appendChild(dateCell);
            }
        }

        function moveMonth(v) {
            currDate.setMonth(currDate.getMonth() + v);
            renderCalendar();
        }

        // DOM이 로드된 후 즉시 실행하도록 보장
        document.addEventListener('DOMContentLoaded', renderCalendar);
    </script>
</body>
</html>