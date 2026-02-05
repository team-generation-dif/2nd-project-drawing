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
    /** ✅ 수정 페이지 이동 */
    @GetMapping("/user/edit")
    public String editForm(@RequestParam("b_code") String b_code, Model model, HttpSession session) {
        
        // 1. 로그인 체크
        String m_id = (String) session.getAttribute("m_id");
        if (m_id == null) return "redirect:/guest/loginForm";

        // 2. 기존 데이터 불러오기 (상세보기와 동일한 로직)
        BoardDTO board = boardService.getDetail(b_code);
        List<BoardTagDTO> tags = boardService.getTagsByBoard(b_code);

        // 3. 본인 글인지 확인 (보안 강화)
        if (!m_id.equals(board.getM_id())) {
            return "redirect:/guest/list"; // 본인 글 아니면 목록으로 튕겨내기
        }

        model.addAttribute("board", board);
        model.addAttribute("tags", tags);
        
        return "user/edit"; // user 폴더 안의 edit.jsp를 리턴
    }
    /** ✅ 게시글 수정 실행 (이미지 유지 로직 포함) */
    @PostMapping("/user/boardUpdate")
    public String boardUpdate(BoardDTO board,
                             @RequestParam(value="file", required=false) MultipartFile file,
                             @RequestParam(value="tagData", required=false, defaultValue="[]") String tagData,
                             HttpSession session) {
        try {
            // 1. 로그인 확인
            String m_id = (String) session.getAttribute("m_id");
            if (m_id == null) return "redirect:/guest/loginForm";

            // 2. 기존 데이터 불러오기 (기존 이미지 경로 확보용)
            BoardDTO oldBoard = boardService.getDetail(board.getB_code());

            // 3. 이미지 처리
            if (file != null && !file.isEmpty()) {
                // 새 파일이 업로드된 경우
                File saveDir = new File("C:/upload/");
                if (!saveDir.exists()) saveDir.mkdirs();

                String saveName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
                file.transferTo(new File(saveDir, saveName));
                board.setB_image(saveName); // 새 파일명 세팅
            } else {
                // 새 파일이 없는 경우 ✨ 기존 이미지 파일명을 그대로 유지
                board.setB_image(oldBoard.getB_image());
            }

            // 4. 태그 데이터 및 서비스 호출
            List<BoardTagDTO> tagList = parseTagData(tagData);
            boardService.updateBoard(board, tagList);

            return "redirect:/user/detail?b_code=" + board.getB_code();

        } catch (Exception e) {
            log.error("수정 중 에러 발생: ", e);
            return "redirect:/user/edit?b_code=" + board.getB_code() + "&error";
        }
    }
    /** ✅ 게시글 삭제 실행 */
    @GetMapping("/user/boardDelete")
    public String boardDelete(@RequestParam("b_code") String b_code, HttpSession session) {
        try {
            // 1. 세션 체크
            String m_id = (String) session.getAttribute("m_id");
            if (m_id == null) return "redirect:/guest/loginForm";

            // 2. 작성자 본인 확인 (선택 사항이지만 권장)
            BoardDTO board = boardService.getDetail(b_code);
            if (!m_id.equals(board.getM_id())) {
                return "redirect:/guest/list";
            }

            // 3. 삭제 실행 (서비스에서 태그 -> 게시글 순으로 삭제)
            boardService.removeBoard(b_code);

            return "redirect:/guest/list"; // 삭제 후 목록으로 이동

        } catch (Exception e) {
            log.error("삭제 실패: ", e);
            return "redirect:/user/detail?b_code=" + b_code + "&error=delete";
        }
    }
}
