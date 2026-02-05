package com.drawing.springboot.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;
@Data
public class ProductsDTO {
    private int p_code;      // 상품고유 번호
    @NotBlank(message = "상품명은 필수 입력입니다.")
    private String p_name;      // 상품명 
    private String p_color;     // 색상 
    private String p_size;      // 규격 
    @Positive(message = "가격은 0보다 커야 합니다.")
    private String p_price;     // 가격 
    private String p_image;     // 이미지 
    @NotNull(message = "평점은 필수 입력입니다.")
    private Double p_rating;    // 평점    
    private String p_url;
    @NotNull(message = "서브카테고리는 필수 선택입니다.")
    private int subcategoryId;
    private int categoryId;
    private double p_width;
    private double p_depth;
    private double p_height;
    
    private String categoryName;    // ✅ 상위 카테고리명
    private String subcategoryName; 
//→ 이 값은 SUBCATEGORY 테이블과 JOIN해서 가져오거나, products 테이블에 이미 있다면 그대로 매핑합니다.
}