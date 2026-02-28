package com.blockchain.experiment.controller;

import com.blockchain.experiment.repository.EthereumNodeRepository;
import com.blockchain.experiment.repository.EthereumTransactionRepository;
import com.blockchain.experiment.service.BlockMonitorService;
import com.blockchain.experiment.service.ExperimentService;
import com.blockchain.experiment.service.TransactionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Scanner;

public class ExperimentController {
    private static final Logger logger = LoggerFactory.getLogger(ExperimentController.class);

    private final EthereumNodeRepository nodeRepository;
    private final ExperimentService experimentService;

    public ExperimentController() {
        this.nodeRepository = new EthereumNodeRepository();
        EthereumTransactionRepository txRepository = new EthereumTransactionRepository();
        TransactionService transactionService = new TransactionService(nodeRepository, txRepository);
        BlockMonitorService blockMonitorService = new BlockMonitorService(nodeRepository);
        this.experimentService = new ExperimentService(nodeRepository, transactionService, blockMonitorService);
    }

    public static void main(String[] args) {
        ExperimentController controller = new ExperimentController();
        controller.run();
    }

    public void run() {
        printBanner();
        try {
            Thread.sleep(3000);
            experimentService.printNetworkStatus();
            runMenu();
        } catch (Exception e) {
            logger.error("Experiment failed with error: ", e);
        } finally {
            cleanup();
        }
    }

    private void runMenu() throws Exception {
        Scanner scanner = new Scanner(System.in);
        boolean running = true;

        while (running) {
            printMenu();
            String choice = scanner.nextLine().trim();

            switch (choice) {
                case "1":
                    experimentService.runScenario1InitialSync();
                    break;
                case "2":
                    experimentService.runScenario2ShutdownNode3();
                    break;
                case "3":
                    experimentService.runScenario3TransactionsWhileOffline();
                    break;
                case "4":
                    experimentService.runScenario4RecoveryAndResync();
                    break;
                case "5":
                    experimentService.runFullAutomatedExperiment();
                    break;
                case "6":
                    experimentService.printNetworkStatus();
                    break;
                case "7":
                    experimentService.verifyImmutability();
                    break;
                case "0":
                    running = false;
                    logger.info("Exiting experiment...");
                    break;
                default:
                    logger.warn("Invalid choice. Please try again.");
            }
        }

        scanner.close();
    }

    private void printBanner() {
        logger.info("\n");
        logger.info("===============================================");
        logger.info("  Blockchain Immutability & Fault Tolerance");
        logger.info("  Private Ethereum Network - 3 Node Topology");
        logger.info("===============================================\n");
    }

    private void printMenu() {
        logger.info("\nEXPERIMENT MENU");
        logger.info("1. Scenario 1: Initial Synchronization Test");
        logger.info("2. Scenario 2: Shutdown Node 3 (Manual)");
        logger.info("3. Scenario 3: Submit Transactions (Node 3 Offline)");
        logger.info("4. Scenario 4: Restart Node 3 & Verify Re-sync");
        logger.info("5. Run Full Automated Experiment");
        logger.info("6. Check Network Status");
        logger.info("7. Verify Blockchain Immutability");
        logger.info("0. Exit");
        logger.info("Enter your choice: ");
    }

    private void cleanup() {
        nodeRepository.shutdown();
        logger.info("Cleanup complete. Goodbye!");
    }
}
