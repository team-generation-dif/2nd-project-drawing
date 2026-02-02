<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 내 아뜰리에</title>
</head>
<body>
	<%@ include file="../../guest/Header.jsp" %>
	<div class="container">
		<h2>내 라이브러리</h2>
		<div>
			<button class="" onclick="openNewModal()">새 인테리어</button>
		</div>
		<div class="">
			<c:forEach var="list" items="${dto}">
				<div class="card">
					<a href="/user/interior/draw?i_code=${list.i_code}">
						<div class="thumb-img"><img src="${list.i_image}"></div>
						<p>${list.i_title}
					</a>
					<p><small>${list.i_date}</small>
					<a href="/user/interior/delete?i_code=${list.i_code}" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
				</div>
			</c:forEach>
		</div>
	</div>
	<div id="newProjectModal" class="modal-overlay" style="display: none;">
	    <div class="modal-content">
	        <div class="modal-header">
	            <h3>새 인테리어 시작하기</h3>
	            <span class="close-btn" onclick="closeModal()">×</span>
	        </div>
	        
	        <div id="step-select" class="modal-body">
	            <div class="option-grid">
	                <div class="option-card" onclick="goToEmptyDraw()">
	                    <div class="icon">📄</div>
	                    <div class="title">빈 도면으로 시작</div>
	                    <div class="desc">처음부터 자유롭게 그립니다.</div>
	                </div>
	                
	                <div class="option-card" onclick="loadFloorplanList('my')">
	                    <div class="icon">🏠</div>
	                    <div class="title">내 평면도에서</div>
	                    <div class="desc">저장해둔 평면도를 불러옵니다.</div>
	                </div>
	                
	                <div class="option-card" onclick="loadFloorplanList('template')">
	                    <div class="icon">🏢</div>
	                    <div class="title">추천 템플릿</div>
	                    <div class="desc">일반적인 방의 구조를 사용합니다.</div>
	                </div>
	                
	                <div class="option-card" onclick="alert('이미지 인식 기능은 준비 중입니다! 🤖')">
	                    <div class="icon">📷</div>
	                    <div class="title">이미지로 만들기</div>
	                    <div class="desc">사진으로 방의 구조를 분석합니다.</div>
	                </div>
	            </div>
	        </div>
	
	        <div id="step-list" class="modal-body" style="display: none;">
	            <button onclick="backToStep1()" style="margin-bottom:10px; cursor:pointer;">⬅ 뒤로가기</button>
	            <div id="fp-list-container" class="list-grid">
	                </div>
	        </div>
	    </div>
	</div>
	
	<style>
	    .modal-overlay {
	        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
	        background: rgba(0,0,0,0.5); z-index: 1000;
	        display: flex; justify-content: center; align-items: center;
	    }
	    .modal-content {
	        background: white; width: 800px; max-width: 90%; 
	        border-radius: 12px; box-shadow: 0 5px 20px rgba(0,0,0,0.2);
	        overflow: hidden; animation: slideDown 0.3s ease;
	    }
	    .modal-header {
	        padding: 15px 20px; border-bottom: 1px solid #eee;
	        display: flex; justify-content: space-between; align-items: center;
	    }
	    .close-btn { font-size: 24px; cursor: pointer; color: #666; }
	    
	    .modal-body { padding: 30px; }
	    
	    .option-grid {
	        display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px;
	    }
	    .option-card {
	        border: 1px solid #ddd; border-radius: 8px; padding: 20px;
	        cursor: pointer; transition: all 0.2s; text-align: center;
	    }
	    .option-card:hover {
	        border-color: #2196F3; background: #f0f9ff; transform: translateY(-3px);
	    }
	    .option-card .icon { font-size: 40px; margin-bottom: 10px; }
	    .option-card .title { font-weight: bold; font-size: 18px; margin-bottom: 5px; }
	    .option-card .desc { font-size: 13px; color: #888; }
	
	    /* 리스트 스타일 */
	    .list-grid {
	        display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;
	        max-height: 400px; overflow-y: auto;
	    }
	    .fp-item {
	        border: 1px solid #eee; border-radius: 6px; overflow: hidden; cursor: pointer;
	    }
	    .fp-item img { width: 100%; height: 150px; object-fit: cover; }
	    .fp-item p { padding: 10px; margin: 0; font-size: 14px; text-align: center; }
	    .fp-item:hover { border-color: #2196F3; }
	
	    @keyframes slideDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
	</style>
	
	<script>
	    // 1. 모달 열기/닫기
	    function openNewModal() {
	        document.getElementById('newProjectModal').style.display = 'flex';
	        backToStep1(); // 항상 첫 화면부터
	    }
	    function closeModal() {
	        document.getElementById('newProjectModal').style.display = 'none';
	    }
	
	    // 2. 빈 도면으로 이동
	    function goToEmptyDraw() {
	        location.href = '/user/interior/draw';
	    }
	
	    // 3. UI 전환 (선택화면 <-> 목록화면)
	    function backToStep1() {
	        document.getElementById('step-select').style.display = 'block';
	        document.getElementById('step-list').style.display = 'none';
	    }
	
	    // 4. 평면도 목록 불러오기 (AJAX)
	    function loadFloorplanList(type) {
	        const container = document.getElementById('fp-list-container');
	        container.innerHTML = '<p style="grid-column:1/-1; text-align:center;">로딩 중...</p>';
	        
	        document.getElementById('step-select').style.display = 'none';
	        document.getElementById('step-list').style.display = 'block';
	
	        // type: 'my' (내꺼), 'template' (관리자꺼)
	        fetch('/user/floorplan/list?type=' + type)
	            .then(res => res.json())
	            .then(data => {
	                container.innerHTML = '';
	                if (data.length === 0) {
	                    container.innerHTML = '<p style="grid-column:1/-1; text-align:center;">저장된 평면도가 없습니다.</p>';
	                    return;
	                }
	                
	                data.forEach(fp => {
	                    const div = document.createElement('div');
	                    div.className = 'fp-item';
	                    div.onclick = () => {
	                        // [핵심] f_code를 가지고 에디터로 이동!
	                        location.href = '/user/interior/draw?f_code=' + fp.f_code;
	                    };
	                    div.innerHTML = `
	                        <img src="${fp.f_img}" onerror="this.src='/img/no-img.png'">
	                        <p>${fp.fTemplate}</p>
	                    `;
	                    container.appendChild(div);
	                });
	            })
	            .catch(err => {
	                console.error(err);
	                container.innerHTML = '<p>목록을 불러오지 못했습니다.</p>';
	            });
	    }
	</script>
</body>
</html>