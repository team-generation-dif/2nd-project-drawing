package com.drawing.springboot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.drawing.springboot.dao.IChatbotAdminDAO;
import com.drawing.springboot.dto.ChatbotQuestDTO;

@RestController
@RequestMapping("/admin/chatbot_mamt")
public class ChatbotAdminController {

    @Autowired
    private IChatbotAdminDAO dao;

    // 전체 챗봇 Q&A 목록
    @GetMapping("/list")
    public List<ChatbotQuestDTO> list() {
        return dao.selectAll();
    }

    // Q&A 등록
    @PostMapping("/insert")
    public void insert(@RequestBody ChatbotQuestDTO dto) {
        dao.insert(dto);
    }

    // Q&A 수정
    @PutMapping("/update")
    public void update(@RequestBody ChatbotQuestDTO dto) {
        dao.update(dto);
    }

    // Q&A 삭제
    @DeleteMapping("/delete/{q_code}")
    public void delete(@PathVariable String q_code) {
        dao.delete(q_code);
    }
}
