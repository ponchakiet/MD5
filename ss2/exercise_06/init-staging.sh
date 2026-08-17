#!/bin/bash

# Định nghĩa màu sắc để in ra terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color (Đặt lại màu mặc định)

echo "--- BẮT ĐẦU QUÁ TRÌNH KHỞI TẠO MÔI TRƯỜNG STAGING ---"

# ==========================================
# Giai đoạn 1: Dọn dẹp tài nguyên (Clean up)
# ==========================================
echo "1. Kiem tra va don dep container cu..."
if [ "$(docker ps -aq -f name=quickbite-db)" ]; then
    echo "Phat hien container 'quickbite-db' cu. Dang tien hanh xoa..."
    docker stop quickbite-db >/dev/null 2>&1
    docker rm quickbite-db >/dev/null 2>&1
    echo "-> Don dep thanh cong!"
else
    echo "-> Khong co container cu nao can don dep."
fi

# ==========================================
# Giai đoạn 2: Kiểm soát cổng mạng (Port Check)
# ==========================================
echo "2. Kiem tra cong mang 5432..."
# Kiểm tra xem có tiến trình nào đang chạy ở cổng 5432 không
if lsof -i:5432 -t >/dev/null 2>&1; then
    echo -e "${RED}LỖI: Cổng 5432 trên máy host đang bị chiếm dụng bởi một tiến trình khác!${NC}"
    exit 1
else
    echo "-> Cong 5432 dang trong, san sang su dung."
fi

# ==========================================
# Giai đoạn 3: Khởi tạo Database
# ==========================================
echo "3. Khoi tao Database moi..."
docker run -d \
  --name quickbite-db \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=12345678 \
  postgres:15-alpine >/dev/null

echo "-> Container quickbite-db da duoc khoi chay."

# ==========================================
# Giai đoạn 4: Kiểm thử độ sẵn sàng (Smoke Test)
# ==========================================
echo "4. Dang kiem thu do san sang (Smoke Test)..."
echo "-> Tam dung 5 giay de database khoi dong..."
sleep 5

# Dùng pg_isready để kiểm tra trạng thái của Postgres
if docker exec quickbite-db pg_isready -U postgres >/dev/null 2>&1; then
    echo -e "${GREEN}DATABASE STAGING KHỞI TẠO THÀNH CÔNG!${NC}"
    exit 0
else
    echo -e "${RED}KHỞI TẠO THẤT BẠI. Dưới đây là 20 dòng log cuối cùng của container:${NC}"
    docker logs --tail 20 quickbite-db
    exit 1
fi