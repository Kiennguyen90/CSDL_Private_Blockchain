#!/bin/bash

###############################################################################
# Test Build Script for Linux/macOS
###############################################################################

echo "========================================"
echo "Testing Java Application Build"
echo "========================================"
echo ""

echo "[1/4] Checking Java version..."
if ! java -version 2>&1 | grep -q "version"; then
    echo "ERROR: Java not found!"
    exit 1
fi
java -version
echo ""

echo "[2/4] Checking Maven version..."
if ! command -v mvn &> /dev/null; then
    echo "ERROR: Maven not found!"
    exit 1
fi
mvn -version | head -1
echo ""

echo "[3/4] Building project..."
if ! mvn clean package -q; then
    echo "ERROR: Build failed!"
    exit 1
fi
echo "Build completed successfully"
echo ""

echo "[4/4] Checking JAR file..."
if [ -f "target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar" ]; then
    echo "SUCCESS: JAR file created!"
    ls -lh target/*.jar | grep ethereum
else
    echo "ERROR: JAR file not found!"
    exit 1
fi
echo ""

echo "========================================"
echo "BUILD TEST PASSED!"
echo "========================================"
echo ""
echo "You can now run the application with:"
echo "java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar"
echo ""
