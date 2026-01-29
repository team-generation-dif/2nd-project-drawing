package com.drawing.springboot.service;

import java.io.IOException;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.stereotype.Component;

import com.drawing.springboot.dao.IMemberDAO;
import com.drawing.springboot.dto.MemberDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class OAuth2SuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private RequestCache requestCache = new HttpSessionRequestCache();
    private final IMemberDAO memberMapper;

    public OAuth2SuccessHandler(IMemberDAO memberMapper) {
        this.memberMapper = memberMapper;
    }

    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication) throws IOException {

        requestCache.removeRequest(request, response);
        clearAuthenticationAttributes(request);

        String m_id = authentication.getName();

        // 🔥 DB 기준으로 신규 / 기존 판단
        MemberDTO member = memberMapper.findByMid(m_id);

        if (member == null) {
            // 🔥 신규 카카오 유저 → 추가정보 입력
            getRedirectStrategy().sendRedirect(
                    request,
                    response,
                    "/guest/socialJoinForm?m_id=" + m_id
            );
            return;
        }

        // 🔥 기존 유저 → ROLE_USER 강제 인증 갱신
        Authentication newAuth =
                new UsernamePasswordAuthenticationToken(
                        authentication.getPrincipal(),
                        null,
                        AuthorityUtils.createAuthorityList(member.getM_role())
                );

        SecurityContextHolder.getContext().setAuthentication(newAuth);

        getRedirectStrategy().sendRedirect(request, response, "/loginSuccess");
    }
}
