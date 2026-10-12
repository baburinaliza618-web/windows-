@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Windows Development Setup

:: Universal starter setup for Windows 10/11
:: Run as Administrator. Uses winget when available.

echo.
echo ============================================================
echo         WINDOWS DEVELOPMENT ENVIRONMENT SETUP
echo ============================================================
echo.
echo This script installs common development tools:
echo  - Git
echo  - Node.js LTS and npm
echo  - Python 3
echo  - Visual Studio Code
echo  - 7-Zip
echo  - Windows Terminal (if available)
echo  - Microsoft Visual C++ Redistributable (if available)
echo.
echo Optional tools can be installed from the menu afterward.
echo Internet access is required.
echo.

:: Check administrator privileges
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    echo [ERROR] Please right-click this file and choose "Run as administrator".
    echo.
    pause
    exit /b 1
)

:: Check winget
where winget >nul 2>&1
if errorlevel 1 (
    echo [ERROR] winget was not found.
    echo Open Microsoft Store, install/update "App Installer", then run this file again.
    echo You can also run Windows Update and restart the computer.
    echo.
    pause
    exit /b 1
)

echo.
echo [1/5] Updating winget sources...
winget source update
echo.

echo [2/5] Installing core development tools...
call :install "Git.Git" "Git"
call :install "OpenJS.NodeJS.LTS" "Node.js LTS"
call :install "Python.Python.3.12" "Python 3.12"
call :install "Microsoft.VisualStudioCode" "Visual Studio Code"
call :install "7zip.7zip" "7-Zip"
call :install "Microsoft.WindowsTerminal" "Windows Terminal"
call :install "Microsoft.VCRedist.2015+.x64" "Microsoft Visual C++ Redistributable"

echo.
echo [3/5] Creating development folders...
if not exist "%USERPROFILE%\Dev" mkdir "%USERPROFILE%\Dev"
if not exist "%USERPROFILE%\Dev\Projects" mkdir "%USERPROFILE%\Dev\Projects"
if not exist "%USERPROFILE%\Dev\Web" mkdir "%USERPROFILE%\Dev\Web"
if not exist "%USERPROFILE%\Dev\Python" mkdir "%USERPROFILE%\Dev\Python"
if not exist "%USERPROFILE%\Dev\DesktopApps" mkdir "%USERPROFILE%\Dev\DesktopApps"
if not exist "%USERPROFILE%\Dev\Minecraft" mkdir "%USERPROFILE%\Dev\Minecraft"

echo.
echo [4/5] Refreshing PATH for this script session...
call :refreshpath

echo.
echo [5/5] Checking installed tools...
echo.
call :check "git --version" "Git"
call :check "node --version" "Node.js"
call :check "npm --version" "npm"
call :check "python --version" "Python"
call :check "code --version" "VS Code command-line launcher"

echo.
echo ============================================================
echo Setup finished. Restart Windows before using all tools.
echo.
echo Projects folder: %USERPROFILE%\Dev
echo Minecraft launcher folder: %USERPROFILE%\Dev\Minecraft
echo.
echo Next steps:
echo  1. Restart Windows.
echo  2. Open PowerShell or Windows Terminal.
echo  3. Run: node -v
echo  4. Run: npm -v
echo  5. Run: git --version
echo.
echo For Electron apps, use a supported Node.js LTS release.
echo Visual Studio Build Tools are NOT installed by this script
echo because they are large; choose them from the optional menu.
echo ============================================================
echo.
pause
exit /b 0

:install
echo.
echo --- Installing %~2 (%~1) ---
winget install --id "%~1" --exact --source winget --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
    echo [WARNING] Installation failed or package is already installed: %~2
    echo You can retry it later from an Administrator terminal.
) else (
    echo [OK] %~2 install command completed.
)
exit /b 0

:check
echo Checking %~2...
%~1
if errorlevel 1 echo [INFO] %~2 was not found in the current session; restart Windows and check again.
exit /b 0

:refreshpath
:: Make newly installed command-line tools visible in this process where possible.
set "PATH=%PATH%;%ProgramFiles%\Git\cmd;%ProgramFiles%\nodejs;%LocalAppData%\Programs\Python\Python312;%LocalAppData%\Programs\Microsoft VS Code\bin;%ProgramFiles%\Microsoft VS Code\bin"
exit /b 0
