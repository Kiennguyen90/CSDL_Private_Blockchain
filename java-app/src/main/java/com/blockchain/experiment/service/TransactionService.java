package com.blockchain.experiment.service;

import com.blockchain.experiment.repository.EthereumNodeRepository;
import com.blockchain.experiment.repository.EthereumTransactionRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.EthSendTransaction;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tx.RawTransactionManager;
import org.web3j.utils.Convert;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Optional;

@Service
public class TransactionService {
    private static final Logger logger = LoggerFactory.getLogger(TransactionService.class);

    private static final BigInteger GAS_PRICE = BigInteger.valueOf(20_000_000_000L);
    private static final BigInteger GAS_LIMIT = BigInteger.valueOf(21000);

    private static final String PRIVATE_KEY =
        "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";

    private final EthereumNodeRepository nodeRepository;
    private final EthereumTransactionRepository transactionRepository;
    private final Credentials defaultCredentials;

    public TransactionService(EthereumNodeRepository nodeRepository,
                              EthereumTransactionRepository transactionRepository) {
        this.nodeRepository = nodeRepository;
        this.transactionRepository = transactionRepository;
        this.defaultCredentials = Credentials.create(PRIVATE_KEY);
        logger.info("TransactionService initialized with default address: {}", defaultCredentials.getAddress());
    }

    public String sendTransaction(String toAddress, BigDecimal etherAmount) throws Exception {
        return sendTransactionFrom(PRIVATE_KEY, toAddress, etherAmount);
    }

    public String sendTransactionFrom(String fromPrivateKey, String toAddress, BigDecimal etherAmount) throws Exception {
        Web3j web3j = nodeRepository.getNode("node1");
        Credentials credentials = Credentials.create(fromPrivateKey);
        long chainId = nodeRepository.getChainId("node1").longValueExact();

        BigInteger weiAmount = Convert.toWei(etherAmount, Convert.Unit.ETHER).toBigInteger();
        RawTransactionManager txManager = new RawTransactionManager(web3j, credentials, chainId);

        EthSendTransaction response = txManager.sendTransaction(
            GAS_PRICE, GAS_LIMIT, toAddress, "", weiAmount);

        if (response.hasError()) {
            throw new RuntimeException("Transaction failed: " + response.getError().getMessage());
        }

        String txHash = response.getTransactionHash();
        logger.info("Transaction submitted from {} to {}: {}", credentials.getAddress(), toAddress, txHash);
        return txHash;
    }

    public void sendMultipleTransactions(int count, String toAddress, BigDecimal etherAmount) {
        logger.info("\n========== Sending {} Transactions ==========", count);
        for (int i = 1; i <= count; i++) {
            try {
                logger.info("[Transaction {}/{}]", i, count);
                sendTransaction(toAddress, etherAmount);
                Thread.sleep(2000);
            } catch (Exception e) {
                logger.error("Failed to send transaction {}/{}: {}", i, count, e.getMessage());
            }
        }
        logger.info("========== Completed {} Transactions ==========\n", count);
    }

    public Optional<TransactionReceipt> getTransactionReceipt(String txHash) throws Exception {
        Web3j web3j = nodeRepository.getNode("node1");
        return transactionRepository.getTransactionReceipt(web3j, txHash);
    }

    public TransactionReceipt waitForReceipt(String txHash, int maxAttempts) throws Exception {
        logger.info("Waiting for transaction to be mined: {}", txHash);
        for (int i = 0; i < maxAttempts; i++) {
            Optional<TransactionReceipt> receipt = getTransactionReceipt(txHash);
            if (receipt.isPresent()) {
                TransactionReceipt txReceipt = receipt.get();
                logger.info("Transaction mined in block: {}", txReceipt.getBlockNumber());
                return txReceipt;
            }
            BigInteger blockNumber = nodeRepository.getNode("node1").ethBlockNumber().send().getBlockNumber();
            logger.info("Attempt {}/{} - current block: {} - waiting...", i + 1, maxAttempts, blockNumber);
            Thread.sleep(2000);
        }
        throw new RuntimeException("Transaction not mined after " + maxAttempts + " attempts");
    }

    public BigDecimal getBalance(String nodeName, String address) throws Exception {
        return transactionRepository.getBalance(nodeRepository.getNode(nodeName), address);
    }

    public void printBalances(String address) {
        logger.info("\n========== Account Balance: {} ==========", address);
        for (String nodeName : nodeRepository.getNodeNames()) {
            try {
                if (nodeRepository.isNodeAlive(nodeName)) {
                    logger.info("{}: {} ETH", nodeName.toUpperCase(), getBalance(nodeName, address));
                } else {
                    logger.info("{}: OFFLINE", nodeName.toUpperCase());
                }
            } catch (Exception e) {
                logger.warn("{}: Unable to fetch balance", nodeName.toUpperCase());
            }
        }
        logger.info("============================================\n");
    }

    public String getSenderAddress() {
        return defaultCredentials.getAddress();
    }
}
