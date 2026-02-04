package com.drawing.springboot.dto;

import lombok.Data;
@Data
public class ProductsDTO {
    private int p_code;      // 상품고유 번호
    private String p_name;      // 상품명 
    private String p_color;     // 색상 
    private String p_size;      // 규격  
    private String p_price;     // 가격 
    private String p_image;     // 이미지 
    private double p_rating;    // 평점    
    private String p_url;
    private int subcategoryId;
    private int categoryId;
    private double p_width;
    private double p_depth;
    private double p_height;
}