package com.storex.alert;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.AppenderBase;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class DiscordAppender extends AppenderBase<ILoggingEvent> {

    // URL Webhook của Discord (sẽ được inject từ logback-spring.xml)
    private String webhookUrl;
    
    private final HttpClient httpClient;

    public DiscordAppender() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(5))
                .build();
    }

    public void setWebhookUrl(String webhookUrl) {
        this.webhookUrl = webhookUrl;
    }

    @Override
    protected void append(ILoggingEvent eventObject) {
        // Chỉ xử lý log cấp độ ERROR
        if (eventObject.getLevel().levelInt == Level.ERROR_INT) {
            sendAlertToDiscord(eventObject);
        }
    }

    private void sendAlertToDiscord(ILoggingEvent event) {
        if (webhookUrl == null || webhookUrl.isEmpty()) {
            return;
        }

        try {
            // Lấy nội dung lỗi
            String message = event.getFormattedMessage();
            String loggerName = event.getLoggerName();
            
            // Xây dựng payload JSON cho Discord
            // Discord webhook payload form: {"content": "your message"}
            String jsonPayload = String.format(
                    "{\"content\": \"🚨 **[CẢNH BÁO LỖI]** 🚨\\n**Logger:** %s\\n**Message:** %s\"}",
                    escapeJson(loggerName),
                    escapeJson(message)
            );

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(webhookUrl))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                    .build();

            // Gửi request bất đồng bộ để không block thread chính đang ghi log
            httpClient.sendAsync(request, HttpResponse.BodyHandlers.ofString())
                    .thenAccept(response -> {
                        if (response.statusCode() >= 400) {
                            System.err.println("Failed to send Discord alert. Status code: " + response.statusCode());
                        }
                    });

        } catch (Exception e) {
            // Bắt lỗi để không làm sập ứng dụng chính khi có lỗi gửi webhook
            addError("Failed to send error alert to Discord", e);
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }
}
