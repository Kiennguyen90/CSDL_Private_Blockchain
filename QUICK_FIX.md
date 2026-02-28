# 🚀 QUICK FIX - Dependency Errors

## ✅ GOOD NEWS: Your Project is Already Built!

The JAR file exists and is ready to run:
- **Location**: `java-app/target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar`
- **Size**: ~25 MB
- **Status**: ✅ Compiled successfully

## 🎯 Quick Solutions

### **Solution 1: Run It Now (Fastest)**

```bash
cd "d:\CSDLNC Demo\java-app"
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```

---

### **Solution 2: Fix IDE Errors (IntelliJ)**

**Quick Fix**:
1. Right-click `pom.xml`
2. **Maven** → **Reload Project**
3. Wait for indexing

**Deep Fix**:
1. **File** → **Invalidate Caches / Restart**
2. Click "Invalidate and Restart"

---

### **Solution 3: Fix IDE Errors (VS Code)**

1. Press `Ctrl+Shift+P`
2. Run: **Java: Clean Java Language Server Workspace**
3. Run: **Java: Force Java Compilation → Full**
4. Reload window (`Ctrl+R`)

---

### **Solution 4: Rebuild from Scratch**

```bash
cd "d:\CSDLNC Demo\java-app"
mvn clean install
```

---

### **Solution 5: Force Dependency Re-download**

```bash
cd "d:\CSDLNC Demo\java-app"
mvn clean install -U
```

---

## 🔍 Why You See Errors

The errors are **IDE display issues only**. Your code compiles fine from command line.

**Proof**:
- ✅ All `.class` files exist in `target/classes/`
- ✅ JAR file was created successfully
- ✅ Maven build shows `BUILD SUCCESS`

**What's happening**:
- Your IDE hasn't indexed the Maven dependencies yet
- Or the project wasn't imported as a Maven project

---

## 📋 Common Error Messages & Fixes

### Error: "Cannot resolve symbol 'Web3j'"

**Fix**:
```bash
mvn dependency:resolve -U
```
Then reload Maven project in IDE.

---

### Error: "Package org.web3j does not exist"

**Fix** (IntelliJ):
1. Maven tool window → Reload All Maven Projects
2. File → Project Structure → Modules → Check dependencies

---

### Error: "Java version mismatch"

**Fix**:
```bash
# Check Java version (must be 21+)
java -version

# If wrong, set JAVA_HOME
# Windows PowerShell:
$env:JAVA_HOME="C:\Program Files\Java\jdk-21"

# Linux/macOS:
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
```

---

## 🧪 Test Your Build

### **Windows**:
```cmd
cd "d:\CSDLNC Demo\java-app"
test-build.bat
```

### **Linux/macOS**:
```bash
cd "d:\CSDLNC Demo\java-app"
bash test-build.sh
```

---

## 📚 Detailed Guides

For complete step-by-step instructions, see:
- 📘 [BUILD_FIX_GUIDE.md](java-app/BUILD_FIX_GUIDE.md) - Comprehensive troubleshooting
- 📗 [SETUP_GUIDE.md](SETUP_GUIDE.md) - Initial setup and installation
- 📙 [README.md](README.md) - Project overview and usage

---

## 🎬 Complete Workflow

```bash
# 1. Start Ethereum network
cd "d:\CSDLNC Demo\docker"
bash ../scripts/init-network.sh

# 2. Build Java app (if not already built)
cd "../java-app"
mvn clean package

# 3. Run experiment
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```

---

## ✅ Success Checklist

- [x] JAR file exists: `target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar`
- [x] All classes compiled: `target/classes/*.class`
- [x] Maven build succeeds: `mvn package` shows `BUILD SUCCESS`
- [ ] IDE shows no errors (follow IDE fix solutions above)
- [ ] Application runs: Shows experiment menu

---

## 🆘 Still Need Help?

1. Check [BUILD_FIX_GUIDE.md](java-app/BUILD_FIX_GUIDE.md)
2. Verify Java version: `java -version` (must be 21+)
3. Verify Maven: `mvn -version`
4. Try clean build: `mvn clean install -U`

---

## 💡 Pro Tips

- **Don't worry about IDE errors** if command line build succeeds
- The application runs fine even if IDE shows red underlines
- Always trust `mvn package` over IDE error messages
- When in doubt: `mvn clean install`

---

## 🚀 Run Your Experiment Now!

```bash
cd "d:\CSDLNC Demo\java-app"
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```

You're ready to go! 🎉
