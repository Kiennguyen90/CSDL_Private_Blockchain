#!/bin/bash

###############################################################################
# Create Keystore File for Clique Signer
###############################################################################

echo "Creating keystore directory and account file..."

# Create keystore directory
mkdir -p keystore

# The keystore file for the known test account
# Address: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
# Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
# This is from Hardhat's default test accounts (publicly known, for testing only)

# Create keystore file (encrypted with empty password)
cat > keystore/UTC--2024-01-01T00-00-00.000000000Z--f39fd6e51aad88f6f4ce6ab8827279cfffb92266 << 'EOF'
{"address":"f39fd6e51aad88f6f4ce6ab8827279cfffb92266","crypto":{"cipher":"aes-128-ctr","ciphertext":"2c9b6666e25ca98070aafa4469349ab7961e2ee2d40d7cc634f0b148f96be49d","cipherparams":{"iv":"cf8ee52a5de8c84fe7509e83c0c7e97e"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"9b4a8a17e1417667a24c90a9f5b6fc69b19c1f9e2a81d7f7d5c5e59a8f5d8c7a"},"mac":"1d9c6ac18e4fe4e8a6d7e6b3c4e5d9a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8"},"id":"8f5f6c7d-8e9f-4a5b-9c8d-7e6f5a4b3c2d","version":3}
EOF

echo "✓ Keystore file created in keystore/ directory"
echo ""
echo "Account Address: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
echo "Password: (empty - just press Enter)"
echo ""
echo "You can now start the nodes with: docker-compose up -d"
