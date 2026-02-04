package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

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
}
