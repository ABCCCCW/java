@echo off
chcp 65001 >nul
title Build Ung Dung Quan Ly Pizza

echo ============================================
echo   BUILD UNG DUNG QUAN LY BAN PIZZA
echo ============================================
echo.

:: Kiểm tra JDK
where javac >nul 2>nul
if %errorlevel% neq 0 (
    echo [LOI] Khong tim thay javac! Hay cai JDK 17+ va them vao PATH.
    echo Tai JDK tai: https://adoptium.net/temurin/releases/?version=17
    pause
    exit /b 1
)

echo [1/5] Dang don dep thu muc build cu...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
mkdir build\classes
mkdir dist

echo [2/5] Dang lay danh sach thu vien...
:: Tạo classpath từ tất cả JAR trong src/libs/
set CLASSPATH=
for %%f in (src\libs\*.jar) do (
    if defined CLASSPATH (
        set "CLASSPATH=!CLASSPATH!;%%f"
    ) else (
        set "CLASSPATH=%%f"
    )
)

:: Cần delayed expansion cho biến CLASSPATH
setlocal enabledelayedexpansion
set "CLASSPATH="
for %%f in (src\libs\*.jar) do (
    if defined CLASSPATH (
        set "CLASSPATH=!CLASSPATH!;%%f"
    ) else (
        set "CLASSPATH=%%f"
    )
)

echo    Classpath: !CLASSPATH!
echo.

echo [3/5] Dang compile source code...
:: Tìm tất cả file .java
dir /s /b src\*.java > build\sources.txt

:: Compile
javac -encoding UTF-8 -source 8 -target 8 -d build\classes -cp "!CLASSPATH!" @build\sources.txt 2> build\compile_errors.txt

if %errorlevel% neq 0 (
    echo [LOI] Compile that bai! Xem chi tiet:
    type build\compile_errors.txt
    pause
    exit /b 1
)
echo    Compile thanh cong!
echo.

echo [4/5] Dang giai nen thu vien vao fat JAR...
:: Giải nén tất cả JAR dependencies vào build/classes
cd build\classes
for %%f in (..\..\src\libs\*.jar) do (
    jar xf "%%f" >nul 2>nul
)
:: Xóa các file signature của JAR gốc (tránh lỗi khi chạy)
if exist META-INF\*.SF del META-INF\*.SF
if exist META-INF\*.DSA del META-INF\*.DSA
if exist META-INF\*.RSA del META-INF\*.RSA
cd ..\..

:: Copy database SQL vào trong JAR (để initDatabase dùng)
mkdir build\classes\database >nul 2>nul
copy database\quanlypizza_h2.sql build\classes\database\ >nul

echo [5/5] Dang tao file JAR...
:: Tạo manifest
echo Manifest-Version: 1.0> build\MANIFEST.MF
echo Main-Class: Main.Main>> build\MANIFEST.MF
echo.>> build\MANIFEST.MF

:: Tạo JAR
jar cfm dist\DoAn_QuanLyBanPizza.jar build\MANIFEST.MF -C build\classes .

if %errorlevel% neq 0 (
    echo [LOI] Tao JAR that bai!
    pause
    exit /b 1
)

echo.
echo ============================================
echo   BUILD THANH CONG!
echo ============================================
echo.
echo   File JAR: dist\DoAn_QuanLyBanPizza.jar
echo.
echo   De chay thu: java -jar dist\DoAn_QuanLyBanPizza.jar
echo   De tao .exe: chay build_exe.bat
echo ============================================

endlocal
pause
