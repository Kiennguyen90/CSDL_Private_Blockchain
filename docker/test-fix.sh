#!/bin/bash

echo "========================================="
echo "Testing Fixed Geth Configuration"
echo "========================================="
echo ""

echo "[1/5] Stopping old containers..."
docker-compose down 2>/dev/null

echo ""
echo "[2/5] Checking if password.txt exists..."
if [ -f "password.txt" ]; then
    echo "✓ password.txt exists"
else
    echo "Creating password.txt..."
    touch password.txt
fi

echo ""
echo "[3/5] Starting nodes with fixed configuration..."
docker-compose up -d

echo ""
echo "[4/5] Waiting for nodes to start..."
sleep 15

echo ""
echo "[5/5] Checking node status..."
docker-compose ps

echo ""
echo "Checking for errors in node1-validator logs..."
docker-compose logs node1-validator | grep -i "miner.threads" && echo "ERROR: Still seeing miner.threads error!" || echo "✓ No miner.threads error found!"

echo ""
echo "Testing RPC connection..."
curl -s -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8545 && echo -e "\n✓ Node1 RPC is responding!" || echo "✗ Node1 RPC not responding"

echo ""
echo "========================================="
echo "Test Complete!"
echo "========================================="
echo ""
echo "If all checks passed, run:"
echo "  docker-compose logs -f"
echo ""
echo "To see live logs from all nodes."
