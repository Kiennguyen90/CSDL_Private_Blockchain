#!/bin/bash

###############################################################################
# Automatic IntelliJ IDEA Maven Project Fix Script
###############################################################################

echo "============================================"
echo "IntelliJ IDEA Maven Project Fix"
echo "============================================"
echo ""

echo "This script will:"
echo "1. Remove incorrect IntelliJ project files"
echo "2. Clean the Maven build"
echo "3. Rebuild the project"
echo "4. Prepare for IntelliJ reimport"
echo ""

read -p "Press ENTER to continue..."

echo ""
echo "[1/4] Removing incorrect IntelliJ files..."
rm -rf .idea *.iml src/.idea src/*.iml src/out 2>/dev/null
echo "Done."

echo ""
echo "[2/4] Cleaning Maven build..."
if ! mvn clean; then
    echo "ERROR: Maven clean failed!"
    echo "Make sure Maven is installed and in PATH"
    exit 1
fi
echo "Done."

echo ""
echo "[3/4] Rebuilding with Maven..."
if ! mvn compile; then
    echo "ERROR: Maven compile failed!"
    exit 1
fi
echo "Done."

echo ""
echo "[4/4] Verifying dependencies..."
if [ -f "target/classes/Web3jClient.class" ]; then
    echo "SUCCESS: Web3jClient compiled!"
else
    echo "WARNING: Web3jClient not found"
fi

if [ -f "target/classes/ExperimentRunner.class" ]; then
    echo "SUCCESS: ExperimentRunner compiled!"
else
    echo "WARNING: ExperimentRunner not found"
fi

echo ""
echo "============================================"
echo "Fix Complete!"
echo "============================================"
echo ""
echo "Next steps:"
echo "1. CLOSE IntelliJ IDEA if it's open"
echo "2. Open IntelliJ IDEA"
echo "3. File > Open"
echo "4. Select this folder: $(pwd)"
echo "5. Click OK"
echo "6. Wait for Maven import to complete"
echo ""
echo "After import, the SLF4J error should be gone!"
echo ""
