package com.drawing.springboot.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.drawing.springboot.dao.IFavoritesDAO;
import com.drawing.springboot.dto.ProductsDTO;

@Service
public class FavoritesService {

    @Autowired
    private IFavoritesDAO favoritesDAO;

    public List<ProductsDTO> getFavoritesByMember(String m_code) {
        return favoritesDAO.getFavoritesByMember(m_code);
    }

    public List<ProductsDTO> getFavoritesByCategory(String m_code, int subcategoryId) {
        Map<String, Object> params = new HashMap<>();
        params.put("m_code", m_code);
        params.put("subcategoryId", subcategoryId);
        return favoritesDAO.getFavoritesByCategory(params);
    }

    public void addFavorite(String m_code, int p_code) {
        Map<String, Object> params = new HashMap<>();
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

}
