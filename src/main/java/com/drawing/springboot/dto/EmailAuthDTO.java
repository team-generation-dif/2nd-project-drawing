package com.drawing.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class EmailAuthDTO {
    private String e_code;      // 인증 기록 번호
    private String m_email;     // 인증 요청 메일
    private String auth_num;    // 6자리 인증번호
    private java.util.Date expire_date; // 만료 시간
    private String e_verified;  // 인증 성공 여부
    private Date e_date; 		// 인증시간
}
