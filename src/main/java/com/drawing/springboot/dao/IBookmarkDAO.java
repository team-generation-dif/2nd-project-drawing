package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.drawing.springboot.dto.BoardDTO; // BoardDTO 임포트 필요

@Mapper
public interface IBookmarkDAO {
    int checkBookmark(@Param("m_code") String m_id, @Param("b_code") String b_code);
    void insertBookmark(@Param("m_code") String m_id, @Param("b_code") String b_code);
    void deleteBookmark(@Param("m_code") String m_id, @Param("b_code") String b_code);

    // ✅ 이 줄을 추가하세요! (Controller의 에러 해결용)
    List<BoardDTO> getFavoriteList(
            @Param("m_code") String m_code, 
            @Param("offset") int offset, 
            @Param("amount") int amount
        );

        // 내 북마크 전체 개수를 가져오는 메서드 추가
        int getTotalBookmarkCount(@Param("m_code") String m_id);
}