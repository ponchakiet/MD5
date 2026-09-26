package com.storex.trace;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.UUID;

@Component
public class RequestIdFilter extends OncePerRequestFilter {

    private static final String REQUEST_ID_HEADER = "X-Request-Id";
    private static final String MDC_REQUEST_ID_KEY = "requestId";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) 
            throws ServletException, IOException {
        
        // Sinh UUID hoặc lấy từ header nếu client có truyền lên
        String requestId = request.getHeader(REQUEST_ID_HEADER);
        if (requestId == null || requestId.isEmpty()) {
            requestId = UUID.randomUUID().toString();
        }
        
        // Put vào MDC context của Logback
        MDC.put(MDC_REQUEST_ID_KEY, requestId);
        
        try {
            // Thêm requestId vào response header để client biết
            response.setHeader(REQUEST_ID_HEADER, requestId);
            
            filterChain.doFilter(request, response);
        } finally {
            // Rất quan trọng: Xóa khỏi MDC sau khi request xử lý xong để tránh leak memory/dữ liệu rác
            MDC.remove(MDC_REQUEST_ID_KEY);
        }
    }
}
