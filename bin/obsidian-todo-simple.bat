@echo off
cd /d "%USERPROFILE%\Documents\Obsidian"

REM Create todo.md if it doesn't exist
if not exist "todo.md" (
    echo  Last updated: %date% %time% > todo.md
    echo. >> todo.md
    echo ####  Tasks >> todo.md
    echo. >> todo.md
    echo. >> todo.md
    echo #### 󰈸 Urgent >> todo.md
    echo. >> todo.md
)

REM Open PowerShell terminal with nvim at todo.md
pwsh.exe -NoExit -Command "nvim todo.md"