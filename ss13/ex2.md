# Bài 2: Bật Radar cho Spring Boot (Actuator)

## 1. Bổ sung Dependency (Giải quyết câu hỏi "Bẫy")
*   **Giải đáp bẫy:** Việc chỉ thêm dependency `spring-boot-starter-actuator` sẽ giúp dự án mở các endpoint giám sát, nhưng dữ liệu trả về mặc định sẽ ở định dạng JSON. Prometheus không thể đọc được định dạng này. Để phơi bày dữ liệu theo chuẩn định dạng text của Prometheus, **dependency còn thiếu bắt buộc phải thêm vào là `micrometer-registry-prometheus`**.
*   **Cập nhật file `build.gradle`:**

```gradle
dependencies {
    // ... các thư viện hiện có của dự án ...
    
    // Thư viện Actuator để mở khóa các endpoint giám sát
    implementation 'org.springframework.boot:spring-boot-starter-actuator'
    
    // Thư viện format dữ liệu sang chuẩn của Prometheus (Dependency bắt buộc bổ sung)
    implementation 'io.micrometer:micrometer-registry-prometheus'
}
```
## 2. Cấu hình `application.yml` (Giải quyết câu hỏi "Bẫy")

```yaml
management:
  endpoints:
    web:
      exposure:
        # Chỉ mở khóa các endpoint thực sự cần thiết cho việc giám sát
        include: "prometheus, health, info"
        
        # Đảm bảo đóng các endpoint nguy hiểm như /actuator/shutdown hoặc /actuator/env
        exclude: "shutdown, env"
        
  endpoint:
    prometheus:
      # Kích hoạt endpoint /actuator/prometheus
      enabled: true
```


