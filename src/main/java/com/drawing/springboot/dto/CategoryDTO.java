package com.drawing.springboot.dto;

import lombok.Data;

@Data
public class CategoryDTO {
	private int categoryId;  // CATEGORY_ID
    private String name;      // NAME
    private String url;       // URL
    private String image; 	  // 이미지 url

}
