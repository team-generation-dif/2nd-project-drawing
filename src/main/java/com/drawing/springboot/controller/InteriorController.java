package com.drawing.springboot.controller;

import java.io.File;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.drawing.springboot.dao.IInteriorDAO;
import com.drawing.springboot.dto.InteriorDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class InteriorController {
    
	@Autowired
	IInteriorDAO interiorDAO;
	
	private final String uploadDir = "C:/upload/interior/";
	
    @RequestMapping("/user/interior/draw")
    public String draw() {
    	return "user/interior/interior_drawing";
    }
    
    @RequestMapping("/user/interior/interiorsave")
    @ResponseBody
    public String interiorsave(InteriorDTO dto, @RequestParam(value = "file") MultipartFile file, HttpServletRequest request) {
    	String iTitle = request.getParameter("iTitle");
    	String fCode = request.getParameter("fCode");
    	String jsonData = request.getParameter("jsonData");
//    	String m_id = authentication.getName();
//    	MemberDTO memberDTO = memberDAO.selectDAOById(m_id); -> 세션으로 될 수도
    	
		dto.setITitle(iTitle);
		dto.setJsonData(jsonData);
		dto.setFCode(fCode);
//		dto.setMCode(memberDTO.getMCode());
		
    	try {
    		File dir = new File(uploadDir);
    		if (!dir.exists()) dir.mkdirs();
    		
    		if (file != null && !file.isEmpty()) {
                String originalName = file.getOriginalFilename();
                String saveName = UUID.randomUUID().toString() + "_" + originalName; // 이름 중복 방지
                String fullPath = uploadDir + saveName;

                file.transferTo(new File(fullPath));

                dto.setIImage("/upload/interior/" + saveName);
            }
    		
    		interiorDAO.insertDAO(dto);
    		
    		return "ok";
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    		return "실패:" + e.getMessage();
    	}
    	
    	
    	
    }
}
