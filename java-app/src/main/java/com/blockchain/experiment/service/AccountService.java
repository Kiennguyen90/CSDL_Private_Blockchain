package com.blockchain.experiment.service;

import com.blockchain.experiment.repository.AccountRepository;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.ECKeyPair;
import org.web3j.crypto.Keys;
import org.web3j.utils.Numeric;

import java.security.SecureRandom;
import java.util.Collection;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class AccountService {
    private static final Logger logger = LoggerFactory.getLogger(AccountService.class);
    private final AccountRepository accountRepository;

    // Pre-funded genesis accounts (Hardhat default keys for chainId 2025 demo)
    private static final String[][] GENESIS_ACCOUNTS = {
        {"0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80", "Genesis Account 1 (Validator)"},
        {"0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d", "Genesis Account 2"},
        {"0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a", "Genesis Account 3"}
    };

    public AccountService(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    @PostConstruct
    public void preloadGenesisAccounts() {
        for (String[] entry : GENESIS_ACCOUNTS) {
            String privateKey = entry[0];
            String name = entry[1];
            Credentials creds = Credentials.create(privateKey);
            String address = creds.getAddress();
            accountRepository.save(new AccountRepository.AccountRecord(address, privateKey, name));
            logger.info("Pre-loaded genesis account: {} ({})", address, name);
        }
    }

    public AccountInfo createAccount(String name) throws Exception {
        ECKeyPair keyPair = Keys.createEcKeyPair(new SecureRandom());
        String address = "0x" + Keys.getAddress(keyPair.getPublicKey());
        String privateKey = Numeric.toHexStringWithPrefix(keyPair.getPrivateKey());
        String accountName = (name != null && !name.isBlank()) ? name.trim() : "Account " + address.substring(0, 8);
        accountRepository.save(new AccountRepository.AccountRecord(address, privateKey, accountName));
        logger.info("New account created: {} ({})", address, accountName);
        return new AccountInfo(address, privateKey, accountName);
    }

    public Optional<AccountInfo> getAccountByAddress(String address) {
        return accountRepository.findByAddress(address)
            .map(record -> new AccountInfo(record.address(), record.privateKey(), record.name()));
    }

    public Collection<AccountInfo> getAllAccounts() {
        return accountRepository.findAll().stream()
            .map(record -> new AccountInfo(record.address(), record.privateKey(), record.name()))
            .collect(Collectors.toList());
    }

    public static class AccountInfo {
        public final String address;
        public final String privateKey;
        public final String name;

        public AccountInfo(String address, String privateKey, String name) {
            this.address = address;
            this.privateKey = privateKey;
            this.name = name;
        }
    }
}
