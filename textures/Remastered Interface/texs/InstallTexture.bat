@echo off

REM -----------------------------------------------------------------------------

REM Settings:
REM Enter a display name for each controller texture:
set AtariVCS=Attari VCS Monochrome White
set GCN=Nintendo Gamecube
set NSwitchB=Nintendo Switch Black
set NSwitchW=Nintendo Switch Monochrome White
set NWii=Nintendo Wii
set PS3=Playstation 2 / Playstation 3
set PS4=Playstation 4
set PS5mc=Playstation 5 Monochrome White
set PS5mcf=Playstation 5 Monochrome White Filled
set X1=Xbox One Normal Colored
set X1BW=Xbox One (BaconWizard17)
set X1mc=Xbox One Monochrome White
set X1mcf=Xbox One Monochrome White Filled
set Xbox=Xbox (The Duke) / Xbox 360 / Logitech
set Xbox360=Xbox (The Duke) - Xbox 360 emulator
set X360=Xbox 360 (non-genuine)
set X360360=Xbox 360 (genuine)
REM Enter the name of one extra texture (HUD always takes priority):
set p=FontTexture0_beenox
REM Enter a suffix for above texture (eg. "_hd"):
set h=_hd

REM -----------------------------------------------------------------------------

REM these are automatic settings, don't edit them:
if not defined p set h=
for %%p in (%*) do goto dnd
set z=%h%
for %%t in (HUD*.png) do set s=HUD& set z=
if not defined s set s=%p%
setlocal enableDelayedExpansion
for %%t in (%s%*.png) do call :Add %%~nt
set "TexNames=!TexNames:%s%=!"
set "TexNames=!TexNames:%h%=!"
endlocal & set TexNames=%TexNames:~0,-1%& set m=%m%


:chooseT
set /a x+=1
call :findInString TexNames %x% T
call set Tn=%%%T%%%
if not defined Tn set Tn=%T%
if %x% EQU %m% set x=0
CLS
ECHO.
ECHO Texture: %Tn%
ECHO.
CHOICE /C AS /M "Press 'A' to accept and install this texture, press 'S' to switch"
IF ERRORLEVEL 2 goto chooseT
if not %s%==HUD set F=%T%
goto copyT

:dnd
2>nul pushd "%~1" && goto End
if /i not "%~x1" == ".png" goto End
set T=%~n1
set T=%T:HUD=%
if "%T:~0,19%" == "%p%" set F=%T:~19,-3%
set "i=%~dp1"
set "o=%~dp0"

:copyT
set X=Logitech
if defined F ( call :detect
) else call :specify
if /i %T:~0,1%==X if not "%F%" == "Logi" set X=360
if defined F call :cT %p% %F% %X% %h%
call :cT %s% %T% Logitech
goto End

:cT
copy /y "%i%%1%2%4.png" "%o%%1%3%4.png"
EXIT /b


:specify
if not exist "%i%%p%%T%%h%.png" EXIT /b
set F=%T%
echo.
if /i %T%==Xbox (
 choice /c XL3 /m "Please specify: [X]box (The Duke) / Xbox [3]60 / [L]ogitech"
 if errorlevel 2 set F=Logi
 if errorlevel 3 set "g=a genuine Xbox 360 controller, or " & set F=X360
) else if /i %T:~0,2%==PS (
 choice /m "Use transparent Playstation icons"
 if not errorlevel 2 set F=PSt
)
if not exist "%i%%p%%F%360%h%.png" EXIT /b
echo.
choice /m "Are you using %g%an Xbox 360 emulator for the %Tn% controller"
if not errorlevel 2 set "X=360" & set F=%F%360
EXIT /b

:detect
set T=%F%
if exist "%i%%s%%T%.png" EXIT /b
set T=%T:Logi=Xbox%
set T=%T:X360=Xbox%
set T=%T:PSt=PS5mcf%
if not %T%==%T:360=% set "X=360" & set T=%T:360=%
EXIT /b

:Add
if /i "%~1" == "%s%Logitech%z%" EXIT /b
if /i "%~1" == "%s%360%z%" EXIT /b
set /a m+=1
set TexNames=!TexNames!%1:
EXIT /b

:findInString var token outVar
REM delimeter is customized for this batch.
if "%~3" == "" (set outVar=%~1) else set outVar=%~3
call set "search=%%%~1%%"
for /f "tokens=%2 delims=:" %%s in ("%search%") do set %outVar%=%%s
EXIT /b


:End
EXIT