# Fix: "package org.slf4j does not exist"

## 🔍 Problem Identified

You're seeing this error because **IntelliJ IDEA is not recognizing this as a Maven project**.

### Root Cause:
- IntelliJ project files (`.idea`, `*.iml`) were created in the `src/` folder instead of the project root
- This caused IntelliJ to treat it as a regular Java project, not a Maven project
- Without Maven integration, dependencies like SLF4J aren't in the classpath

### ✅ Verification:
The dependencies ARE downloaded:
- SLF4J 2.0.9: ✅ Exists in `~/.m2/repository/org/slf4j/slf4j-api/2.0.9/`
- Web3j 4.10.3: ✅ Downloaded
- Logback 1.4.11: ✅ Downloaded

The code compiles fine from command line but IntelliJ doesn't see the dependencies.

---

## 🛠️ Solution: Reimport as Maven Project

### **Method 1: Quick Fix (Recommended)**

1. **Close IntelliJ IDEA completely**

2. **Delete old project files**:
   ```bash
   cd "d:\CSDLNC Demo\java-app"
   rm -rf .idea *.iml src/.idea src/*.iml src/out
   ```

3. **Reopen in IntelliJ**:
   - Click **Open** (NOT "Import Project")
   - Navigate to `d:\CSDLNC Demo\java-app`
   - Select the **folder** (not pom.xml)
   - Click **OK**

4. **IntelliJ will detect Maven**:
   - You'll see a popup: "Maven project needs to be imported"
   - Click **Import**
   - Wait for dependency resolution (bottom-right corner)

5. **Verify**:
   - Open `Web3jClient.java`
   - The `import org.slf4j.*` lines should be **green** (not red)

---

### **Method 2: Force Maven Reimport**

If Method 1 doesn't work:

1. **In IntelliJ**:
   - Right-click `pom.xml` in Project view
   - **Add as Maven Project**

2. **Reload Maven**:
   - View → Tool Windows → Maven
   - Click **Reload All Maven Projects** (circular arrow icon ↻)

3. **Invalidate Caches**:
   - File → Invalidate Caches / Restart
   - Select "Invalidate and Restart"

---

### **Method 3: Manual Project Setup**

If both methods above fail:

1. **File → Project Structure** (`Ctrl+Alt+Shift+S`)

2. **Project** tab:
   - SDK: Select JDK 21 or higher
   - Language Level: 21

3. **Modules** tab:
   - Click **+** → Import Module
   - Select `pom.xml` from `java-app` folder
   - Import as Maven project
   - Click **OK**

4. **Libraries** tab:
   - Click **+** → From Maven
   - Search and add:
     - `org.slf4j:slf4j-api:2.0.9`
     - `org.web3j:core:4.10.3`
     - `ch.qos.logback:logback-classic:1.4.11`

---

## 🧪 Verify the Fix

### **Test 1: Check Dependencies in IntelliJ**

1. Open Maven tool window (View → Tool Windows → Maven)
2. Expand: `ethereum-fault-tolerance → Dependencies`
3. You should see:
   ```
   ├─ org.web3j:core:4.10.3
   ├─ org.slf4j:slf4j-api:2.0.9
   ├─ ch.qos.logback:logback-classic:1.4.11
   └─ ...
   ```

### **Test 2: Check Imports**

Open `Web3jClient.java` and verify these imports are **not red**:
```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.http.HttpService;
```

### **Test 3: Build in IntelliJ**

- Build → Build Project (`Ctrl+F9`)
- Should complete without errors

### **Test 4: Run from IntelliJ**

- Right-click `ExperimentRunner.java`
- Run 'ExperimentRunner.main()'
- Should show the experiment menu

---

## 📋 Detailed Step-by-Step (Windows)

### **Complete Fresh Start**

```powershell
# 1. Close IntelliJ IDEA

# 2. Navigate to project
cd "d:\CSDLNC Demo\java-app"

# 3. Clean IntelliJ files
Remove-Item -Recurse -Force .idea -ErrorAction SilentlyContinue
Remove-Item -Force *.iml -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force src\.idea -ErrorAction SilentlyContinue
Remove-Item -Force src\*.iml -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force src\out -ErrorAction SilentlyContinue

# 4. Clean Maven build
Remove-Item -Recurse -Force target -ErrorAction SilentlyContinue

# 5. Rebuild with Maven (this proves dependencies work)
mvn clean compile

# 6. Open IntelliJ
# - File → Open
# - Select: d:\CSDLNC Demo\java-app
# - Wait for Maven import
```

---

## 🐧 Detailed Step-by-Step (Linux/macOS)

```bash
# 1. Close IntelliJ IDEA

# 2. Navigate to project
cd "d:\CSDLNC Demo/java-app"

# 3. Clean IntelliJ files
rm -rf .idea *.iml src/.idea src/*.iml src/out

# 4. Clean Maven build
rm -rf target

# 5. Rebuild with Maven
mvn clean compile

# 6. Open IntelliJ
# - File → Open
# - Select: /d/CSDLNC Demo/java-app
# - Wait for Maven import
```

---

## ⚠️ Common Mistakes

### **Mistake 1: Opening pom.xml instead of folder**
❌ File → Open → Select `pom.xml`
✅ File → Open → Select `java-app` folder

### **Mistake 2: Wrong SDK version**
- Check: File → Project Structure → Project → SDK
- Must be JDK 21 or higher
- Download from: https://adoptium.net/

### **Mistake 3: Maven not enabled**
- Check if Maven tool window exists
- If not: View → Tool Windows → Maven

### **Mistake 4: Offline Mode**
- Maven may be in offline mode
- Toggle: Maven tool window → Click 🔌 (toggle offline mode)
- Should NOT be highlighted

---

## 🔧 Alternative: Use Command Line

If IntelliJ continues to have issues, you can always compile and run from command line:

```bash
cd "d:\CSDLNC Demo\java-app"

# Compile
mvn clean compile

# Run
mvn exec:java -Dexec.mainClass="ExperimentRunner"

# Or create JAR and run
mvn clean package
java -jar target/ethereum-fault-tolerance-1.0-SNAPSHOT.jar
```

---

## 🎯 Root Cause Summary

| Issue | Status |
|-------|--------|
| **SLF4J dependency downloaded?** | ✅ Yes (in `~/.m2/repository`) |
| **Code compiles with Maven?** | ✅ Yes (`mvn compile` works) |
| **JAR was built?** | ✅ Yes (25 MB file exists) |
| **IntelliJ sees dependencies?** | ❌ No - Project not imported as Maven |

**The Fix**: Delete `.idea` and reimport as Maven project

---

## 📞 If Still Not Working

### Check Maven Installation
```bash
mvn -version
```

Output should show:
```
Apache Maven 3.x.x
Java version: 17.x.x or higher
```

### Check Java Version
```bash
java -version
```

Must be **21 or higher**.

### Force Dependency Download
```bash
cd "d:\CSDLNC Demo\java-app"
mvn dependency:purge-local-repository
mvn clean install -U
```

### Check IntelliJ Maven Settings
1. File → Settings (or Preferences on Mac)
2. Build, Execution, Deployment → Build Tools → Maven
3. Maven home path: Should point to Maven installation
4. User settings file: Should point to `~/.m2/settings.xml` (or leave default)
5. Local repository: Should point to `~/.m2/repository`

---

## ✅ Success Criteria

You'll know it's fixed when:

1. ✅ No red underlines in Java files
2. ✅ Imports are green: `import org.slf4j.Logger;`
3. ✅ Maven tool window shows all dependencies
4. ✅ Build → Build Project completes without errors
5. ✅ Can run `ExperimentRunner` from IntelliJ

---

## 🚀 Quick Reference

```bash
# Clean everything
cd "d:\CSDLNC Demo\java-app"
rm -rf .idea *.iml target src/.idea src/*.iml src/out

# Rebuild
mvn clean compile

# Run
mvn exec:java -Dexec.mainClass="ExperimentRunner"
```

Then reopen in IntelliJ: File → Open → Select `java-app` folder

---

**Bottom Line**: Your code is correct, Maven works, dependencies exist. IntelliJ just needs to be told this is a Maven project. Follow Method 1 above and you'll be set! 🎉
