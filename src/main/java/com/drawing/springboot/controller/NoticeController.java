package com.drawing.springboot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.drawing.springboot.dao.INoticeDAO;
import com.drawing.springboot.dto.NoticeDTO;

@Controller
public class NoticeController {

    @Autowired
    private INoticeDAO noticeDAO;

    // 1. 사용자/관리자 공통 목록 (경로 수정됨)
    @GetMapping("/notice/list")
    public String noticeList(Model model) {
        model.addAttribute("list", noticeDAO.selectAll());
        return "guest/notice/notice_list";
    }

    @GetMapping("/notice/detail")
    public String noticeDetail(@RequestParam("n_code") String n_code, Model model) {
        model.addAttribute("notice", noticeDAO.selectOne(n_code));
        return "guest/notice/notice_detail";
    }


    // 3. 관리자 등록 폼 (경로 수정됨)
    @GetMapping("/admin/notice_write")
    public String noticeWriteForm() {
        return "admin/notice/notice_write"; // 이미지의 admin/notice 폴더 경로
    }

    // 4. 관리자 등록 처리
    @PostMapping("/admin/notice_insert")
    public String noticeInsert(@RequestParam("n_title") String n_title, 
                               @RequestParam("n_content") String n_content) {
        
        NoticeDTO dto = new NoticeDTO();
        dto.setN_title(n_title);
        dto.setN_content(n_content);
        
        noticeDAO.insert(dto);
        return "redirect:/notice/list";
    }

    // 5. 관리자 수정 폼 (경로 수정됨)
    @GetMapping("/admin/notice_edit")
    public String noticeEditForm(@RequestParam("n_code") String n_code, Model model) {
        model.addAttribute("dto", noticeDAO.selectOne(n_code));
        return "admin/notice/notice_edit"; // 이미지의 admin/notice 폴더 경로
    }

    // 6. 관리자 수정 처리
    @PostMapping("/admin/notice_update")
    public String noticeUpdate(NoticeDTO dto) {
        noticeDAO.update(dto);
        // 수정한 글의 상세페이지로 이동
        return "redirect:/notice/detail?n_code=" + dto.getN_code();
    }

    // 7. 관리자 삭제 처리
    @GetMapping("/admin/notice_delete")
    public String noticeDelete(@RequestParam("n_code") String n_code) {
        noticeDAO.delete(n_code);
        return "redirect:/notice/list";
    }
}