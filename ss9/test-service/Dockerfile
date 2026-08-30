#FROM eclipse-temurin:17-jre-alpine
#
#WORKDIR /app
#
#COPY build/libs/payment-service-1.0.0.jar app.jar
#
#EXPOSE 8080
#ENTRYPOINT ["java", "-jar", "app.jar"]

#ex5
FROM gradle:7.6-jdk17 AS builder

WORKDIR /home/gradle/project

COPY . .

RUN chmod +x gradlew
RUN ./gradlew clean build -x test


FROM eclipse-temurin:17-jre-alpine

WORKDIR /app
COPY --from=builder /home/gradle/project/build/libs/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]