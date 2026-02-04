package com.drawing.springboot.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.drawing.springboot.dao.IFavoritesDAO;
import com.drawing.springboot.dao.IFloorplanDAO;
import com.drawing.springboot.dao.IInteriorDAO;
import com.drawing.springboot.dao.IMemberDAO;
import com.drawing.springboot.dao.IProductsDAO;
import com.drawing.springboot.dto.FloorplanDTO;
import com.drawing.springboot.dto.InteriorDTO;
import com.drawing.springboot.dto.MemberDTO;
import com.drawing.springboot.dto.ProductsDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class InteriorController {
    
	@Autowired
	IInteriorDAO interiorDAO;
	
	@Autowired
	IFloorplanDAO floorplanDAO;
	
	@Autowired
	IMemberDAO memberDAO;
	
	@Autowired
	IProductsDAO productsDAO;
	
	@Autowired
	IFavoritesDAO favoritesDAO;
	
	private final String uploadDir = "C:/upload/interior/";
	
    @RequestMapping("/user/interior/draw")
    public String draw(Model model, 
    		@RequestParam(value="i_code", required = false) String i_code,
    		@RequestParam(value="f_code", required = false) String f_code) {
    	if (i_code != null && !i_code.isEmpty()) {
    		InteriorDTO dto = interiorDAO.selectDAOByICode(i_code);
    		model.addAttribute("loaded", dto);
    	} else if (f_code != null && !f_code.isEmpty()) {
    		FloorplanDTO fp = floorplanDAO.selectDAOByFCode(f_code);
    		
    		InteriorDTO floordto = new InteriorDTO();
    		floordto.setJson_data(fp.getJson_data());
    		floordto.setF_code(fp.getF_code());
    		
    		model.addAttribute("loaded", floordto);
    	}
    	
    	return "user/interior/interior_drawing";
    }
    
    @RequestMapping("/user/interior/myDraw")
    public String myDraw(Authentication authentication, Model model) {
    	String m_code = memberDAO.findByMid(authentication.getName()).getM_code();
    	List<InteriorDTO> list = interiorDAO.selectDAOByMCode(m_code);
    	
    	if (list == null || list.isEmpty()) {
            System.out.println("저장된 인테리어가 없습니다 m_code: " + m_code);
        } else {
            System.out.println("조회 성공! 개수: " + list.size());
        }
    	model.addAttribute("dto", list);
    	return "user/interior/myInterior";
    }
    
    // 인테리어 저장
    @RequestMapping("/user/interior/interiorsave")
    @ResponseBody
    public Map<String, String> interiorsave(InteriorDTO dto, @RequestParam(value = "file") MultipartFile file, HttpServletRequest request, Authentication authentication) {
    	Map<String, String> response = new HashMap<>();
    	
    	String i_title = request.getParameter("i_title");
    	String f_code = request.getParameter("f_code");
    	String json_data = request.getParameter("json_data");
    	MemberDTO memberDTO = memberDAO.findByMid(authentication.getName()); 
    	
		dto.setI_title(i_title);
		dto.setJson_data(json_data);
		dto.setF_code(f_code);
		dto.setM_code(memberDTO.getM_code());
		
    	try {
    		File dir = new File(uploadDir);
    		if (!dir.exists()) dir.mkdirs();
    		
    		if (file != null && !file.isEmpty()) {
                String originalName = file.getOriginalFilename();
                String saveName = UUID.randomUUID().toString() + "_" + originalName; // 이름 중복 방지
                String fullPath = uploadDir + saveName;

                file.transferTo(new File(fullPath));

                dto.setI_image("/upload/interior/" + saveName);
            }
    		
    		//  i_code 없을 경우 처음엔 생성, i_code 있을 경우 수정
    		if (dto.getI_code() == null || dto.getI_code().isEmpty()) {
    			interiorDAO.insertDAO(dto);
    			response.put("status","ok");
    			response.put("iCode",dto.getI_code());
    			response.put("message", "신규 저장 성공");
    		} else {
    			interiorDAO.updateDAO(dto);
    			response.put("status","ok");
    			response.put("iCode",dto.getI_code());
    			response.put("message", "수정 저장 성공");
    		}
    		return response;
    		
    	} catch (Exception e) {
    		response.put("status", "fail");
            response.put("message", e.getMessage());
            return response;
    	}
    }
    
    // 인테리어 목록에서 삭제
    @RequestMapping("/user/interior/delete")
    public String interiordelete(@RequestParam(value="i_code") String i_code) {
    	interiorDAO.deleteDAO(i_code);
    	return "redirect:/user/interior/myDraw";
    }
    
    @RequestMapping("/user/interior/prodlist")
    @ResponseBody
    public List<ProductsDTO> getEditorProducts(@RequestParam(value="categoryId", required=false) Long categoryId,
    										   @RequestParam(value="subcategoryId", required=false) Long subcategoryId) {
        
    	List<ProductsDTO> list = null;
    	
    	// 1. 데이터 조회
        if (subcategoryId != null) {
            list = productsDAO.getProductsBySubcategoryId(subcategoryId);
        } else if (categoryId != null) {
            list = productsDAO.getProductsByCategoryId(categoryId);
        }
        
        if (list == null) {
        	return null;
    	}
        Iterator<ProductsDTO> iterator = list.iterator();
        while (iterator.hasNext()) {
            ProductsDTO dto = iterator.next();
            String rawSize = dto.getP_size(); // DB에서 가져온 "100x80x80"
            
            boolean isValid = false;

            if (rawSize != null && !rawSize.trim().isEmpty()) {
                // "x" 또는 "X"로 분리
                String[] parts = rawSize.split("[xX]");
                
                // 정확히 3덩어리(가로x세로x높이)여야 함
                if (parts.length == 3) {
                    try {
                        // 문자열을 숫자로 변환 (공백 제거)
                        double w = Double.parseDouble(parts[0].trim())*10;
                        double d = Double.parseDouble(parts[1].trim())*10;
                        double h = Double.parseDouble(parts[2].trim())*10;
                        
                        // DTO에 예쁘게 담기
                        dto.setP_width(w);
                        dto.setP_depth(d); // 세로
                        dto.setP_height(h);
                        
                        isValid = true;
                    } catch (NumberFormatException e) {
                        // 숫자가 아닌 경우 (예: "100x80x높이")
                        isValid = false;
                    }
                }
            }
            
            // 조건에 안 맞으면 리스트에서 삭제
            if (!isValid) {
                iterator.remove();
            }
        }
        
        return list; 
    }
    
    @RequestMapping("/user/interior/favlist")
    @ResponseBody
    public List<ProductsDTO> getFavoriteList(Authentication authentication) {
    	String m_code = "";
        if (authentication != null) {
            try {
                String m_id = authentication.getName();
                m_code = memberDAO.findByMid(m_id).getM_code();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        return favoritesDAO.favoritesByMCode(m_code);
    }
}
