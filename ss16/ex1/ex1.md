## Bước 1: Xóa cấu hình log chung
Mở file application.yml và xóa bỏ toàn bộ cấu hình logging cũ đang bị fix cứng.

## Bước 2: Tạo file application-dev.yml
Cấu hình root log ở mức DEBUG để phục vụ việc tìm lỗi chi tiết:

```yaml
logging:
  level:
    root: DEBUG
```

## Bước 3: Tạo file application-prod.yml
Cấu hình root log là INFO, đồng thời giới hạn package com.example cũng ở mức INFO để tránh rác hệ thống:

```yaml
logging:
  level:
    root: INFO
    com.example: INFO
```
