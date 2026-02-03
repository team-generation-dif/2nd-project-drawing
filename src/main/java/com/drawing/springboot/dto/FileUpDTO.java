package com.drawing.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class FileUpDTO {
    private String up_code;     // 파일 번호 (PK) 
    private String m_code;      // 회원 번호 (FK) 
    private String up_name;     // 파일명 
    private String up_path;     // 저장경로 
    private String up_type;     // 파일타입 
    private Date up_date; 		// 업로드일 
}
