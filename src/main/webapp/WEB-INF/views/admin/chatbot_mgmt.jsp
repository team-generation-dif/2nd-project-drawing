<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>그리다 아뜰리에 - 관리자 챗봇</title>
    <style>
        .admin-wrap { max-width: 1200px; margin: 50px auto; padding: 0 20px; }
        .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        
        /* 탭 디자인 */
        .tab-nav { display: flex; gap: 10px; margin-bottom: 20px; border-bottom: 2px solid #eee1d5; }
        .tab-link { padding: 12px 25px; cursor: pointer; border: none; background: none; font-weight: 600; color: #8b7e74; }
        .tab-link.active { color: #e76f51; border-bottom: 3px solid #e76f51; }

        /* 테이블 디자인 */
        .mgmt-card { background: white; border-radius: 25px; padding: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th { padding: 15px; text-align: left; border-bottom: 2px solid #f7ede2; color: #8b7e74; }
        .admin-table td { padding: 15px; border-bottom: 1px solid #f7ede2; color: #5d5a58; }

        .badge-keyword { background: #f7ede2; color: #e76f51; padding: 5px 12px; border-radius: 15px; font-size: 13px; font-weight: bold; }
        .btn-add { background: #e76f51; color: white; border: none; padding: 12px 25px; border-radius: 15px; cursor: pointer; font-weight: bold; }
        .btn-del { color: #e76f51; background: none; border: 1px solid #e76f51; padding: 5px 10px; border-radius: 8px; cursor: pointer; }
    </style>
</head>
<body>
    <jsp:include page="../common/Header.jsp" />

    <div class="admin-wrap">
        <div class="admin-header">
            <h2 style="font-family: 'Nanum Myeongjo';">🤖 챗봇 시스템 관리</h2>
            <button class="btn-add" onclick="location.href='/admin/chatbot/write'">+ 새 시나리오 등록</button>
        </div>

        <div class="tab-nav">
            <button class="tab-link active" onclick="openTab('quest')">응답 시나리오</button>
            <button class="tab-link" onclick="openTab('log')">대화 로그 분석</button>
        </div>

        <div id="quest" class="tab-content mgmt-card">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>코드</th>
                        <th>매칭 키워드</th>
                        <th>자동 응답 메시지</th>
                        <th>사용 횟수</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="q" items="${questList}">
                        <tr>
                            <td>${q.q_code}</td>
                            <td><span class="badge-keyword">${q.keyword}</span></td>
                            <td>${q.response_msg}</td>
                            <td>${q.hit_count}회</td>
                            <td><button class="btn-del" onclick="deleteQuest('${q.q_code}')">삭제</button></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div id="log" class="tab-content mgmt-card" style="display:none;">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>대화일시</th>
                        <th>회원코드</th>
                        <th>질문 내용</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="log" items="${logList}">
                        <tr>
                            <td>${log.chat_date}</td>
                            <td>${log.m_code}</td>
                            <td>${log.chat_message}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function openTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(t => t.style.display = 'none');
            document.querySelectorAll('.tab-link').forEach(l => l.classList.remove('active'));
            document.getElementById(tabId).style.display = 'block';
            event.currentTarget.classList.add('active');
        }

        function deleteQuest(code) {
            if(confirm('이 시나리오를 삭제할까요?')) {
                location.href = '/admin/chatbot/delete?q_code=' + code;
            }
        }
    </script>
</body>
</html>