package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.drawing.springboot.dto.CategoryDTO;

@Mapper
public interface ICategoryDAO {
	List<CategoryDTO> getAllCategories(); // 전체 카테고리 목록
    CategoryDTO getCategoryById(Long categoryId); // ID로 카테고리 조회
}
