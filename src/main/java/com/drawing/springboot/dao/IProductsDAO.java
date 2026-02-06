package com.drawing.springboot.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.drawing.springboot.dto.ProductsDTO;

@Mapper
public interface IProductsDAO {
    // 1. 기본 조회
    List<ProductsDTO> getAllProducts();
    ProductsDTO getProductById(Long p_code);
    List<ProductsDTO> getProductsByCategoryId(Long categoryId);
    List<ProductsDTO> getProductsBySubcategoryId(Long subcategoryId);
    
    // 2. 관리자용 CRUD
    void insertProduct(ProductsDTO product);
    void updateProduct(ProductsDTO product);
    void deleteProduct(int p_code);
    void bulkInsertProducts(List<ProductsDTO> products); // 서비스에서 사용 중인 경우 유지
    int countByName(String p_name);  

    // 3. [관리자용] 전체 상품 목록 페이징
    List<ProductsDTO> getProductsPaged(@Param("size") int size, @Param("offset") int offset);
    int countProducts();

    // 4. [유저용] 특정 카테고리 내 상품 페이징 (새로 추가한 부분)
    List<ProductsDTO> getProductsByCategoryIdPaged(
        @Param("categoryId") Long categoryId, 
        @Param("size") int size, 
        @Param("offset") int offset
    );
    List<ProductsDTO> getProductsBySubcategoryIdPaged(
    	    @Param("subcategoryId") Long subcategoryId, 
    	    @Param("size") int size, 
    	    @Param("offset") int offset
    	);

    	int countProductsBySubcategoryId(@Param("subcategoryId") Long subcategoryId);
    // 5. [유저용] 특정 카테고리 전체 개수
    int countProductsByCategoryId(@Param("categoryId") Long categoryId);
}