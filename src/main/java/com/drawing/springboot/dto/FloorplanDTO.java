package com.drawing.springboot.dto;

import java.util.Date;
import lombok.Data;
@Data
public class FloorplanDTO {
    private String f_code;
    private String m_code;
    private String f_template;
    private String json_data;
    private String f_img;
    private Date f_date;
}

