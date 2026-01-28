package com.drawing.springboot.dto;
import java.util.Date;
import lombok.Data;

@Data
public class HistoryDTO {
    private String H_CODE;
    private String M_CODE;
    private String H_AMOUNT;
    private String H_METHOD;
    private String H_STATUS;
    private Date H_DATE;
}

