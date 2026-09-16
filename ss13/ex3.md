# Bài 3: Khám sức khỏe máy chủ với Node Exporter (Vận dụng chuyên sâu)

## 1. Triển khai Node Exporter bằng Docker Compose
Để thu thập các thông số cấp thấp của hệ điều hành và phần cứng máy chủ Host, ta tiến hành chạy Node Exporter dưới dạng một container.

Bổ sung cấu hình sau vào file `docker-compose.yml`:

```yaml
services:
  # ... (các service khác nếu có) ...

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    ports:
      - "9100:9100"
    # Bắt buộc phải mount các thư mục hệ thống của máy Host vào container để Node Exporter có thể đọc được dữ liệu thật
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
```

## 2. Cấu hình Prometheus để lấy dữ liệu (Scrape Config)

```yaml
scrape_configs:
  # (Job backend của bài tập trước giữ nguyên)
  - job_name: 'backend'
    metrics_path: '/actuator/prometheus' 
    static_configs:
      - targets: ['host.docker.internal:8080'] 

  # Bổ sung job mới cho Node Exporter
  - job_name: 'node-exporter'
    static_configs:
      # Sử dụng host.docker.internal (nếu chạy local) hoặc IP thật của VPS để gọi đến port 9100
      - targets: ['host.docker.internal:9100']
```

## 3. Giải thích ý nghĩa nghiệp vụ
- Tại sao lại cần Node Exporter? Prometheus đóng vai trò là kho lưu trữ và công cụ truy vấn tập trung, nhưng nó không có khả năng tự động hiểu được phần cứng của máy chủ. Node Exporter được sinh ra để làm nhiệm vụ "phiên dịch" — nó đọc các chỉ số tài nguyên từ hệ điều hành Linux (qua /proc và /sys) rồi chuyển đổi thành chuẩn dữ liệu dạng text mà Prometheus có thể hiểu được.

- Port mặc định: Node Exporter luôn giao tiếp qua cổng 9100.
