package com.blockchain.experiment.repository;

import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

@Repository
public class AccountRepository {
    private final Map<String, AccountRecord> accounts = new ConcurrentHashMap<>();

    public void save(AccountRecord record) {
        accounts.put(record.address(), record);
    }

    public Optional<AccountRecord> findByAddress(String address) {
        return Optional.ofNullable(accounts.get(address));
    }

    public Collection<AccountRecord> findAll() {
        return accounts.values();
    }

    public record AccountRecord(String address, String privateKey, String name) {
    }
}
