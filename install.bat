@echo off
REM EverQuest Emulator Universal Installer - Windows Entry Point

echo ##########################################################
echo #  EverQuest Emulator Universal Installer               #
echo #  Windows Platform                                      #
echo ##########################################################
echo.

REM Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This installer must be run as Administrator
    echo Please right-click install.bat and select "Run as administrator"
    pause
    exit /b 1
)

echo Launching Windows PowerShell installer...
echo.

PowerShell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\install_windows.ps1"

if %errorLevel% neq 0 (
    echo.
    echo Installation encountered errors. Please check the output above.
    pause
    exit /b 1
)

echo.
echo Installation complete!
pause
