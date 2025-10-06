package com.baeldung.spring;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Spring Boot Ana Uygulama Sınıfı
 * 
 * @SpringBootApplication anotasyonu şu üç anotasyonu içerir:
 * - @Configuration: Bu sınıfın bir yapılandırma sınıfı olduğunu belirtir
 * - @EnableAutoConfiguration: Spring Boot'un otomatik yapılandırmasını etkinleştirir
 * - @ComponentScan: Bu paket ve alt paketlerdeki Spring bileşenlerini tarar
 */
@SpringBootApplication(scanBasePackages = "com.baeldung.spring")
public class Application {

    /**
     * Uygulamanın başlangıç noktası
     * Spring Boot uygulamasını başlatır
     * 
     * @param args komut satırı argümanları
     */
    public static void main(String[] args) {
        // Spring Boot uygulamasını başlat
        SpringApplication.run(Application.class, args);
        
        System.out.println("=================================");
        System.out.println("🚀 Spring Boot Uygulaması Başlatıldı!");
        System.out.println("📍 http://localhost:8080 adresinden erişebilirsiniz");
        System.out.println("=================================");
    }
}
