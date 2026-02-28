# Blockchain Immutability & Fault Tolerance Experiment

A comprehensive demonstration of blockchain immutability, synchronization, and fault tolerance using a private Ethereum network with three nodes and a Java Web3j application.

## 📋 Table of Contents

- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Experimental Scenarios](#experimental-scenarios)
- [Project Structure](#project-structure)
- [Usage Guide](#usage-guide)
- [Troubleshooting](#troubleshooting)
- [Expected Results](#expected-results)

## 🎯 Overview

This experiment demonstrates three fundamental blockchain properties:

1. **Immutability**: Historical data cannot be altered
2. **Synchronization**: All nodes maintain consistent state
3. **Fault Tolerance**: Network continues operating despite node failures

### Experimental Objectives

- Observe blockchain synchronization across multiple nodes
- Simulate node failure and recovery
- Verify data consistency and immutability
- Demonstrate blockchain resilience

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Java Application (Web3j)                 │
│                                                             │
│  • Transaction Submission                                   │
│  • Block Monitoring                                         │
│  • Synchronization Verification                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ├────────┬────────┬────────┐
                            ▼        ▼        ▼        │
                      ┌─────────────────────────────┐  │
                      │  Private Ethereum Network   │  │
                      │  (Network ID: 2025)         │  │
                      └─────────────────────────────┘  │
                            │                           │
        ┌───────────────────┼───────────────────┐      │
        ▼                   ▼                   ▼       │
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Node 1     │◄──►│   Node 2     │◄──►│   Node 3     │
│  Validator   │    │  Full Node   │    │  Recovery    │
│   Miner      │    │              │    │  Test Node   │
│              │    │              │    │              │
│ Port: 8545   │    │ Port: 8547   │    │ Port: 8549   │
└──────────────┘    └──────────────┘    └──────────────┘
```

### Node Roles

- **Node 1 (Validator/Miner)**: Mines blocks and validates transactions
- **Node 2 (Full Node)**: Maintains complete blockchain copy, participates in consensus
- **Node 3 (Recovery Node)**: Used for offline/recovery testing scenarios

## 📦 Prerequisites

### Required Software

- **Docker** (v20.10+) & **Docker Compose** (v2.0+)
- **Java Development Kit** (JDK 21 or higher)
- **Apache Maven** (v3.6+)
- **Bash** (for running scripts)

### System Requirements

- 4GB RAM minimum (8GB recommended)
- 10GB free disk space
- Linux/macOS/Windows with WSL

### Installation Verification

```bash
# Verify Docker
docker --version
docker-compose --version

# Verify Java
java -version

# Verify Maven
mvn -version
```

## 🚀 Installation

### 1. Clone or Download Project

```bash
cd "CSDLNC Demo"
```

### 2. Make Scripts Executable (Linux/macOS)

```bash
chmod +x scripts/*.sh
```

### 3. Initialize the Ethereum Network

```bash
cd docker
bash ../scripts/init-network.sh
```

This script will:
- Stop any existing containers
- Clean old blockchain data
- Start 3 Ethereum nodes
- Initialize genesis blocks
- Connect nodes as peers

### 4. Compile Java Application

```bash
cd ../java-app
mvn clean package
```

## ⚡ Quick Start

### Option 1: Interactive Menu (Recommended)

```bash
bash scripts/run-experiment.sh
```

This launches an interactive menu where you can:
- Run individual scenarios
- Check network status
- Verify blockchain state
- Monitor synchronization

### Option 2: Manual Execution

```bash
# Start the network
cd docker
bash ../scripts/init-network.sh

# Compile and run Java application
cd ../java-app
mvn clean package
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```

## 🧪 Experimental Scenarios

### Scenario 1: Initial Synchronization Test

**Objective**: Verify all nodes synchronize when a new block is created

**Steps**:
1. All three nodes are online
2. Submit transaction from Java application
3. Observe block creation on Node 1
4. Verify Nodes 2 and 3 synchronize the new block
5. Confirm block hash consistency

**Expected Result**: All nodes report identical block number and hash

---

### Scenario 2: Node Failure Simulation

**Objective**: Simulate a node going offline

**Steps**:
1. Check current network status
2. Shutdown Node 3:
   ```bash
   docker-compose stop eth-node3-recovery
   ```
3. Verify Node 3 is offline
4. Confirm Nodes 1 and 2 continue operating

**Expected Result**: Network continues with 2 nodes; Node 3 is unreachable

---

### Scenario 3: Transactions While Node Offline

**Objective**: Submit transactions while one node is down

**Steps**:
1. With Node 3 still offline, submit 5-10 transactions
2. Observe blocks being mined on Nodes 1 and 2
3. Record block numbers and hashes
4. Verify Nodes 1 and 2 remain synchronized

**Expected Result**: Nodes 1 and 2 continue normal operation; blockchain grows despite Node 3 being offline

---

### Scenario 4: Recovery & Re-synchronization

**Objective**: Demonstrate automatic blockchain recovery

**Steps**:
1. Record current block numbers (Node 1, Node 2)
2. Restart Node 3:
   ```bash
   docker-compose start eth-node3-recovery
   ```
3. Monitor Node 3 synchronization progress
4. Wait for Node 3 to catch up
5. Verify all nodes have identical blockchain state
6. Compare block hashes to ensure immutability

**Expected Result**:
- Node 3 automatically downloads missing blocks
- Final block number matches Nodes 1 and 2
- All block hashes are identical (no data corruption)

## 📁 Project Structure

```
CSDLNC Demo/
├── docker/
│   ├── docker-compose.yml      # Docker orchestration config
│   └── genesis.json            # Genesis block configuration
├── java-app/
│   ├── src/
│   │   ├── Web3jClient.java         # Multi-node connection manager
│   │   ├── TransactionManager.java  # Transaction submission
│   │   ├── BlockMonitor.java        # Synchronization tracking
│   │   ├── ExperimentRunner.java    # Main application
│   │   └── logback.xml             # Logging configuration
│   └── pom.xml                 # Maven dependencies
├── scripts/
│   ├── init-network.sh         # Network initialization
│   ├── run-experiment.sh       # Application runner
│   └── verify-sync.sh          # Synchronization checker
├── docs/
│   └── experiment-results.md   # Results documentation
└── README.md                   # This file
```

## 📖 Usage Guide

### Starting the Network

```bash
cd docker
bash ../scripts/init-network.sh
```

### Checking Network Status

```bash
# Using script
bash scripts/verify-sync.sh

# Or check individual nodes
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8545

curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8547

curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8549
```

### Stopping the Network

```bash
cd docker
docker-compose down
```

### Complete Cleanup (Remove All Data)

```bash
cd docker
docker-compose down -v
docker volume rm docker_node1-data docker_node2-data docker_node3-data
```

### Viewing Container Logs

```bash
# All containers
docker-compose logs -f

# Specific node
docker-compose logs -f eth-node1-validator
docker-compose logs -f eth-node2-full
docker-compose logs -f eth-node3-recovery
```

## 🔧 Troubleshooting

### Nodes Not Starting

**Problem**: Containers fail to start

**Solution**:
```bash
# Check Docker is running
docker ps

# View logs
docker-compose logs

# Restart network
docker-compose down
bash ../scripts/init-network.sh
```

### Nodes Not Synchronizing

**Problem**: Nodes show different block numbers

**Solution**:
```bash
# Check peer connections
docker exec eth-node1-validator geth attach --exec "admin.peers"
docker exec eth-node2-full geth attach --exec "admin.peers"

# Manually add peers (get enode from Node 1)
NODE1_ENODE=$(docker exec eth-node1-validator geth attach --exec "admin.nodeInfo.enode")
docker exec eth-node2-full geth attach --exec "admin.addPeer('$NODE1_ENODE')"
```

### Java Application Cannot Connect

**Problem**: "Connection refused" errors

**Solution**:
```bash
# Verify nodes are running
docker ps

# Check RPC is accessible
curl http://localhost:8545
curl http://localhost:8547
curl http://localhost:8549

# Restart containers
docker-compose restart
```

### Maven Build Failures

**Problem**: Compilation errors

**Solution**:
```bash
# Clean and rebuild
cd java-app
mvn clean install -U

# Verify JDK version
java -version  # Should be 21+
```

### Port Already in Use

**Problem**: "Address already in use" error

**Solution**:
```bash
# Check what's using the ports
netstat -tulpn | grep 8545
netstat -tulpn | grep 8547
netstat -tulpn | grep 8549

# Kill existing processes or change ports in docker-compose.yml
```

## ✅ Expected Results

### Immutability Verification

- **Block Hashes**: All nodes report identical hash for same block number
- **Transaction Order**: Transaction sequence is preserved across all nodes
- **Historical Data**: Past blocks remain unchanged after Node 3 recovery

### Synchronization Verification

- **Block Propagation**: New blocks appear on all online nodes within 5-10 seconds
- **Consistency**: Online nodes always have same block height (±1 block during mining)
- **Peer Discovery**: Nodes automatically connect to each other

### Fault Tolerance Verification

- **Network Continuity**: Blockchain continues operating with Node 3 offline
- **Automatic Recovery**: Node 3 synchronizes automatically upon restart
- **No Data Loss**: Node 3 recovers all missed transactions and blocks
- **State Consistency**: Final state matches across all nodes

### Sample Output

```
========== Blockchain Synchronization Status ==========
NODE1: Block #127
NODE2: Block #127
NODE3: Block #127
=======================================================

========== Verifying Block #127 Hash Consistency ==========
NODE1: 0x7d2d8c9e4f6a1b3c5e8f9d2a4c6b8e1f3a5c7d9e2b4f6a8c1d3e5b7c9f1a3c5
NODE2: 0x7d2d8c9e4f6a1b3c5e8f9d2a4c6b8e1f3a5c7d9e2b4f6a8c1d3e5b7c9f1a3c5
NODE3: 0x7d2d8c9e4f6a1b3c5e8f9d2a4c6b8e1f3a5c7d9e2b4f6a8c1d3e5b7c9f1a3c5
✓ All block hashes are CONSISTENT - Immutability verified!
==========================================================
```

## 📊 Technical Details

### Consensus Mechanism

- **Algorithm**: Clique (Proof of Authority)
- **Block Time**: 5 seconds
- **Network ID**: 2025

### Network Configuration

- **Chain ID**: 2025
- **Gas Limit**: 8,000,000
- **Pre-funded Accounts**: 3 accounts with test Ether

### Pre-funded Account Details

| Address | Balance | Purpose |
|---------|---------|---------|
| 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 | Large amount | Transaction sender |
| 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 | Large amount | Transaction recipient |
| 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC | Large amount | Reserved |

## 🔒 Security Notes

- This is a **private test network** for educational purposes only
- Private keys are publicly known (from Hardhat test accounts)
- **Never use these accounts on mainnet or with real funds**

## 📝 License

Educational/Research Project

## 🤝 Contributing

This is an educational demonstration project. Feel free to modify and adapt for your learning needs.

---

**Happy Experimenting! 🚀**
