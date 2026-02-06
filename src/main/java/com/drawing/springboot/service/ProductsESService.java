package com.drawing.springboot.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.drawing.springboot.dto.ProductsDTO;

@Service
public class ProductsESService {

	@Autowired
	private RestHighLevelClient client;
	
	// 엘라스틱 서치로 저장
	public void save(ProductsDTO dto) throws Exception {
		
		// 엘라스틱 서치로 저장할 json 형태 객체 불러오기
		Map<String, Object> map = new HashMap<>();
		map.put("p_code", dto.getP_code());
		map.put("p_name", dto.getP_name());
		map.put("p_color", dto.getP_color());
		map.put("p_size", dto.getP_size());
		map.put("p_rating", dto.getP_rating());
		map.put("p_image", dto.getP_image());
		map.put("p_url", dto.getP_url());
		map.put("p_price", dto.getP_price());
		map.put("subcategoryname", dto.getSubcategoryName());
		map.put("categoryname", dto.getCategoryName());
		
		// products 인덱스를 지정하여 문서 저장
		IndexRequest request = new IndexRequest("products")
			.id(String.valueOf(dto.getP_code()))
			.source(map);
		
		client.index(request, RequestOptions.DEFAULT);
		
		// 로그
		String id = String.valueOf(dto.getP_code());
		System.out.println("ES INDEX ID : " + id);
	}
	
	// 엘라스틱 서치로 검색
	public List<ProductsDTO> search(String keyword) throws Exception {
		
		// 엘라스틱 서치에서 인덱스를 가져옴
		SearchRequest request = new SearchRequest("products");
		
		// 검색 요청의 엘라스틱 서치 본문을 만드는 객체 생성
		SearchSourceBuilder builder = new SearchSourceBuilder();
		
		// 엘라스틱 서치 검색 결과문 빌더 저장
		builder.fetchSource(new String[]{"p_name","subcategoryname","categoryname"}, null);
		builder.query(QueryBuilders.multiMatchQuery(keyword, "p_name","subcategoryname","categoryname"));
		request.source(builder);
		SearchResponse response = client.search(request, RequestOptions.DEFAULT);
		
		List<ProductsDTO> list = new ArrayList<ProductsDTO>();
		
		for(SearchHit hit:response.getHits().getHits()) {
			Map<String, Object> map = hit.getSourceAsMap();
			ProductsDTO dto = new ProductsDTO();
			dto.setP_code(Integer.parseInt(String.valueOf(map.get("p_code"))));
			dto.setP_name(map.get("p_name").toString());
			dto.setP_color(map.get("p_color").toString());
			dto.setP_size(map.get("p_size").toString());
			dto.setP_rating(Double.parseDouble(String.valueOf(map.get("p_rating"))));
			dto.setP_image(map.get("p_image").toString());
			dto.setP_url(map.get("p_url").toString());
			dto.setP_price(map.get("p_price").toString());
			dto.setSubcategoryName(map.get("subcategoryname").toString());
			dto.setCategoryName(map.get("categoryname").toString());
			
			list.add(dto);
		}
		
		return list;
	}
	
	// 자동완성
	public List<Map<String, String>> autocomplete(String keyword) throws Exception {
		
		SearchRequest request = new SearchRequest("products");
		SearchSourceBuilder builder = new SearchSourceBuilder();
		builder.fetchSource(new String[]{"p_name", "subcategoryname"}, null);
		builder.size(10);
		
		builder.query(QueryBuilders.multiMatchQuery(keyword,"p_name","subcategoryname"));
		
		request.source(builder);
		
		SearchResponse response = client.search(request, RequestOptions.DEFAULT);
		
		List<Map<String, String>> result = new ArrayList<Map<String,String>>();
		
		for(SearchHit hit:response.getHits()) {
			String p_name = hit.getSourceAsMap().get("p_name").toString();
			
			Map<String, String> map = new HashMap<String, String>();
			map.put("p_name", p_name);
			
			result.add(map);
		}
		
		return result;
	}
	
	public void delete(int p_code) throws Exception {
		DeleteRequest request = new DeleteRequest("products", String.valueOf(p_code));
		
		try {
            client.delete(request, RequestOptions.DEFAULT);
            System.out.println("ES DELETE SUCCESS - ID : " + p_code);
        } catch (Exception e) {
            System.err.println("ES DELETE FAILED - ID : " + p_code);
            throw e;
        }
	}
}
