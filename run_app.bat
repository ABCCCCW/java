@echo off
chcp 65001 >nul
title Quan Ly Pizza

:: Đảm bảo chạy từ đúng thư mục chứa file bat này
cd /d "%~dp0"

:: Kiểm tra Java
where java >nul 2>nul
if %errorlevel% neq 0 (
    echo [LOI] Khong tim thay Java! Hay cai JDK 17+.
    pause
    exit /b 1
)

:: Kiểm tra JAR
if not exist dist\DoAn_QuanLyBanPizza.jar (
    echo [LOI] Chua co file JAR! Hay chay build_app.bat truoc.
    pause
    exit /b 1
)

:: Kiểm tra thư mục image
if not exist image (
    echo [CANH BAO] Khong tim thay thu muc image! Giao dien co the bi loi.
)

echo Dang khoi dong ung dung Quan Ly Pizza...
echo Thu muc hien tai: %cd%
echo.
java -Dfile.encoding=UTF-8 -jar dist\DoAn_QuanLyBanPizza.jar

echo.
echo ============================================
if %errorlevel% neq 0 (
    echo   [LOI] Ung dung bi loi! Xem thong bao phia tren.
) else (
    echo   Ung dung da dong.
)
echo ============================================
pause
