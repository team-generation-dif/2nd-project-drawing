package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.drawing.springboot.dto.ChatbotQuestDTO;

@Mapper
public interface IChatbotAdminDAO {

    List<ChatbotQuestDTO> selectAll();

    void insert(ChatbotQuestDTO dto);

    void update(ChatbotQuestDTO dto);

    void delete(@Param("q_code") String q_code);
}
