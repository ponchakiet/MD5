package com.edu.testservice.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LogTestController {

    private static final Logger logger = LoggerFactory.getLogger(LogTestController.class);

    @GetMapping("/test-json-log")
    public String triggerError() {
        try {
            // Cố tình ném ra một ngoại lệ
            throw new RuntimeException("Giả lập lỗi Exception để test JSON Log");
        } catch (Exception e) {
            // Ghi log lỗi kèm theo stack trace
            logger.error("Đã xảy ra lỗi trong quá trình xử lý: ", e);
        }
        return "Hãy kiểm tra file log hoặc console!";
    }
}