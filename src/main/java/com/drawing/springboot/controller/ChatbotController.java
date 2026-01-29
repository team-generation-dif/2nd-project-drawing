package com.drawing.springboot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.drawing.springboot.dao.IChatbotDAO;
import com.drawing.springboot.dto.ChatbotDTO;
import com.drawing.springboot.dto.ChatbotQuestDTO;

@RestController
@RequestMapping("/chatbot")
public class ChatbotController {

    @Autowired
    private IChatbotDAO chatbotDAO;

    // 유저 메시지 저장
    @PostMapping("/send")
    public ChatbotQuestDTO sendMessage(@RequestBody ChatbotDTO dto) {

        // 1. 유저 메시지 저장
        chatbotDAO.insertChat(dto);

        // 2. 키워드 기반 답변 조회
        ChatbotQuestDTO answer =
                chatbotDAO.selectAnswer(dto.getChat_message());

        // 3. 답변 횟수 증가
        if (answer != null) {
            chatbotDAO.updateHitCount(answer.getQ_code());
        }

        return answer;
    }
}
