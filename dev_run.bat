@echo off
chcp 65001 >nul
title Quan Ly Pizza [DEV MODE]

:: Đảm bảo chạy từ đúng thư mục gốc project
cd /d "%~dp0"

:START
cls
echo ==============================================
echo        DANG BIEN DICH VA KHOI DONG APP...
echo ==============================================
echo.

echo [1/3] Dang don dep class cu...
if exist build rd /s /q build
mkdir build\classes

echo [2/3] Dang lay danh sach thu vien...
set "CP="
for %%i in (src\libs\*.jar) do (
    call set "CP=%%CP%%%%i;"
)

echo [3/3] Dang compile code phien ban JDK hien tai...
dir /s /b src\*.java > sources.txt
javac -encoding UTF-8 -d build\classes -cp "%CP%" @sources.txt
del sources.txt

if %errorlevel% neq 0 (
    echo.
    echo ==============================================
    echo [LOI] Compile CODE THAT BAI! 
    echo Vui long kiem tra lai code ben tren. Kiem tra code xong nhan phim bat ky de CHAY LAI.
    echo ==============================================
    pause
    goto START
)

echo.
echo ==============================================
echo [DEV] Compile thanh cong! APP DANG CHAY...
echo ==============================================
echo.

:: Chạy thẳng file class (.class) không qua file JAR
java -Dfile.encoding=UTF-8 -cp "build\classes;%CP%" Main.Main

echo.
echo ==============================================
echo Ung dung da dong.
echo.
echo ! LUY Y: 
echo - Hay SUA SU BUG trong code cua ban.
echo - Sua xong, chi can NHAN PHIM BAT KY TRONG BANG NAY de he thong tu dong compile va mo lai App.
echo ==============================================
pause >nul
goto START
