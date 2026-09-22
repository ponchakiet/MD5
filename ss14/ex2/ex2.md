# Giải bài 2: Vận dụng cơ bản - Vẽ biểu đồ sức khỏe VPS

Dưới đây là các câu truy vấn PromQL chuẩn xác và hướng dẫn tinh chỉnh trên Grafana để đáp ứng đầy đủ yêu cầu bài toán.

## 1. Biểu đồ Time series: Phần trăm sử dụng CPU

**Câu truy vấn PromQL:**
```promql
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

**Giải thích:**
- `node_cpu_seconds_total{mode="idle"}`: Lấy tổng số giây mà CPU ở trạng thái rảnh.
- `rate(...[5m])`: Tính tốc độ gia tăng trung bình (thời gian rảnh mỗi giây) trong khoảng thời gian 5 phút.
- `avg by (instance) (...)`: Nhóm và tính trung bình theo từng máy chủ (`instance`).
- `* 100`: Quy đổi ra tỷ lệ phần trăm (%).
- `100 - (...)`: Lấy 100% trừ đi phần trăm rảnh để ra kết quả cuối cùng là phần trăm CPU đang được sử dụng (Utilization).

**Cách hiển thị trên Grafana:**
- Đảm bảo chọn loại biểu đồ là **Time series**.
- Trong phần cài đặt Panel bên phải, tìm đến **Standard options**.
- Ở ô **Unit**, tìm từ khóa `percent` và chọn **Percent (0-100)** để trục Y của biểu đồ hiển thị đúng đơn vị `%`.

---

## 2. Biểu đồ Stat: Tổng lượng RAM còn trống

**Câu truy vấn PromQL:**
```promql
node_memory_MemFree_bytes
```

**Cách giải quyết "bẫy" hiển thị dữ liệu (Từ Bytes sang MB/GB):**
Truy vấn trên sẽ trả về con số tĩnh có đơn vị là Bytes (ví dụ: `1504561152`). Thay vì viết phép chia loằng ngoằng trong PromQL (`/ 1024 / 1024`), ta có thể để Grafana xử lý việc hiển thị một cách đẹp mắt như sau:

1. Đảm bảo chọn loại biểu đồ là **Stat** (hiển thị con số thông kê).
2. Phía bên phải giao diện cấu hình Panel, kéo xuống phần **Standard options**.
3. Tại mục **Unit** (mặc định là `none`), click vào và gõ từ khóa `bytes`.
4. Trong danh sách xổ xuống, chọn **Bytes (IEC)** (nếu muốn hiển thị KiB, MiB, GiB - chia theo cơ số 1024) hoặc **Bytes (SI)** (nếu muốn hiển thị kB, MB, GB - chia theo cơ số 1000).
5. Lúc này, Grafana sẽ tự động nhận diện giá trị, rút gọn độ dài và gắn đơn vị lớn hơn cho phù hợp nhất (ví dụ hiển thị thành `1.4 GiB`). Tùy chỉnh thêm ở ô **Decimals** để giới hạn số phần thập phân.
