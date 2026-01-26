package com.drawing.springboot.dto;


import java.util.Date;

import lombok.Data;

@Data
public class CommentsDTO {
    private String c_code;      // 댓글 번호 (PK) 
    private String b_code;      // 게시글 번호 (FK) 
    private String m_code;      // 회원 번호 (FK) 
    private String c_content;   // 내용 
    private Date c_date; // 작성일 
}
