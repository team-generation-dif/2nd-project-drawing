package com.drawing.springboot.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.drawing.springboot.dao.IBoardDAO;
import com.drawing.springboot.dto.BoardDTO;
import com.drawing.springboot.dto.BoardTagDTO;

@Service
public class BoardService {

    @Autowired
    private IBoardDAO boardDAO;

    /* 게시글 등록 */
    @Transactional
    public void registerBoard(BoardDTO board, List<BoardTagDTO> tagList) {
        boardDAO.insertBoard(board);
        if (tagList != null && !tagList.isEmpty()) {
            for(BoardTagDTO tag : tagList) {
                tag.setB_code(board.getB_code());
                boardDAO.insertTag(tag);
            }
        }
    }

    /* 게시글 수정 (전체 교체 방식) */
    @Transactional
    public void updateBoard(BoardDTO board, List<BoardTagDTO> tagList) {
        boardDAO.updateBoard(board); // 게시글 본문 수정
        boardDAO.deleteTagsByBoard(board.getB_code()); // 기존 태그 삭제
        
        if (tagList != null && !tagList.isEmpty()) {
            for(BoardTagDTO tag : tagList) {
                tag.setB_code(board.getB_code());
                boardDAO.insertTag(tag); // 새 태그 삽입
            }
        }
    }

    public List<BoardDTO> getBoardList() {
        return boardDAO.getBoardList();
    }

    public BoardDTO getDetail(String b_code) {
        return boardDAO.getDetail(b_code);
    }

    public List<BoardTagDTO> getTagsByBoard(String b_code) {
        return boardDAO.getTagsByBoard(b_code);
    }

    /* 게시글 삭제 */
    @Transactional
    public void removeBoard(String b_code) {
        boardDAO.deleteTagsByBoard(b_code);
        boardDAO.deleteBoard(b_code);
    }
} // 클래스 끝 (이 중괄호가 하나만 있어야 합니다)