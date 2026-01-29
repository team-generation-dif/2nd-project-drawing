package com.drawing.springboot.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller; // 변경
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.drawing.springboot.dao.IChatbotAdminDAO;
import com.drawing.springboot.dto.ChatbotQuestDTO;

@Controller // JSP를 보여주기 위해 @Controller 사용
public class ChatbotAdminController {

    @Autowired
    private IChatbotAdminDAO chatbotAdminDAO;

    // 1. 챗봇 관리 메인 목록
    @GetMapping("/admin/chatbot_mgmt")
    public String chatbotMgmt(Model model) {
        List<ChatbotQuestDTO> list = chatbotAdminDAO.selectAll();
        model.addAttribute("list", list); 
        return "admin/chatbot_mgmt"; 
    }

    // 2. 등록 폼 이동
    @GetMapping("/admin/chatbot_write")
    public String chatbotWriteForm() {
        return "admin/chatbot_write";
    }

    // 3. 등록 처리
    @PostMapping("/admin/chatbot_insert")
    public String chatbotInsert(
        @RequestParam(name = "keyword") String keyword, // name 수정
        @RequestParam(name = "response_msg") String response_msg, // name 수정
        @RequestParam(name = "link_url", required = false) String link_url, // 추가
        @RequestParam(name = "file") MultipartFile file
    ) {
        ChatbotQuestDTO dto = new ChatbotQuestDTO();
        dto.setKeyword(keyword);
        dto.setResponse_msg(response_msg);
        dto.setLink_url(link_url); // 반드시 세팅!
        
        // 파일 업로드 로직
        if (file != null && !file.isEmpty()) {
            try {
                // 1. 파일이 저장될 경로 설정 (static/upload 폴더 추천)
                String savePath = "C:/upload/";
                File folder = new File(savePath);
                if (!folder.exists()) folder.mkdirs(); // 폴더 없으면 생성

                // 2. 파일 이름 중복 방지를 위한 랜덤 이름 생성
                String originalName = file.getOriginalFilename();
                String ext = originalName.substring(originalName.lastIndexOf("."));
                String fileName = UUID.randomUUID().toString() + ext;

                // 3. 파일 물리 저장
                file.transferTo(new File(savePath + fileName));

                // 4. DB에 저장할 파일명 세팅 (DTO에 image_file 필드와 setter가 있어야 함)
                dto.setImg_url(fileName); 
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        try {
            chatbotAdminDAO.insert(dto);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/admin/chatbot_mgmt";
    }

    // 4. 수정 폼 이동 (기존 데이터 조회 로직 추가)
    @GetMapping("/admin/chatbot_edit")
    public String chatbotEditForm(@RequestParam(name = "q_code") String q_code, Model model) {
        // 모든 목록 중 해당 코드와 일치하는 데이터 찾기
        List<ChatbotQuestDTO> list = chatbotAdminDAO.selectAll();
        ChatbotQuestDTO target = list.stream()
                                     .filter(d -> d.getQ_code().equals(q_code))
                                     .findFirst()
                                     .orElse(null);
        
        model.addAttribute("dto", target); 
        return "admin/chatbot_edit"; 
    }

    // 5. 수정 처리
 // ChatbotAdminController 내 수정 처리 부분
    @PostMapping("/admin/chatbot_update")
    public String chatbotUpdate(
        @RequestParam(name = "q_code") String q_code,
        @RequestParam(name = "keyword") String keyword,
        @RequestParam(name = "response_msg") String response_msg,
        @RequestParam(name = "link_url", required = false) String link_url, // 추가
        @RequestParam(name = "file", required = false) MultipartFile file
    ) {
        ChatbotQuestDTO dto = new ChatbotQuestDTO();
        dto.setQ_code(q_code);
        dto.setKeyword(keyword);
        dto.setResponse_msg(response_msg);
        dto.setLink_url(link_url); // 반드시 세팅!

        if (file != null && !file.isEmpty()) {
            try {
                String savePath = "C:/upload/";

                String originalName = file.getOriginalFilename();
                String ext = originalName.substring(originalName.lastIndexOf("."));
                String fileName = UUID.randomUUID().toString() + ext;

                file.transferTo(new File(savePath + fileName));
                dto.setImg_url(fileName);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        chatbotAdminDAO.update(dto); // DAO의 update문도 img_url을 수정하도록 쿼리 수정 필요
        return "redirect:/admin/chatbot_mgmt";
    }

    // 6. 삭제 처리
    @GetMapping("/admin/chatbot_delete")
    public String chatbotDelete(@RequestParam(name = "q_code") String q_code) {
        chatbotAdminDAO.delete(q_code);
        return "redirect:/admin/chatbot_mgmt";
    }
}