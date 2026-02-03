package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.drawing.springboot.dto.BoardDTO;
import com.drawing.springboot.dto.BoardTagDTO;

@Mapper
public interface IBoardDAO {
    List<BoardDTO> getBoardList();
    BoardDTO getDetail(String b_code);
    List<BoardTagDTO> getTagsByBoard(String b_code);
    void insertBoard(BoardDTO board);
    void insertTag(BoardTagDTO tag);
    void updateBoard(BoardDTO board);
    int getTodayWorkCount();
    // @Param을 붙여서 XML의 #{b_code}와 명확하게 연결합니다.
    void deleteBoard(@Param("b_code") String b_code);
    void deleteTagsByBoard(@Param("b_code") String b_code);
 // 특정 태그 1개만 삭제
    void deleteTagByTcode(String t_code);

    // 특정 태그의 정보(이름, URL 등)만 수정
    void updateTag(BoardTagDTO tag);
    
}