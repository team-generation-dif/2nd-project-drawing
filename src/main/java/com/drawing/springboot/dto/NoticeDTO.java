package com.drawing.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class NoticeDTO {
    private String n_code;      // 공지 번호 (PK) 
    private String n_title;     // 제목 
    private String n_content;   // 내용 
    private Date n_date; 		// 작성일 
 // NoticeDTO.java에 꼭 추가하세요! (Lombok만으로는 부족할 때가 있습니다)
    public String getN_code() { return n_code; }
    public java.util.Date getN_date() { return n_date; }
}