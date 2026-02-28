# Setup Guide - Fixing Java Application Issues

## Problem Identified

The Java application had **incorrect directory structure**. Maven expects a specific folder layout, but the files were in the wrong location.

### What Was Wrong:

1. **Wrong Directory Structure**:
   ```
   ❌ BEFORE (Incorrect):
   java-app/
   └── src/
       ├── Web3jClient.java
       ├── TransactionManager.java
       ├── BlockMonitor.java
       ├── ExperimentRunner.java
       └── logback.xml
   ```

2. **Maven's Expected Structure**:
   ```
   ✅ AFTER (Correct):
   java-app/
   └── src/
       └── main/
           ├── java/
           │   ├── Web3jClient.java
           │   ├── TransactionManager.java
           │   ├── BlockMonitor.java
           │   └── ExperimentRunner.java
           └── resources/
               └── logback.xml
   ```

## What Was Fixed

The following changes were made:

1. ✅ Created `src/main/java` directory
2. ✅ Created `src/main/resources` directory
3. ✅ Moved all `.java` files to `src/main/java/`
4. ✅ Moved `logback.xml` to `src/main/resources/`

## How to Compile and Run

### Prerequisites

Make sure you have installed:
- **Java JDK 21 or higher**
- **Apache Maven 3.6+**

Verify installation:
```bash
java -version
mvn -version
```

### Step 1: Clean and Compile

```bash
cd "d:\CSDLNC Demo\java-app"
mvn clean compile
```

### Step 2: Package (Create JAR)

```bash
mvn clean package
```

This will create:
- `target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar` (executable JAR with all dependencies)

### Step 3: Run the Application

```bash
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```

## Installation Instructions for Maven

### Windows:

1. **Download Maven**:
   - Go to https://maven.apache.org/download.cgi
   - Download `apache-maven-3.x.x-bin.zip`

2. **Extract**:
   - Extract to `C:\Program Files\Apache\maven`

3. **Set Environment Variables**:
   - Add `M2_HOME = C:\Program Files\Apache\maven`
   - Add to `PATH`: `%M2_HOME%\bin`

4. **Verify**:
   ```cmd
   mvn -version
   ```

### Linux/macOS:

```bash
# Using package manager
# Ubuntu/Debian
sudo apt update
sudo apt install maven

# macOS (Homebrew)
brew install maven

# Verify
mvn -version
```

## Troubleshooting

### Error: "Cannot resolve symbol 'web3j'"

**Cause**: Maven dependencies not downloaded or wrong directory structure

**Solution**:
1. Ensure correct directory structure (see above)
2. Run `mvn clean install` to download dependencies
3. Wait for Maven to download all dependencies from Maven Central

### Error: "package org.web3j does not exist"

**Cause**: Dependencies not downloaded

**Solution**:
```bash
cd "d:\CSDLNC Demo\java-app"
mvn dependency:resolve
mvn clean compile
```

### Error: "JAVA_HOME not set"

**Solution**:
```bash
# Windows (cmd)
set JAVA_HOME=C:\Program Files\Java\jdk-21

# Linux/macOS
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
```

### Force Re-download Dependencies

If dependencies are corrupted:
```bash
mvn dependency:purge-local-repository
mvn clean install
```

## IDE Setup (Optional)

### IntelliJ IDEA:
1. Open IntelliJ IDEA
2. File → Open → Select `java-app` folder
3. IntelliJ will auto-detect Maven project
4. Wait for dependency download
5. Run `ExperimentRunner.java`

### Eclipse:
1. File → Import → Existing Maven Projects
2. Select `java-app` folder
3. Right-click project → Maven → Update Project
4. Run as Java Application

### VS Code:
1. Install "Java Extension Pack"
2. Install "Maven for Java"
3. Open `java-app` folder
4. VS Code will detect Maven project automatically

## Project Structure Overview

```
java-app/
├── pom.xml                          # Maven configuration
├── src/
│   └── main/
│       ├── java/                    # Java source files
│       │   ├── Web3jClient.java           # Multi-node connection manager
│       │   ├── TransactionManager.java    # Transaction handling
│       │   ├── BlockMonitor.java          # Synchronization monitoring
│       │   └── ExperimentRunner.java      # Main application
│       └── resources/               # Resources
│           └── logback.xml                # Logging configuration
└── target/                          # Compiled output (generated)
    └── *.jar                        # Executable JARs
```

## Quick Start Commands

```bash
# Navigate to project
cd "d:\CSDLNC Demo\java-app"

# Install dependencies (first time)
mvn clean install

# Compile only
mvn compile

# Package (create JAR)
mvn package

# Run application
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar

# Clean build artifacts
mvn clean
```

## Complete Workflow

```bash
# 1. Start Ethereum network
cd "d:\CSDLNC Demo\docker"
bash ../scripts/init-network.sh

# 2. Compile Java application
cd "../java-app"
mvn clean package

# 3. Run experiment
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar

# OR use the automated script
cd "d:\CSDLNC Demo"
bash scripts/run-experiment.sh
```

## Expected Output

When compilation is successful, you should see:
```
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 15.234 s
[INFO] Finished at: 2024-XX-XX...
[INFO] ------------------------------------------------------------------------
```

When running the application:
```
╔════════════════════════════════════════════════════════════════╗
║  Blockchain Immutability & Fault Tolerance Experiment         ║
║  Private Ethereum Network - 3 Node Topology                   ║
╚════════════════════════════════════════════════════════════════╝

Initializing connections to Ethereum nodes...
✓ Connected to Node1 (Validator) at http://localhost:8545
✓ Connected to Node2 (Full) at http://localhost:8547
✓ Connected to Node3 (Recovery) at http://localhost:8549
```

## Summary

✅ **Fixed**: Moved Java files from `src/` to `src/main/java/`
✅ **Fixed**: Moved logback.xml from `src/` to `src/main/resources/`
✅ **Result**: Maven can now compile the project correctly

You can now proceed with compiling and running the blockchain experiment!
