package com.drawing.springboot.config;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;

import com.drawing.springboot.service.CustomOAuth2UserService;
import com.drawing.springboot.service.OAuth2SuccessHandler;

import jakarta.servlet.DispatcherType;
import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor 
public class WebSecurityConfig {

    private final CustomOAuth2UserService customOAuth2UserService;
    private final OAuth2SuccessHandler successHandler; 
    // 추가: 리졸버를 위한 레포지토리 주입
    private final org.springframework.security.oauth2.client.registration.ClientRegistrationRepository clientRegistrationRepository;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf((csrf) -> csrf.disable())
            .cors((cors) -> cors.disable())
            .authorizeHttpRequests(request -> request
                    .dispatcherTypeMatchers(
                        DispatcherType.FORWARD,
                        DispatcherType.INCLUDE
                    ).permitAll()
                    .requestMatchers("/", "/error","/CSS/**", "/JS/**", "/imgsrc/**", "/upload/**").permitAll()
                    .requestMatchers("/guest/**", "/login/**", "/oauth2/**").permitAll()
                    .requestMatchers("/chatbot/**").permitAll()
                    .requestMatchers("/user/**").hasAnyRole("USER", "ADMIN")
                    .requestMatchers("/admin/**").hasRole("ADMIN")
                    .anyRequest().authenticated()
                );
        
        http.formLogin((formlogin) -> formlogin
                .loginPage("/guest/loginForm")
                .loginProcessingUrl("/j_spring_security_check")
                .usernameParameter("j_username")
                .passwordParameter("j_password")
                .defaultSuccessUrl("/loginSuccess", false)
                .failureUrl("/guest/loginForm?error")
                .permitAll()
        );

        http.oauth2Login((oauth2) -> oauth2
                .loginPage("/guest/loginForm")
                // 무조건 로그인창을 띄우는 리졸버 설정
                .authorizationEndpoint(auth -> auth.authorizationRequestResolver(authorizationRequestResolver())) 
                .successHandler(successHandler) 
                .userInfoEndpoint(userInfo -> userInfo.userService(customOAuth2UserService))
        );
        
        http.logout((logout) -> logout
                .logoutUrl("/logout") 
                .logoutSuccessHandler((request, response, authentication) -> {
                    String clientId = "cc71d2dce34b07aa23b9fe6d6432ad57"; 
                    String logoutRedirectUri = "http://localhost:8080/"; 
                    
                    String kakaoLogoutUrl = "https://kauth.kakao.com/oauth/logout"
                            + "?client_id=" + clientId 
                            + "&logout_redirect_uri=" + logoutRedirectUri;
                    
                    response.sendRedirect(kakaoLogoutUrl);
                })
                .invalidateHttpSession(true) 
                .deleteCookies("JSESSIONID") 
                .permitAll()
        );
        
        return http.build();
    }

    // 메서드를 filterChain 밖으로 뺐습니다.
    private org.springframework.security.oauth2.client.web.OAuth2AuthorizationRequestResolver authorizationRequestResolver() {
        org.springframework.security.oauth2.client.web.DefaultOAuth2AuthorizationRequestResolver resolver = 
            new org.springframework.security.oauth2.client.web.DefaultOAuth2AuthorizationRequestResolver(clientRegistrationRepository, "/oauth2/authorization");
        
        resolver.setAuthorizationRequestCustomizer(customizer -> 
            customizer.additionalParameters(params -> params.put("prompt", "login"))
        );
        return resolver;
    }
 
}