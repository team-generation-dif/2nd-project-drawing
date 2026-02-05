<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 관리자 | 시나리오 수정</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 전체 배경 및 초기화 */
        body {
            background-color: #fdfbf9;
            font-family: 'Pretendard', -apple-system, sans-serif;
            color: #4a3f35;
            margin: 0;
            padding: 0;
        }

        /* 2. 메인 컨테이너 (기타 페이지와 너비 1100px로 통일) */
        .admin-write-wrap {
            background: #ffffff;
            width: 90%;
            max-width: 1200px;
            margin: 60px auto 120px;
            padding: 80px 60px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(139, 126, 116, 0.05);
            border: 1px solid rgba(231, 224, 217, 0.5);
            box-sizing: border-box;
        }

        h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-weight: 700;
            color: #3d342c;
            text-align: center;
            margin-bottom: 60px;
            font-size: 2.2rem;
            letter-spacing: -0.02em;
        }

        hr {
            border: 0;
            height: 1px;
            background: #f0eeec;
            margin: -20px 0 50px;
        }

        /* 3. 입력 폼 스타일 */
        .form-group {
            margin-bottom: 35px;
            max-width: 900px;
            margin-left: auto;
            margin-right: auto;
        }

        label {
            display: block;
            font-weight: 600;
            font-size: 0.95rem;
            color: #8b7e74;
            margin-bottom: 12px;
            padding-left: 5px;
        }
        
        input[type="text"], textarea, input[type="file"] {
            width: 100%;
            padding: 18px 25px;
            border: 1px solid #f0eeec;
            border-radius: 12px;
            background-color: #fff;
            font-size: 1rem;
            box-sizing: border-box;
            transition: all 0.3s;
            color: #4a3f35;
            font-family: inherit;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #8b7e74;
            box-shadow: 0 0 0 4px rgba(139, 126, 116, 0.05);
            background-color: #fffdfb;
        }

        textarea {
            min-height: 150px;
            line-height: 1.6;
            resize: vertical;
        }

        /* 4. 이미지 미리보기 박스 (세련되게 변경) */
        .preview-box {
            margin-top: 15px;
            padding: 20px;
            background-color: #faf9f8;
            border: 1px dashed #e7e2df;
            border-radius: 15px;
            text-align: center;
        }

        .preview-img {
            max-width: 100%;
            max-height: 300px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-top: 10px;
        }

        .current-info {
            font-size: 0.85rem;
            color: #a39485;
            margin-bottom: 8px;
        }

        /* 5. 버튼 영역 */
        .btn-area {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 60px;
        }

        .btn {
            width: 200px;
            padding: 20px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-align: center;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-update {
            background-color: #8b7e74;
            color: white;
        }
        .btn-update:hover {
            background-color: #4a3f35;
            transform: translateY(-2px);
        }

        .btn-cancel {
            background-color: #fff;
            color: #8b7e74;
            border: 1px solid #8b7e74;
        }
        .btn-cancel:hover {
            background-color: #fdfbf9;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <jsp:include page="../guest/Header.jsp" />

    <div class="admin-write-wrap">
        <h2>✏️ 시나리오 수정</h2>
 

        <form action="/admin/chatbot_update" method="post" enctype="multipart/form-data">
            <input type="hidden" name="q_code" value="${dto.q_code}">
            
            <div class="form-group">
                <label>매칭 키워드</label>
                <input type="text" name="keyword" value="${dto.keyword}" required placeholder="예: 배송, 취소, 교환">
            </div>
            
            <div class="form-group">
                <label>자동 응답 메시지</label>
                <textarea name="response_msg" required placeholder="챗봇이 응답할 문구를 입력하세요">${dto.response_msg}</textarea>
            </div>

            <div class="form-group">
                <label>이미지 수정</label>
                <input type="file" name="file" accept="image/*" onchange="previewImage(this)">
                
                <div class="preview-box">
                    <c:choose>
                        <c:when test="${not empty dto.img_url}">
                            <div class="current-info">✦ 현재 등록된 이미지: ${dto.img_url}</div>
                            <img id="imagePreview" src="/upload/${dto.img_url}" class="preview-img">
                        </c:when>
                        <c:otherwise>
                            <div class="current-info">등록된 이미지가 없습니다.</div>
                            <img id="imagePreview" src="" class="preview-img" style="display:none;">
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="form-group">
                <label>이동 링크 URL (선택)</label>
                <input type="text" name="link_url" value="${dto.link_url}" placeholder="https://... 관련 상품 또는 공지사항 링크">
            </div>
            
            <div class="btn-area">
                <button type="button" onclick="history.back()" class="btn btn-cancel">취소</button>
                <button type="submit" class="btn btn-update">수정 완료</button>
            </div>
        </form>
    </div>

    <script>
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            const info = document.querySelector('.current-info');
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'inline-block';
                    if(info) info.innerText = "✦ 변경될 이미지 미리보기";
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>