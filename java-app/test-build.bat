@echo off
REM Test Build Script for Windows

echo ========================================
echo Testing Java Application Build
echo ========================================
echo.

echo [1/4] Checking Java version...
java -version
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Java not found!
    exit /b 1
)
echo.

echo [2/4] Checking Maven version...
call mvn -version
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven not found!
    exit /b 1
)
echo.

echo [3/4] Building project...
call mvn clean package -q
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Build failed!
    exit /b 1
)
echo.

echo [4/4] Checking JAR file...
if exist "target\ethereum-fault-tolerance-1.0-SNAPSHOT.jar" (
    echo SUCCESS: JAR file created!
    dir target\*.jar | findstr ethereum
) else (
    echo ERROR: JAR file not found!
    exit /b 1
)
echo.

echo ========================================
echo BUILD TEST PASSED!
echo ========================================
echo.
echo You can now run the application with:
echo java -jar target\ethereum-fault-tolerance-1.0-SNAPSHOT.jar
echo.

pause
