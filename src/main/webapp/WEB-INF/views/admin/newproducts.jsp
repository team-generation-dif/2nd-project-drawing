<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 등록</title>
    <style>
        body {
            font-family: '맑은 고딕', sans-serif;
            background-color: #f9f9f9;
        }
        .form-container {
            width: 500px;
            margin: 50px auto;
            padding: 30px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        .form-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-container input {
            width: 100%;
            padding: 8px;
            margin-bottom: 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .form-container button {
            width: 100%;
            padding: 10px;
            background-color: #0078d7;
            color: white;
            border: none;
            border-radius: 4px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>상품 등록</h2>
        <form action="${pageContext.request.contextPath}/products/admin/new" method="post">
            <input type="text" name="p_code" placeholder="상품 코드" required />
            <input type="text" name="p_name" placeholder="상품명" required />
            <input type="text" name="p_color" placeholder="색상" />
            <input type="number" name="p_width" placeholder="형태" /> 
            <input type="text" name="p_price" placeholder="가격" required />
            <input type="text" name="p_image" placeholder="이미지 URL" required />           
            <input type="number" step="0.1" name="p_rating" placeholder="평점" />
            <input type="number" name="subcategoryId" placeholder="서브카테고리 ID" required />
            <button type="submit">등록</button>
        </form>
    </div>
</body>
</html>
