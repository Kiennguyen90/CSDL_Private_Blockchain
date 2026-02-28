package com.blockchain.experiment.service;

import com.blockchain.experiment.repository.EthereumNodeRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.math.BigInteger;

public class ExperimentService {
    private static final Logger logger = LoggerFactory.getLogger(ExperimentService.class);
    private static final String RECIPIENT_ADDRESS = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";

    private final EthereumNodeRepository nodeRepository;
    private final TransactionService transactionService;
    private final BlockMonitorService blockMonitorService;

    public ExperimentService(EthereumNodeRepository nodeRepository,
                             TransactionService transactionService,
                             BlockMonitorService blockMonitorService) {
        this.nodeRepository = nodeRepository;
        this.transactionService = transactionService;
        this.blockMonitorService = blockMonitorService;
    }

    public void printNetworkStatus() {
        nodeRepository.printConnectionStatus();
        blockMonitorService.printSyncStatus();
    }

    public void runScenario1InitialSync() throws Exception {
        logger.info("Step 1: Checking initial network status...");
        printNetworkStatus();

        logger.info("Step 2: Submitting test transaction...");
        String txHash = transactionService.sendTransaction(RECIPIENT_ADDRESS, BigDecimal.valueOf(0.1));

        logger.info("Step 3: Waiting for transaction to be mined...");
        transactionService.waitForReceipt(txHash, 30);

        logger.info("Step 4: Waiting for all nodes to synchronize...");
        blockMonitorService.waitForSync(30);

        logger.info("Step 5: Verifying block hash consistency...");
        BigInteger currentBlock = nodeRepository.getBlockNumber("node1");
        blockMonitorService.verifyBlockHashConsistency(currentBlock);
    }

    public void runScenario2ShutdownNode3() throws Exception {
        logger.info("INSTRUCTIONS:");
        logger.info("1. Open a new terminal");
        logger.info("2. Navigate to the docker directory");
        logger.info("3. Run: docker-compose stop eth-node3-recovery");
        logger.info("Press ENTER when Node 3 is shutdown...");

        System.in.read();
        Thread.sleep(2000);

        logger.info("Verifying Node 3 is offline...");
        printNetworkStatus();
    }

    public void runScenario3TransactionsWhileOffline() throws Exception {
        BigInteger blockBeforeNode1 = nodeRepository.getBlockNumber("node1");
        BigInteger blockBeforeNode2 = nodeRepository.getBlockNumber("node2");

        logger.info("Node 1 Block: {}", blockBeforeNode1);
        logger.info("Node 2 Block: {}", blockBeforeNode2);

        logger.info("Submitting 5 transactions while Node 3 is offline...");
        transactionService.sendMultipleTransactions(5, RECIPIENT_ADDRESS, BigDecimal.valueOf(0.05));

        logger.info("Waiting for Node 1 and Node 2 to synchronize...");
        blockMonitorService.waitForSync(30);

        BigInteger blockAfterNode1 = nodeRepository.getBlockNumber("node1");
        BigInteger blockAfterNode2 = nodeRepository.getBlockNumber("node2");

        logger.info("========== Results ==========");
        logger.info("Node 1: {} -> {} (+ {} blocks)", blockBeforeNode1, blockAfterNode1,
            blockAfterNode1.subtract(blockBeforeNode1));
        logger.info("Node 2: {} -> {} (+ {} blocks)", blockBeforeNode2, blockAfterNode2,
            blockAfterNode2.subtract(blockBeforeNode2));
        logger.info("Node 3: OFFLINE");
        logger.info("=============================");
    }

    public void runScenario4RecoveryAndResync() throws Exception {
        logger.info("Current blockchain state:");
        logger.info("Node 1 Block: {}", nodeRepository.getBlockNumber("node1"));
        logger.info("Node 2 Block: {}", nodeRepository.getBlockNumber("node2"));

        logger.info("INSTRUCTIONS:");
        logger.info("1. Open a new terminal");
        logger.info("2. Navigate to the docker directory");
        logger.info("3. Run: docker-compose start eth-node3-recovery");
        logger.info("Press ENTER when Node 3 is restarted...");

        System.in.read();
        Thread.sleep(10000);

        logger.info("Checking network status after restart...");
        printNetworkStatus();

        logger.info("Waiting for full synchronization...");
        blockMonitorService.waitForSync(60);

        logger.info("Verifying blockchain consistency...");
        BigInteger latestBlock = nodeRepository.getBlockNumber("node1");
        blockMonitorService.verifyBlockHashConsistency(latestBlock);
    }

    public void runFullAutomatedExperiment() throws Exception {
        logger.info("Running full automated experiment...");
        runScenario1InitialSync();
        runScenario2ShutdownNode3();
        runScenario3TransactionsWhileOffline();
        runScenario4RecoveryAndResync();
        logger.info("Full experiment completed.");
    }

    public void verifyImmutability() throws Exception {
        BigInteger latestBlock = nodeRepository.getBlockNumber("node1");
        blockMonitorService.verifyBlockHashConsistency(latestBlock);
    }
}
