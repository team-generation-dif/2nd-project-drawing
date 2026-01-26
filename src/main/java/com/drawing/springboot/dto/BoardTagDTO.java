package com.drawing.springboot.dto;

import lombok.Data;

@Data
public class BoardTagDTO {
    private String t_code;      // 태그 번호 (PK) 
    private String b_code;      // 게시글 번호 (FK) 
    private double x_coord;     // X 좌표 
    private double y_coord;     // Y 좌표 
    private String t_url;       // 외부사이트 URL 
    private String t_name;      // 태그 이름 
    private String t_price;     // 태그 가격 
}