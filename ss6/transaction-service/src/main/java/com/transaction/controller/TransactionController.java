package com.transaction.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api/v1/transactions")
public class TransactionController {

    private final RestTemplate restTemplate;

    public TransactionController(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    @PostMapping("/transfer")
    public ResponseEntity<String> transferMoney(@RequestParam Long accountId, @RequestParam Double amount) {
        String accountServiceUrl = "http://account-service:8080/api/v1/accounts/" + accountId;

        System.out.println("Đang kiểm tra tài khoản qua URL: " + accountServiceUrl);

        try {
            ResponseEntity<Object> response = restTemplate.getForEntity(accountServiceUrl, Object.class);

            return ResponseEntity.ok("Tài khoản hợp lệ. Đang xử lý chuyển số tiền: " + amount);

        } catch (HttpClientErrorException.NotFound e) {
            return ResponseEntity.status(404).body("Giao dịch thất bại: Tài khoản nguồn không tồn tại!");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Lỗi kết nối nội bộ giữa các service!");
        }
    }
}