package com.drawing.springboot.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.drawing.springboot.dto.ProductsDTO;

@Mapper
public interface IFavoritesDAO {
	List<ProductsDTO> favoritesByMCode(String m_code);
	void addFavorite(Map<String, Object> params);   // 찜 추가
    void removeFavorite(Map<String, Object> params); // 찜 삭제
    List<ProductsDTO> getFavoritesByMember(String m_code); // 찜 목록 조회

}
