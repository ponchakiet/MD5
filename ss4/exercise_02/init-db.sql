-- Tạo các cơ sở dữ liệu con
CREATE DATABASE quickbite_user_db;
CREATE DATABASE quickbite_restaurant_db;
CREATE DATABASE quickbite_order_db;
CREATE DATABASE quickbite_notification_db;

-- Tạo user dùng chung cho các dịch vụ và cấp quyền
CREATE USER quickbite_service WITH PASSWORD 'secret';
GRANT ALL PRIVILEGES ON DATABASE quickbite_user_db TO quickbite_service;
GRANT ALL PRIVILEGES ON DATABASE quickbite_restaurant_db TO quickbite_service;
GRANT ALL PRIVILEGES ON DATABASE quickbite_order_db TO quickbite_service;
GRANT ALL PRIVILEGES ON DATABASE quickbite_notification_db TO quickbite_service;
