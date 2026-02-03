package com.drawing.springboot.dto;

import lombok.Data;

@Data
public class SubcategoryDTO {
	private Long subcategoryId;
    private Long categoryId;
    private String name;
    private String url;
    private String image;
}
