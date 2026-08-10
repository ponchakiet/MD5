#!/bin/bash

# Khai báo màu sắc cho terminal trực quan hơn
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Không màu

echo -e "${YELLOW}=== BẮT ĐẦU QUY TRÌNH DEPLOY TỰ ĐỘNG ===${NC}"

# Bước 1: Biên dịch mã nguồn (Build & Test)
echo -e "${YELLOW}[Bước 1] Đang biên dịch mã nguồn với Gradle...${NC}"
./gradlew clean bootJar

# Áp dụng Fail-fast: Kiểm tra xem lệnh gradle vừa rồi có thành công không ($? bằng 0 là thành công)
if [ $? -ne 0 ]; then
    echo -e "${RED}[LỖI FAIL-FAST] Biên dịch thất bại! Dừng toàn bộ quy trình deploy.${NC}"
    exit 1
fi
echo -e "${GREEN}=> Biên dịch thành công!${NC}"

# Bước 2: Chuẩn bị hạ tầng thư mục
echo -e "${YELLOW}[Bước 2] Chuẩn bị thư mục /opt/quickbite/user-service...${NC}"
if [ ! -d "/opt/quickbite/user-service" ]; then
    sudo mkdir -p /opt/quickbite/user-service
fi
sudo chown -R quickbite:quickbite /opt/quickbite/user-service
echo -e "${GREEN}=> Thư mục đã sẵn sàng!${NC}"

# Bước 3: Sao chép ứng dụng
echo -e "${YELLOW}[Bước 3] Dừng dịch vụ cũ và sao chép file JAR mới...${NC}"
# Tìm và tắt tiến trình đang chiếm cổng 8080 (nếu có)
OLD_PID=$(sudo ss -tulpn | grep :8080 | awk '{print $6}' | cut -d',' -f2 | cut -d'=' -f2)
if [ -n "$OLD_PID" ]; then
    sudo kill -9 $OLD_PID
    echo "   Đã dừng tiến trình cũ (PID: $OLD_PID)"
fi

# Copy file jar mới build vào thư mục /opt
sudo cp build/libs/*.jar /opt/quickbite/user-service-0.0.1.jar
sudo chown quickbite:quickbite /opt/quickbite/user-service-0.0.1.jar
echo -e "${GREEN}=> Sao chép và phân quyền thành công!${NC}"

# Bước 4: Khởi động dịch vụ
echo -e "${YELLOW}[Bước 4] Khởi động ứng dụng user-service...${NC}"
# Chạy ngầm ứng dụng dưới quyền của user 'quickbite', ghi log ra file app.log
sudo -u quickbite bash -c 'nohup java -jar /opt/quickbite/user-service-0.0.1.jar > /opt/quickbite/user-service/app.log 2>&1 &'
echo -e "${GREEN}=> Lệnh khởi động đã được gửi!${NC}"

# Bước 5: Smoke Test
echo -e "${YELLOW}[Bước 5] Đợi 5 giây để JVM khởi tạo và thực hiện Smoke Test...${NC}"
sleep 5

# Kiểm tra xem cổng 8080 đã mở chưa
if sudo ss -tulpn | grep -q :8080; then
    echo -e "${GREEN}==========================================${NC}"
    echo -e "${GREEN}     DEPLOY DỊCH VỤ THÀNH CÔNG!           ${NC}"
    echo -e "${GREEN} Ứng dụng đang lắng nghe trên cổng 8080.  ${NC}"
    echo -e "${GREEN}==========================================${NC}"
else
    echo -e "${RED}[LỖI] Ứng dụng không khởi động được (Cổng 8080 đang đóng).${NC}"
    echo -e "${YELLOW}--- 30 dòng log cuối cùng ---${NC}"
    sudo tail -n 30 /opt/quickbite/user-service/app.log
    exit 1
fi