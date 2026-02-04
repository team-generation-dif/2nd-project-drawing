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

import com.drawing.springboot.dao.IBoardDAO;
import com.drawing.springboot.dao.IBookmarkDAO;
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
    private final IBoardDAO boardDAO;
    private final IBookmarkDAO bookmarkDAO;

    @GetMapping("/guest/list")
    public String list(
            @RequestParam(value = "page", defaultValue = "1") int page, 
            Model model, 
            HttpSession session) {

        int amount = 3; 
        int offset = (page - 1) * amount;

        // 1. 세션에서 m_id 가져오기 (추가된 부분)
        String m_code = (String) session.getAttribute("m_code");

        // 2. DAO 호출 시 m_id를 세 번째 인자로 전달 (에러 해결 지점!)
     // BoardController.java
        List<BoardDTO> list = boardDAO.getBoardListWithPaging(offset, amount, m_code);

        // 이 부분에서 각 게시글마다 북마크 상태를 명확히 셋팅하고 있습니다.
        if (m_code != null) {
            for (BoardDTO board : list) {
                int count = bookmarkDAO.checkBookmark(m_code, board.getB_code());
                board.setIsBookmarked(count > 0); 
            }
        }

        // 중복된 model.addAttribute 중 하나를 정리하고 확실히 전달하세요.
        model.addAttribute("list", list);

        // 3. 모델에 리스트 담기
        model.addAttribute("list", list); // ✅ addAllAttributes -> addAttribute로 수정

        // 4. 페이징 처리
        BoardDTO paging = new BoardDTO(); 
        int total = boardDAO.getTotalCount();
        paging.setPage(page); 
        paging.setPaging(page, amount, total);
        
        model.addAttribute("paging", paging); 

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
