package com.drawing.springboot.controller;

import java.util.List;

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

import com.drawing.springboot.dao.ICategoryDAO;
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

    private final IMemberDAO memberMapper;
    private final PasswordEncoder passwordEncoder;

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

        memberMapper.insertMember(member);

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

        memberMapper.insertMember(member);

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
            return memberMapper.findByMid(m_id) == null ? "OK" : "DUPLICATE";
        }
    	
        if (m_nick != null) {
            return memberMapper.findByMnick(m_nick) == null ? "OK" : "DUPLICATE";
        }

        if (m_email != null) {
            return memberMapper.findByMemail(m_email) == null ? "OK" : "DUPLICATE";
        }

        if (m_tel != null) {
            return memberMapper.findByMtel(m_tel) == null ? "OK" : "DUPLICATE";
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
            existingUser = memberMapper.findByMnick(value);
        } else if ("email".equals(type)) {
            existingUser = memberMapper.findByMemail(value);
        } else if ("tel".equals(type)) {
            existingUser = memberMapper.findByMtel(value);
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

        return "redirect:/";
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
    @PostMapping("/user/update")
    public String updateMember(MemberDTO member, Authentication authentication) {

        // 보안: 로그인한 사용자만 수정 가능
        member.setM_id(authentication.getName());

        memberMapper.updateMember(member);

        return "redirect:/user/mypage";
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
 // 특정 회원의 상세 정보를 보여주는 메서드 추가
    @GetMapping("/admin/userDetail")
    public String userDetail(@RequestParam(name = "m_id") String m_id, Model model) {
        // 1. m_id를 이용해 DB에서 회원 한 명의 정보를 가져옵니다.
        // (사용하시는 Mapper의 메서드명에 맞춰 수정하세요. 예: findByMid 또는 selectUser)
        MemberDTO member = memberMapper.findByMid(m_id); 
        
        // 2. 모델에 담아서 JSP로 보냅니다.
        model.addAttribute("user", member);
        
        // 3. /WEB-INF/views/admin/userDetail.jsp 파일을 찾아서 보여줍니다.
        return "admin/userDetail";
    }


    @GetMapping("/admin/forceDelete")
    public String forceDelete(@RequestParam(name = "m_id") String m_id) { // name="m_id" 추가
        memberMapper.deleteMember(m_id);
        return "redirect:/admin/userManage";
    }
    
}
