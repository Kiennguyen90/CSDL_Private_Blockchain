package com.blockchain.experiment.controller;

import com.blockchain.experiment.service.AccountService;
import com.blockchain.experiment.service.TransactionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/transactions")
public class TransactionController {
    private static final Pattern ADDRESS_PATTERN = Pattern.compile("^0x[0-9a-fA-F]{40}$");

    private final TransactionService transactionService;
    private final AccountService accountService;

    public TransactionController(TransactionService transactionService, AccountService accountService) {
        this.transactionService = transactionService;
        this.accountService = accountService;
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> sendTransaction(@RequestBody TransactionRequest request) {
        if (request.from == null || !ADDRESS_PATTERN.matcher(request.from).matches()) {
            return ResponseEntity.badRequest().body(error("Invalid 'from' address"));
        }
        if (request.to == null || !ADDRESS_PATTERN.matcher(request.to).matches()) {
            return ResponseEntity.badRequest().body(error("Invalid 'to' address"));
        }
        if (request.amount == null || request.amount.compareTo(BigDecimal.ZERO) <= 0) {
            return ResponseEntity.badRequest().body(error("Amount must be greater than 0"));
        }

        Optional<AccountService.AccountInfo> sender = accountService.getAccountByAddress(request.from);
        if (sender.isEmpty()) {
            return ResponseEntity.badRequest().body(error("Sender account not found: " + request.from));
        }

        try {
            String txHash = transactionService.sendTransactionFrom(
                sender.get().privateKey, request.to, request.amount);
            Map<String, String> body = new LinkedHashMap<>();
            body.put("txHash", txHash);
            body.put("from", request.from);
            body.put("to", request.to);
            body.put("amount", request.amount.toPlainString());
            body.put("unit", "ETH");
            return ResponseEntity.ok(body);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(error(e.getMessage()));
        }
    }

    private static Map<String, String> error(String message) {
        Map<String, String> body = new LinkedHashMap<>();
        body.put("error", message);
        return body;
    }

    public static class TransactionRequest {
        public String from;
        public String to;
        public BigDecimal amount;
    }
}
