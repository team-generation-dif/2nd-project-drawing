package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.drawing.springboot.dto.NoticeDTO;

@Mapper
public interface INoticeDAO {
    public List<NoticeDTO> selectAll();         // 목록 보기
    public NoticeDTO selectOne(String n_code);   // 상세 보기
    public int insert(NoticeDTO dto);           // 등록
    public int update(NoticeDTO dto);           // 수정
    public int delete(String n_code);           // 삭제
}