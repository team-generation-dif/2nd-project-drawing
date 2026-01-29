package com.drawing.springboot.dto;

import lombok.Data;

@Data
public class ChatbotQuestDTO {
    private String q_code;       // 챗봇 응답 코드 (PK)
    private String keyword;      // 유저 입력 키워드
    private String response_msg; // 챗봇의 답변 (Oracle의 VARCHAR2(4000) 대응)
    private int hit_count;       // 누적 답변 횟수
}