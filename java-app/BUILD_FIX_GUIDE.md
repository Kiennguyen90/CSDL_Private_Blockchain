# Build Fix Guide - Resolving Dependency Errors

## ✅ Good News!

Your project **has already been built successfully**! The JAR file exists at:
```
target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar (25 MB)
```

All classes compiled successfully:
- ✅ Web3jClient.class
- ✅ TransactionManager.class
- ✅ BlockMonitor.class
- ✅ ExperimentRunner.class

## 🔍 Why You See Errors in IDE

The errors you're seeing are **IDE-related**, not actual compilation errors. Your IDE (IntelliJ IDEA, Eclipse, or VS Code) hasn't properly imported the Maven project or indexed the dependencies.

## 🛠️ Solutions by IDE

### **Option 1: IntelliJ IDEA**

#### Method A: Reimport Maven Project
1. **File → Invalidate Caches / Restart**
2. Click "Invalidate and Restart"
3. After restart: **Right-click `pom.xml`** → **Maven** → **Reload Project**
4. Wait for indexing to complete (bottom-right corner)

#### Method B: Reimport Project from Scratch
1. **File → Close Project**
2. **Open → Select** `d:\CSDLNC Demo\java-app`
3. IntelliJ will detect Maven project automatically
4. Wait for dependency download (check bottom-right progress bar)

#### Method C: Force Dependency Download
1. Open **Maven Tool Window** (View → Tool Windows → Maven)
2. Click **Reload All Maven Projects** (circular arrow icon)
3. Right-click project → **Maven** → **Download Sources and Documentation**

---

### **Option 2: Visual Studio Code**

1. Install required extensions:
   - **Extension Pack for Java** (by Microsoft)
   - **Maven for Java** (by Microsoft)

2. Open Command Palette (`Ctrl+Shift+P`)
3. Run: **Java: Clean Java Language Server Workspace**
4. Run: **Java: Force Java Compilation → Full**
5. Run: **Maven: Update Project**

6. Reload VS Code (`Ctrl+R`)

---

### **Option 3: Eclipse**

1. **Right-click project** → **Maven** → **Update Project**
2. Check "Force Update of Snapshots/Releases"
3. Click **OK**

4. If still showing errors:
   - **Project → Clean**
   - Select "Clean all projects"
   - Check "Start a build immediately"

---

## 🚀 Command Line Build (Always Works)

Even if your IDE shows errors, you can always build from command line:

### **Full Clean Build**
```bash
cd "d:\CSDLNC Demo\java-app"

# Clean everything
mvn clean

# Download all dependencies
mvn dependency:resolve
mvn dependency:resolve-plugins

# Compile and package
mvn clean package
```

### **Quick Rebuild**
```bash
cd "d:\CSDLNC Demo\java-app"
mvn clean install
```

### **Force Re-download Dependencies**
```bash
cd "d:\CSDLNC Demo\java-app"

# Clear local Maven cache for this project
mvn dependency:purge-local-repository

# Re-download everything
mvn clean install -U
```

---

## 🧪 Test the Application

The JAR is already built and ready to run!

### **Run Directly**
```bash
cd "d:\CSDLNC Demo\java-app"
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```

### **Expected Output**
```
╔════════════════════════════════════════════════════════════════╗
║  Blockchain Immutability & Fault Tolerance Experiment         ║
║  Private Ethereum Network - 3 Node Topology                   ║
╚════════════════════════════════════════════════════════════════╝

Initializing connections to Ethereum nodes...
```

---

## 📊 Verify Dependencies

Check that all dependencies are downloaded:

```bash
cd "d:\CSDLNC Demo\java-app"
mvn dependency:tree
```

Expected key dependencies:
```
[INFO] com.blockchain.experiment:ethereum-fault-tolerance:jar:1.0-SNAPSHOT
[INFO] +- org.web3j:core:jar:4.10.3:compile
[INFO] +- org.slf4j:slf4j-api:jar:2.0.9:compile
[INFO] +- ch.qos.logback:logback-classic:jar:1.4.11:compile
[INFO] +- org.apache.commons:commons-lang3:jar:3.13.0:compile
[INFO] \- com.google.code.gson:gson:jar:2.10.1:compile
```

---

## 🔧 Common Dependency Issues

### **Issue 1: "Cannot resolve symbol 'Web3j'"**

**Cause**: IDE hasn't indexed Maven dependencies

**Solution**:
```bash
# Command line - force dependency download
cd "d:\CSDLNC Demo\java-app"
mvn dependency:resolve -U

# Then reload project in IDE
```

---

### **Issue 2: "Package org.web3j does not exist"**

**Cause**: Dependencies not in IDE classpath

**Solution for IntelliJ**:
1. File → Project Structure (Ctrl+Alt+Shift+S)
2. Modules → Dependencies
3. Click **+** → Library → From Maven
4. Search: `org.web3j:core:4.10.3`
5. Add it

**Better Solution**:
```bash
mvn clean install
```
Then reimport Maven project in IDE.

---

### **Issue 3: "Java version mismatch"**

**Cause**: Project requires JDK 21, but IDE is using different version

**Solution**:
```bash
# Check Java version
java -version
# Should show version 21 or higher

# If wrong version, set JAVA_HOME
# Windows (PowerShell)
$env:JAVA_HOME="C:\Program Files\Java\jdk-21"

# Linux/macOS
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
```

**IntelliJ**:
1. File → Project Structure → Project
2. SDK: Select JDK 21
3. Language Level: 21

---

### **Issue 4: "Maven not found" or "mvn command not found"**

**Verify Maven Installation**:
```bash
mvn -version
```

**If not installed**:
- Windows: Download from https://maven.apache.org/download.cgi
- Linux: `sudo apt install maven`
- macOS: `brew install maven`

---

## 📁 Project Structure Verification

Ensure your structure matches this exactly:

```
java-app/
├── pom.xml                    ✅ Maven configuration
├── src/
│   └── main/
│       ├── java/              ✅ Java source files here
│       │   ├── Web3jClient.java
│       │   ├── TransactionManager.java
│       │   ├── BlockMonitor.java
│       │   └── ExperimentRunner.java
│       └── resources/         ✅ Resources here
│           └── logback.xml
└── target/                    ✅ Build output (auto-generated)
    ├── classes/               ✅ Compiled .class files
    └── *.jar                  ✅ Packaged JARs
```

Verify with:
```bash
cd "d:\CSDLNC Demo\java-app"
find src -name "*.java"
```

Should show:
```
src/main/java/BlockMonitor.java
src/main/java/ExperimentRunner.java
src/main/java/TransactionManager.java
src/main/java/Web3jClient.java
```

---

## 🎯 Step-by-Step: Complete Fix

If you're still having issues, follow these steps in order:

### **Step 1: Clean Everything**
```bash
cd "d:\CSDLNC Demo\java-app"
mvn clean
rm -rf target/
```

### **Step 2: Verify Java Version**
```bash
java -version
# Must be 21 or higher
```

### **Step 3: Download Dependencies**
```bash
mvn dependency:resolve -U
mvn dependency:resolve-plugins
```

### **Step 4: Compile**
```bash
mvn compile
```

If this succeeds, your code is correct!

### **Step 5: Package**
```bash
mvn package
```

### **Step 6: Test Run**
```bash
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```

### **Step 7: Fix IDE (IntelliJ Example)**
1. Close IntelliJ
2. Delete `.idea` folder in `java-app/` directory
3. Reopen project
4. Import as Maven project
5. Wait for indexing

---

## 🐛 Still Having Issues?

### Check Maven Local Repository
```bash
# Windows
ls C:\Users\YourName\.m2\repository\org\web3j\core\

# Linux/macOS
ls ~/.m2/repository/org/web3j/core/
```

Should contain `4.10.3/` folder with JARs.

### Clear Maven Cache and Retry
```bash
# Windows
rmdir /s /q %USERPROFILE%\.m2\repository\org\web3j

# Linux/macOS
rm -rf ~/.m2/repository/org/web3j

# Re-download
cd "d:\CSDLNC Demo\java-app"
mvn clean install
```

---

## ✅ Success Indicators

You'll know everything is working when:

1. **Command Line Build Succeeds**:
   ```
   [INFO] BUILD SUCCESS
   [INFO] Total time: XX.XXX s
   ```

2. **JAR File Exists**:
   ```bash
   ls -lh target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
   # Should show ~25 MB file
   ```

3. **IDE Shows No Errors**:
   - All imports are green
   - No red underlines
   - Auto-complete works for Web3j classes

4. **Application Runs**:
   ```bash
   java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
   # Shows experiment menu
   ```

---

## 🚀 Quick Commands Reference

```bash
# Navigate to project
cd "d:\CSDLNC Demo\java-app"

# Clean build
mvn clean package

# Force update
mvn clean install -U

# Run application
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar

# View dependencies
mvn dependency:tree

# Download sources (for IDE)
mvn dependency:sources

# Compile only
mvn compile

# Skip tests (faster)
mvn package -DskipTests
```

---

## 📝 Summary

**Current Status**: ✅ **Project is ALREADY BUILT**

The JAR file at `target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar` is ready to run.

Any errors you see are **IDE display issues**, not actual compilation problems. The application will run fine from command line.

To fix IDE errors: **Reload/Reimport the Maven project** in your IDE.

To run immediately:
```bash
cd "d:\CSDLNC Demo\java-app"
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```
