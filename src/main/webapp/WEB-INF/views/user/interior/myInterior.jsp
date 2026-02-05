<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그리다 | 나의 3D작품</title>
</head>
<body>
    <%@ include file="../../guest/Header.jsp" %>
    
<div class="container">
    <div class="title-area">
        <div class="title-group">
            <h2>내 아뜰리에</h2> 
            <p>나의 소중한 공간을 3D로 꾸며보세요</p>    
        </div>

        <div class="action-bar">
            <button class="btn-new" onclick="openNewModal()">+ 새 인테리어 기록하기</button>
        </div>
    </div>
        <div class="library-grid">
            <c:forEach var="list" items="${dto}">
                <div class="card">
                    <button class="btn-delete-card" onclick="location.href='/user/interior/delete?i_code=${list.i_code}'" title="삭제">×</button>
                    <a href="/user/interior/draw?i_code=${list.i_code}">
                        <div class="thumb-img">
                            <img src="${list.i_image}" onerror="this.src='https://placehold.co/400x300/fdfbf9/8b7e74?text=Interior'">
                        </div>
                        <div class="card-info">
                            <span class="title">${list.i_title}</span>
                            <span class="date">${list.i_date}</span>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

    <div id="newProjectModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <div style="display:flex; justify-content: space-between; align-items: center;">
                    <h3>새로운 공간 기록</h3>
                    <span class="close-btn" style="cursor:pointer; font-size: 30px; color:#b7ada6;" onclick="closeModal()">×</span>
                </div>
            </div>
            
            <div id="step-select" class="modal-body">
                <div class="option-grid">
                    <div class="option-card" onclick="goToEmptyDraw()">
                        <div class="icon">✨</div>
                        <div class="title">빈 캔버스로 시작</div>
                        <div class="desc">아무것도 없는 빈 공간에서<br>자유롭게 설계를 시작합니다.</div>
                    </div>
                    
                    <div class="option-card" onclick="loadFloorplanList('my')">
                        <div class="icon">📁</div>
                        <div class="title">나의 도면 라이브러리</div>
                        <div class="desc">이전에 저장해둔 나만의<br>평면도 템플릿을 불러옵니다.</div>
                    </div>
                    
                    <div class="option-card" onclick="loadFloorplanList('template')">
                        <div class="icon">🏛️</div>
                        <div class="title">전문가 템플릿</div>
                        <div class="desc">그리다가 제공하는 표준형<br>공간 구조로 빠르게 시작합니다.</div>
                    </div>
                    
                    <div class="option-card" onclick="triggerImageUpload()">
                        <div class="icon">🖼️</div>
                        <div class="title">사진으로 자동 생성</div>
                        <div class="desc">종이 도면이나 평면도 사진을 분석하여<br>3D 벽면을 자동으로 세워드립니다.</div>
                    </div>
                </div>
                <input type="file" id="fp-image-upload" accept="images/*" style="display:none;" onchange="uploadAndAnalyze(this)">
            </div>

            <div id="step-list" class="modal-body" style="display: none;">
                <button class="btn-back" onclick="backToStep1()">← 이전으로</button>
                <div id="fp-list-container" class="list-grid">
                    </div>
            </div>
        </div>
    </div>
	
	<style>
    /* 1. 전체 배경 및 초기화 */
    body {
        background-color: #fffaf5;
        font-family: 'Pretendard', -apple-system, sans-serif;
        color: #4a3f35;
        margin: 0; padding: 0;
    }

    /* 1. 컨테이너 및 제목 영역 정돈 */
.container {
    max-width: 1200px; /* 매거진 비율을 위해 살짝 조정 */
    margin: 0 auto; 
    padding: 100px 20px; 
}

.title-area {
    display: flex;
    justify-content: space-between; /* 제목그룹은 왼쪽, 버튼은 오른쪽 */
    align-items: flex-end; 
    margin-bottom: 50px;
    border-bottom: 2px solid #f7ede2;
    padding-bottom: 25px;
}

/* 제목과 p글자를 세로로 나열 */
.title-group {
    display: flex;
    flex-direction: column;
    gap: 10px; /* 제목과 설명글 사이 간격 */
}

.title-group h2 {
        font-family: 'Nanum Myeongjo', serif; 
        font-size: 2.2rem; /* 관리자 페이지와 통일감을 위해 살짝 조절 */
        color: #3d342c; 
        margin: 0;
        letter-spacing: -0.03em;
}

.title-group p {
    margin: 0; /* 기본 여백 제거 */
    color: #8b7e74;
    font-size: 1.05rem;
    font-weight: 500;
}

.action-bar {
    margin-bottom: 0 !important; /* 기존 아래 여백 제거 */
}


.btn-new {
    background-color: #8b7e74;
    color: white;
    padding: 14px 28px;
    border-radius: 15px;
    border: none;
    font-weight: 700;
    font-size: 1rem;
    cursor: pointer;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    box-shadow: 0 8px 20px rgba(139, 126, 116, 0.15);
}
.btn-new:hover {
    background-color: #4a3f35;
    transform: translateY(-4px) scale(1.02);
    box-shadow: 0 12px 25px rgba(139, 126, 116, 0.25);
}
.library-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 40px;
}

.card {
    background: #fff;
    border-radius: 30px;
    overflow: hidden;
    border: 1px solid #f7ede2;
    transition: all 0.4s ease;
}

.card:hover {
    transform: translateY(-12px);
    box-shadow: 0 20px 40px rgba(139, 126, 116, 0.12);
}

    .thumb-img {
        width: 100%;
        height: 180px;
        background-color: #f5f5f5;
        overflow: hidden;
    }
    .thumb-img img {
        width: 100%; height: 100%; object-fit: cover;
        transition: transform 0.5s;
    }
    .card:hover .thumb-img img { transform: scale(1.05); }

    .card-info { padding: 20px; }
    .card-info a { text-decoration: none; color: inherit; }
    .card-info .title {
        font-family: 'Nanum Myeongjo', serif;
        font-weight: 700; font-size: 1.15rem;
        margin-bottom: 8px; color: #3d342c;
        display: block;
    }
    .card-info .date { font-size: 0.85rem; color: #b7ada6; }

 /* 4. 삭제 버튼 (세련된 코랄 레드) */
.btn-delete-card {
    position: absolute; top: 20px; right: 20px;
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(5px);
    color: #e76f51; /* 포인트 컬러 통일 */
    border: 1px solid #ffccbb;
    width: 36px; height: 36px;
    border-radius: 50%; 
    font-size: 20px;
    font-weight: bold;
    cursor: pointer;
    z-index: 10;
    opacity: 0; 
    transition: all 0.3s ease;
}
.card:hover .btn-delete-card { opacity: 1; }
.btn-delete-card:hover { background: #e76f51; color: white; transform: rotate(90deg); }

    /* 4. 모달 스타일 정제 */
    .modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(61, 52, 44, 0.6); z-index: 1000;
        backdrop-filter: blur(5px);
        display: none; justify-content: center; align-items: center;
    }
    .modal-content {
        background: #fff; width: 850px; max-width: 90%; 
        border-radius: 25px; padding: 40px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.15);
    }
    .modal-header h3 {
        font-family: 'Nanum Myeongjo', serif;
        font-size: 1.6rem; color: #3d342c; margin-top: 0;
    }
    
/* 5. 모달 옵션 카드 (핵심 UI) */
.option-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 24px;
    margin-top: 30px;
}

.option-card {
    background: #ffffff;
    border: 1.5px solid #f7ede2;
    border-radius: 25px;
    padding: 40px 30px;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    position: relative;
    overflow: hidden;
}

.option-card:hover {
    border-color: #8b7e74;
    background: #fff;
    transform: translateY(-8px);
    box-shadow: 0 15px 30px rgba(139, 126, 116, 0.1);
}
.option-card .icon {
    font-size: 40px;
    margin-bottom: 20px;
    display: block;
}

.option-card .title {
    font-family: 'Nanum Myeongjo', serif;
    font-size: 1.25rem;
    font-weight: 800;
    color: #3d342c;
    margin-bottom: 12px;
}

.option-card .desc {
    font-size: 0.9rem;
    color: #a39485;
    line-height: 1.6;
}

    /* 5. 평면도 리스트 모달 내 그리드 */
    .list-grid {
        display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;
        max-height: 450px; overflow-y: auto; padding: 10px;
    }
    .fp-item {
        background: #fff; border: 1px solid #f0eeec; border-radius: 12px;
        overflow: hidden; cursor: pointer; transition: 0.3s;
    }
    .fp-item:hover { border-color: #8b7e74; }
    .fp-item img { width: 100%; height: 120px; object-fit: cover; }
    .fp-item p { padding: 12px; margin: 0; font-size: 0.9rem; text-align: center; }

    .btn-back {
        background: none; border: 1px solid #f0eeec; color: #8b7e74;
        padding: 8px 16px; border-radius: 8px; cursor: pointer; margin-bottom: 20px;
    }
    /* 6. 평면도 아이템 내 삭제 버튼 */
.btn-delete-fp {
    background: #fff;
    color: #e76f51;
    border: 1px solid #ffccbb;
    padding: 5px 12px;
    border-radius: 10px;
    font-size: 0.75rem;
    margin: 0 0 10px 10px;
    cursor: pointer;
}

.btn-delete-fp:hover {
    background: #e76f51;
    color: #fff;
}
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
	                    if (type == 'my') {
		                    div.innerHTML = `
		                        <img src="\${fp.f_img}" onerror="this.src='/images/no-img.png'">
		                        <p>\${fp.f_template}</p>
		                        <button class="btn-delete-fp" onclick="deleteFloorplan(event, '\${fp.f_code}')">삭제</button>
		                    `;
	                    } else {
	                    	div.innerHTML = `
		                        <img src="\${fp.f_img}" onerror="this.src='/images/no-img.png'">
		                        <p>\${fp.f_template}</p>
		                    `;
	                    }
	                    container.appendChild(div);
	                });
	            })
	            .catch(err => {
	                console.error(err);
	                container.innerHTML = '<p>목록을 불러오지 못했습니다.</p>';
	            });
	    }
		// 평면도 삭제 함수
	    function deleteFloorplan(event, f_code) {
	        // 1. 클릭 이벤트가 부모(div.fp-item)로 전파되는 것을 방지.
	        event.stopPropagation(); 

	        if (!confirm("정말 이 평면도 템플릿을 삭제하시겠습니까?")) return;

	        // 2. 삭제 요청 (Controller에 해당 엔드포인트 필요)
	        fetch('/user/floorplan/delete?f_code=' + f_code) // 혹은 GET
	            .then(res => res.text())
	            .then(result => {
	                if (result.trim() === "ok") {
	                    alert("삭제되었습니다.");
	                    // 3. 목록 새로고침 (현재 보고 있는 my 타입으로 다시 로드)
	                    loadFloorplanList('my');
	                } else {
	                    alert("삭제 실패");
	                }
	            })
	            .catch(err => {
	                console.error(err);
	                alert("서버 통신 오류");
	            });
	    }
		// 파일 선택창 열기
	    function triggerImageUpload() {
	        document.getElementById('fp-image-upload').click();
	    }

	    // 파일 선택 시 자동 업로드 & 분석 요청
	    function uploadAndAnalyze(input) {
	        if (!input.files || input.files.length === 0) return;
	        let realWidth = prompt("도면 이미지의 실제 가로 길이(mm)를 입력해주세요.", "15000");
	        if (!realWidth) return;
	        
	        const file = input.files[0];
	        const formData = new FormData();
	        formData.append("file", file);
	        formData.append("realWidth", realWidth);

	        fetch('/user/floorplan/analyze', {
	            method: 'POST',
	            body: formData
	        })
	        .then(res => res.json())
	        .then(data => {
	        	// 파이썬에서 에러 메시지가 왔는지 확인
	            if (data.length === 1 && data[0].error) {
	                alert("파이썬 오류 발생:\n" + data[0].error);
	                console.error(data[0].trace); // 콘솔에 상세 내용 출력
	                return;
	            }
	        	
	            if (data && data.length > 0) {
	                // 분석된 벽 데이터를 sessionStorage에 저장
	                sessionStorage.setItem("importedWalls", JSON.stringify(data));
	                location.href = '/user/interior/draw?mode=import';
	            } else {
	                alert("벽을 찾을 수 없습니다. 이미지가 너무 복잡하거나 흐릿합니다.");
	            }
	        })
	        .catch(err => {
	            console.error(err);
	            alert("분석 실패");
	        });
	    	// input 초기화 (같은 파일 다시 선택 가능하게)
	        input.value = '';
	    }
	</script>
</body>
</html>