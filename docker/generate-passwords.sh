#!/bin/bash

echo "Generating password files for 3 nodes..."
echo ""

# Node 1 password (for validator/miner)
echo "node1_password_2025" > password-node1.txt
echo "✓ Created password-node1.txt"

# Node 2 password (for full node)
echo "node2_password_2025" > password-node2.txt
echo "✓ Created password-node2.txt"

# Node 3 password (for recovery node)
echo "node3_password_2025" > password-node3.txt
echo "✓ Created password-node3.txt"

# Keep the original empty password for node1 (backward compatibility)
touch password.txt
echo "✓ Created password.txt (empty - for compatibility)"

echo ""
echo "========================================="
echo "Password files created:"
echo "========================================="
echo "password-node1.txt  : node1_password_2025"
echo "password-node2.txt  : node2_password_2025"
echo "password-node3.txt  : node3_password_2025"
echo "password.txt        : (empty)"
echo ""
echo "You can change these passwords to anything you want."
echo "For a test network, these simple passwords are fine."
echo "========================================="
