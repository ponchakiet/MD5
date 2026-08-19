# Báo cáo Thực hành Session 04: Container hóa ứng dụng User Service
**Dự án:** user-service

---

## I. Các bước thực hiện

### 1. Đóng gói ứng dụng (Dockerfile)
- Thực hiện build dự án `user-service` thành file `.jar`.
- Tạo file `Dockerfile` sử dụng base image `eclipse-temurin:17-jre-alpine`.
- Copy file `.jar` vào container và thiết lập lệnh khởi chạy `ENTRYPOINT ["java", "-jar", "app.jar"]`.

### 2. Thiết lập hệ thống (Docker Compose)
- Tạo file `docker-compose.yml` gồm 2 services:
  - **db:** Sử dụng image `postgres:15-alpine`, cấu hình biến môi trường khởi tạo database `user_db_test`. Khai báo volume `user_db_data` để lưu trữ dữ liệu bền vững.
  - **user-service:** Build từ thư mục hiện tại, ánh xạ port `8080:8080`, cấu hình chuỗi kết nối trỏ tới service `db` và database `user_db_test`.
- Tạo network nội bộ `user_network` để 2 services giao tiếp với nhau.

### 3. Khởi chạy và Kiểm tra
- Khởi chạy toàn bộ hệ thống ở chế độ ngầm bằng lệnh: `docker compose up -d --build`.
- Kiểm tra trạng thái các container bằng lệnh: `docker compose ps`.

## II. Minh chứng thực hành

### Ảnh 1: Trạng thái hệ thống (Up)
*(Chèn ảnh chụp màn hình lệnh `docker compose ps` cho thấy 2 container đang chạy tại đây)*


### Ảnh 2: Log khởi chạy thành công
*(Chèn ảnh chụp màn hình lệnh `docker compose logs -f user-service` cho thấy ứng dụng khởi chạy và kết nối DB `user_db_test` thành công tại đây)*


### Ảnh 3: Dọn dẹp hệ thống
- Thực hiện lệnh `docker compose down` để dừng và xóa container/network nhưng vẫn giữ lại volume dữ liệu.

*(Chèn ảnh chụp màn hình hiển thị log dọn dẹp thành công tại đây)*