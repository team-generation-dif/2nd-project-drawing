package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.drawing.springboot.dto.ProductsDTO;

@Mapper
public interface IProductsDAO {
	List<ProductsDTO> getAllProducts();
    ProductsDTO getProductById(Long p_code);
    List<ProductsDTO> getProductsByCategoryId(Long categoryId);
    List<ProductsDTO> getProductsBySubcategoryId(Long subcategoryId);
    void insertProduct(ProductsDTO product);
    void updateProduct(ProductsDTO product);
    void deleteProduct(int p_code);
    void bulkInsertProducts(List<ProductsDTO> products);
    int countByName(String p_name);  
    // 페이징된 상품 목록 조회
    List<ProductsDTO> getProductsPaged(@Param("size") int size, @Param("offset") int offset);
    // 전체 상품 개수
    int countProducts();

}
