# 🚀 Start Ethereum Private Network - Complete Guide

## ✅ ALL ERRORS FIXED!

Three issues have been resolved:
1. ✅ **Mining flags error** (`--miner.threads`)
2. ✅ **Account unlock error** (keystore missing)
3. ✅ **Genesis RLP error** (incompatible fields)

---

## 🎯 Quick Start (3 Steps)

```bash
cd "d:\CSDLNC Demo\docker"

# Step 1: Clean everything
docker-compose down -v
docker volume rm docker_node1-data docker_node2-data docker_node3-data 2>/dev/null || true

# Step 2: Start the network
docker-compose up -d

# Step 3: Verify
docker-compose logs -f
```

**That's it!** The network will:
- Auto-initialize genesis on all nodes
- Auto-copy keystore to node1
- Auto-unlock signer account
- Auto-start mining

---

## 📋 Pre-Flight Checklist

Before starting, verify these files exist:

```bash
cd "d:\CSDLNC Demo\docker"

# Check required files
ls -la genesis.json          # ✓ Should exist
ls -la password.txt          # ✓ Should exist (can be empty)
ls -la docker-compose.yml    # ✓ Should exist
ls -la keystore/            # ✓ Directory should exist

# If keystore missing, create it:
bash create-keystore.sh
```

---

## 🔍 What Happens During Startup

### **Timeline:**

```
T+0s   : docker-compose up -d
         ↓
T+2s   : Containers start
         ↓
T+3s   : Node1 entrypoint checks for keystore
         ├─ Not found? → Initialize genesis + Copy keystore
         └─ Found? → Skip init
         ↓
T+5s   : Genesis initialized
         ↓
T+7s   : Geth starts with --unlock flag
         ↓
T+8s   : Account unlocked successfully
         ↓
T+10s  : Mining/sealing starts
         ↓
T+15s  : First block mined (block #1)
         ↓
T+20s  : Nodes connect as peers
         ↓
T+25s  : Block #2 mined
         ↓
✅      : Network fully operational
```

---

## ✅ Verification Steps

### **1. Check All Containers are Running**
```bash
docker-compose ps
```

**Expected:**
```
NAME                     STATUS
eth-node1-validator      Up
eth-node2-full           Up
eth-node3-recovery       Up
```

---

### **2. Check Node1 Logs (Key Messages)**
```bash
docker-compose logs node1-validator | tail -50
```

**Look for these SUCCESS messages:**
```
✓ INFO Successfully wrote genesis state
✓ INFO Unlocked account address=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
✓ INFO Starting mining operation
✓ INFO Commit new sealing work number=1
✓ INFO Successfully sealed new block number=1
```

**Should NOT see:**
```
❌ "flag provided but not defined: -miner.threads"
❌ "no key for given address or file"
❌ "rlp: input list has too many elements"
```

---

### **3. Test RPC Connectivity**
```bash
# Node 1
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8545

# Node 2
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8547

# Node 3
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8549
```

**Expected:** All return increasing block numbers

---

### **4. Verify Account Balance**
```bash
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266","latest"],"id":1}' \
  http://localhost:8545
```

**Expected:** Large balance from genesis allocation

---

### **5. Check Peer Connections**
```bash
docker exec eth-node1-validator geth attach --exec "admin.peers" 2>/dev/null
```

**Expected:** Shows connected peers (may take 30-60s)

---

## 🐛 Troubleshooting

### **Issue: Containers exit immediately**

**Diagnosis:**
```bash
docker-compose logs node1-validator
```

**Common Causes & Solutions:**

| Error Message | Fix |
|---------------|-----|
| "flag provided but not defined" | Update docker-compose.yml ([FIX_MINING_ERROR.md](FIX_MINING_ERROR.md)) |
| "no key for given address" | Run `bash create-keystore.sh` ([FIX_ACCOUNT_ERROR.md](FIX_ACCOUNT_ERROR.md)) |
| "rlp: input list has too many elements" | Use simplified genesis.json ([FIX_GENESIS_ERROR.md](FIX_GENESIS_ERROR.md)) |

---

### **Issue: "genesis.json: no such file"**

**Solution:**
```bash
cd "d:\CSDLNC Demo\docker"
ls -la genesis.json

# If missing, the file should already exist in your docker/ directory
# Make sure you're in the right directory
```

---

### **Issue: Nodes don't connect to each other**

**Solution:**
```bash
# Manually add peers
docker exec eth-node1-validator geth attach --exec "admin.nodeInfo.enode" 2>/dev/null

# Copy the enode URL, then:
docker exec eth-node2-full geth attach --exec "admin.addPeer('enode://...')" 2>/dev/null
docker exec eth-node3-recovery geth attach --exec "admin.addPeer('enode://...')" 2>/dev/null
```

Or use the init script:
```bash
cd "d:\CSDLNC Demo"
bash scripts/init-network.sh
```

---

### **Issue: "port already allocated"**

**Cause:** Ports 8545, 8547, 8549 already in use

**Solution:**
```bash
# Check what's using the ports
netstat -ano | findstr "8545"

# Stop conflicting services or change ports in docker-compose.yml
```

---

## 📊 Network Configuration Summary

| Node | Role | RPC Port | WS Port | P2P Port | Mining |
|------|------|----------|---------|----------|--------|
| **node1-validator** | Validator/Miner | 8545 | 8546 | 30303 | ✅ Yes |
| **node2-full** | Full Node | 8547 | 8548 | 30304 | ❌ No |
| **node3-recovery** | Full Node (Recovery Test) | 8549 | 8550 | 30305 | ❌ No |

### **Network Details:**
- **Chain ID:** 2025
- **Consensus:** Clique PoA (Proof of Authority)
- **Block Time:** 5 seconds
- **Signer:** 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
- **Gas Limit:** ~4.7M

---

## 🎯 Running the Experiment

Once the network is up:

### **Option 1: Manual Experiment**
```bash
# In terminal 1: Monitor logs
docker-compose logs -f

# In terminal 2: Run Java app
cd ../java-app
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```

### **Option 2: Automated Script**
```bash
cd "d:\CSDLNC Demo"
bash scripts/run-experiment.sh
```

### **Option 3: Verification Script**
```bash
bash scripts/verify-sync.sh
```

---

## 🛑 Stopping the Network

### **Stop (Keep Data)**
```bash
docker-compose stop
```

### **Stop & Remove Containers (Keep Volumes)**
```bash
docker-compose down
```

### **Complete Cleanup (Remove Everything)**
```bash
docker-compose down -v
docker volume rm docker_node1-data docker_node2-data docker_node3-data 2>/dev/null || true
```

---

## 📚 Documentation Reference

| Guide | Purpose |
|-------|---------|
| **[FIX_MINING_ERROR.md](FIX_MINING_ERROR.md)** | Mining flags issue |
| **[FIX_ACCOUNT_ERROR.md](FIX_ACCOUNT_ERROR.md)** | Account unlock issue |
| **[FIX_GENESIS_ERROR.md](FIX_GENESIS_ERROR.md)** | Genesis RLP issue |
| **[START_NETWORK.md](START_NETWORK.md)** | This guide |

---

## ✅ Success Checklist

- [ ] All 3 containers show "Up" status
- [ ] Node1 logs show "Unlocked account"
- [ ] Node1 logs show "Successfully sealed new block"
- [ ] RPC endpoints respond (ports 8545, 8547, 8549)
- [ ] Block numbers are increasing
- [ ] No error messages in logs

---

## 🎉 You're Ready!

If all checks pass, your private Ethereum network is running successfully!

```bash
# Start experimenting
cd ../java-app
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```

**Enjoy your blockchain experiment!** 🚀
