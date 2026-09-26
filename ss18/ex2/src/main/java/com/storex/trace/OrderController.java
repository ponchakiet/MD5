package com.storex.trace;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class OrderController {
    
    private static final Logger logger = LoggerFactory.getLogger(OrderController.class);

    @GetMapping("/api/order")
    public String createOrder() {
        logger.info("Received request to create order.");
        
        // Giả lập xử lý nghiệp vụ
        processOrder();
        
        logger.info("Order created successfully.");
        return "Order created";
    }
    
    private void processOrder() {
        logger.info("Validating order details...");
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        logger.warn("Inventory is running low for this item.");
        logger.info("Saving order to database...");
    }
    
    @GetMapping("/api/fail")
    public String failOrder() {
        logger.info("Received request to process payment.");
        logger.error("Transaction Failed: Insufficient funds.");
        return "Transaction Failed";
    }
}
