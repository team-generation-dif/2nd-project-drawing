package com.drawing.springboot.dto;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BoardTagDTO {
    private String t_code;
    private String b_code;
    private String x_coord; // double에서 String으로 변경
    private String y_coord; // double에서 String으로 변경
    private String t_url;   
    private String t_name;  
    private String t_price;
    private String status;
}