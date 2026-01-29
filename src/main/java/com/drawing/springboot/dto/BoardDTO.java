package com.drawing.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class BoardDTO {
    private String b_code;      // 게시글 번호 (PK) 
    private String m_code;      // 회원 번호 (FK) 
    private String i_code;      // 인테리어 번호 (FK) 
    private String b_title;     // 제목 
    private String b_content;   // 내용 
    private String b_image;     // 이미지 
    private String b_interior;  // 인테리어 경로 
    private Date b_date;        // 작성일 
    private String m_id; 
    private String m_nick; // 추가
    // ★ 추가: Getter / Setter
    public String getM_id() { return m_id; }
    public void setM_id(String m_id) { this.m_id = m_id; }
}
