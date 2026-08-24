#!/bin/bash
echo "==========================================="
echo "BẮT ĐẦU TRIỂN KHAI HỆ THỐNG BANKING"
echo "==========================================="

echo "[1/3] Đang dọn dẹp các container và mạng cũ..."
docker compose down

echo "[2/3] Đang đóng gói và khởi động lại hệ thống..."
docker compose up -d --build

echo "[3/3] Quá trình khởi động đang diễn ra!"
echo "Sử dụng lệnh 'docker ps' để theo dõi trạng thái (Starting -> Healthy)."
echo "==========================================="