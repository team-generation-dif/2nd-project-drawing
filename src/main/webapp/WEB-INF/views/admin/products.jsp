<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 등록</title>
</head>
<body>
    <h2>상품 등록</h2>
    <form action="${pageContext.request.contextPath}/products/admin/new" method="post">
        <input type="text" name="p_code" placeholder="상품 코드" required /><br/>
        <input type="text" name="p_name" placeholder="상품명" required /><br/>
        <input type="text" name="p_price" placeholder="가격" required /><br/>
        <input type="text" name="p_image" placeholder="이미지 URL" required /><br/>
        <input type="text" name="p_color" placeholder="색상" /><br/>
        <input type="number" name="p_width" placeholder="가로" /><br/>
        <input type="number" name="p_depth" placeholder="세로" /><br/>
        <input type="number" name="p_height" placeholder="높이" /><br/>
        <input type="number" step="0.1" name="p_rating" placeholder="평점" /><br/>
        <input type="number" name="subcategoryId" placeholder="서브카테고리 ID" required /><br/>
        <button type="submit">등록</button>
    </form>
</body>
</html>
