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
for /f "skip=2 tokens=1,2*" %%n in ('REG query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /v "Path" 2^>nul') do if /i "%%n" == "Path" set "PATH_M=%%p"
setlocal enableDelayedExpansion
for %%p in ("C:\Windows\system32" "C:\Windows\System32\WindowsPowerShell\v1.0") do (
    call echo "%PATH_M%" | find /i /v "%%~p;" | find /i /v "%%~p\;" >nul && set "newPath=!newPath!%%~p;"
)
if "%newPath%"=="" (
    echo Paths already exist in the "Path" variable.
    pause
    exit /b
)

REM Add paths to the system environment variable "Path" and Display updated environment variables
echo.
echo Environment variables updated successfully.
echo.
echo Current system "Path" variable value:
echo -------------------------------------
PowerShell "$envkey = 'registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment'; $NPath = '%newPath%' -split ';' -ne ''; $MPath = ((Get-Item -LiteralPath $envkey).GetValue('Path', '', 'DoNotExpandEnvironmentNames') -split ';' -ne '') | ? {$_.TrimEnd('/').TrimEnd('\') -notin $NPat}; $MPath = $NPath + $MPath ; sp -Type ExpandString -LiteralPath $envkey Path ($MPath -join ';'); $MPath"
echo.

pause