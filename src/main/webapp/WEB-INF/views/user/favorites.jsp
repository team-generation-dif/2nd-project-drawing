<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .favorites-container {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        justify-content: center;
        padding: 30px;
    }
    .product-card {
        width: 250px;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 15px;
        text-align: center;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    .product-card img {
        width: 100%;
        height: auto;
        border-radius: 4px;
    }
    .product-card h4 {
        margin: 10px 0 5px;
        font-size: 18px;
    }
    .product-card p {
        margin: 5px 0;
        font-size: 14px;
        color: #555;
    }
    .wishlist-btn {
        margin-top: 10px;
        background-color: #ff6666;
        color: white;
        border: none;
        padding: 8px 12px;
        border-radius: 4px;
        cursor: pointer;
    }
    .wishlist-btn:hover {
        background-color: #ff4d4d;
    }
</style>

<h2 style="text-align:center;">내 찜 목록*</h2>
<div class="favorites-container">
    <c:forEach var="product" items="${favorites}">
        <div class="product-card">
            <img src="${product.p_image}" alt="${product.p_name}" />
            <h4>${product.p_name}</h4>
            <p><strong>${product.p_price}</strong> 원</p>
            <p>⭐ ${product.p_rating}</p>
            <form action="/products/favorites/remove" method="post">
                <input type="hidden" name="p_code" value="${product.p_code}" />
                <button type="submit" class="wishlist-btn">♥ 찜 해제</button>
            </form>
        </div>
    </c:forEach>
</div>
