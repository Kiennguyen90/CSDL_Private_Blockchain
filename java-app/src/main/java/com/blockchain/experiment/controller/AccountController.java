package com.blockchain.experiment.controller;

import com.blockchain.experiment.service.AccountService;
import com.blockchain.experiment.service.TransactionService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/accounts")
public class AccountController {
    private static final Pattern ADDRESS_PATTERN = Pattern.compile("^0x[0-9a-fA-F]{40}$");

    private final AccountService accountService;
    private final TransactionService transactionService;

    public AccountController(AccountService accountService, TransactionService transactionService) {
        this.accountService = accountService;
        this.transactionService = transactionService;
    }

    @PostMapping
    public ResponseEntity<Map<String, String>> createAccount(
            @RequestParam(required = false) String name) throws Exception {
        AccountService.AccountInfo account = accountService.createAccount(name);
        Map<String, String> body = new LinkedHashMap<>();
        body.put("address", account.address);
        body.put("privateKey", account.privateKey);
        body.put("name", account.name);
        return ResponseEntity.status(HttpStatus.CREATED).body(body);
    }

    @GetMapping
    public ResponseEntity<List<Map<String, String>>> getAllAccounts() {
        Collection<AccountService.AccountInfo> accounts = accountService.getAllAccounts();
        List<Map<String, String>> body = accounts.stream().map(account -> {
            Map<String, String> entry = new LinkedHashMap<>();
            entry.put("address", account.address);
            entry.put("name", account.name);
            entry.put("privateKey", account.privateKey);
            return entry;
        }).collect(Collectors.toList());
        return ResponseEntity.ok(body);
    }

    @GetMapping("/{address}")
    public ResponseEntity<Map<String, String>> getAccount(@PathVariable String address) {
        if (!isValidAddress(address)) {
            return ResponseEntity.badRequest().body(error("Invalid Ethereum address"));
        }
        Optional<AccountService.AccountInfo> account = accountService.getAccountByAddress(address);
        if (account.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(error("Account not found: " + address));
        }

        Map<String, String> body = new LinkedHashMap<>();
        body.put("address", account.get().address);
        body.put("privateKey", account.get().privateKey);
        body.put("name", account.get().name);
        return ResponseEntity.ok(body);
    }

    @GetMapping("/{address}/balance")
    public ResponseEntity<Map<String, String>> getBalance(@PathVariable String address) throws Exception {
        if (!isValidAddress(address)) {
            return ResponseEntity.badRequest().body(error("Invalid Ethereum address"));
        }
        BigDecimal balance = transactionService.getBalance("node1", address);
        Map<String, String> body = new LinkedHashMap<>();
        body.put("address", address);
        body.put("balance", balance.toPlainString());
        body.put("unit", "ETH");
        return ResponseEntity.ok(body);
    }

    private static Map<String, String> error(String message) {
        Map<String, String> body = new LinkedHashMap<>();
        body.put("error", message);
        return body;
    }

    private static boolean isValidAddress(String address) {
        return ADDRESS_PATTERN.matcher(address).matches();
    }
}
