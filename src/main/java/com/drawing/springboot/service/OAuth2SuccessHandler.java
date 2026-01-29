package com.drawing.springboot.service;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.stereotype.Component;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Set;

@Component
public class OAuth2SuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
    
    // 시큐리티가 로그인 전 페이지를 기억하는 캐시 객체
    private RequestCache requestCache = new HttpSessionRequestCache();

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        
        // 1. 로그인 전의 요청 기록을 지워버림 (HOME으로 가려는 관성을 끊음)
        requestCache.removeRequest(request, response);

        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        if (roles.contains("ROLE_GUEST")) {
            // 신규 유저 -> 추가 정보 입력 폼
            String kakaoId = authentication.getName(); 
            getRedirectStrategy().sendRedirect(request, response, "/guest/socialJoinForm?m_id=" + kakaoId);
        } else {
            // 기존 유저 -> 로그인 성공 후 분기 처리 컨트롤러
            getRedirectStrategy().sendRedirect(request, response, "/loginSuccess");
        }
    }
}