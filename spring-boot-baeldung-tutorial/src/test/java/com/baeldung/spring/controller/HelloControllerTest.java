package com.baeldung.spring.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * HelloController Test Sınıfı
 * 
 * Bu test sınıfı, HelloController'daki endpoint'lerin doğru çalıştığını test eder.
 */
@WebMvcTest(HelloController.class)
class HelloControllerTest {

    @Autowired
    private MockMvc mockMvc;

    /**
     * Ana endpoint testi
     * GET / endpoint'inin doğru mesajı döndürdüğünü test eder
     */
    @Test
    void testIndex() throws Exception {
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(content().string("🎉 Merhaba! Spring Boot uygulamanız başarıyla çalışıyor! 🚀"));
    }

    /**
     * Hello endpoint testi (varsayılan parametre ile)
     * GET /hello endpoint'inin varsayılan parametreyle doğru çalıştığını test eder
     */
    @Test
    void testHelloDefault() throws Exception {
        mockMvc.perform(get("/hello"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.mesaj").value("Merhaba, Dünya!"))
                .andExpect(jsonPath("$.durum").value("başarılı"));
    }

    /**
     * Hello endpoint testi (özel parametre ile)
     * GET /hello?name=Test endpoint'inin özel parametreyle doğru çalıştığını test eder
     */
    @Test
    void testHelloWithParameter() throws Exception {
        mockMvc.perform(get("/hello?name=Test"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.mesaj").value("Merhaba, Test!"))
                .andExpect(jsonPath("$.durum").value("başarılı"));
    }

    /**
     * Path variable ile hello endpoint testi
     * GET /hello/{name} endpoint'inin doğru çalıştığını test eder
     */
    @Test
    void testHelloWithPath() throws Exception {
        mockMvc.perform(get("/hello/Spring"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.mesaj").value("Merhaba, Spring! (Path variable ile)"))
                .andExpect(jsonPath("$.durum").value("başarılı"));
    }

    /**
     * Info endpoint testi
     * GET /info endpoint'inin uygulama bilgilerini döndürdüğünü test eder
     */
    @Test
    void testInfo() throws Exception {
        mockMvc.perform(get("/info"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.uygulama").value("Spring Boot Baeldung Tutorial"))
                .andExpect(jsonPath("$.versiyon").value("1.0.0"));
    }

    /**
     * Health endpoint testi
     * GET /health endpoint'inin sağlık durumunu döndürdüğünü test eder
     */
    @Test
    void testHealth() throws Exception {
        mockMvc.perform(get("/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.durum").value("SAĞLIKLI"))
                .andExpect(jsonPath("$.mesaj").value("Uygulama normal çalışıyor"));
    }
}
