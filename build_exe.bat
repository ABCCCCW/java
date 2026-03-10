@echo off
chcp 65001 >nul
title Tao File EXE Installer - Quan Ly Pizza

echo ============================================
echo   TAO FILE .EXE INSTALLER
echo ============================================
echo.

:: Kiểm tra jpackage
where jpackage >nul 2>nul
if %errorlevel% neq 0 (
    echo [LOI] Khong tim thay jpackage! Can JDK 14+ (khuyen nghi JDK 17+^).
    echo Tai JDK tai: https://adoptium.net/temurin/releases/?version=17
    pause
    exit /b 1
)

:: Kiểm tra JAR đã build chưa
if not exist dist\DoAn_QuanLyBanPizza.jar (
    echo [LOI] Chua co file JAR! Hay chay build_app.bat truoc.
    pause
    exit /b 1
)

:: Dọn dẹp build cũ
echo [1/3] Dang chuan bi...
if exist installer rmdir /s /q installer
if exist build\jpackage-input rmdir /s /q build\jpackage-input
if exist build\jpackage-temp rmdir /s /q build\jpackage-temp

:: Chuẩn bị thư mục input cho jpackage
mkdir build\jpackage-input
copy dist\DoAn_QuanLyBanPizza.jar build\jpackage-input\ >nul

echo [2/3] Dang tao file .exe installer (mat vai phut)...
echo    Dang dong goi JRE + ung dung...
echo.

jpackage ^
  --type exe ^
  --name "QuanLyPizza" ^
  --app-version 1.0 ^
  --vendor "DoAn_TotNghiep" ^
  --description "Ung dung quan ly cua hang ban Pizza" ^
  --input build\jpackage-input ^
  --main-jar DoAn_QuanLyBanPizza.jar ^
  --main-class Main.Main ^
  --dest installer ^
  --temp build\jpackage-temp ^
  --win-dir-chooser ^
  --win-shortcut ^
  --win-menu ^
  --win-menu-group "QuanLyPizza" ^
  --java-options "-Dfile.encoding=UTF-8"

if %errorlevel% neq 0 (
    echo.
    echo [LOI] Tao installer that bai!
    echo.
    echo Neu loi "WiX Toolset not found", hay cai WiX Toolset:
    echo   winget install WixToolset.WixToolset
    echo   hoac tai tai: https://wixtoolset.org/releases/
    echo.
    echo Neu khong muon cai WiX, dung lenh nay de tao app-image (thu muc):
    echo   jpackage --type app-image --name QuanLyPizza --input build\jpackage-input --main-jar DoAn_QuanLyBanPizza.jar --main-class Main.Main --dest installer
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   TAO INSTALLER THANH CONG!
echo ============================================
echo.
echo   File installer nam trong thu muc: installer\
echo.
echo   Huong dan:
echo   1. Chay file .exe trong thu muc installer\ de cai dat
echo   2. Sau khi cai, copy thu muc "image" vao thu muc cai dat
echo      (Thuong la: C:\Program Files\QuanLyPizza\)
echo   3. Copy file "ConnectVariable.txt" vao thu muc cai dat (neu can)
echo   4. Mo ung dung tu Start Menu hoac Shortcut tren Desktop
echo   5. Dang nhap: admin / admin
echo ============================================

pause
