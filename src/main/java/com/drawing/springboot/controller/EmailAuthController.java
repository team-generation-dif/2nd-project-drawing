package com.drawing.springboot.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder; // 추가됨
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.drawing.springboot.dao.IMemberDAO;
import com.drawing.springboot.service.EmailAuthService;

import lombok.RequiredArgsConstructor; // 추가됨
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor // ★ final이 붙은 필드들을 자동으로 주입해줍니다.
public class EmailAuthController {

    private final EmailAuthService emailAuthService;
    private final IMemberDAO memberDAO;
    private final BCryptPasswordEncoder passwordEncoder; // ★ 필드 선언 추가 (에러 해결)

    @PostMapping("/email/send-auth")
    @ResponseBody
    public String sendAuth(@RequestParam("m_email") String m_email) {
        try {
            log.info("인증번호 발송 요청 이메일: {}", m_email);
            emailAuthService.sendAuthMail(m_email);
            return "OK";
        } catch (Exception e) {
            log.error("메일 발송 에러: ", e);
            return "ERROR";
        }
    }

    @PostMapping("/email/verify-find-id")
    @ResponseBody
    public ResponseEntity<?> verifyFindId(
            @RequestParam("m_email") String m_email,   
            @RequestParam("auth_num") String auth_num  
        ) {
        if (emailAuthService.verify(m_email, auth_num)) {
            String foundId = memberDAO.findIdByEmail(m_email);
            return ResponseEntity.ok(foundId != null ? foundId : "NONE");
        }
        return ResponseEntity.status(400).body("FAIL");
    }

    @PostMapping("/email/verify-find-pw")
    @ResponseBody
    public ResponseEntity<?> verifyFindPw(
            @RequestParam("m_email") String m_email,   
            @RequestParam("auth_num") String auth_num) {
        
        log.info("▶ 비밀번호 찾기 인증 시도: {} / {}", m_email, auth_num);
        
        if (emailAuthService.verify(m_email, auth_num)) {
            // 1. 임시 비밀번호 생성 (8자리)
            String tempPw = java.util.UUID.randomUUID().toString().substring(0, 8);
            
            // 2. 암호화 (이제 에러가 나지 않습니다)
            String encodedPw = passwordEncoder.encode(tempPw); 
            
            try {
                // 3. DB 업데이트 (encodedPw 저장)
                memberDAO.updatePassword(m_email, encodedPw);
                log.info("▶ 비밀번호 업데이트 성공. 임시비번: {}", tempPw);
                
                return ResponseEntity.ok(tempPw); 
            } catch (Exception e) {
                log.error("▶ DB 업데이트 중 에러: ", e);
                return ResponseEntity.status(500).body("DB_ERROR");
            }
        }
        return ResponseEntity.status(400).body("FAIL");
    }

    @PostMapping("/email/verify-auth")
    @ResponseBody
    public ResponseEntity<?> verifyAuth(
            @RequestParam("m_email") String m_email, 
            @RequestParam("auth_num") String auth_num) {
        
        if (emailAuthService.verify(m_email, auth_num)) {
            return ResponseEntity.ok("OK");
        } else {
            return ResponseEntity.status(400).body("FAIL");
        }
    }
}