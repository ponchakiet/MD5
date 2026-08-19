# 1. Sử dụng base image JRE 17 tối ưu theo yêu cầu
FROM eclipse-temurin:17-jre-alpine

# 2. Thiết lập thư mục làm việc mặc định trong container
WORKDIR /app

# 3. Copy file thực thi JAR từ máy host vào container và đổi tên thành app.jar
COPY build/libs/*-SNAPSHOT.jar app.jar

# 4. Cấu hình tiến trình khởi chạy ứng dụng
ENTRYPOINT ["java", "-jar", "app.jar"]
