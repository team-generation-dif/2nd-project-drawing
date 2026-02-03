package com.drawing.springboot.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.drawing.springboot.dto.ChatbotDTO;
import com.drawing.springboot.dto.ChatbotQuestDTO;

@Mapper
public interface IChatbotDAO {

    // 유저 대화 저장
    void insertChat(ChatbotDTO dto);

    // 키워드로 답변 조회
    ChatbotQuestDTO selectAnswer(@Param("message") String message);

    // 답변 횟수 증가
    void updateHitCount(@Param("q_code") String q_code);
    int getTodayChatCount();
}
