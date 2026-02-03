package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.drawing.springboot.dto.ProductsDTO;

@Mapper
public interface IFavoritesDAO {
	List<ProductsDTO> favoritesByMCode(String m_code);
}
