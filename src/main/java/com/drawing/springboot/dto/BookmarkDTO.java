package com.drawing.springboot.dto;

import lombok.Data;

@Data
public class BookmarkDTO {
    private int bookmark_id;
    private String m_code;
    private String b_code;
    private String reg_date;
    
    // Getter, Setter 생략 (Lombok 사용 시 @Data)
}