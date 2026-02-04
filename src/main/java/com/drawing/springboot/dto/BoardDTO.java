package com.drawing.springboot.dto;

import java.util.Date;

import lombok.Data;

@Data
public class BoardDTO {
    private String b_code;      // 게시글 번호 (PK) 
    private String m_code;      // 회원 번호 (FK) 
    private String i_code;      // 인테리어 번호 (FK) 
    private String b_title;     // 제목 
    private String b_content;   // 내용 
    private String b_image;     // 이미지 
    private String b_interior;  // 인테리어 경로 
    private Date b_date;        // 작성일 
    private String m_id; 
    private String m_nick; // 추가
    private boolean isBookmarked; 

    /* 만약 @Data나 @Setter 어노테이션이 없다면 
       아래 메서드를 직접 작성해 주어야 합니다.
    */
    public boolean isIsBookmarked() {
        return isBookmarked;
    }

    public void setIsBookmarked(boolean isBookmarked) {
        this.isBookmarked = isBookmarked;
    }
    // ★ 추가: Getter / Setter
    public String getM_id() { return m_id; }
    public void setM_id(String m_id) { this.m_id = m_id; }
    private int page;
    private int startPage;    // 화면 시작 페이지
    private int endPage;      // 화면 끝 페이지
    private boolean prev, next; // 이전/다음 버튼 유무
    private int total;        // 전체 게시물 수
    
    // 페이징 계산을 위한 메서드 (직접 추가)
    public void setPaging(int page, int amount, int total) {
        this.total = total;
        this.endPage = (int) (Math.ceil(page / 5.0)) * 5;
        this.startPage = this.endPage - 4;
        
        int realEnd = (int) (Math.ceil((total * 1.0) / amount));
        if (realEnd < this.endPage) this.endPage = realEnd;
        
        this.prev = this.startPage > 1;
        this.next = this.endPage < realEnd;
    }
}
