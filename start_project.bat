@echo off
:: 设置编码为 UTF-8，防止中文乱码
chcp 65001 > nul
title 🌸 文旅电商一键启动面板 🌸

:: 打印高端精致的终端 Banner
echo =======================================================================
echo              🌟  文旅电商系统 一键启动面板 (Windows)  🌟
echo =======================================================================
echo   [温馨提示] 启动前请确保本地 MySQL 已运行，且已导入相应的 SQL 数据库。
echo =======================================================================
echo.

:: 1. 检查 Java 运行环境
echo 🔍 [检测] 正在检测 Java 运行环境 (JDK)...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ [错误] 未检测到 Java 运行环境！
    echo          请确保已安装 JDK 17 或更高版本，并配置到系统环境变量中。
    echo.
    pause
    exit /b
)
echo  [OK] Java 环境就绪。
echo.

:: 2. 检查 Node.js 运行环境
echo 🔍 [检测] 正在检测 Node.js 运行环境...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ [错误] 未检测到 Node.js 运行环境！
    echo          请确保已安装 Node.js (推荐 v16/v18/v20)，并配置到系统环境变量中。
    echo.
    pause
    exit /b
)
echo  [OK] Node.js 环境就绪。
echo.

:: 3. 智能探测 Maven 编译环境
echo 🔍 [检测] 正在探测 Maven 构建工具...
set MAVEN_CMD=mvn
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ℹ️ [提示] 未检测到全局 mvn 变量，正在智能检索本地开发环境...
    
    :: 尝试寻找 IntelliJ IDEA 的内置 Maven (Ultimate / Community) 以及常见安装位置
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
        :: 常见自定义 Maven 安装路径
        for /d %%i in ("%%d:\apache-maven-*") do (
            if exist "%%i\bin\mvn.cmd" (
                set MAVEN_CMD="%%i\bin\mvn.cmd"
                set FOUND_MAVEN=1
                goto :MAVEN_DETECTED
            )
        )
    )

    :: 检查是否有 Maven Wrapper (mvnw.cmd)
    if exist "springboot\mvnw.cmd" (
        set MAVEN_CMD="%~dp0springboot\mvnw.cmd"
        set FOUND_MAVEN=1
        goto :MAVEN_DETECTED
    )

:MAVEN_DETECTED
    if defined FOUND_MAVEN (
        echo  [OK] 成功定位到本地 Maven: %MAVEN_CMD%
    ) else (
        echo ❌ [错误] 未能找到可用的 Maven 工具！
        echo          请手动将 Maven 配置到环境变量，或者确保 IntelliJ IDEA 安装在默认路径。
        echo.
        pause
        exit /b
    )
) else (
    echo  [OK] 全局 Maven 构建工具就绪。
)
echo.

:: 4. 检查并自动安装前端依赖 node_modules
if not exist "vue_template\node_modules" (
    echo =======================================================================
    echo ⚡ [首次运行提示] 未检测到前端项目依赖库 (node_modules)
    echo                  系统将自动为您执行 "npm install" 安装依赖。
    echo =======================================================================
    echo.
    echo 正在安装前端依赖，这可能需要 2~5 分钟，请稍候...
    cd vue_template && call npm install && cd ..
    if %errorlevel% neq 0 (
        echo.
        echo ❌ [错误] 前端依赖安装失败！请在 vue_template 目录下手动执行 npm install 检查错误。
        echo.
        pause
        exit /b
    )
    echo  [OK] 前端依赖包成功安装！
    echo.
)

echo =======================================================================
echo                     🚀  一切准备就绪，正在并行启动服务...
echo =======================================================================
echo.

:: 5. 启动后端 Spring Boot
echo 🍀 [1/2] 正在独立窗口中编译并启动 Spring Boot 后端服务...
start "☕ 文旅电商-后端服务 [端口: 1234]" cmd /k "cd springboot && title 后端服务-1234 && echo [后端] 正在编译并启动 Spring Boot... && %MAVEN_CMD% spring-boot:run"

:: 6. 启动前端 Vue 2
echo 📦 [2/2] 正在独立窗口中编译并启动 Vue 前端商城...
start "🌐 文旅电商-前端商城 [端口: 8081]" cmd /k "cd vue_template && title 前端服务-8081 && echo [前端] 正在运行前端 Webpack 编译... && npm run serve"

echo.
echo =======================================================================
echo                         🎉  服务启动命令发送完毕！
echo =======================================================================
echo.
echo  🛍️  前端商城访问地址:  http://127.0.0.1:8081
echo  💻  后端接口管理中心:  http://127.0.0.1:1234/swagger-ui.html
echo  👤  测试普通用户账号:  user2  / 密码: 123456 (可在商城首页登录查看“我的收藏”)
echo.
echo =======================================================================
echo.
echo 正在为您在默认浏览器中打开商城首页，请稍候...
timeout /t 5 >nul
start http://127.0.0.1:8081/
echo.
echo [提示] 服务已在新的两个控制台窗口中异步运行。
echo        您可以随时关闭此引导窗口，后台服务不会受到影响。
echo.
pause
