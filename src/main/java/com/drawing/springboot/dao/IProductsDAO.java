package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.drawing.springboot.dto.ProductsDTO;

@Mapper
public interface IProductsDAO {
	List<ProductsDTO> getProductsBySubcategoryId(Long subcategoryId); // 특정 서브카테고리의 상품
    List<ProductsDTO> getProductsByCategoryId(Long categoryId); // 카테고리 기준 상품 (JOIN)
    ProductsDTO getProductById(Long productId);
    // 관리자용 상품 등록
    void insertProduct(ProductsDTO product);
}
