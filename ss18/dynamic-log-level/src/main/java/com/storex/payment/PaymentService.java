package com.storex.payment;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
public class PaymentService {
    private static final Logger logger = LoggerFactory.getLogger(PaymentService.class);

    @Scheduled(fixedRate = 5000)
    public void processPayment() {
        logger.info("Processing payment - INFO level");
        logger.debug("Payment details - DEBUG level (This should appear after changing log level)");
    }
}
