package com.drawing.springboot.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.drawing.springboot.dto.ProductsDTO;

@Mapper
public interface IFavoritesDAO {
	List<ProductsDTO> favoritesByMCode(String m_code);
	void addFavorite(Map<String, Object> params);   // 찜 추가
    void removeFavorite(Map<String, Object> params); // 찜 삭제
    List<ProductsDTO> getFavoritesByMember(String m_code); // 찜 목록 조회
    List<ProductsDTO> getFavoritesByCategory(Map<String, Object> params);
    void addFavorite(@Param("m_code") String m_code, @Param("p_code") int p_code);
    void removeFavorite(@Param("m_code") String m_code, @Param("p_code") int p_code);
}
