#!/bin/bash

# 1. Tạo thư mục làm việc của dự án (dùng -p để tạo các thư mục cha nếu chưa có)
echo "Đang tạo thư mục /opt/quickbite/user-service..."
sudo mkdir -p /opt/quickbite/user-service

# 2. Thay đổi chủ sở hữu (owner) và nhóm (group) cho thư mục và toàn bộ thư mục con (-R)
echo "Đang thay đổi chủ sở hữu thành quickbite:quickbite..."
sudo chown -R quickbite:quickbite /opt/quickbite

# 3. Thiết lập quyền hạn truy cập 750 cho thư mục /opt/quickbite
echo "Đang thiết lập quyền 750..."
sudo chmod 750 /opt/quickbite

echo "Đã hoàn thành thiết lập thư mục và phân quyền!"