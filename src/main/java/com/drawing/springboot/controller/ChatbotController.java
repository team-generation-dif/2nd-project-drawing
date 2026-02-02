package com.drawing.springboot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.drawing.springboot.dao.IChatbotDAO;
import com.drawing.springboot.dto.ChatbotDTO;
import com.drawing.springboot.dto.ChatbotQuestDTO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/chatbot")
public class ChatbotController {

    @Autowired
    private IChatbotDAO chatbotDAO;

    @PostMapping(value="/send", produces = "application/json")
    @ResponseBody
    public ChatbotQuestDTO sendMessage(@RequestBody ChatbotDTO dto, HttpSession session) {
        // 1. 모든 질문은 일단 로그로 저장 (나중에 관리자가 답변하기 위함)
        try {
            chatbotDAO.insertChat(dto); 
        } catch (Exception e) { e.printStackTrace(); }

        ChatbotQuestDTO answer = chatbotDAO.selectAnswer(dto.getChat_message());

        if (answer != null) {
            chatbotDAO.updateHitCount(answer.getQ_code());
        } else {
            answer = new ChatbotQuestDTO();
            // 관리자가 확인할 수 있도록 안내 메시지 변경
            answer.setResponse_msg("아직 그 질문에 대한 답변을 배우지 못 했어요. 따로 답변이 필요하시다면 고객센터 이메일(drawing@gmail.com)으로 답변 남겨주세요.🎨");
        }
        return answer;
    }

}
