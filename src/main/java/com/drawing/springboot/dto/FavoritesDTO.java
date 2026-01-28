package com.drawing.springboot.dto;

import lombok.Data;
@Data
public class FavoritesDTO {
    private String a_code; // 찜 고유 번호 
    private String m_code; // 회원 번호
    private String p_code; // 상품 번호
}
