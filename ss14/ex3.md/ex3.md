# Giải bài 3: Vận dụng chuyên sâu - Import Template Dashboard

## 1. Thao tác Import Dashboard bằng ID (ID: 4701)

Thay vì phải tự tay thiết lập từng biểu đồ tốn hàng tuần, Grafana cho phép tận dụng hàng ngàn mẫu Dashboard được thiết kế sẵn cực kỳ tối ưu. Các bước Import:

1. Lấy ID của Dashboard trên trang chủ Grafana Labs (Ví dụ template nổi tiếng cho JVM Micrometer là **4701**).
2. Đăng nhập Grafana, di chuột sang thanh menu bên trái, nhấn vào biểu tượng **dấu cộng (+)** (hoặc menu **Dashboards**) -> Chọn **Import**.
3. Tại ô **Import via grafana.com**, bạn nhập/dán số ID `4701` vào và nhấn nút **Load** ở bên cạnh.
4. Tại màn hình cấu hình Option:
   - **Name**: Đặt lại tên Dashboard (nếu cần).
   - **Prometheus** (Quan trọng nhất): Ở dòng dưới cùng yêu cầu Data Source, hãy mở menu xổ xuống và chọn chính xác Data source Prometheus mà bạn đã kết nối.
5. Nhấn nút **Import**. Ngay lập tức một bảng điều khiển xịn sò, đầy đủ thông số sẽ hiện ra.

---

## 2. Phân tích 3 biểu đồ quan trọng nhất của ứng dụng Java (JVM)

Trong một Dashboard của Spring Boot có hàng chục biểu đồ, nhưng 3 biểu đồ dưới đây là "mạch máu" mà DevOps/Developer phải nhìn đầu tiên:

### a) JVM Heap Memory (Bộ nhớ Heap)
- **Hình dáng biểu đồ:** Thường có dạng hình "răng cưa" (Tăng lên từ từ rồi rớt xuống đột ngột do Garbage Collector dọn dẹp).
- **Ý nghĩa & Quan trọng:** Biểu đồ này giám sát lượng RAM mà Java cấp phát để khởi tạo các Object trong quá trình chạy. Nếu bạn thấy đỉnh của các "răng cưa" ngày một dâng cao dần theo thời gian mà không giảm xuống, ứng dụng đang bị rò rỉ bộ nhớ (**Memory Leak**). Nếu chạm trần (Max Heap), hệ thống sẽ sập với lỗi kinh điển `OutOfMemoryError`.

### b) Garbage Collection Pause Time (Thời gian dọn rác)
- **Hình dáng biểu đồ:** Các cột hiển thị thời gian tính bằng ms (Mili-giây).
- **Ý nghĩa & Quan trọng:** Khi bộ nhớ đầy, JVM kích hoạt Garbage Collection (GC) đi dọn rác. Đáng sợ là đa phần các thuật toán GC bắt buộc phải tạm dừng toàn bộ ứng dụng (Stop-the-world) để dọn dẹp. Nếu biểu đồ này tăng vọt (nhiều giây), ứng dụng sẽ bị treo cứng trong khoảng thời gian đó, dẫn đến API Time-out và trải nghiệm người dùng tệ hại. 

### c) JVM Threads (Số lượng luồng xử lý)
- **Hình dáng biểu đồ:** Đường kẻ ngang thể hiện số lượng Live threads, Daemon threads.
- **Ý nghĩa & Quan trọng:** Trong mô hình Spring Boot MVC, mỗi HTTP Request đến được cấp 1 Thread. Nếu lượng Live Threads tăng dựng đứng và kịch trần giới hạn (Pool size), nguyên nhân có thể do Database quá tải không trả về kết quả, hoặc code bị Deadlock (tắc nghẽn). Ứng dụng sẽ không thể nhận thêm bất kỳ request nào nữa.

---

## 3. Cách gỡ "Bẫy" Dashboard báo lỗi No Data

**Tình huống bẫy:** Sau khi hớn hở Import thành công Dashboard `4701`, đập vào mắt là 100% biểu đồ báo chữ `No data`. Bạn nhìn lên thanh công cụ (Variables) trên cùng thì thấy ô `application` đang trống rỗng.

**Nguyên nhân:**
Template `4701` được tác giả viết câu truy vấn PromQL đính kèm với bộ lọc theo nhãn (tag) tên là `application` (để phân biệt giữa 10 cái microservices khác nhau cùng gửi metric về). Tuy nhiên, mặc định Spring Boot không tự động gửi tên ứng dụng của nó vào metrics. Khiến Prometheus không có tag đó, Grafana thì lọc theo tag đó sinh ra `No data`.

**Cách khắc phục:**
Bạn cần báo cho Spring Boot Actuator gắn cái nhãn tên ứng dụng vào mọi metric nó xuất ra.
Mở file `application.yml` của dự án Spring Boot và bổ sung đoạn cấu hình sau:

```yaml
management:
  metrics:
    tags:
      application: MySpringBootApp
```

**Kết quả:** Sau khi Restart ứng dụng Spring Boot vài giây, Prometheus sẽ lấy số liệu mới có kèm tag `application`. F5 lại Grafana, ở góc trên cùng bạn sẽ chọn được `MySpringBootApp` và các biểu đồ sẽ nhảy múa tràn ngập data!
