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
            // [수정] DB에 없으면 가입시키지 않고 'GUEST' 권한만 부여
            role = "ROLE_GUEST"; 
            log.info("카카오 신규 방문자 (미가입): {}", kakaoId);
        } else {
            // 기존 회원이면 DB에 저장된 권한 부여 (ROLE_USER 등)
            role = member.getM_role();
            log.info("기존 카카오 회원 로그인: {}", kakaoId);
        }
        
        return new DefaultOAuth2User(
            Collections.singleton(new SimpleGrantedAuthority(role)), 
            attributes, 
            "id" 
        );
    }
}