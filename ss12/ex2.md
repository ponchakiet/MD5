# Bài tập 2: Tối ưu Timeout cho Proxy (Vận dụng cơ bản)

## 1. Đoạn cấu hình Nginx đã cập nhật
Để khắc phục lỗi `504 Gateway Time-out` và cho phép Nginx chờ ứng dụng Backend xử lý lên đến 120 giây, cấu hình đã được cập nhật như sau:

```nginx
server {
    listen 80;
    server_name api.example.com;

    location /api/export/ {
        proxy_pass http://localhost:8080;
        
        # Bổ sung cấu hình timeout 120 giây
        proxy_connect_timeout 120s;
        proxy_send_timeout 120s;
        proxy_read_timeout 120s;
    }
}
```

## 2. Giải thích các chỉ thị timeout
Để đảm bảo kết nối không bị ngắt một cách triệt để, ta cấu hình 3 chỉ thị timeout liên quan đến proxy:

- proxy_read_timeout 120s; (Quan trọng nhất trong tình huống này): Thời gian tối đa Nginx chờ để đọc (nhận) dữ liệu phản hồi từ Backend. Vì Backend cần 90 giây để export báo cáo, việc tăng tham số này lên 120 giây giúp Nginx giữ kết nối, kiên nhẫn chờ đợi kết quả mà không vội vàng ném ra lỗi 504.

- proxy_connect_timeout 120s;: Thời gian tối đa Nginx chờ để thiết lập thành công một kết nối mạng với Backend.

- proxy_send_timeout 120s;: Thời gian tối đa Nginx chờ để gửi toàn bộ dữ liệu của request (từ người dùng) sang cho Backend.