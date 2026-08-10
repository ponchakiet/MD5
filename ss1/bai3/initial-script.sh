#!/bin/bash

# 1. Cập nhật hệ thống
echo "Đang cập nhật hệ thống..."
sudo apt-get update && sudo apt-get upgrade -y

# 2. Cài đặt các gói phần mềm bắt buộc
echo "Đang cài đặt openjdk-17-jdk, git, curl..."
sudo apt-get install -y openjdk-17-jdk git curl

# 3. Kiểm tra và tạo nhóm quickbite
if ! getent group quickbite > /dev/null; then
    echo "Tạo nhóm quickbite..."
    sudo groupadd quickbite
else
    echo "Nhóm quickbite đã tồn tại."
fi

# 4. Tạo người dùng hệ thống quickbite
if ! id "quickbite" &>/dev/null; then
    echo "Tạo user hệ thống quickbite..."
    # -r: tạo system user
    # -g: gán vào nhóm quickbite
    # -M: không tạo thư mục home
    # -s: thiết lập shell là /bin/false
    sudo useradd -r -g quickbite -M -s /bin/false quickbite
    echo "Đã tạo user quickbite thành công."
else
    echo "User quickbite đã tồn tại."
fi
