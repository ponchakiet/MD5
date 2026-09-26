package com.storex.alert;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestAlertController {

    private static final Logger logger = LoggerFactory.getLogger(TestAlertController.class);

    @GetMapping("/api/test-alert")
    public String triggerError() {
        logger.info("This is an info log, will not trigger alert.");
        
        // Giả lập một lỗi DB
        logger.error("Lỗi DB: Connection timeout during executing query 'SELECT * FROM users'");
        
        return "Error triggered. Check Discord!";
    }
}
