package com.drawing.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ChatbotDTO {
    private String chat_code;   // 챗봇 번호 (PK) 
    private String m_code;      // 회원 번호 (FK) 
    private String chat_message;// 대화 내용 
    private Date chat_date; 	// 대화시간 
}