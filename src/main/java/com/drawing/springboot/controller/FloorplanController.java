package com.drawing.springboot.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.drawing.springboot.dao.IFloorplanDAO;
import com.drawing.springboot.dao.IMemberDAO;
import com.drawing.springboot.dto.FloorplanDTO;
import com.drawing.springboot.dto.MemberDTO;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class FloorplanController {
	
	@Autowired
	IFloorplanDAO floorplanDAO;
	
	@Autowired
	IMemberDAO memberDAO;
	
	private final String uploadDir = "C:/upload/floorplan/";
	
	// 인테리어 저장
    @RequestMapping("/user/floorplan/save")
    @ResponseBody
    public String floorplansave(FloorplanDTO dto, @RequestParam(value = "file") MultipartFile file, HttpServletRequest request, Authentication authentication) {
    	String f_template = request.getParameter("f_template");
    	String json_data = request.getParameter("json_data");
    	MemberDTO memberDTO = memberDAO.findByMid(authentication.getName()); 
    	
		dto.setF_template(f_template);
		dto.setJson_data(json_data);
		dto.setM_code(memberDTO.getM_code());
		
    	try {
    		File dir = new File(uploadDir);
    		if (!dir.exists()) dir.mkdirs();
    		
    		if (file != null && !file.isEmpty()) {
                String originalName = file.getOriginalFilename();
                String saveName = UUID.randomUUID().toString() + "_" + originalName; // 이름 중복 방지
                String fullPath = uploadDir + saveName;

                file.transferTo(new File(fullPath));

                dto.setF_img("/upload/floorplan/" + saveName);
            }
    		int result = floorplanDAO.insertDAO(dto);
            return result > 0 ? "ok" : "fail";
            
    	} catch (Exception e) {
    		e.printStackTrace();
    		return "fail";
    	}
    }
    
    @RequestMapping("/user/floorplan/list")
    @ResponseBody
    public List<FloorplanDTO> floorplanlist(Authentication authentication, @RequestParam("type") String type) {
    	String m_id = authentication.getName();
    	String m_code = memberDAO.findByMid(m_id).getM_code();
    	
    	if ("my".equals(type)) {
            return floorplanDAO.selectDAOByMCode(m_code);
        } else if ("template".equals(type)) {
            return floorplanDAO.selectDAOByMId("admin"); 
        }
        return null;
    }
    
    // 평면도 목록에서 삭제
    @RequestMapping("/user/floorplan/delete")
    public String floorplandelete(@RequestParam(value="f_code") String f_code) {
    	floorplanDAO.deleteDAO(f_code);
    	return "redirect:/user/interior/myDraw";
    }
}
