package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.drawing.springboot.dto.ProductsDTO;

@Mapper
public interface IProductsDAO {
    List<ProductsDTO> getProductsBySubcategoryId(Long subcategoryId); // 특정 서브카테고리 상품
    List<ProductsDTO> getProductsByCategoryId(Long categoryId);       // 카테고리 기준 상품
    ProductsDTO getProductById(Long productId);                       // 특정 상품 조회
    void insertProduct(ProductsDTO product);                          // 관리자 상품 등록

    // 🔴 추가: 전체 상품 조회 (관리자 페이지에서 CSV 업로드 후 목록 갱신용)
    List<ProductsDTO> getAllProducts();
}

