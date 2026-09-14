# Bài tập 4: Tích hợp UFW và Docker (Vận dụng chuyên sâu)

## 1. Cấu hình `docker-compose.yml` mới

Để ngăn chặn Docker tự động public cổng 8080 ra internet (vượt mặt tường lửa UFW), chúng ta cần thay đổi cấu hình binding port từ tất cả các card mạng (mặc định là `0.0.0.0`) sang chỉ dùng card mạng nội bộ (`127.0.0.1`).

File `docker-compose.yml` sau khi chỉnh sửa:

```yaml
version: '3'
services: 
  backend: 
    image: my-spring-boot-app:latest 
    ports: 
      # Chỉ định rõ ràng IP localhost (127.0.0.1) để chặn truy cập từ bên ngoài
      - "127.0.0.1:8080:8080"
````

## 2. Giải thích cơ chế bảo mật của Port Mapping
- Vấn đề mặc định của Docker: Khi ta sử dụng cú pháp ngắn gọn ports: - "8080:8080", Docker sẽ ngầm định bind port này vào 0.0.0.0:8080:8080 (mở trên mọi giao diện mạng). Đồng thời, Docker tự động tạo ra các luật (rules) trong iptables với độ ưu tiên cao hơn cả UFW. Hậu quả là request từ bên ngoài Internet đi thẳng vào Docker, lách qua lớp bảo vệ của UFW.

- Cách khắc phục: Bằng cách thêm 127.0.0.1 vào trước (thành 127.0.0.1:8080:8080), ta ép Docker chỉ được phép ánh xạ cổng 8080 vào loopback interface (mạng ảo chỉ tồn tại bên trong chính máy chủ đó).

- Hiệu quả đạt được:

  - Hacker hoặc người dùng bình thường cố tình gõ http://<IP_Public_VPS>:8080 từ bên ngoài sẽ bị máy chủ từ chối kết nối ngay lập tức.

  - Tuy nhiên, dịch vụ Nginx vì được cài đặt trực tiếp trên cùng một máy chủ vật lý này nên nó vẫn "nhìn thấy" và giao tiếp được với container Backend thông qua địa chỉ nội bộ http://localhost:8080. Hệ thống Reverse Proxy vẫn hoạt động bình thường, an toàn và bảo mật hơn.