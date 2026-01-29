package com.drawing.springboot.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.drawing.springboot.dto.BoardDTO;
import com.drawing.springboot.dto.BoardTagDTO;
import com.drawing.springboot.service.BoardService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/user")
@RequiredArgsConstructor // 생성자 주입 (final 필드 자동 주입)
public class BoardController {

    private final BoardService boardService;

    /** 1. 게시글 리스트 (404 방지를 위해 반드시 필요) **/
    @GetMapping("/list")
    public String list(Model model) {
        log.info("리스트 페이지 호출");
        model.addAttribute("list", boardService.getBoardList());
        return "user/list"; // /WEB-INF/views/user/list.jsp
    }

    /** 2. 게시글 작성 폼 **/
    @GetMapping("/write")
    public String writeForm() {
        return "user/write";
    }

    /** 3. 게시글 저장 (등록) **/
    @PostMapping("/insert")
    public String insert(BoardDTO board, 
                         @RequestParam(value="file", required=false) MultipartFile file, 
                         @RequestParam(value="tagData", required=false, defaultValue="[]") String tagData, 
                         HttpSession session) {
        try {
            Object mCodeObj = session.getAttribute("m_code");
            if (mCodeObj == null) return "redirect:/guest/loginForm";
            
            board.setM_code(mCodeObj.toString());

            // 파일 업로드
            if (file != null && !file.isEmpty()) {
                File saveDir = new File("C:/upload/");
                if (!saveDir.exists()) saveDir.mkdirs();
                String saveName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
                file.transferTo(new File(saveDir, saveName));
                board.setB_image(saveName);
            }

            List<BoardTagDTO> tagList = parseTagData(tagData);
            boardService.registerBoard(board, tagList);
            return "redirect:/user/list";

        } catch (Exception e) {
            log.error("등록 실패: ", e);
            return "redirect:/user/write?error";
        }
    }

    /** 4. 상세 보기 **/
    @GetMapping("/detail")
    public String detail(@RequestParam("b_code") String b_code, Model model, HttpSession session) {
        String m_id = (String) session.getAttribute("m_id");
        model.addAttribute("loginId", m_id); 

        BoardDTO board = boardService.getDetail(b_code);
        List<BoardTagDTO> tags = boardService.getTagsByBoard(b_code);
        
        model.addAttribute("board", board);
        model.addAttribute("tags", tags);
        return "user/detail";
    }

    /** 5. 수정 페이지 이동 **/
    @GetMapping("/edit")
    public String editForm(@RequestParam("b_code") String b_code, HttpSession session, Model model) {
        String m_id = (String) session.getAttribute("m_id");
        BoardDTO board = boardService.getDetail(b_code);
        
        if (board != null && m_id != null && m_id.equals(board.getM_id())) {
            List<BoardTagDTO> tags = boardService.getTagsByBoard(b_code);
            model.addAttribute("board", board);
            model.addAttribute("tags", tags);
            return "user/edit";
        }
        return "redirect:/user/list";
    }

    /** 6. 게시글 수정 실행 **/
    @PostMapping("/boardUpdate")
    public String boardUpdate(BoardDTO board, 
                              @RequestParam(value = "file", required = false) MultipartFile file,
                              @RequestParam(value = "tagData", required = false, defaultValue = "[]") String tagData, 
                              HttpSession session) {
        try {
            // 이미지 처리
            if (file != null && !file.isEmpty()) {
                File saveDir = new File("C:/upload/");
                if (!saveDir.exists()) saveDir.mkdirs();
                String saveName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
                file.transferTo(new File(saveDir, saveName));
                board.setB_image(saveName);
            } else {
                BoardDTO oldBoard = boardService.getDetail(board.getB_code());
                board.setB_image(oldBoard.getB_image());
            }

            List<BoardTagDTO> tagList = parseTagData(tagData); 
            boardService.updateBoard(board, tagList);
            return "redirect:/user/detail?b_code=" + board.getB_code();

        } catch (Exception e) {
            log.error("수정 실패: ", e);
            return "redirect:/user/list?error=update_failed";
        }
    }

    /** 7. 삭제 **/
    @GetMapping("/boardDelete")
    public String deleteBoard(@RequestParam("b_code") String b_code, HttpSession session) {
        String loginId = (String) session.getAttribute("m_id");
        BoardDTO board = boardService.getDetail(b_code);

        if (board != null && loginId != null && (loginId.equals(board.getM_id()) || "admin".equals(loginId))) {
            boardService.removeBoard(b_code);
        }
        return "redirect:/user/list";
    }

    /** [공통] 태그 데이터 파싱 메서드 **/
    private List<BoardTagDTO> parseTagData(String json) {
        if (json == null || json.trim().isEmpty() || json.equals("[]")) {
            return new ArrayList<>();
        }
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
            return mapper.readValue(json, new TypeReference<List<BoardTagDTO>>(){});
        } catch (Exception e) {
            log.error("태그 파싱 에러: {}", e.getMessage());
            return new ArrayList<>();
        }
    }
}