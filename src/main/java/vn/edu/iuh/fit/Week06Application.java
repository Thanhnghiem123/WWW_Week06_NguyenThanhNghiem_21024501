package vn.edu.iuh.fit;

import jakarta.annotation.PostConstruct;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.TimeZone;

@SpringBootApplication
public class Week06Application {

    public static void main(String[] args) {
        SpringApplication.run(Week06Application.class, args);
    }
//    @PostConstruct
//    public void init() {
//        // Set múi giờ mặc định cho toàn bộ ứng dụng
//        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
//    }
}
