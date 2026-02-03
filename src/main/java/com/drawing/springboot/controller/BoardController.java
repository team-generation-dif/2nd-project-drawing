package com.drawing.springboot.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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

@Controller
@RequiredArgsConstructor
@Slf4j
public class BoardController {

    private final BoardService boardService;

    /** ✅ 게스트도 보는 목록 */
    @GetMapping("/guest/list")
    public String list(Model model) {
        model.addAttribute("list", boardService.getBoardList());
        return "guest/list";
    }

    /** ✅ 상세보기는 로그인 필요 */
    @GetMapping("/user/detail")
    public String detail(@RequestParam("b_code") String b_code, Model model, HttpSession session) {

        String m_id = (String) session.getAttribute("m_id");
        if (m_id == null) return "redirect:/guest/loginForm";

        BoardDTO board = boardService.getDetail(b_code);
        List<BoardTagDTO> tags = boardService.getTagsByBoard(b_code);

        model.addAttribute("board", board);
        model.addAttribute("tags", tags);
        return "user/detail";
    }

    /** 글쓰기 */
    @GetMapping("/user/write")
    public String writeForm() {
        return "user/write";
    }

    /** 저장 */
    @PostMapping("/user/insert")
    public String insert(BoardDTO board,
                         @RequestParam(value="file", required=false) MultipartFile file,
                         @RequestParam(value="tagData", required=false, defaultValue="[]") String tagData,
                         HttpSession session) {

        try {
            Object mCodeObj = session.getAttribute("m_code");
            if (mCodeObj == null) return "redirect:/guest/loginForm";

            board.setM_code(mCodeObj.toString());

            if (file != null && !file.isEmpty()) {
                File saveDir = new File("C:/upload/");
                if (!saveDir.exists()) saveDir.mkdirs();

                String saveName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
                file.transferTo(new File(saveDir, saveName));
                board.setB_image(saveName);
            }

            List<BoardTagDTO> tagList = parseTagData(tagData);
            boardService.registerBoard(board, tagList);

            return "redirect:/guest/list";

        } catch (Exception e) {
            log.error("등록 실패: ", e);
            return "redirect:/user/write?error";
        }
    }

    /** 태그 파싱 */
    private List<BoardTagDTO> parseTagData(String json) {
        if (json == null || json.trim().isEmpty() || json.equals("[]")) {
            return new ArrayList<>();
        }

        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
            return mapper.readValue(json, new TypeReference<List<BoardTagDTO>>() {});
        } catch (Exception e) {
            log.error("태그 파싱 에러: {}", e.getMessage());
            return new ArrayList<>();
        }
    }
}
