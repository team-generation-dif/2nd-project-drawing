package com.drawing.springboot.service;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.drawing.springboot.dao.IProductsDAO;
import com.drawing.springboot.dto.ProductsDTO;

@Service
public class ProductsService {

    @Autowired
    private IProductsDAO productsDAO;
    
    @Transactional
    public void importCsv(MultipartFile file) throws Exception {
        List<ProductsDTO> productList = new ArrayList<>();

        try (CSVParser parser = CSVParser.parse(
                file.getInputStream(), StandardCharsets.UTF_8,
                CSVFormat.DEFAULT.withHeader(
                    "p_code","p_name","p_color","p_width","p_price","p_image","p_rating","subcategory_id"
                ).withSkipHeaderRecord())) {

            for (CSVRecord record : parser) {
                ProductsDTO product = new ProductsDTO();

                product.setP_code(Integer.parseInt(record.get("p_code")));
                product.setP_name(record.get("p_name"));
                product.setP_color(record.get("p_color"));
                product.setP_width(record.get("p_width"));
                product.setP_price(record.get("p_price")); // 문자열 그대로 저장
                product.setP_image(record.get("p_image"));

                String rating = record.get("p_rating");
                product.setP_rating(rating.isEmpty() ? null : Double.parseDouble(rating));

                String subId = record.get("subcategory_id");
                product.setSubcategoryId(subId.isEmpty() ? 0 : Integer.parseInt(subId));

                productList.add(product);
            }
        }
                
        // ✅ 한 번에 bulk insert 실행
        productsDAO.bulkInsertProducts(productList);
    }
}

