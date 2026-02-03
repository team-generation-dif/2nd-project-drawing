package com.drawing.springboot.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.drawing.springboot.dao.IBoardDAO;
import com.drawing.springboot.dao.ICategoryDAO;
import com.drawing.springboot.dao.IChatbotDAO;
import com.drawing.springboot.dao.IMemberDAO;
import com.drawing.springboot.dto.CategoryDTO;
import com.drawing.springboot.dto.MemberDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class MemberController {

    private final IMemberDAO memberDAO;
    private final PasswordEncoder passwordEncoder;
    private final IBoardDAO boardDAO;
    private final IChatbotDAO chatbotDAO;

    @Autowired
    private ICategoryDAO categoryDAO;

    
    /* =========================
     * 1. Guest (비로그인)
     * ========================= */

    @GetMapping("/")
    public String mainPage(Model model) {
        List<CategoryDTO> categories = categoryDAO.getAllCategories();
        model.addAttribute("categories", categories); // ✅ JSP에서 ${categories}로 접근 가능
        return "guest/main";
    }
    
    @GetMapping("/guest/loginForm")
    public String loginForm() {
        return "guest/loginForm";
    }
    @GetMapping("/member/change-password")
    public String changePwPage(HttpSession session) {
        if (session.getAttribute("verifiedEmail") == null) return "redirect:/login"; // 인증 안 됐으면 차단
        return "member/changePassword"; // changePassword.jsp로 이동
    }

    @PostMapping("/member/update-password")
    public String updatePw(@RequestParam("m_pw") String m_pw, HttpSession session) {
        String email = (String) session.getAttribute("verifiedEmail");
        
        if (email != null) {
            // 1. 비밀번호 암호화 (시큐리티 로그인 호환을 위해 필수)
            String encodedPw = passwordEncoder.encode(m_pw);
            
            // 2. memberMapper를 사용하여 업데이트 (대소문자 및 변수명 수정)
            memberDAO.updatePassword(email, encodedPw);
            
            session.removeAttribute("verifiedEmail"); // 완료 후 세션 삭제
        }
        
        return "redirect:/guest/loginForm"; // 로그인 페이지로 이동
    }
    /* =========================
     * 일반 회원가입
     * ========================= */

    @GetMapping("/guest/joinForm")
    public String joinForm() {
        return "guest/joinForm";
    }

    @PostMapping("/guest/join")
    public String join(MemberDTO member) {

        member.setM_passwd(passwordEncoder.encode(member.getM_passwd()));
        member.setLogin_type("NORMAL");
        
        // ✅ 권한 설정 로직 변경
        // 아이디가 ADMIN(대소문자 무관)이면 ROLE_ADMIN, 아니면 ROLE_USER
        if ("ADMIN".equalsIgnoreCase(member.getM_id())) {
            member.setM_role("ROLE_ADMIN");
        } else {
            member.setM_role("ROLE_USER");
        }
        
        member.setK_id(null);

        memberDAO.insertMember(member);

        return "redirect:/guest/joinSuccess";
    }

    @GetMapping("/guest/joinSuccess")
    public String joinSuccess() {
        return "guest/joinSuccess";
    }
    /* =========================
     * 카카오 추가정보
     * ========================= */

    @GetMapping("/guest/socialJoinForm")
    public String socialJoinForm(@RequestParam(name = "m_id") String m_id, Model model) { // name="m_id" 추가
        log.info("▶ 카카오 신규회원 추가정보 입력: {}", m_id);
        model.addAttribute("m_id", m_id);
        return "guest/socialJoinForm";
    }

    /* 카카오 회원 가입 완료 */
    @PostMapping("/guest/socialJoin")
    public String socialJoin(MemberDTO member) {

        member.setLogin_type("KAKAO");
        member.setM_role("ROLE_USER");
        member.setM_passwd("SOCIAL");

        memberDAO.insertMember(member);

        // 🔥 인증 강제 갱신
        Authentication newAuth =
            new UsernamePasswordAuthenticationToken(
                member.getM_id(),
                null,
                AuthorityUtils.createAuthorityList("ROLE_USER")
            );

        SecurityContextHolder.getContext().setAuthentication(newAuth);

        return "redirect:/loginSuccess";
    }
    
    /* =========================
     * 중복 체크 (본인 제외)
     * ========================= */
    @PostMapping("/guest/checkDuplicateJoin")
    @ResponseBody
    public String checkDuplicate(
    		@RequestParam(name = "m_id", required = false) String m_id,
            @RequestParam(name = "m_nick", required = false) String m_nick,
            @RequestParam(name = "m_email", required = false) String m_email,
            @RequestParam(name = "m_tel", required = false) String m_tel
    ) {

    	if (m_id != null) {
            return memberDAO.findByMid(m_id) == null ? "OK" : "DUPLICATE";
        }
    	
        if (m_nick != null) {
            return memberDAO.findByMnick(m_nick) == null ? "OK" : "DUPLICATE";
        }

        if (m_email != null) {
            return memberDAO.findByMemail(m_email) == null ? "OK" : "DUPLICATE";
        }

        if (m_tel != null) {
            return memberDAO.findByMtel(m_tel) == null ? "OK" : "DUPLICATE";
        }

        return "INVALID";
    }
    @PostMapping("/guest/checkDuplicateSocial")
    @ResponseBody
    public String checkDuplicateSocial(
            @RequestParam(name = "m_id") String m_id,
            @RequestParam(name = "type") String type,  // nick, email, tel 중 하나
            @RequestParam(name = "value") String value // 검사할 값
    ) {
        log.info("▶ 중복체크 요청 - 아이디: {}, 타입: {}, 값: {}", m_id, type, value);

        if (value == null || value.trim().isEmpty()) {
            return "EMPTY"; // 값이 없으면 EMPTY 반환
        }

        MemberDTO existingUser = null;

        if ("nick".equals(type)) {
            existingUser = memberDAO.findByMnick(value);
        } else if ("email".equals(type)) {
            existingUser = memberDAO.findByMemail(value);
        } else if ("tel".equals(type)) {
            existingUser = memberDAO.findByMtel(value);
        }

        // 결과 반환: 찾은 데이터가 없으면 OK, 있으면 DUPLICATE
        return (existingUser == null) ? "OK" : "DUPLICATE";
    }
    


    /* =========================
     * 2. 로그인 성공 후 분기
     * ========================= */

    @RequestMapping("/loginSuccess")
    public String loginSuccess(Authentication authentication, HttpSession session) {

        String m_id = authentication.getName();
        MemberDTO user = memberDAO.findByMid(m_id);

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

        return "redirect:/";
    }

    /* =========================
     * 3. USER
     * ========================= */

    @GetMapping("/guest/main")
    public String guestMain() {
        return "guest/main";
    }

    @PostMapping("/user/verify-password")
    @ResponseBody
    public Map<String, Object> verifyPassword(
            @RequestParam("password") String inputPassword,
            Authentication authentication) {

        Map<String, Object> result = new HashMap<>();

        // ✅ 1️⃣ 인증 먼저 체크 (가장 중요)
        if (authentication == null) {
            result.put("isValid", false);
            return result;
        }

        // ✅ 2️⃣ 사용자 조회
        MemberDTO member = memberDAO.findByMid(authentication.getName());
        if (member == null) {
            result.put("isValid", false);
            return result;
        }

        // ✅ 3️⃣ 카카오 회원 → 바로 통과
        if ("KAKAO".equals(member.getLogin_type())
            || "SOCIAL".equals(member.getM_passwd())) {
            result.put("isValid", true);
            return result;
        }

        // ✅ 4️⃣ 일반 회원 → 비밀번호 검증
        boolean matched =
                passwordEncoder.matches(inputPassword, member.getM_passwd());

        result.put("isValid", matched);
        return result;
    }

    @GetMapping("/user/mypage")
    public String mypage(Authentication authentication, Model model) {
        MemberDTO user = memberDAO.findByMid(authentication.getName());
        model.addAttribute("user", user);
        model.addAttribute("loginType", user.getLogin_type()); // ⭐ 핵심
        return "user/mypage";
    }

    @PostMapping("/user/update")
    public String updateMember(MemberDTO dto) {
        // 1. 비밀번호를 새로 입력했다면 암호화
        if (dto.getM_passwd() != null && !dto.getM_passwd().isEmpty()) {
            dto.setM_passwd(passwordEncoder.encode(dto.getM_passwd()));
        } else {
            dto.setM_passwd(null); // XML의 <if> 조건문에 걸리도록 null 처리
        }

        // 2. DB 업데이트 실행 (인스턴스 변수인 memberMapper 사용!)
        memberDAO.updateMemberInfo(dto); 
        
        return "redirect:/user/mypage";
    }

    @GetMapping("/user/delete")
    public String delete(Authentication authentication, HttpSession session) {
        memberDAO.deleteMember(authentication.getName());
        session.invalidate();
        return "redirect:/";
    }


    /* =========================
     * 4. ADMIN
     * ========================= */

    @GetMapping("/admin/main") // 어드민 메인 진입 경로
    public String adminMain(Model model) {
    	// 1. 회원 관리: 총 회원 수
        model.addAttribute("totalUsers", memberDAO.getTotalUserCount()); 
        
        // 2. 작품 모니터링: 오늘 업로드 수
        model.addAttribute("todayWorks", boardDAO.getTodayWorkCount());
        
        // 3. 챗봇 관리: 오늘 총 사용 횟수 (수정된 부분)
        model.addAttribute("todayChatCount", chatbotDAO.getTodayChatCount());

        return "admin/main"; // 해당 JSP 파일명
    }
    @GetMapping("/admin/userManage")
    public String userManage(Model model) {
        model.addAttribute("userList", memberDAO.findAllMembers());
        return "admin/userManage";
    }
 // 특정 회원의 상세 정보를 보여주는 메서드 추가
    @GetMapping("/admin/userDetail")
    public String userDetail(@RequestParam(name = "m_id") String m_id, Model model) {
        // 1. m_id를 이용해 DB에서 회원 한 명의 정보를 가져옵니다.
        // (사용하시는 Mapper의 메서드명에 맞춰 수정하세요. 예: findByMid 또는 selectUser)
        MemberDTO member = memberDAO.findByMid(m_id); 
        
        // 2. 모델에 담아서 JSP로 보냅니다.
        model.addAttribute("user", member);
        
        // 3. /WEB-INF/views/admin/userDetail.jsp 파일을 찾아서 보여줍니다.
        return "admin/userDetail";
    }


    @GetMapping("/admin/forceDelete")
    public String forceDelete(@RequestParam(name = "m_id") String m_id) { // name="m_id" 추가
        memberDAO.deleteMember(m_id);
        return "redirect:/admin/userManage";
    }
    
}
