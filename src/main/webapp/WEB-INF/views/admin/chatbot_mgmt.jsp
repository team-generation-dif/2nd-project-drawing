<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그리다 어드민 | 챗봇 관리</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Pretendard:wght@400;600;700&display=swap');

        body {
            background-color: #fffaf5; /* 회원 관리와 동일한 아이보리 톤 */
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
        }

        /* 상단 헤더 섹션 */
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

        /* 새 시나리오 등록 버튼 (회원관리 btn-user-page 스타일 계승) */
        .btn-add {
            text-decoration: none;
            background-color: #8b7e74;
            color: white;
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-add:hover {
            background-color: #4a3f35;
            transform: translateY(-2px);
        }

        /* 테이블 스타일 통일 */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 10px;
        }

        th {
            background-color: #fcf6f0;
            color: #8b7e74;
            font-weight: 600;
            padding: 18px 15px;
            border-bottom: 2px solid #f7ede2;
            font-size: 0.95rem;
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

        /* 이미지 썸네일 */
        .img-thumb {
            width: 55px;
            height: 55px;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid #f7ede2;
            cursor: pointer;
            transition: 0.2s;
        }
        .img-thumb:hover { transform: scale(1.05); }

        /* 키워드 배지 (회원관리 배지 스타일 계승) */
        .badge-keyword {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
            background: #fdf6f2; 
            color: #e76f51;
            border: 1px solid #f9e8de;
        }

        /* 링크 스타일 */
        .link-verify {
            color: #8b7e74;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.85rem;
            border-bottom: 1px solid transparent;
        }
        .link-verify:hover { border-bottom: 1px solid #8b7e74; }

        /* 수정/삭제 버튼 */
        .btn-action {
            padding: 6px 14px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            border: 1px solid transparent;
        }

        .btn-edit {
            background-color: #f0f4f3;
            color: #2a9d8f;
        }
        .btn-edit:hover { background-color: #2a9d8f; color: white; }

        .btn-del {
            background-color: #fff0f0;
            color: #ff4d4f;
            border: 1px solid #ffccc7;
        }
        .btn-del:hover { background-color: #ff4d4f; color: white; }

        .no-data { color: #ccc; font-style: italic; font-size: 0.8rem; }
    </style>
</head>
<body>
    <jsp:include page="../guest/Header.jsp" />

    <div class="admin-container">
        <div class="header-flex">
            <h2>🤖 챗봇 시스템 관리</h2>
            <button class="btn-add" onclick="location.href='/admin/chatbot_write'">+ 새 시나리오 등록</button>
        </div>

        <table>
            <thead>
                <tr>
                    <th>코드</th>
                    <th>이미지</th>
                    <th>매칭 키워드</th>
                    <th>자동 응답 메시지</th>
                    <th>연결 링크</th>
                    <th>사용 횟수</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${list}">
                    <tr>
                        <td style="color: #a39485;">${item.q_code}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.img_url}">
                                    <img src="/upload/${item.img_url}" class="img-thumb" 
                                         onclick="window.open(this.src)" title="클릭하여 크게 보기">
                                </c:when>
                                <c:otherwise>
                                    <span class="no-data">없음</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><span class="badge-keyword">${item.keyword}</span></td>
                        <td style="text-align: left; max-width: 300px; line-height: 1.4;">${item.response_msg}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.link_url}">
                                    <a href="${item.link_url}" target="_blank" class="link-verify">🔗 연결 확인</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="no-data">-</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="font-weight: 600;">${item.hit_count}</td>
                        <td>
                            <div style="display: flex; gap: 5px; justify-content: center;">
                                <button class="btn-action btn-edit" 
                                        onclick="location.href='/admin/chatbot_edit?q_code=${item.q_code}'">수정</button>
                                <button class="btn-action btn-del" 
                                        onclick="deleteQuest('${item.q_code}')">삭제</button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script>
        function deleteQuest(code) {
            if(confirm('이 시나리오를 삭제하시겠습니까?')) {
                location.href = '/admin/chatbot_delete?q_code=' + code;
            }
        }
    </script>
</body>
</html>