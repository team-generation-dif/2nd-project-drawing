package com.drawing.springboot.controller;

import java.io.File;
import java.util.HashMap;
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

import com.drawing.springboot.dao.IInteriorDAO;
import com.drawing.springboot.dao.IMemberDAO;
import com.drawing.springboot.dto.InteriorDTO;
import com.drawing.springboot.dto.MemberDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class InteriorController {
    
	@Autowired
	IInteriorDAO interiorDAO;
	
	@Autowired
	IMemberDAO memberDAO;
	
	private final String uploadDir = "C:/upload/interior/";
	
    @RequestMapping("/user/interior/draw")
    public String draw(Model model, @RequestParam(value="i_code", required = false) String i_code) {
    	if (i_code != null && !i_code.isEmpty()) {
    		InteriorDTO dto = interiorDAO.selectDAOByICode(i_code);
    		model.addAttribute("loaded", dto);
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
}
