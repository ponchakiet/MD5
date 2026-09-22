# Bài tập 3: Xử lý cảnh báo giả (False Alarm)

## 1. Chỉnh sửa rule trong file `alert_rules.yml`
Việc đặt ngưỡng cảnh báo quá thấp (20%) và thời gian theo dõi quá ngắn (10 giây) sẽ khiến hệ thống liên tục phát ra các cảnh báo rác mỗi khi CPU có các đợt tăng vọt (spike) tạm thời do các tác vụ bình thường gây ra.

Để khắc phục, chúng ta cần chỉnh sửa lại cấu hình trong file `alert_rules.yml`. Cụ thể:
- Tăng ngưỡng (threshold) của biểu thức lên `> 85` (tức 85% CPU).
- Tăng thời gian theo dõi (thuộc tính `for`) lên `5m` (5 phút) để loại bỏ các đợt tăng tải tạm thời. Cảnh báo chỉ được gửi đi nếu tình trạng quá tải diễn ra liên tục trong 5 phút.

**Nội dung file sau khi sửa:**
```yaml
groups:
- name: CPU_Alerts
  rules:
  - alert: HighCPUUsage
    expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[1m])) * 100) > 85
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High CPU usage detected"
```

## 2. Sử dụng `promtool` để kiểm tra cú pháp
Trước khi yêu cầu Prometheus chạy cấu hình mới, một thực hành rất tốt (best practice) là kiểm tra xem file YAML có bị lỗi cú pháp hay không. Công cụ `promtool` (đi kèm với Prometheus) sẽ giúp thực hiện việc này.

Chạy lệnh sau tại thư mục chứa file `alert_rules.yml`:
```bash
promtool check rules alert_rules.yml
```
Nếu cú pháp hợp lệ, kết quả trả về sẽ báo thành công:
```text
Checking alert_rules.yml
  SUCCESS: 1 rules found
```

## 3. Reload cấu hình và kiểm tra kết quả
Sau khi chắc chắn file cấu hình hợp lệ, tiến hành reload lại Prometheus (thông qua API hoặc khởi động lại container):
```bash
curl -X POST http://localhost:9090/-/reload
```

**Kết quả thu được:**
- Prometheus không còn gửi các cảnh báo rác liên tục gây phiền nhiễu.
- Hệ thống cảnh báo hoạt động ổn định và chính xác hơn: Chỉ khi CPU duy trì trên mức 85% liên tục trong khoảng thời gian 5 phút thì cảnh báo mới được trigger (kích hoạt) và gửi cho đội vận hành.
