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
        Object loginUser = session.getAttribute("user"); 

        if (loginUser != null) {
            try {
                chatbotDAO.insertChat(dto);
            } catch (Exception e) {
                System.err.println("로그 저장 실패 (무시): " + e.getMessage());
            }
        }

        ChatbotQuestDTO answer = chatbotDAO.selectAnswer(dto.getChat_message());

        if (answer != null) {
            chatbotDAO.updateHitCount(answer.getQ_code());
        } else {
            answer = new ChatbotQuestDTO();
            answer.setResponse_msg("그 단어는 아직 공부 중이에요. '거실'이나 '침실'처럼 입력해보세요! 🎨");
        }

        return answer;
    }

}
