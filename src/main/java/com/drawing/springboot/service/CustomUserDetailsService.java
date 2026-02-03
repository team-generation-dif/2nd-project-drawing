package com.drawing.springboot.service;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.drawing.springboot.dao.IMemberDAO;
import com.drawing.springboot.dto.MemberDTO;

import lombok.RequiredArgsConstructor;

@Service // 이 어노테이션이 있어야 로그의 경고창이 사라집니다!
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final IMemberDAO memberMapper;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // DB에서 사용자 정보 조회
        MemberDTO member = memberMapper.findByMid(username);
        
        if (member == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        }

        // 시큐리티가 이해할 수 있는 객체로 변환해서 리턴
        return User.builder()
                .username(member.getM_id())
                .password(member.getM_passwd()) // DB에 저장된 암호화된 비번
                .roles(member.getM_role().replace("ROLE_", "")) // ROLE_USER -> USER
                .build();
    }
}
