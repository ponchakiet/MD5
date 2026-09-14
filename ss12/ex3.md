# Bài tập 3: Cấu hình Header Security (Vận dụng chuyên sâu)

## 1. Đoạn cấu hình Nginx đã cập nhật
Để bảo vệ ứng dụng khỏi các lỗ hổng bảo mật web phổ biến, các directive `add_header` đã được bổ sung vào khối cấu hình cơ sở:

```nginx
server {
    listen 443 ssl;
    server_name secure.example.com;
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;

    # Bổ sung các cấu hình Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    location / {
        proxy_pass http://localhost:8080;
    }
}
```

## 2. Ý nghĩa của các Header Bảo mật
- X-Frame-Options: SAMEORIGIN: Ngăn chặn tấn công Clickjacking bằng cách không cho phép trang web bị nhúng vào các thẻ <frame hay <iframe của một tên miền lạ (chỉ cho phép nhúng trên cùng một nguồn gốc).

- X-Content-Type-Options: nosniff: Ngăn chặn tấn công MIME-sniffing. Lệnh này ép trình duyệt phải tuân thủ nghiêm ngặt định dạng file (Content-Type) mà server trả về, không được tự ý phán đoán (sniff) loại nội dung.

- Strict-Transport-Security (HSTS): Ép buộc trình duyệt của người dùng luôn phải giao tiếp với server thông qua giao thức mã hóa HTTPS trong khoảng thời gian quy định là 1 năm (max-age=31536000 giây), đồng thời áp dụng chính sách này cho tất cả các subdomain (includeSubDomains).

## 3. Câu lệnh kiểm chứng (Curl)

```bash
curl -I [https://secure.example.com](https://secure.example.com)
```
