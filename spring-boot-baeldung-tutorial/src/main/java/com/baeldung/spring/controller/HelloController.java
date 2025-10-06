package com.baeldung.spring.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

/**
 * Basit REST Controller Sınıfı
 * 
 * @RestController anotasyonu, bu sınıfın bir REST web servisi controller'ı olduğunu belirtir.
 * Bu anotasyon @Controller ve @ResponseBody anotasyonlarını birleştirir.
 */
@RestController
public class HelloController {

    /**
     * Ana endpoint - Basit merhaba mesajı döndürür
     * 
     * @return Merhaba mesajı
     */
    @GetMapping("/")
    public String index() {
        return "Merhaba Sarp, uygulaman harika bir şekilde çalışıyor";
    }

    /**
     * Merhaba endpoint'i - Parametre ile kişiselleştirilmiş mesaj
     * 
     * @param name isim parametresi (opsiyonel, varsayılan: "Dünya")
     * @return Kişiselleştirilmiş merhaba mesajı
     */
    @GetMapping("/hello")
    public Map<String, Object> hello(@RequestParam(value = "name", defaultValue = "Dünya") String name) {
        Map<String, Object> response = new HashMap<>();
        response.put("mesaj", "Merhaba, " + name + "!");
        response.put("zaman", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")));
        response.put("durum", "başarılı");
        
        return response;
    }

    /**
     * Path variable ile merhaba mesajı
     * 
     * @param name URL'den alınan isim
     * @return Kişiselleştirilmiş merhaba mesajı
     */
    @GetMapping("/hello/{name}")
    public Map<String, Object> helloWithPath(@PathVariable String name) {
        Map<String, Object> response = new HashMap<>();
        response.put("mesaj", "Merhaba, " + name + "! (Path variable ile)");
        response.put("zaman", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")));
        response.put("durum", "başarılı");
        
        return response;
    }

    /**
     * Uygulama bilgileri endpoint'i
     * 
     * @return Uygulama hakkında bilgiler
     */
    @GetMapping("/info")
    public Map<String, Object> info() {
        Map<String, Object> info = new HashMap<>();
        info.put("uygulama", "Spring Boot Baeldung Tutorial");
        info.put("versiyon", "1.0.0");
        info.put("aciklama", "Baeldung rehberini takip ederek oluşturulan basit Spring Boot uygulaması");
        info.put("java_versiyonu", System.getProperty("java.version"));
        info.put("zaman", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")));
        
        return info;
    }

    /**
     * Sağlık kontrolü endpoint'i
     * 
     * @return Uygulama durumu
     */
    @GetMapping("/health")
    public Map<String, String> health() {
        Map<String, String> status = new HashMap<>();
        status.put("durum", "SAĞLIKLI");
        status.put("mesaj", "Uygulama normal çalışıyor");
        status.put("zaman", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")));
        
        return status;
    }
}
