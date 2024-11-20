// SecurityConfig.java
package vn.edu.iuh.fit.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(authorize -> authorize
//                        .requestMatchers(
//                                "/users/home"
//                        ).authenticated() // Chỉ cho phép các đường dẫn này mà không cần đăng nhập
                        .anyRequest().permitAll() // Các đường dẫn còn lại cần đăng nhập
                )
                .formLogin(form -> form
                        .loginPage("/users/show_signin_form") // Trang đăng nhập
                        .loginPage("/users/show_signup_form") // Xử lý đăng nhập
                        .defaultSuccessUrl("/users/home", true) // Điều hướng sau khi đăng nhập thành công
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/users/signout")
                        .logoutSuccessUrl("/users/guest") // Điều hướng sau khi đăng xuất
                        .permitAll()
                );

        return http.build();
    }


}