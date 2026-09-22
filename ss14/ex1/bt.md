Sử dụng http://localhost:9090 hay http://prometheus:9090?
CÂU TRẢ LỜI CHÍNH XÁC: URL truyền vào Grafana bắt buộc phải là: http://prometheus:9090

Giải thích lý do dựa trên kiến trúc mạng của Docker Compose:

Bản chất của từ khóa localhost bên trong container: Khi Grafana chạy dưới dạng một Docker container, từ khóa localhost (hoặc 127.0.0.1) đối với nó có nghĩa là "chính bản thân container Grafana này". Vì bên trong container Grafana không hề chạy dịch vụ Prometheus nào ở port 9090, nên nếu bạn điền http://localhost:9090, Grafana sẽ tự gọi vào chính nó và báo lỗi kết nối (Connection refused).

Cơ chế phân giải DNS của Docker Network: Khi các container cùng nằm trong một cụm Docker Compose (chung một mạng mặc định), Docker sẽ kích hoạt một máy chủ DNS nội bộ. Máy chủ DNS này tự động ánh xạ tên của service (được định nghĩa trong file yaml) thành địa chỉ IP nội bộ của container đó.

Vì vậy, container Grafana muốn giao tiếp với container Prometheus thì phải gọi qua tên định danh của Prometheus trong mạng nội bộ, tức là prometheus. Docker sẽ tự hiểu và định tuyến gói tin từ Grafana sang đúng IP nội bộ của Prometheus ở port 9090 mà không cần đi vòng qua Internet hay card mạng của máy Host.