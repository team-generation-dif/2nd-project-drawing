package com.drawing.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class MemberDTO {
    private String m_code;     // 회원 번호
    private String m_id;       // 회원 ID
    private String m_passwd;   // 비밀번호 
    private String k_id;       // 카카오 ID 
    private String m_name;     // 이름
    private String m_nick;     // 닉네임 
    private String m_email;    // 이메일
    private String m_tel;      // 전화번호 
    private String m_role;     // 권한
    private String sub_yn;     // 구독여부 
    private String login_type; // 가입유형 
    private Date m_date; 	   // 가입일 
}
