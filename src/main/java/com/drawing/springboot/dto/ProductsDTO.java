package com.drawing.springboot.dto;

import lombok.Data;

@Data
public class ProductsDTO {
    private String p_code;      // 상품고유 번호
    private String p_name;      // 상품명 
    private String p_color;     // 색상 
    private double p_width;     // 가로
    private double p_depth;     // 세로
    private double p_height;    // 높이
    private String p_price;     // 가격 
    private String p_image;     // 이미지 
    private double p_rating;    // 평점 
    private String p_category;  // 카테고리
}