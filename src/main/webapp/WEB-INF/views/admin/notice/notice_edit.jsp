<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 - 공지사항 수정</title>
    <style>
        /* write.jsp와 동일한 스타일 사용 */
        .write-wrap { max-width: 800px; margin: 50px auto; font-family: sans-serif; }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: bold; margin-bottom: 8px; }
        input[type="text"], textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; box-sizing: border-box; }
        .btn-area { display: flex; gap: 10px; justify-content: flex-end; }
        .btn { padding: 10px 25px; border-radius: 8px; cursor: pointer; border: none; font-weight: bold; }
        .btn-update { background: #2a9d8f; color: white; }
        .btn-delete { background: #e76f51; color: white; text-decoration: none; font-size: 13px; line-height: 20px; }
    </style>
</head>
<body>
    <div class="write-wrap">
        <h2>✏️ 공지사항 수정</h2>
        <hr>
        <form action="/admin/notice_update" method="post">
            <input type="hidden" name="n_code" value="${dto.n_code}">
            
            <div class="form-group">
                <label>공지 제목</label>
                <input type="text" name="n_title" value="${dto.n_title}" required>
            </div>
            
            <div class="form-group">
                <label>공지 내용</label>
                <textarea name="n_content" rows="15" required>${dto.n_content}</textarea>
            </div>

            <div class="btn-area">
                <a href="javascript:void(0);" onclick="confirmDelete()" class="btn btn-delete">삭제</a>
                <button type="submit" class="btn btn-update">수정 완료</button>
            </div>
        </form>
    </div>

    <script>
        function confirmDelete() {
            if(confirm("정말로 이 공지사항을 삭제하시겠습니까?")) {
                location.href = "/admin/notice_delete?n_code=${dto.n_code}";
            }
        }
    </script>
</body>
</html>