package com.drawing.springboot.service;

import java.util.Calendar;
import java.util.Date;
import java.util.UUID;

import org.springframework.mail.SimpleMailMessage; // 추가
import org.springframework.mail.javamail.JavaMailSender; // 추가
import org.springframework.stereotype.Service;

import com.drawing.springboot.dao.IEmailAuthDAO;
import com.drawing.springboot.dto.EmailAuthDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EmailAuthService {

    private final IEmailAuthDAO emailAuthDAO;
    private final JavaMailSender mailSender; // 1. 전송 도구 주입

    public void sendAuthMail(String email) {

        String code = String.valueOf((int)(Math.random() * 900000) + 100000);

        EmailAuthDTO dto = new EmailAuthDTO();
        dto.setE_code(UUID.randomUUID().toString());
        dto.setM_email(email);
        dto.setAuth_num(code);

        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MINUTE, 5); // 5분 유효
        dto.setExpire_date(cal.getTime());

        emailAuthDAO.insertAuth(dto);

        // 2. 📩 실제 메일 발송 로직 추가
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email); // 받는 사람
        message.setSubject("[Drawing] 이메일 인증 번호 안내"); // 제목
        message.setText("안녕하세요. 요청하신 인증번호는 [" + code + "] 입니다. \n5분 이내에 입력해 주세요."); // 내용
        
        mailSender.send(message); // 실제로 메일을 쏘는 명령
        
        System.out.println("📧 " + email + "로 메일 발송 완료! 인증번호: " + code);
    }

    public boolean verify(String email, String inputCode) {
        EmailAuthDTO auth = emailAuthDAO.findLatestByEmail(email);

        if (auth == null) return false;
        if (auth.getExpire_date().before(new Date())) return false;
        if (!auth.getAuth_num().equals(inputCode)) return false;

        emailAuthDAO.verifyAuth(auth.getE_code());
        return true;
    }
 // 임시 비밀번호 생성 로직 추가
    public String sendTempPassword(String email) {
        // 8자리 무작위 문자열 생성 (임시 비번)
        String tempPw = UUID.randomUUID().toString().substring(0, 8);

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("[Drawing] 임시 비밀번호가 발급되었습니다.");
        message.setText("안녕하세요. 요청하신 임시 비밀번호는 [" + tempPw + "] 입니다.\n" +
                        "로그인 후 마이페이지에서 반드시 비밀번호를 변경해 주세요.");
        
        mailSender.send(message);
        return tempPw; // 생성된 비번을 컨트롤러에 전달하여 DB 업데이트에 사용
    }
}