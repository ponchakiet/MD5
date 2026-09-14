# Bài tập 1: Xử lý sự cố sập Nginx (Vận dụng cơ bản)

## 1. Xác định nguyên nhân lỗi

**Thông báo lỗi:**
`nginx: [emerg] unexpected "proxy_set_header" in /etc/nginx/sites-enabled/app.conf:7`

**Nguyên nhân thực sự:**
Mặc dù thông báo lỗi chỉ điểm ở dòng số 7 (`proxy_set_header`), nhưng nguyên nhân gốc rễ là do cấu hình bị **thiếu dấu chấm phẩy (`;`)** ở cuối dòng lệnh `proxy_pass http://localhost:8080` nằm ngay phía trước đó.

Do thiếu dấu kết thúc câu, Nginx đọc tràn sang dòng tiếp theo và không hiểu được cú pháp, dẫn đến việc ném ra lỗi `unexpected`.

---

## 2. Cấu hình đã sửa (`app.conf`)

Cú pháp đã được khắc phục bằng cách bổ sung dấu `;` vào cuối chỉ thị `proxy_pass`.

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:8080; # <- Đã bổ sung dấu chấm phẩy tại đây
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 3. Các lệnh kiểm tra và vận hành

- `sudo nginx -t`: Kiểm tra cú pháp file cấu hình
- `sudo systemctl reload nginx`: Tải lại cấu hình mà không làm gián đoạn dịch vụ
- `sudo systemctl restart nginx`: Khởi động lại toàn bộ dịch vụ Nginx

