package com.drawing.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class NoticeDTO {
    private String n_code;      // 공지 번호 (PK) 
    private String n_title;     // 제목 
    private String n_content;   // 내용 
    private Date n_date; // 작성일 
}