#!/bin/bash

# Định nghĩa màu sắc
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Khôi phục màu mặc định

COMMAND=$1

case "$COMMAND" in
    start)
        echo "1. Dang khoi chay he thong..."
        docker compose up -d --build

        echo "2. Kiem tra trang thai Database (Timeout 10s)..."
        DB_READY=false
        # Lặp 5 lần, mỗi lần nghỉ 2s = 10s timeout
        for i in {1..5}; do
            if docker exec quickbite-db pg_isready -U postgres >/dev/null 2>&1; then
                DB_READY=true
                echo "-> Database da san sang!"
                break
            fi
            echo "-> Dang cho Database... (lan $i/5)"
            sleep 2
        done

        if [ "$DB_READY" = false ]; then
            echo -e "${RED}LỖI: Database khong phan hoi sau 10 giay!${NC}"
            echo -e "${RED}--- 20 DÒNG LOG CUỐI CỦA BACKEND ---${NC}"
            docker compose logs --tail 20 quickbite-user
            echo "Dang don dep he thong..."
            docker compose down
            exit 1
        fi

        echo "3. Kiem tra API Backend (Doi Spring Boot khoi dong)..."
        API_READY=false
        # Cần đợi Spring Boot chạy (thường mất 10-20s)
        for i in {1..15}; do
            # Lấy mã phản hồi HTTP
            HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081/actuator/health || true)
            if [ "$HTTP_STATUS" = "200" ]; then
                API_READY=true
                break
            fi
            sleep 2
        done

        if [ "$API_READY" = true ]; then
            echo -e "${GREEN}HỆ THỐNG QUICKBITE HOẠT ĐỘNG ỔN ĐỊNH!${NC}"
            exit 0
        else
            echo -e "${RED}LỖI: API Backend khong hoat dong!${NC}"
            echo -e "${RED}--- 20 DÒNG LOG CUỐI CỦA BACKEND ---${NC}"
            docker compose logs --tail 20 quickbite-user
            echo "Dang don dep he thong..."
            docker compose down
            exit 1
        fi
        ;;

    stop)
        echo "Dang tam dung he thong..."
        docker compose stop
        ;;

    clean)
        echo "Dang don dep hoan toan tai nguyen (kem volume)..."
        docker compose down -v
        ;;

    *)
        echo "Su dung: $0 {start|stop|clean}"
        exit 1
        ;;
esac
