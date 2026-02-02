package com.drawing.springboot.service;

import java.util.Collections;
import java.util.Map;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.drawing.springboot.dao.IMemberDAO;
import com.drawing.springboot.dto.MemberDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final IMemberDAO memberMapper;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        Map<String, Object> attributes = oAuth2User.getAttributes();
        String kakaoId = String.valueOf(attributes.get("id")); 
        
        MemberDTO member = memberMapper.findByMid(kakaoId);
        String role;

        if (member == null) {
            role = "ROLE_GUEST"; 
            log.info("카카오 신규 방문자 (미가입): {}", kakaoId);
        } else {
            // DB에서 가져온 값이 "USER"라면 "ROLE_USER"로, 
            // 이미 "ROLE_USER"라면 그대로 유지하도록 처리
            String dbRole = member.getM_role().toUpperCase(); // 대문자 변환 (안전장치)
            role = dbRole.startsWith("ROLE_") ? dbRole : "ROLE_" + dbRole;
            
            log.info("기존 카카오 회원 로그인: {}, 부여된 권한: {}", kakaoId, role);
        }
        
        return new DefaultOAuth2User(
            Collections.singleton(new SimpleGrantedAuthority(role)), 
            attributes, 
            "id" 
        );
    }
}