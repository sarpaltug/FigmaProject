package com.baeldung.spring;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

/**
 * Spring Boot Uygulama Test Sınıfı
 * 
 * Bu test, uygulamanın context'inin düzgün yüklendiğini kontrol eder.
 */
@SpringBootTest
@TestPropertySource(locations = "classpath:application.properties")
class ApplicationTest {

    /**
     * Context yükleme testi
     * Bu test, Spring Boot uygulamasının context'inin başarıyla yüklendiğini kontrol eder.
     */
    @Test
    void contextLoads() {
        // Bu test, Spring Boot context'inin başarıyla yüklenmesini test eder
        // Eğer context yüklenemezse, test başarısız olur
        System.out.println("✅ Spring Boot context başarıyla yüklendi!");
    }
}
