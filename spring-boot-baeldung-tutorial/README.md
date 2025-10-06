# 🚀 Spring Boot Baeldung Tutorial

Bu proje, [Baeldung'daki Spring Boot başlangıç rehberini](https://www.baeldung.com/spring-boot-start) takip ederek oluşturulan basit bir Spring Boot uygulamasıdır.

## 📋 İçindekiler

- [Proje Hakkında](#-proje-hakkında)
- [Özellikler](#-özellikler)
- [Teknolojiler](#-teknolojiler)
- [Kurulum](#-kurulum)
- [Kullanım](#-kullanım)
- [API Endpoints](#-api-endpoints)
- [Test Etme](#-test-etme)
- [Proje Yapısı](#-proje-yapısı)
- [Konfigürasyon](#-konfigürasyon)

## 🎯 Proje Hakkında

Bu proje, Spring Boot'un temel özelliklerini öğrenmek ve uygulamak için oluşturulmuştur. Baeldung'daki rehberi takip ederek:

- ✅ Spring Boot uygulaması oluşturma
- ✅ REST API endpoint'leri geliştirme
- ✅ Maven ile bağımlılık yönetimi
- ✅ Otomatik yapılandırma kullanma
- ✅ Test yazma
- ✅ Uygulama ayarları yapma

## 🌟 Özellikler

- **REST API**: Çeşitli HTTP endpoint'leri
- **JSON Response**: Yapılandırılmış JSON yanıtları
- **Health Check**: Uygulama sağlık kontrolü
- **Hot Reload**: Geliştirme sırasında otomatik yeniden yükleme
- **Logging**: Detaylı log sistemi
- **Testing**: Birim ve entegrasyon testleri
- **Turkish Support**: Türkçe mesajlar ve tarih formatı

## 🛠 Teknolojiler

- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Web**
- **Spring Boot DevTools**
- **Spring Boot Test**
- **Maven**
- **JUnit 5**

## 📦 Kurulum

### Gereksinimler

- Java 17 veya üzeri
- Maven 3.6 veya üzeri

### Adımlar

1. **Projeyi klonlayın:**
   ```bash
   git clone <repository-url>
   cd spring-boot-baeldung-tutorial
   ```

2. **Bağımlılıkları indirin:**
   ```bash
   mvn clean install
   ```

3. **Uygulamayı çalıştırın:**
   ```bash
   mvn spring-boot:run
   ```

   Alternatif olarak:
   ```bash
   java -jar target/spring-boot-baeldung-tutorial-1.0.0.jar
   ```

4. **Tarayıcınızda açın:**
   ```
   http://localhost:8080
   ```

## 🚀 Kullanım

Uygulama başlatıldıktan sonra aşağıdaki URL'leri kullanabilirsiniz:

### Ana Sayfa
```
http://localhost:8080/
```

### Merhaba Mesajı
```
http://localhost:8080/hello
http://localhost:8080/hello?name=YourName
http://localhost:8080/hello/YourName
```

### Uygulama Bilgileri
```
http://localhost:8080/info
```

### Sağlık Kontrolü
```
http://localhost:8080/health
```

## 🔗 API Endpoints

| Method | Endpoint | Açıklama | Örnek Response |
|--------|----------|----------|----------------|
| GET | `/` | Ana sayfa mesajı | `"🎉 Merhaba! Spring Boot uygulamanız başarıyla çalışıyor! 🚀"` |
| GET | `/hello` | Varsayılan merhaba | `{"mesaj": "Merhaba, Dünya!", "zaman": "...", "durum": "başarılı"}` |
| GET | `/hello?name=Test` | Parametreli merhaba | `{"mesaj": "Merhaba, Test!", "zaman": "...", "durum": "başarılı"}` |
| GET | `/hello/{name}` | Path variable ile merhaba | `{"mesaj": "Merhaba, {name}! (Path variable ile)", ...}` |
| GET | `/info` | Uygulama bilgileri | `{"uygulama": "...", "versiyon": "1.0.0", ...}` |
| GET | `/health` | Sağlık durumu | `{"durum": "SAĞLIKLI", "mesaj": "...", "zaman": "..."}` |

## 🧪 Test Etme

### Tüm testleri çalıştırma:
```bash
mvn test
```

### Belirli bir test sınıfını çalıştırma:
```bash
mvn test -Dtest=ApplicationTest
mvn test -Dtest=HelloControllerTest
```

### Test kapsamı:
- ✅ Context yükleme testi
- ✅ Controller endpoint testleri
- ✅ JSON response testleri
- ✅ HTTP status kodları testleri

## 📁 Proje Yapısı

```
spring-boot-baeldung-tutorial/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/baeldung/spring/
│   │   │       ├── Application.java              # Ana uygulama sınıfı
│   │   │       └── controller/
│   │   │           └── HelloController.java      # REST Controller
│   │   └── resources/
│   │       ├── application.properties            # Uygulama ayarları
│   │       └── banner.txt                        # Başlangıç banner'ı
│   └── test/
│       └── java/
│           └── com/baeldung/spring/
│               ├── ApplicationTest.java          # Uygulama testi
│               └── controller/
│                   └── HelloControllerTest.java  # Controller testleri
├── pom.xml                                       # Maven konfigürasyonu
└── README.md                                     # Bu dosya
```

## ⚙️ Konfigürasyon

### application.properties

Uygulama ayarları `src/main/resources/application.properties` dosyasında bulunur:

```properties
# Server ayarları
server.port=8080

# Uygulama bilgileri
spring.application.name=Spring Boot Baeldung Tutorial

# Logging ayarları
logging.level.root=INFO
logging.level.com.baeldung.spring=DEBUG

# JSON ayarları
spring.jackson.serialization.indent-output=true
spring.jackson.date-format=dd-MM-yyyy HH:mm:ss
spring.jackson.time-zone=Europe/Istanbul
```

### Banner

Özel başlangıç banner'ı `src/main/resources/banner.txt` dosyasında tanımlanmıştır.

## 🔧 Geliştirme

### Hot Reload

Spring Boot DevTools sayesinde kod değişiklikleriniz otomatik olarak uygulamaya yansır.

### Profil Kullanımı

Farklı ortamlar için profil kullanabilirsiniz:

```bash
# Development profili
mvn spring-boot:run -Dspring-boot.run.profiles=dev

# Production profili
mvn spring-boot:run -Dspring-boot.run.profiles=prod
```

## 📚 Kaynaklar

- [Baeldung Spring Boot Tutorial](https://www.baeldung.com/spring-boot-start)
- [Spring Boot Documentation](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Spring Framework Documentation](https://docs.spring.io/spring-framework/docs/current/reference/html/)

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje eğitim amaçlı oluşturulmuştur.

---

**Not:** Bu proje Baeldung'daki "Spring Boot Tutorial – Bootstrap a Simple Application" rehberini takip ederek oluşturulmuştur. Türkçe açıklamalar ve ek özellikler eklenmiştir.

🎉 **Mutlu kodlamalar!** 🚀
