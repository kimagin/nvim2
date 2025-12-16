@echo off
setlocal enabledelayedexpansion

REM Get day of week using PowerShell
for /f "delims=" %%i in ('powershell -command "Get-Date -Format \"dddd\""') do set DOW=%%i

REM Get date components
for /f "delims=" %%i in ('powershell -command "Get-Date -Format \"dd-MM-yyyy\""') do set DATE_FORMAT=%%i

REM Format date string to match your format
set "date_string=%DOW%-%DATE_FORMAT%"

REM Set vault path
set "vault_path=%USERPROFILE%\Documents\Obsidian\journal\%date_string%.md"
set "journal_dir=%USERPROFILE%\Documents\Obsidian\journal"

REM Create journal directory if it doesn't exist
if not exist "%journal_dir%" mkdir "%journal_dir%"

REM Create today's note if it doesn't exist
if not exist "%vault_path%" (
    echo # %date_string% > "%vault_path%"
    echo. >> "%vault_path%"
)

REM Debug output (remove this line once working)
echo Opening: %vault_path%

REM Open pwsh terminal with nvim at today's journal
pwsh.exe -NoExit -Command "cd '%USERPROFILE%\Documents\Obsidian'; nvim '%vault_path%'"