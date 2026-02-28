#!/bin/bash

###############################################################################
# Account Initialization Script
# Creates the signer account for Clique PoA
###############################################################################

echo "========================================="
echo "Initializing Clique Signer Account"
echo "========================================="
echo ""

ACCOUNT_ADDRESS="0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
PRIVATE_KEY="ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"

# Start temporary container to create account
echo "[1/3] Creating temporary container..."
docker run --rm -v "$(pwd)/node1-data:/root/.ethereum" \
  ethereum/client-go:v1.13.15 \
  account import --password /dev/null --datadir /root/.ethereum \
  /dev/stdin <<< "$PRIVATE_KEY" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Account imported successfully!"
else
    echo "Note: Account may already exist (this is okay)"
fi

echo ""
echo "[2/3] Verifying account..."
docker run --rm -v "$(pwd)/node1-data:/root/.ethereum" \
  ethereum/client-go:v1.13.15 \
  account list --datadir /root/.ethereum

echo ""
echo "[3/3] Account setup complete!"
echo "Address: $ACCOUNT_ADDRESS"
echo ""
echo "You can now start the nodes with: docker-compose up -d"
echo "========================================="
