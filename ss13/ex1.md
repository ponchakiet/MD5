# Bài 1: Khắc phục lỗi Scrape Metrics (Vận dụng cơ bản)

## 1. Giải quyết vấn đề mạng (Localhost trong Docker)
*   **Nguyên nhân:** Nếu Prometheus được chạy bằng Docker (Container) còn Backend chạy trực tiếp trên máy chủ thật (Host), thì chữ `localhost` trong file cấu hình sẽ trỏ vào **chính mạng nội bộ của container Prometheus đó**, chứ không trỏ ra ngoài máy chủ Host. Do đó, Prometheus không thể tìm thấy cổng 8080 và báo lỗi `connection refused`.
*   **Cách khắc phục:** Cần thay thế `localhost` bằng `host.docker.internal` (DNS đặc biệt giúp container truy cập ngược ra host) hoặc sử dụng trực tiếp **IP thật của VPS/máy chủ**.

## 2. Giải đáp câu hỏi "Bẫy" (Metrics Endpoint)
*   **Endpoint mặc định:** Theo mặc định, Prometheus sẽ tự động gọi vào đường dẫn `/metrics` để thu thập (scrape) dữ liệu.
*   **Endpoint của Spring Boot:** Tuy nhiên, đối với ứng dụng Spring Boot (sử dụng thư viện Actuator), endpoint cung cấp dữ liệu cho Prometheus lại nằm ở đường dẫn `/actuator/prometheus`.
*   **Kết luận:** Do có sự sai khác này, ta **bắt buộc phải thêm chỉ thị `metrics_path`** vào cấu hình để ghi đè đường dẫn mặc định, hướng Prometheus gọi đúng vào `/actuator/prometheus`.

## 3. Cấu hình `prometheus.yml` đã sửa
Dưới đây là cấu hình hoàn chỉnh sau khi khắc phục cả 2 lỗi trên:

```yaml
scrape_configs:
  - job_name: 'backend'
    # Khai báo lại đường dẫn metrics chuẩn của Spring Boot Actuator
    metrics_path: '/actuator/prometheus' 
    static_configs:
      # Sử dụng host.docker.internal hoặc IP thật của VPS để gọi ra ngoài container
      - targets: ['host.docker.internal:8080']
```
