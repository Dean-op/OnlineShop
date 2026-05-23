@echo off
title ZKY Online Shop Starter

echo =======================================================================
echo               ZKY Online Shop One-Click Starter (Windows)
echo =======================================================================
echo   [Notice] Make sure MySQL is running and product_system2.sql is imported.
echo =======================================================================
echo.

:: 1. Check Java Environment
echo [*] Checking Java Runtime Environment (JDK)...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java not found! 
    echo         Please install JDK 17+ and add it to your PATH environment variable.
    echo.
    pause
    exit /b
)
echo [OK] Java environment is ready.
echo.

:: 2. Check Node.js Environment
echo [*] Checking Node.js Environment...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js not found!
    echo         Please install Node.js like v16, v18 or v20 and add it to your PATH.
    echo.
    pause
    exit /b
)
echo [OK] Node.js environment is ready.
echo.

:: 3. Detect Maven
echo [*] Detecting Maven Build Tool...
set MAVEN_CMD=mvn
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Global mvn not found. Scanning local JetBrains paths...
    
    set FOUND_MAVEN=
    for %%d in (C D E) do (
        for /d %%i in ("%%d:\Program Files\JetBrains\IntelliJ IDEA*") do (
            if exist "%%i\plugins\maven\lib\maven3\bin\mvn.cmd" (
                set MAVEN_CMD="%%i\plugins\maven\lib\maven3\bin\mvn.cmd"
                set FOUND_MAVEN=1
                goto :MAVEN_DETECTED
            )
        )
        for /d %%i in ("%%d:\Program Files (x86)\JetBrains\IntelliJ IDEA*") do (
            if exist "%%i\plugins\maven\lib\maven3\bin\mvn.cmd" (
                set MAVEN_CMD="%%i\plugins\maven\lib\maven3\bin\mvn.cmd"
                set FOUND_MAVEN=1
                goto :MAVEN_DETECTED
            )
        )
        for /d %%i in ("%%d:\apache-maven-*") do (
            if exist "%%i\bin\mvn.cmd" (
                set MAVEN_CMD="%%i\bin\mvn.cmd"
                set FOUND_MAVEN=1
                goto :MAVEN_DETECTED
            )
        )
    )

    if exist "springboot\mvnw.cmd" (
        set MAVEN_CMD="%~dp0springboot\mvnw.cmd"
        set FOUND_MAVEN=1
        goto :MAVEN_DETECTED
    )

:MAVEN_DETECTED
    if defined FOUND_MAVEN (
        echo [OK] Found Maven at: %MAVEN_CMD%
    ) else (
        echo [ERROR] Maven not found!
        echo         Please configure Maven in your PATH or install IntelliJ IDEA in default path.
        echo.
        pause
        exit /b
    )
) else (
    echo [OK] Global Maven is ready.
)
echo.

:: 4. Check Frontend Dependencies
if not exist "vue_template\node_modules" (
    echo =======================================================================
    echo [INFO] node_modules not found in vue_template.
    echo        Installing frontend dependencies automatically via "npm install"...
    echo =======================================================================
    echo.
    cd vue_template && call npm install && cd ..
    if %errorlevel% neq 0 (
        echo.
        echo [ERROR] npm install failed! Please run "npm install" manually inside vue_template.
        echo.
        pause
        exit /b
    )
    echo [OK] Frontend dependencies installed successfully.
    echo.
)

echo =======================================================================
echo                     All systems go! Starting services...
echo =======================================================================
echo.

:: 5. Start Backend
echo [1/2] Compiling and starting Spring Boot backend...
start "ZKY Shop - Backend API [Port: 1234]" cmd /k "cd springboot && title Backend-1234 && echo [Backend] Running maven Spring Boot app... && %MAVEN_CMD% spring-boot:run"

:: 6. Start Frontend
echo [2/2] Running Webpack dev server for Vue frontend...
start "ZKY Shop - Frontend UI [Port: 8081]" cmd /k "cd vue_template && title Frontend-8081 && echo [Frontend] Running npm run serve... && npm run serve"

echo.
echo =======================================================================
echo                         Startup commands dispatched!
echo =======================================================================
echo.
echo    Shopping Mall URL:  http://127.0.0.1:8081
echo    Backend Swagger UI: http://127.0.0.1:1234/swagger-ui.html
echo.
echo    Test User Account:  user2 / 123456
echo =======================================================================
echo.
echo Opening the shopping website in your browser in 5 seconds...
timeout /t 5 >nul
start http://127.0.0.1:8081/
echo.
echo [Tip] Services are running in the newly opened windows.
echo       You can safely close this helper window.
echo.
pause
