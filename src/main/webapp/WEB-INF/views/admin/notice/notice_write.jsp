<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 - 공지사항 작성</title>
    <style>
        .write-wrap { max-width: 800px; margin: 50px auto; font-family: sans-serif; }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: bold; margin-bottom: 8px; color: #4a3f35; }
        input[type="text"], textarea { 
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; 
        }
        .btn-area { display: flex; gap: 10px; justify-content: flex-end; }
        .btn { padding: 10px 25px; border-radius: 8px; cursor: pointer; border: none; font-weight: bold; }
        .btn-save { background: #e76f51; color: white; }
        .btn-cancel { background: #8b7e74; color: white; text-decoration: none; font-size: 13px; line-height: 20px; }
    </style>
</head>
<body>
    <div class="write-wrap">
        <h2>📢 새 공지사항 작성</h2>
        <hr>
        <form action="/admin/notice_insert" method="post">
            <div class="form-group">
                <label>공지 제목</label>
                <input type="text" name="n_title" placeholder="제목을 입력하세요" required>
            </div>
            
            <div class="form-group">
                <label>공지 내용</label>
                <textarea name="n_content" rows="15" placeholder="내용을 입력하세요" required></textarea>
            </div>

            <div class="btn-area">
                <a href="/notice/list" class="btn btn-cancel">취소</a>
                <button type="submit" class="btn btn-save">등록하기</button>
            </div>
        </form>
    </div>
</body>
</html>