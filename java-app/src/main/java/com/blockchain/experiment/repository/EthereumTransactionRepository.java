package com.blockchain.experiment.repository;

import org.springframework.stereotype.Repository;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.DefaultBlockParameterName;
import org.web3j.protocol.core.methods.response.EthGetBalance;
import org.web3j.protocol.core.methods.response.EthGetTransactionCount;
import org.web3j.protocol.core.methods.response.EthGetTransactionReceipt;
import org.web3j.protocol.core.methods.response.EthSendTransaction;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.utils.Convert;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Optional;

@Repository
public class EthereumTransactionRepository {

    public BigInteger getNonce(Web3j web3j, String address) throws IOException {
        EthGetTransactionCount txCount = web3j.ethGetTransactionCount(
            address, DefaultBlockParameterName.PENDING).send();
        return txCount.getTransactionCount();
    }

    public EthSendTransaction sendRawTransaction(Web3j web3j, String hexSignedTx) throws IOException {
        return web3j.ethSendRawTransaction(hexSignedTx).send();
    }

    public Optional<TransactionReceipt> getTransactionReceipt(Web3j web3j, String txHash) throws IOException {
        EthGetTransactionReceipt receipt = web3j.ethGetTransactionReceipt(txHash).send();
        return receipt.getTransactionReceipt();
    }

    public BigDecimal getBalance(Web3j web3j, String address) throws IOException {
        EthGetBalance balance = web3j.ethGetBalance(address, DefaultBlockParameterName.LATEST).send();
        return Convert.fromWei(balance.getBalance().toString(), Convert.Unit.ETHER);
    }
}
