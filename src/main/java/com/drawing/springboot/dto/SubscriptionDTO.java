package com.drawing.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class SubscriptionDTO {
    private String s_code;  	 // 구독 번호 (PK) 
    private String m_code;    	 // 회원 번호 (FK) 
    private String s_plan;    	 // 구독 플랜 
    private String s_status; 	 // 상태 
    private Date s_start; 		 // 시작일 
    private Date s_end;   		 // 종료일 
}
