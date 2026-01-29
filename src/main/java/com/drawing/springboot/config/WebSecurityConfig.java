package com.drawing.springboot.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import com.drawing.springboot.service.CustomOAuth2UserService;
import com.drawing.springboot.service.OAuth2SuccessHandler;

import jakarta.servlet.DispatcherType;
import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor 
public class WebSecurityConfig {

    private final CustomOAuth2UserService customOAuth2UserService;
    // 신규 유저를 가입 폼으로 보내버릴 핸들러 주입
    private final OAuth2SuccessHandler successHandler; 

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(); // 일반 로그인 비밀번호 암호화용
    }
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        // 1. 보안 설정 (CSRF, CORS 비활성화 및 경로별 권한 설정)
        http.csrf((csrf) -> csrf.disable())
            .cors((cors) -> cors.disable())
            .authorizeHttpRequests(request -> request
                    .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll() 
                    .requestMatchers("/", "/CSS/**", "/JS/**", "/imgsrc/**").permitAll() 
                    .requestMatchers("/guest/**", "/login/**", "/oauth2/**").permitAll() 
                    .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN") 
                    .requestMatchers("/admin/**").hasRole("ADMIN") 
                    .anyRequest().authenticated() 
            );
        
        // 2. 일반 폼 로그인 설정
        http.formLogin((formlogin) -> formlogin
                .loginPage("/guest/loginForm")
                .loginProcessingUrl("/j_spring_security_check")
                .usernameParameter("j_username")
                .passwordParameter("j_password")
                .defaultSuccessUrl("/loginSuccess", true)
                .failureUrl("/guest/loginForm?error")
                .permitAll()
        );

        // 3. 카카오(OAuth2) 로그인 설정 (핵심 수정 부분)
        http.oauth2Login((oauth2) -> oauth2
                .loginPage("/guest/loginForm")
                // 성공 시 defaultSuccessUrl 대신 커스텀 핸들러를 실행하여 
                // 가입 여부에 따라 /guest/socialJoinForm 등으로 리다이렉트 시킴
                .successHandler(successHandler) 
                .userInfoEndpoint(userInfo -> userInfo
                        .userService(customOAuth2UserService)
                )
        );
        
        // 4. 로그아웃 설정
        http.logout((logout) -> logout
                .logoutUrl("/logout") 
                .logoutSuccessUrl("/") 
                .invalidateHttpSession(true) 
                .deleteCookies("JSESSIONID") 
                .permitAll()
        );
        
        return http.build();
    }
}