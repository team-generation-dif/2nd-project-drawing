<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 관리자 | 챗봇 지식 등록</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 전체 배경 및 초기화 (디자인 시스템 통일) */
        body {
            background-color: #fffaf5; /* 아이보리 톤 */
            font-family: 'Pretendard', -apple-system, sans-serif;
            color: #4a3f35;
            margin: 0;
            padding: 0;
        }

        /* 2. 메인 컨테이너 (1100px 너비 유지) */
        .admin-write-wrap {
            background: #ffffff;
            width: 90%;
            max-width: 1200px;
            margin: 60px auto 120px;
            padding: 80px 60px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(139, 126, 116, 0.05);
            border: 1px solid #f7ede2;
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
            height: 2px;
            background: #fcf6f0;
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
            min-height: 200px;
            line-height: 1.6;
            resize: vertical;
        }

        /* 4. 이미지 미리보기 박스 (점선 포인트) */
        .preview-box {
            margin-top: 15px;
            padding: 30px;
            background-color: #faf9f8;
            border: 2px dashed #e7e2df;
            border-radius: 15px;
            text-align: center;
            min-height: 100px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .preview-img {
            max-width: 100%;
            max-height: 350px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            display: none; /* 파일 선택 전까지 숨김 */
        }

        .placeholder-text {
            color: #bcaaa4;
            font-size: 0.9rem;
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
            padding: 18px;
            border-radius: 25px; /* 알약 모양 버튼 */
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

        /* 등록하기 버튼 */
        .btn-save {
            background-color: #8b7e74;
            color: white;
        }
        .btn-save:hover {
            background-color: #4a3f35;
            transform: translateY(-2px);
        }

        /* 취소 버튼 */
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
        <h2>🤖 챗봇 답변 신규 등록</h2>


        <form action="/admin/chatbot_insert" method="post" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-group">
                <label>질문 키워드</label>
                <input type="text" name="keyword" placeholder="예: 배송 문의, 교환 방법 등" required>
            </div>
            
            <div class="form-group">
                <label>자동 응답 메시지</label>
                <textarea name="response_msg" required placeholder="챗봇이 대답할 내용을 상세히 입력해주세요."></textarea>
            </div>

            <div class="form-group">
                <label>이미지 첨부 (선택)</label>
                <input type="file" name="file" accept="image/*" onchange="previewImage(this)">
                
                <div class="preview-box" id="drop-zone">
                    <img id="imagePreview" src="" class="preview-img">
                    <div id="placeholder-text" class="placeholder-text">
                        선택된 이미지가 없습니다.<br>이미지를 업로드하면 미리보기가 표시됩니다.
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>이동 링크 URL (선택)</label>
                <input type="text" name="link_url" placeholder="https://... 관련 상품 또는 공지사항 링크">
            </div>

            <div class="btn-area">
                <button type="button" onclick="history.back();" class="btn btn-cancel">취소하기</button>
                <button type="submit" class="btn btn-save">등록 완료</button>
            </div>
        </form>
    </div>

    <script>
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            const placeholder = document.getElementById('placeholder-text');
            
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    placeholder.style.display = 'none';
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = 'none';
                placeholder.style.display = 'block';
            }
        }
    </script>
</body>
</html>