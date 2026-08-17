docker run -d \
  --name quickbite-user \
  -p 8081:8081 \
  -v /home/quank3/quickbite-test/learn/build/libs:/app \
  -w /app \
  --add-host=host.docker.internal:host-gateway \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/user_db_test \
  -e SPRING_DATASOURCE_USERNAME=postgres \
  -e SPRING_DATASOURCE_PASSWORD=******* \
  -e SPRING_DATASOURCE_DRIVER_CLASS_NAME=org.postgresql.Driver \
  eclipse-temurin:17-jre-alpine \
  java -jar learn-0.0.1-SNAPSHOT.jar

