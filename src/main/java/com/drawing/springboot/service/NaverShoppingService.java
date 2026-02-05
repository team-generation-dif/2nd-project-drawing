package com.drawing.springboot.service;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class NaverShoppingService {

    @Value("${naver.client.id}")
    private String clientId;

    @Value("${naver.client.secret}")
    private String clientSecret;

    // 가구 키워드별 검색량 조회
    public Map<String, Integer> getFurnitureTrends() {
        String[] furnitureKeywords = {"소파", "침대", "테이블", "의자", "책장"};
        Map<String, Integer> trends = new LinkedHashMap<>();

        RestTemplate restTemplate = new RestTemplate();

        for (String keyword : furnitureKeywords) {
            String apiURL = "https://openapi.naver.com/v1/search/shop.json?query=" 
                          + keyword + "&display=1";

            HttpHeaders headers = new HttpHeaders();
            headers.set("X-Naver-Client-Id", clientId);
            headers.set("X-Naver-Client-Secret", clientSecret);

            HttpEntity<String> entity = new HttpEntity<>(headers);

            try {
                ResponseEntity<Map> response = restTemplate.exchange(
                    apiURL, HttpMethod.GET, entity, Map.class
                );

                Map<String, Object> body = response.getBody();
                int total = (int) body.get("total"); // 검색 결과 총 개수
                trends.put(keyword, total);

            } catch (Exception e) {
                trends.put(keyword, 0);
            }
        }

        return trends;
    }
}