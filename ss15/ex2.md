# Bài tập 2: Tối ưu hóa chu kỳ Scrape

## 1. Mở và chỉnh sửa file `prometheus.yml`
Khi chu kỳ scrape (`scrape_interval`) được đặt quá ngắn (ví dụ `1s`), Prometheus sẽ liên tục gửi request đến các target để lấy dữ liệu. Điều này dẫn đến tình trạng quá tải (overload), ngốn nhiều CPU và RAM, đồng thời tạo ra lượng dữ liệu rất lớn có thể gây phình ổ cứng nhanh chóng

**Cấu hình ban đầu đang làm quá tải hệ thống:**
```yaml
global:
  scrape_interval: 1s
  evaluation_interval: 1s
```

**Sửa lại file `prometheus.yml` như sau:**
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'backend-app'
    static_configs:
      - targets: ['backend:8080']
```

## 2. Reload lại cấu hình Prometheus
Sau khi lưu file `prometheus.yml`, bạn cần yêu cầu Prometheus tải lại cấu hình mới để áp dụng thay đổi. Có hai cách phổ biến:

**Cách 1: Khởi động lại container (Phổ biến với Docker/Docker Compose)**
Tại thư mục chứa file `docker-compose.yml`, chạy lệnh:
```bash
docker-compose restart prometheus
```
**Cách 2: Gọi API Reload (Zero-downtime)**
Nếu Prometheus của bạn được khởi động với cờ `--web.enable-lifecycle`, bạn có thể reload cấu hình mà không cần khởi động lại tiến trình (tránh gián đoạn) bằng cách gửi một HTTP POST request:
```bash
curl -X POST http://localhost:9090/-/reload
```
*(Lưu ý: Đổi `localhost` thành địa chỉ/IP tương ứng của Prometheus nếu bạn gọi lệnh từ bên ngoài host).*

## 3. Kiểm tra kết quả
- Kiểm tra metric CPU, RAM (nếu có sử dụng cAdvisor hoặc Node Exporter) sẽ thấy tài nguyên hệ thống do Prometheus tiêu thụ giảm xuống rõ rệt.
- Log của Prometheus không còn xuất hiện các cảnh báo overload hay cảnh báo thời gian scrape quá dài.
- Trên Grafana, dashboard của ứng dụng (backend-app) vẫn hiển thị dữ liệu liên tục và được làm mới mỗi 15 giây mà không bị gián đoạn hay đứt gãy đồ thị.
