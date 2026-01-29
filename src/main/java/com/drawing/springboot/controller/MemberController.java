package com.drawing.springboot.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.drawing.springboot.dao.IMemberDAO;
import com.drawing.springboot.dto.MemberDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class MemberController {

    private final IMemberDAO memberMapper;
    private final PasswordEncoder passwordEncoder;

    /* =========================
     * 1. Guest (비로그인)
     * ========================= */

    @GetMapping("/")
    public String home() {
        return "common/home";
    }

    @GetMapping("/guest/loginForm")
    public String loginForm() {
        return "guest/loginForm";
    }

    @GetMapping("/guest/joinForm")
    public String joinForm() {
        return "guest/joinForm";
    }

    /* 🔥 카카오 로그인 후 추가정보 입력 폼 */
    @GetMapping("/guest/socialJoinForm")
    public String socialJoinForm(@RequestParam("m_id") String m_id, Model model) {
        log.info("▶ 카카오 신규회원 추가정보 입력: {}", m_id);
        model.addAttribute("m_id", m_id);
        return "guest/socialJoinForm";
    }

    /* 카카오 회원 가입 완료 */
    @PostMapping("/guest/socialJoin")
    public String socialJoin(MemberDTO member) {

        // 🔥 핵심
        member.setLogin_type("KAKAO");
        member.setM_role("ROLE_USER");   // ⭐⭐⭐
        member.setM_passwd("SOCIAL");

        memberMapper.insertMember(member);

        // 🔥 중요: Security 인증은 이미 되어 있음
        return "redirect:/loginSuccess";
    }


    /* =========================
     * 2. 로그인 성공 후 분기
     * ========================= */

    @RequestMapping("/loginSuccess")
    public String loginSuccess(Authentication authentication, HttpSession session) {

        String m_id = authentication.getName();
        MemberDTO user = memberMapper.findByMid(m_id);

        if (user != null) {
            session.setAttribute("m_id", user.getM_id());
            session.setAttribute("nickname", user.getM_nick());
            session.setAttribute("m_role", user.getM_role());
            session.setAttribute("m_code", user.getM_code());
        }

        boolean isAdmin =
                authentication.getAuthorities().stream()
                        .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (isAdmin) {
            return "redirect:/admin/main";
        }

        return "redirect:/user/main";
    }

    /* =========================
     * 3. USER
     * ========================= */

    @GetMapping("/user/main")
    public String userMain() {
        return "user/main";
    }

    @GetMapping("/user/mypage")
    public String mypage(Authentication authentication, Model model) {
        model.addAttribute(
                "user",
                memberMapper.findByMid(authentication.getName())
        );
        return "user/mypage";
    }

    @GetMapping("/user/delete")
    public String delete(Authentication authentication, HttpSession session) {
        memberMapper.deleteMember(authentication.getName());
        session.invalidate();
        return "redirect:/";
    }

    /* =========================
     * 4. ADMIN
     * ========================= */

    @GetMapping("/admin/main")
    public String adminMain() {
        return "admin/main";
    }

    @GetMapping("/admin/userManage")
    public String userManage(Model model) {
        model.addAttribute("userList", memberMapper.findAllMembers());
        return "admin/userManage";
    }

    @GetMapping("/admin/forceDelete")
    public String forceDelete(@RequestParam("m_id") String m_id) {
        memberMapper.deleteMember(m_id);
        return "redirect:/admin/userManage";
    }
}
