@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Add Development Tools to PATH

echo.
echo ============================================================
echo       ADD COMMON DEVELOPMENT TOOLS TO WINDOWS PATH
echo ============================================================
echo This script adds existing tool folders to your USER PATH.
echo It does not install missing software.
echo.

:: Require admin? Not required: this updates the current user's PATH.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$ErrorActionPreference='Stop';" ^
 "$candidates = @(" ^
 "  \"$env:ProgramFiles\Git\cmd\"," ^
 "  \"$env:ProgramFiles\Git\bin\"," ^
 "  \"$env:ProgramFiles\nodejs\"," ^
 "  \"$env:ProgramFiles\Python312\"," ^
 "  \"$env:ProgramFiles\Python312\Scripts\"," ^
 "  \"$env:LocalAppData\Programs\Python\Python312\"," ^
 "  \"$env:LocalAppData\Programs\Python\Python312\Scripts\"," ^
 "  \"$env:LocalAppData\Programs\Python\Python313\"," ^
 "  \"$env:LocalAppData\Programs\Python\Python313\Scripts\"," ^
 "  \"$env:LocalAppData\Programs\Python\Python311\"," ^
 "  \"$env:LocalAppData\Programs\Python\Python311\Scripts\"," ^
 "  \"$env:LocalAppData\Programs\Microsoft VS Code\bin\"," ^
 "  \"$env:ProgramFiles\Microsoft VS Code\bin\"," ^
 "  \"$env:ProgramFiles\7-Zip\"," ^
 "  \"$env:ProgramFiles\PowerShell\7\"," ^
 "  \"$env:USERPROFILE\.dotnet\tools\"," ^
 "  \"$env:ProgramFiles\dotnet\"," ^
 "  \"$env:LocalAppData\Microsoft\WindowsApps\"," ^
 "  \"$env:USERPROFILE\Dev\tools\bin\"" ^
 " );" ^
 "$existing = @($candidates | Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Container) } | ForEach-Object { [IO.Path]::GetFullPath($_).TrimEnd('\') } | Select-Object -Unique);" ^
 "$old = [Environment]::GetEnvironmentVariable('Path','User');" ^
 "$parts = @($old -split ';' | Where-Object { $_ -and $_.Trim() });" ^
 "$combined = [Collections.Generic.List[string]]::new();" ^
 "foreach ($x in $parts) { if (-not $combined.Contains($x.TrimEnd('\'))) { $combined.Add($x.TrimEnd('\')) } };" ^
 "$added = @();" ^
 "foreach ($x in $existing) { if (-not ($combined | Where-Object { $_.TrimEnd('\') -ieq $x })) { $combined.Add($x); $added += $x } };" ^
 "[Environment]::SetEnvironmentVariable('Path', ($combined -join ';'), 'User');" ^
 "Write-Host ''; Write-Host 'Folders found and checked:' -ForegroundColor Cyan;" ^
 "if ($existing.Count -eq 0) { Write-Host 'No matching tool folders found yet.' -ForegroundColor Yellow } else { $existing | ForEach-Object { Write-Host ('  + ' + $_) } };" ^
 "Write-Host ''; if ($added.Count -gt 0) { Write-Host 'New entries added to User PATH:' -ForegroundColor Green; $added | ForEach-Object { Write-Host ('  + ' + $_) } } else { Write-Host 'No new entries were needed; PATH already contains these folders.' -ForegroundColor Green };" ^
 "Write-Host ''; Write-Host 'User PATH updated. Close and reopen terminals/apps to refresh PATH.' -ForegroundColor Green;" ^
 "Write-Host 'For Java, add its actual JDK bin folder after installing a JDK if needed.' -ForegroundColor Yellow;" ^
 "Write-Host 'For Visual Studio C++ tools, use the Developer Command Prompt or install Build Tools.' -ForegroundColor Yellow;"
if errorlevel 1 (
    echo.
    echo [ERROR] Could not update PATH. Try running this file again.
    pause
    exit /b 1
)

echo.
echo Finished. Close and reopen PowerShell / CMD / VS Code.
echo To inspect PATH, open a NEW PowerShell and run: $env:Path -split ';'
echo.
pause
endlocal
