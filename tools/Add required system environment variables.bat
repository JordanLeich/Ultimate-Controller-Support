@echo off
CLS

REM Check if running with administrative rights
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrative privileges...
) else (
    echo Please run this script as an administrator.
    pause
    exit /b
)

REM Check if the paths already exist in the system environment variable "Path"
set "newPath=C:\Windows\system32;C:\Windows\System32\WindowsPowerShell\v1.0"
echo %PATH% | findstr /C:"%newPath%" >nul
if %errorLevel% == 0 (
    echo Paths already exist in the "Path" variable.
    pause
    exit /b
)

REM Add paths to the system environment variable "Path"
setx PATH "%newPath%;%PATH%" /M

REM Display updated environment variables
echo.
echo Environment variables updated successfully.
echo.
echo Current "Path" variable value:
echo ------------------------------
echo %PATH%
echo.

pause