#!/bin/bash

###############################################################################
# Blockchain Synchronization Verification Script
# Purpose: Verify that all nodes have synchronized blockchain state
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
echo "Q  Blockchain Synchronization Verification                      Q"
echo "ZPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP]"
echo -e "${NC}"

# Function to get block number from a node
get_block_number() {
    local port=$1
    local result=$(curl -s -X POST -H "Content-Type: application/json" \
        --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
        http://localhost:$port 2>/dev/null)

    if [ $? -eq 0 ]; then
        # Extract hex block number and convert to decimal
        local hex_block=$(echo $result | grep -o '"result":"[^"]*"' | cut -d'"' -f4)
        if [ -n "$hex_block" ]; then
            echo $((16#${hex_block:2}))
        else
            echo "-1"
        fi
    else
        echo "-1"
    fi
}

# Function to get block hash
get_block_hash() {
    local port=$1
    local block_num=$2

    # Convert decimal to hex
    local hex_block=$(printf "0x%x" $block_num)

    local result=$(curl -s -X POST -H "Content-Type: application/json" \
        --data "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBlockByNumber\",\"params\":[\"$hex_block\",false],\"id\":1}" \
        http://localhost:$port 2>/dev/null)

    if [ $? -eq 0 ]; then
        echo $result | grep -o '"hash":"[^"]*"' | head -1 | cut -d'"' -f4
    else
        echo "N/A"
    fi
}

# Function to get peer count
get_peer_count() {
    local port=$1
    local result=$(curl -s -X POST -H "Content-Type: application/json" \
        --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' \
        http://localhost:$port 2>/dev/null)

    if [ $? -eq 0 ]; then
        local hex_peers=$(echo $result | grep -o '"result":"[^"]*"' | cut -d'"' -f4)
        if [ -n "$hex_peers" ]; then
            echo $((16#${hex_peers:2}))
        else
            echo "0"
        fi
    else
        echo "0"
    fi
}

echo -e "${YELLOW}Checking node connectivity and block numbers...${NC}\n"

# Get block numbers from all nodes
NODE1_BLOCK=$(get_block_number 8545)
NODE2_BLOCK=$(get_block_number 8547)
NODE3_BLOCK=$(get_block_number 8549)

# Get peer counts
NODE1_PEERS=$(get_peer_count 8545)
NODE2_PEERS=$(get_peer_count 8547)
NODE3_PEERS=$(get_peer_count 8549)

# Display status
echo "TPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPW"
echo "Q  Node Status                                                   Q"
echo "`PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPc"

if [ $NODE1_BLOCK -ge 0 ]; then
    echo -e "Q  ${GREEN}Node 1 (Validator)${NC}                                         Q"
    printf "Q    Block Number: %-42sQ\n" "$NODE1_BLOCK"
    printf "Q    Peers: %-49sQ\n" "$NODE1_PEERS"
else
    echo -e "Q  ${RED}Node 1 (Validator): OFFLINE${NC}                               Q"
fi

echo "`PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPc"

if [ $NODE2_BLOCK -ge 0 ]; then
    echo -e "Q  ${GREEN}Node 2 (Full)${NC}                                              Q"
    printf "Q    Block Number: %-42sQ\n" "$NODE2_BLOCK"
    printf "Q    Peers: %-49sQ\n" "$NODE2_PEERS"
else
    echo -e "Q  ${RED}Node 2 (Full): OFFLINE${NC}                                    Q"
fi

echo "`PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPc"

if [ $NODE3_BLOCK -ge 0 ]; then
    echo -e "Q  ${GREEN}Node 3 (Recovery)${NC}                                          Q"
    printf "Q    Block Number: %-42sQ\n" "$NODE3_BLOCK"
    printf "Q    Peers: %-49sQ\n" "$NODE3_PEERS"
else
    echo -e "Q  ${RED}Node 3 (Recovery): OFFLINE${NC}                                Q"
fi

echo "ZPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP]"

# Check synchronization
echo -e "\n${YELLOW}Synchronization Analysis:${NC}"

all_synced=true

# Collect online nodes and their blocks
declare -a online_blocks
[ $NODE1_BLOCK -ge 0 ] && online_blocks+=($NODE1_BLOCK)
[ $NODE2_BLOCK -ge 0 ] && online_blocks+=($NODE2_BLOCK)
[ $NODE3_BLOCK -ge 0 ] && online_blocks+=($NODE3_BLOCK)

if [ ${#online_blocks[@]} -eq 0 ]; then
    echo -e "${RED} All nodes are offline!${NC}"
    exit 1
fi

# Check if all online nodes have the same block number
reference_block=${online_blocks[0]}
for block in "${online_blocks[@]}"; do
    if [ $block -ne $reference_block ]; then
        all_synced=false
        break
    fi
done

if [ "$all_synced" = true ]; then
    echo -e "${GREEN} All online nodes are synchronized at block #$reference_block${NC}"

    # Verify block hash consistency
    echo -e "\n${YELLOW}Verifying block hash consistency for block #$reference_block...${NC}"

    NODE1_HASH=""
    NODE2_HASH=""
    NODE3_HASH=""

    [ $NODE1_BLOCK -ge 0 ] && NODE1_HASH=$(get_block_hash 8545 $reference_block)
    [ $NODE2_BLOCK -ge 0 ] && NODE2_HASH=$(get_block_hash 8547 $reference_block)
    [ $NODE3_BLOCK -ge 0 ] && NODE3_HASH=$(get_block_hash 8549 $reference_block)

    echo ""
    [ -n "$NODE1_HASH" ] && echo "Node 1 hash: $NODE1_HASH"
    [ -n "$NODE2_HASH" ] && echo "Node 2 hash: $NODE2_HASH"
    [ -n "$NODE3_HASH" ] && echo "Node 3 hash: $NODE3_HASH"

    # Check if all hashes match
    hashes_match=true
    reference_hash=""

    for hash in "$NODE1_HASH" "$NODE2_HASH" "$NODE3_HASH"; do
        if [ -n "$hash" ] && [ "$hash" != "N/A" ]; then
            if [ -z "$reference_hash" ]; then
                reference_hash=$hash
            elif [ "$hash" != "$reference_hash" ]; then
                hashes_match=false
                break
            fi
        fi
    done

    if [ "$hashes_match" = true ] && [ -n "$reference_hash" ]; then
        echo -e "\n${GREEN} Block hashes are CONSISTENT - Immutability verified!${NC}"
    else
        echo -e "\n${RED} Block hash MISMATCH detected!${NC}"
    fi

else
    echo -e "${YELLOW}  Nodes are at different block heights:${NC}"
    [ $NODE1_BLOCK -ge 0 ] && echo "  Node 1: $NODE1_BLOCK"
    [ $NODE2_BLOCK -ge 0 ] && echo "  Node 2: $NODE2_BLOCK"
    [ $NODE3_BLOCK -ge 0 ] && echo "  Node 3: $NODE3_BLOCK"
    echo -e "${YELLOW}  (This may be temporary during synchronization)${NC}"
fi

# Summary
echo -e "\n${BLUE}TPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPW${NC}"
echo -e "${BLUE}Q  Verification Summary                                          Q${NC}"
echo -e "${BLUE}ZPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP]${NC}"

online_count=0
[ $NODE1_BLOCK -ge 0 ] && ((online_count++))
[ $NODE2_BLOCK -ge 0 ] && ((online_count++))
[ $NODE3_BLOCK -ge 0 ] && ((online_count++))

echo "  " Online Nodes: $online_count/3"
echo "  " Synchronized: $([ "$all_synced" = true ] && echo "Yes" || echo "No")"
echo "  " Latest Block: $reference_block"

echo ""
