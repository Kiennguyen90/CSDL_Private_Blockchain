#!/bin/bash

###############################################################################
# Ethereum Private Network Initialization Script
# Purpose: Initialize and start the 3-node Ethereum network
###############################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "TPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPW"
echo "Q  Ethereum Private Network - Initialization Script             Q"
echo "Q  3-Node Topology: Validator + 2 Full Nodes                    Q"
echo "ZPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP]"
echo -e "${NC}"

# Navigate to docker directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")/docker"

echo -e "${YELLOW}[1/6]${NC} Navigating to Docker directory..."
cd "$DOCKER_DIR"
echo -e "${GREEN}${NC} Current directory: $(pwd)"

# Stop any existing containers
echo -e "\n${YELLOW}[2/6]${NC} Stopping existing containers (if any)..."
docker-compose down -v 2>/dev/null || true
echo -e "${GREEN}${NC} Cleanup complete"

# Remove old blockchain data
echo -e "\n${YELLOW}[3/6]${NC} Removing old blockchain data..."
docker volume rm docker_node1-data docker_node2-data docker_node3-data 2>/dev/null || true
echo -e "${GREEN}${NC} Old data removed"

# Start the network
echo -e "\n${YELLOW}[4/6]${NC} Starting Ethereum network..."
docker-compose up -d

# Wait for containers to start
echo -e "\n${YELLOW}[5/6]${NC} Waiting for containers to initialize..."
sleep 10

# Initialize nodes with genesis block
# MSYS_NO_PATHCONV=1 prevents Git Bash on Windows from converting /genesis.json to a Windows path
echo -e "\n${YELLOW}[6/6]${NC} Initializing nodes with genesis block..."

echo "  Initializing Node 1 (Validator)..."
MSYS_NO_PATHCONV=1 docker exec eth-node1-validator geth init --datadir /root/.ethereum /genesis.json 2>/dev/null || echo "    Genesis already initialized"

echo "  Initializing Node 2 (Full)..."
MSYS_NO_PATHCONV=1 docker exec eth-node2-full geth init --datadir /root/.ethereum /genesis.json 2>/dev/null || echo "    Genesis already initialized"

echo "  Initializing Node 3 (Recovery)..."
MSYS_NO_PATHCONV=1 docker exec eth-node3-recovery geth init --datadir /root/.ethereum /genesis.json 2>/dev/null || echo "    Genesis already initialized"

echo -e "${GREEN}${NC} Genesis blocks initialized"

# Restart containers to apply genesis
echo -e "\n${YELLOW}Restarting containers...${NC}"
docker-compose restart

# Wait for nodes to be fully ready
echo -e "\n${YELLOW}Waiting for nodes to be ready...${NC}"
sleep 15

# Connect nodes as peers
echo -e "\n${YELLOW}Connecting nodes as peers...${NC}"

# Extract the 128-char public key from the full enode URL, then rebuild with Docker hostname
RAW_ENODE=$(MSYS_NO_PATHCONV=1 docker exec eth-node1-validator geth attach --exec "admin.nodeInfo.enode" 2>/dev/null | tr -d '"')
NODE1_PUBKEY=$(echo "$RAW_ENODE" | sed 's/enode:\/\/\([0-9a-f]*\)@.*/\1/')
if [ -z "$NODE1_PUBKEY" ]; then
  echo -e "${RED}  ERROR: Could not retrieve Node 1 enode. Is node1 running?${NC}"
  exit 1
fi
NODE1_ENODE="enode://${NODE1_PUBKEY}@node1:30303"
echo "  Node 1 enode: $NODE1_ENODE"

# Get Node 2 and Node 3 enodes
RAW_NODE2=$(MSYS_NO_PATHCONV=1 docker exec eth-node2-full geth attach --exec "admin.nodeInfo.enode" 2>/dev/null | tr -d '"')
NODE2_PUBKEY=$(echo "$RAW_NODE2" | sed 's/enode:\/\/\([0-9a-f]*\)@.*/\1/')
NODE2_ENODE="enode://${NODE2_PUBKEY}@node2:30303"

RAW_NODE3=$(MSYS_NO_PATHCONV=1 docker exec eth-node3-recovery geth attach --exec "admin.nodeInfo.enode" 2>/dev/null | tr -d '"')
NODE3_PUBKEY=$(echo "$RAW_NODE3" | sed 's/enode:\/\/\([0-9a-f]*\)@.*/\1/')
NODE3_ENODE="enode://${NODE3_PUBKEY}@node3:30303"

# Connect peers in both directions to handle one-way connectivity issues
echo "  Connecting Node 2 to Node 1..."
MSYS_NO_PATHCONV=1 docker exec eth-node2-full geth attach --exec "admin.addPeer('$NODE1_ENODE')" 2>/dev/null || true
echo "  Connecting Node 1 to Node 2..."
MSYS_NO_PATHCONV=1 docker exec eth-node1-validator geth attach --exec "admin.addPeer('$NODE2_ENODE')" 2>/dev/null || true

echo "  Connecting Node 3 to Node 1..."
MSYS_NO_PATHCONV=1 docker exec eth-node3-recovery geth attach --exec "admin.addPeer('$NODE1_ENODE')" 2>/dev/null || true
echo "  Connecting Node 1 to Node 3..."
MSYS_NO_PATHCONV=1 docker exec eth-node1-validator geth attach --exec "admin.addPeer('$NODE3_ENODE')" 2>/dev/null || true

# Write static-nodes.json into each node's datadir so peers reconnect after restarts
STATIC_JSON=$(printf '[\n  "%s",\n  "%s",\n  "%s"\n]' "$NODE1_ENODE" "$NODE2_ENODE" "$NODE3_ENODE")
echo "$STATIC_JSON" | MSYS_NO_PATHCONV=1 docker exec -i eth-node1-validator tee /root/.ethereum/geth/static-nodes.json > /dev/null
echo "$STATIC_JSON" | MSYS_NO_PATHCONV=1 docker exec -i eth-node2-full tee /root/.ethereum/geth/static-nodes.json > /dev/null
echo "$STATIC_JSON" | MSYS_NO_PATHCONV=1 docker exec -i eth-node3-recovery tee /root/.ethereum/geth/static-nodes.json > /dev/null
echo "  Static-nodes.json written to all nodes"

sleep 5

# Display network status
echo -e "\n${BLUE}TPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPW${NC}"
echo -e "${BLUE}Q  Network Status                                                Q${NC}"
echo -e "${BLUE}ZPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP]${NC}"

docker-compose ps

echo -e "\n${GREEN}PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP${NC}"
echo -e "${GREEN} Ethereum Private Network Initialized Successfully!${NC}"
echo -e "${GREEN}PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP${NC}"

echo -e "\n${YELLOW}Node Connection Details:${NC}"
echo "  Node 1 (Validator): http://localhost:8545"
echo "  Node 2 (Full):      http://localhost:8547"
echo "  Node 3 (Recovery):  http://localhost:8549"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "  1. Compile Java application: cd ../java-app && mvn clean package"
echo "  2. Run experiment: java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar"
echo "  3. Or use: bash ../scripts/run-experiment.sh"

echo ""
