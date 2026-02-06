package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.drawing.springboot.dto.SubcategoryDTO;

@Mapper
public interface ISubcategoryDAO {
	List<SubcategoryDTO> getSubcategoriesByCategoryId(int categoryId); // 특정 카테고리의 하위 목록
	SubcategoryDTO getSubcategoryById(int subcategoryId);
	// ✅ 전체 서브카테고리 조회
    List<SubcategoryDTO> getAllSubcategories();

}
