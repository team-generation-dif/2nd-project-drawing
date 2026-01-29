package com.drawing.springboot.dto;

import lombok.Data;

@Data
public class ChatbotQuestDTO {
	private String q_code;
    private String keyword;
    private String response_msg;
    private int hit_count;
    private String use_yn;
    private String img_url; // 변수명 변경
    private String link_url;

}