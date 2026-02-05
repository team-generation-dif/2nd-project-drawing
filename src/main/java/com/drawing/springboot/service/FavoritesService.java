package com.drawing.springboot.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.drawing.springboot.dao.IFavoritesDAO;
import com.drawing.springboot.dto.ProductsDTO;

@Service
public class FavoritesService {

    @Autowired
    private IFavoritesDAO favoritesDAO;

    public void addFavorite(String m_code, int p_code) {
        Map<String, Object> params = new HashMap<>();
        params.put("a_code", UUID.randomUUID().toString().substring(0,7)); // 간단히 랜덤 코드 생성
        params.put("m_code", m_code);
        params.put("p_code", p_code);
        favoritesDAO.addFavorite(params);
    }

    public void removeFavorite(String m_code, int p_code) {
        Map<String, Object> params = new HashMap<>();
        params.put("m_code", m_code);
        params.put("p_code", p_code);
        favoritesDAO.removeFavorite(params);
    }

    public List<ProductsDTO> getFavoritesByMember(String m_code) {
    	 List<ProductsDTO> list = favoritesDAO.getFavoritesByMember(m_code);
    	    System.out.println("DAO 결과 = " + list); // ✅ DB에서 가져온 값 확인
    	    return list;

    }
}
