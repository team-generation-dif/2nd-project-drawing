package com.drawing.springboot.dto;

import lombok.Data;

@Data
public class SubcategoryDTO {
	private int subcategoryId;
    private int categoryId;
    private String name;
    private String url;
    private String image;
}
