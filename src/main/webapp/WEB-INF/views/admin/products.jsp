<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 어드민 | 상품 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        /* 1. 디자인 시스템 통일 */
        body {
            background-color: #fffaf5;
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            color: #4a3f35;
        }

        .admin-container {
            max-width: 1280px;
            margin: 40px auto;
            padding: 40px;
            background: #ffffff;
            border-radius: 35px;
            border: 1px solid #f7ede2;
            box-shadow: 0 10px 30px rgba(139, 126, 116, 0.05);
            box-sizing: border-box;
        }

        /* 2. 헤더 섹션 */
        .header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #fcf6f0;
        }

        .header-flex h2 {
            font-family: 'Nanum Myeongjo', serif;
            font-size: 1.8rem;
            margin: 0;
            color: #4a3f35;
        }

        /* 3. CSV 업로드 카드 (상단에 배치하여 편의성 제공) */
        .upload-card {
            background-color: #faf9f8;
            border: 1px dashed #e7e2df;
            border-radius: 20px;
            padding: 25px 40px;
            margin-bottom: 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .upload-info h3 {
            margin: 0 0 5px 0;
            font-size: 1.1rem;
            color: #8b7e74;
        }

        .upload-info p {
            margin: 0;
            font-size: 0.85rem;
            color: #a39485;
        }

        .upload-form {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        /* 4. 테이블 스타일 (회원 관리와 동일) */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        th {
            background-color: #fcf6f0;
            color: #8b7e74;
            font-weight: 600;
            padding: 18px 15px;
            border-bottom: 2px solid #f7ede2;
            font-size: 0.95rem;
            text-align: center;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #fcf6f0;
            text-align: center;
            font-size: 0.9rem;
            vertical-align: middle;
        }

        tr:hover td {
            background-color: #fffdfb;
        }

        /* 5. 상품 이미지 썸네일 */
        .prod-thumb {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 10px;
            border: 1px solid #f0eeec;
        }

        /* 6. 버튼 스타일 */
        .btn {
            padding: 10px 20px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: 0.3s;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-main { background-color: #8b7e74; color: white; }
        .btn-main:hover { background-color: #4a3f35; transform: translateY(-2px); }

        .btn-outline { background-color: #fff; color: #8b7e74; border: 1px solid #8b7e74; }
        .btn-outline:hover { background-color: #fdfbf9; }

        .btn-detail { color: #e76f51; font-weight: 700; text-decoration: none; }
        .btn-detail:hover { text-decoration: underline; }

        /* 파일 선택 커스텀 스타일 */
        input[type="file"] {
            font-size: 0.85rem;
            color: #8b7e74;
        }

        /* 메시지 알림 */
        .alert-msg {
            background-color: #f0f4f3;
            color: #2a9d8f;
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            text-align: center;
        }
    </style>
</head>
<body>
    <jsp:include page="../guest/Header.jsp" />

    <div class="admin-container">
        <c:if test="${not empty message}">
            <div class="alert-msg">✨ ${message}</div>
        </c:if>

        <div class="header-flex">
            <h2>📦 상품 목록 관리</h2>
            <a href="${pageContext.request.contextPath}/products/admin/new" class="btn btn-main">+ 개별 상품 등록</a>
        </div>

        <div class="upload-card">
            <div class="upload-info">
                <h3>대량 상품 등록</h3>
                <p>CSV 파일을 업로드하여 여러 상품을 한 번에 등록하세요.</p>
            </div>
            <form action="${pageContext.request.contextPath}/products/admin/upload" method="post" enctype="multipart/form-data" class="upload-form">
                <input type="file" name="file" accept=".csv" required />
                <button type="submit" class="btn btn-outline">업로드 실행</button>
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th>이미지</th>
                    <th>상품 코드</th>
                    <th>상품명</th>
                    <th>가격</th>
                    <th>상세</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td>
                            <img src="${product.p_image}" alt="${product.p_name}" class="prod-thumb" onerror="this.src='https://placehold.co/60x60?text=No+Image'">
                        </td>
                        <td style="color: #a39485;">${product.p_code}</td>
                        <td style="font-weight: 600;">${product.p_name}</td>
                        <td style="color: #4a3f35;">${product.p_price}원</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/products/${product.p_code}" class="btn-detail">조회</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>"file" accept=".csv" required />
    <button type="submit">업로드</button>
</form>

<!-- 업로드 결과 메시지 -->
<c:if test="${not empty message}">
    <p style="color:green;">${message}</p>
</c:if>

<!-- 개별 등록 버튼 -->
<a href="${pageContext.request.contextPath}/products/admin/new">
    <button>개별 상품 등록</button>
</a>
</body>
</html>
