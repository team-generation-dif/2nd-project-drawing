package com.drawing.springboot.dto;

import java.util.Date;
import lombok.Data;

@Data
public class FloorplanDTO {
    private String F_CODE;
    private String M_CODE;
    private String F_TEMPLATE;
    private double F_WIDTH;
    private double F_DEPTH;
    private double F_HEIGHT;
    private String F_FILE;
    private Date F_DATE;
}

