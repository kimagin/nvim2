@echo off
setlocal enabledelayedexpansion

REM Set vault path
set "vault_path=%USERPROFILE%\Documents\Obsidian\todo.md"
set "vault_dir=%USERPROFILE%\Documents\Obsidian"

REM Create vault directory if it doesn't exist
if not exist "%vault_dir%" mkdir "%vault_dir%"

REM Create todo.md if it doesn't exist
if not exist "%vault_path%" (
    echo  Last updated: %date% %time% > "%vault_path%"
    echo. >> "%vault_path%"
    echo ####  Tasks >> "%vault_path%"
    echo. >> "%vault_path%"
    echo. >> "%vault_path%"
    echo #### 󰈸 Urgent >> "%vault_path%"
    echo. >> "%vault_path%"
)

REM Debug output (remove this line once working)
echo Opening: %vault_path%

REM Open pwsh terminal with nvim at todo.md
pwsh.exe -NoExit -Command "cd '%USERPROFILE%\Documents\Obsidian'; nvim '%vault_path%'"