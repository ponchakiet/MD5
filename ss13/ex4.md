# Bài 4: Liên minh Docker Compose (Prometheus + App)

## 1. File `docker-compose.yml` hoàn chỉnh
Để chạy song song ứng dụng Spring Boot và Prometheus trong cùng một mạng nội bộ (mặc định của Docker Compose) và nạp file cấu hình từ máy Host, ta viết file `docker-compose.yml` như sau:

```yaml
version: '3.8'

services:
  ecommerce-api:
    image: my-spring-boot-app:latest # Thay bằng tên image thực tế của bạn
    container_name: ecommerce-api
    # Cố tình KHÔNG khai báo 'ports' để tránh lộ port ra ngoài Internet.
    # Các container trong cùng compose file mặc định đã giao tiếp được với nhau.

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090" # Mở port 9090 để Dev xem dashboard
    volumes:
      # Nạp file prometheus.yml từ máy Host vào container bằng tính năng Bind Mount
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      # Flag cực kỳ quan trọng bắt buộc phải có để bật tính năng hot-reload qua API
      - '--web.enable-lifecycle'
```

## 2. File prometheus.yml

```yaml
scrape_configs:
  - job_name: 'ecommerce-api'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['ecommerce-api:8080']
```

## 3. Giải đáp câu hỏi "Bẫy"
- Vấn đề: Khi ta sửa nội dung file prometheus.yml trên máy chủ Host, Prometheus đang chạy sẽ KHÔNG tự động nhận cấu hình mới.

- Cách giải quyết (Không cần Restart): Thay vì phải khởi động lại (Restart) container gây gián đoạn hệ thống (downtime), Prometheus cung cấp một API đặc biệt để ép tải lại cấu hình (hot-reload). Ta chỉ cần gọi một API HTTP POST tới endpoint /-/reload.

- Câu lệnh cần gọi:
```bash
curl -X POST http://localhost:9090/-/reload
```