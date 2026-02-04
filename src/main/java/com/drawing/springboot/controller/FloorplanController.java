package com.drawing.springboot.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
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
    	String admin_code = memberDAO.findByMid("admin").getM_code();
    	
    	if ("my".equals(type)) {
            return floorplanDAO.selectDAOByMCode(m_code);
        } else if ("template".equals(type)) {
            return floorplanDAO.selectDAOByMCode(admin_code); 
        }
        return null;
    }
    
    // 평면도 목록에서 삭제
    @RequestMapping("/user/floorplan/delete")
    @ResponseBody
    public String deleteFloorplan(@RequestParam(value="f_code") String f_code) {
    	try {
            int result = floorplanDAO.deleteDAO(f_code); // DAO에 deleteDAO 메서드 필요
            return result > 0 ? "ok" : "fail";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }
    
    // 평면도 이미지 분석
    @RequestMapping("/user/floorplan/analyze")
    @ResponseBody
    public String analyzeFloorplan(@RequestParam("file") MultipartFile file, @RequestParam(value="realWidth", defaultValue="15000") String realWidth) {
        try {
            // 1. 이미지 임시 저장
            String originalName = file.getOriginalFilename();
            String saveName = UUID.randomUUID().toString() + "_" + originalName;
            String fullPath = uploadDir + saveName;
            File dest = new File(fullPath);
            file.transferTo(dest);

            // 2. 파이썬 스크립트 실행 (경로는 본인 환경에 맞게 수정 필수!)
            String pythonPath = "C:\\Users\\KH\\AppData\\Local\\Programs\\Python\\Python313\\python.exe";
            
            String pythonScriptPath = "C:/Springboot/drawing/pythonscript/wall_extractor.py"; 
            ProcessBuilder pb = new ProcessBuilder(pythonPath, pythonScriptPath, fullPath, realWidth);
            pb.redirectErrorStream(true);
            Process process = pb.start();

            // 3. 파이썬 출력(JSON) 읽기
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream(), "EUC-KR"));
            StringBuilder jsonResult = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                jsonResult.append(line);
            }
            
            // 프로세스 종료 대기
            process.waitFor();
            
            // 임시 파일 삭제
            dest.delete(); 

            return jsonResult.toString(); // JSON 배열 문자열 반환

        } catch (Exception e) {
            e.printStackTrace();
            return "[]"; // 에러 시 빈 배열
        }
    }
}
