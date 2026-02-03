package com.drawing.springboot.service;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.StandardCharsets;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.drawing.springboot.dao.IProductsDAO;
import com.drawing.springboot.dto.ProductsDTO;

@Service
public class ProductsService {

    @Autowired
    private IProductsDAO productsDAO;

    public void importCsv(MultipartFile file) throws IOException {
        try (Reader reader = new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8)) {
            CSVParser parser = CSVFormat.DEFAULT.withFirstRecordAsHeader().parse(reader);

            for (CSVRecord record : parser) {
                ProductsDTO dto = new ProductsDTO();

                dto.setP_code(Integer.parseInt(record.get("p_code")));
                dto.setP_name(record.get("p_name"));
                dto.setP_color(record.get("p_color"));

                // p_width는 문자열 그대로 저장 ("-", "50x30x80 cm" 등)
                dto.setP_width(record.get("p_width"));

                // 가격도 문자열 그대로 저장 (varchar2 컬럼과 매칭)
                dto.setP_price(record.get("p_price"));

                dto.setP_image(record.get("p_image"));

                // 평점은 숫자로 변환, 빈 값이면 0.0
                String ratingStr = record.get("p_rating");
                dto.setP_rating(ratingStr == null || ratingStr.isEmpty() ? 0.0 : Double.parseDouble(ratingStr));

                dto.setSubcategoryId(Integer.parseInt(record.get("subcategory_id")));

                productsDAO.insertProduct(dto);
            }
        }
    }
}
