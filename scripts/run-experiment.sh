#!/bin/bash

###############################################################################
# Ethereum Fault Tolerance Experiment Runner
# Purpose: Compile and run the Java experiment application
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
echo "Q  Blockchain Fault Tolerance Experiment - Runner               Q"
echo "ZPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP]"
echo -e "${NC}"

# Navigate to java-app directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JAVA_APP_DIR="$(dirname "$SCRIPT_DIR")/java-app"

echo -e "${YELLOW}[1/4]${NC} Navigating to Java application directory..."
cd "$JAVA_APP_DIR"
echo -e "${GREEN}${NC} Current directory: $(pwd)"

# Check if Maven is installed
echo -e "\n${YELLOW}[2/4]${NC} Checking Maven installation..."
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}${NC} Maven is not installed!"
    echo "Please install Maven: https://maven.apache.org/install.html"
    exit 1
fi
echo -e "${GREEN}${NC} Maven is installed: $(mvn --version | head -n 1)"

# Compile the Java application
echo -e "\n${YELLOW}[3/4]${NC} Compiling Java application..."
mvn clean package -q

if [ $? -eq 0 ]; then
    echo -e "${GREEN}${NC} Compilation successful!"
else
    echo -e "${RED}${NC} Compilation failed!"
    exit 1
fi

# Check if Ethereum nodes are running
echo -e "\n${YELLOW}[4/4]${NC} Checking Ethereum node connectivity..."

check_node() {
    local port=$1
    local node_name=$2

    if curl -s -X POST -H "Content-Type: application/json" \
        --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
        http://localhost:$port > /dev/null 2>&1; then
        echo -e "${GREEN}${NC} $node_name is reachable (port $port)"
        return 0
    else
        echo -e "${RED}${NC} $node_name is NOT reachable (port $port)"
        return 1
    fi
}

all_nodes_ok=true

check_node 8545 "Node 1 (Validator)" || all_nodes_ok=false
check_node 8547 "Node 2 (Full)"      || all_nodes_ok=false
check_node 8549 "Node 3 (Recovery)"  || all_nodes_ok=false

if [ "$all_nodes_ok" = false ]; then
    echo -e "\n${YELLOW}  Warning: Not all nodes are reachable!${NC}"
    echo "You may want to start the network first:"
    echo "  bash ../scripts/init-network.sh"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Run the experiment
echo -e "\n${GREEN}PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP${NC}"
echo -e "${GREEN}Starting Experiment Application...${NC}"
echo -e "${GREEN}PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP${NC}\n"

sleep 2

# Run with logging
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar

echo -e "\n${GREEN}PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP${NC}"
echo -e "${GREEN}Experiment Complete!${NC}"
echo -e "${GREEN}PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP${NC}\n"
