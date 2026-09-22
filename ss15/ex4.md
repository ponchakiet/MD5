## Bước 1: Cấu hình prometheus.yml
Thay thế khối static_configs bằng file_sd_configs và trỏ đường dẫn đến file targets.json:

```yaml
scrape_configs:
  - job_name: 'microservices'
    file_sd_configs:
      - files:
        - 'targets.json'
```

## Bước 2: Tạo file targets.json

```yaml
[
  {
    "targets": [
      "10.0.0.51:8080", 
      "10.0.0.52:8080"
    ],
    "labels": {
      "env": "production"
    }
  }
]
```