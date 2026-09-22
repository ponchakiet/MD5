# Bài tập 1: Sửa lỗi mất kết nối Grafana - Prometheus

## 1. Đọc log lỗi của Grafana
Khi Grafana không thể kết nối đến Prometheus do thay đổi IP, log của Grafana (có thể xem bằng lệnh `docker logs <tên_container_grafana>`) thường sẽ hiển thị các lỗi liên quan đến việc không thể kết nối (như `connection refused`, `timeout`, hoặc `no route to host`) tới địa chỉ `http://192.168.1.15:9090`.

## 2. Sửa file cấu hình `datasource.yml`
Nội dung file sau khi sửa:

```yaml
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    url: http://prometheus:9090
    access: proxy
    isDefault: true
```

## 3. Khởi động lại Grafana và kiểm tra kết nối
Để Grafana nhận cấu hình datasource mới từ provisioning, bạn cần khởi động lại container Grafana. 

Tại thư mục chứa file `docker-compose.yml`, chạy lệnh:
```bash
docker-compose restart grafana
```

**Các bước kiểm tra lại:**
1. Mở trình duyệt và đăng nhập vào Grafana.
2. Truy cập vào mục **Connections** > **Data sources** (hoặc Configuration > Data sources).
3. Chọn datasource **Prometheus**.
4. Cuộn xuống cuối trang và nhấn nút **Save & test**.
5. Nếu màn hình hiển thị thông báo "Data source is working", cấu hình đã thành công. Lúc này quay lại Dashboard, dữ liệu sẽ được hiển thị trở lại thay vì lỗi 'No data'.
