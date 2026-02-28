@echo off
REM Automatic IntelliJ IDEA Maven Project Fix Script

echo ============================================
echo IntelliJ IDEA Maven Project Fix
echo ============================================
echo.

echo This script will:
echo 1. Remove incorrect IntelliJ project files
echo 2. Clean the Maven build
echo 3. Rebuild the project
echo 4. Prepare for IntelliJ reimport
echo.

pause

echo.
echo [1/4] Removing incorrect IntelliJ files...
if exist ".idea" rmdir /s /q .idea
if exist "*.iml" del /q *.iml
if exist "src\.idea" rmdir /s /q src\.idea
if exist "src\*.iml" del /q src\*.iml
if exist "src\out" rmdir /s /q src\out
echo Done.

echo.
echo [2/4] Cleaning Maven build...
call mvn clean
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven clean failed!
    echo Make sure Maven is installed and in PATH
    pause
    exit /b 1
)
echo Done.

echo.
echo [3/4] Rebuilding with Maven...
call mvn compile
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven compile failed!
    pause
    exit /b 1
)
echo Done.

echo.
echo [4/4] Verifying dependencies...
if exist "target\classes\Web3jClient.class" (
    echo SUCCESS: Web3jClient compiled!
) else (
    echo WARNING: Web3jClient not found
)

if exist "target\classes\ExperimentRunner.class" (
    echo SUCCESS: ExperimentRunner compiled!
) else (
    echo WARNING: ExperimentRunner not found
)

echo.
echo ============================================
echo Fix Complete!
echo ============================================
echo.
echo Next steps:
echo 1. CLOSE IntelliJ IDEA if it's open
echo 2. Open IntelliJ IDEA
echo 3. File ^> Open
echo 4. Select this folder: %CD%
echo 5. Click OK
echo 6. Wait for Maven import to complete
echo.
echo After import, the SLF4J error should be gone!
echo.

pause
