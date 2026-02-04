package com.drawing.springboot.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.drawing.springboot.dao.IBookmarkDAO;
import com.drawing.springboot.dto.BoardDTO;

import jakarta.servlet.http.HttpSession;

@Controller
public class BookmarkController {
    
    @Autowired
    private IBookmarkDAO bookmarkDAO;

    // 1. 북마크 토글 (m_code 기준)
    @PostMapping("/user/toggleBookmark")
    @ResponseBody 
    public int toggleBookmark(@RequestParam("b_code") String b_code, HttpSession session) {
        // 세션에서 로그인 시 저장한 m_code를 가져옵니다.
        String m_code = (String) session.getAttribute("m_code");
        
        if (m_code == null) return -1; // 로그인 안 됨

        try {
            // DAO의 파라미터를 m_id에서 m_code로 모두 교체
            int count = bookmarkDAO.checkBookmark(m_code, b_code);
            if (count > 0) {
                bookmarkDAO.deleteBookmark(m_code, b_code);
                return 0; // 삭제 성공
            } else {
                bookmarkDAO.insertBookmark(m_code, b_code);
                return 1; // 추가 성공
            }
        } catch (Exception e) {
            e.printStackTrace();
            return -2;
        }
    }

    // 2. 내 북마크 목록 보기 (m_code 기준)
    @GetMapping("/user/myBookmarks")
    public String getMyBookmarks(@RequestParam(value="page", defaultValue="1") int page, 
                                 HttpSession session, Model model) {
        String m_code = (String) session.getAttribute("m_code");
        if (m_code == null) return "redirect:/guest/loginForm";

        // 페이징 설정
        int amount = 9; // 한 페이지에 보여줄 개수
        int offset = (page - 1) * amount;
        
        // 닉네임(m_nick)과 제목(b_title)이 포함된 리스트를 가져옴
        List<BoardDTO> bookmarkList = bookmarkDAO.getFavoriteList(m_code, offset, amount);
        model.addAttribute("bookmarkList", bookmarkList);

        // 페이징 정보 계산
        BoardDTO paging = new BoardDTO(); 
        // [수정] m_id가 아니라 세션에서 받은 m_code를 사용해야 합니다.
        int total = bookmarkDAO.getTotalBookmarkCount(m_code); 
        
        paging.setPage(page); 
        paging.setPaging(page, amount, total);
        
        model.addAttribute("paging", paging); 

        return "user/myBookmarks"; 
    }
}