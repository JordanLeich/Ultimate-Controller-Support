@echo off
for %%p in (%*) do EXIT

REM Paste the path to the game here, instead of being prompted each time:
set "MUApath="
REM Ask to use 2nd controller texture? (yes =true; no, use only 1 set of icons =false)
set ask2=true
REM Ask to change button challenge colour effects? (yes =true; no =false)
set askc=true
REM Language? (define the language suffix =eng; =ita)
set lang=eng
REM Which HUD texture does the controller use? (All =Logitech; Never seen, but Enchlore reported that his Logitech controller uses the 360 text =360; needs more testing)
set HUDc=Logitech
REM This is the location of the registry keys (where the controllers are located with their key bindings):
set RKL=HKEY_CURRENT_USER\SOFTWARE\Activision\Marvel Ultimate Alliance\Controls\DeviceConfig

if "%temp%"=="" set "temp=%~dp0"
set sm=-- successfully completed
set device=N/A
set pn=N/A
set devcode=AU
set opt=BFT
setlocal enableDelayedExpansion

choice /M "Are you using ak2yny's HUD and the big font from the remastered interface mods"
if not errorlevel 2 set RI=r
CLS

:chooseO
set m=
if defined FBdone set opt=BFTX& if defined ITdone set Bdone=%sm%
if defined ITdone set opt=BFTX
CALL :TITLE 0
echo [B] Both                       %Bdone%
echo [F] Fix button mapping only    %FBdone%
echo [T] Apply button textures only %ITdone%
if %opt%==BFTX echo [X] Done. Close console.
echo.
choice /c %opt% /m "Please select an option:"
echo.
if errorlevel 4 EXIT
if errorlevel 3 goto askCT
if %errorlevel%==1 set opt=

for /f "delims=" %%d in ('reg query "%RKL%"') do if not "%%~nd"=="BXNoneDevice" if not "%%~nd"=="BXKeyboard" set devices=!devices!"%%~nd" 
if []==[%devices%] goto chooseP
set deviceB=%devices:~,-1%

:chooseD
call :switch devices device m || goto chooseP
CALL :TITLE 1
CHOICE /C ASE /M "Press 'A' to accept and fix this controller, press 'S' to switch, and press 'E' to fix every controller:"
IF ERRORLEVEL 3 set device=%deviceB% & goto chooseP
IF ERRORLEVEL 2 goto chooseD
set device="%device%"
call :readDC %device%

:chooseP
set m=
echo.
choice /c 1234A /m "Fix controls for which player [A = all]"
set /a player=%errorlevel%-1
set pn=%errorlevel%
if errorlevel 5 set pn=All
if defined opt goto patch

:askCT
if defined devices set ds=2& goto readT
echo [3] Xbox 360 controllers, genuine or emulated
echo [A] All other controllers
choice /c A3 /m "Select your button layout type"
set /a ds=%errorlevel%+1
:readT
for /f "delims=" %%t in ('dir /ad /b /s ^| findstr /ei "\texs"') do set "bt=%%~t\" & call :addBT buttonT
for /f "delims=" %%t in ('dir /a-d /b /s ^| findstr /eil "1r.png"') do set "bt=%%~dpt" & call :addBT buttonTr

:chooseT
call :switch buttonT tex m || goto patch
set "tpp=%tex:*\=%"
CALL :TITLE 2
CHOICE /C AS /M "Press 'A' to accept and use this texture, press 'S' to switch:"
IF ERRORLEVEL 2 goto chooseT

set "tex3=%tex%"
set "tpp3=%tpp%"
if %ask2%==false goto chooseTr
echo.
choice /m "BETA - Do you want to use separate icons for different controllers"
if errorlevel 2 goto chooseTr
call :switchT buttonT 3

:chooseTr
set m=
set x=
call :PStrSw buttonTr 4 tpp
call :PStrSw buttonTr 5 tpp3

:chooseL
echo.
if "%MUApath%"=="" set /p "MUApath=Please paste or type the path to MUA or an MO2 mod folder here: " || goto chooseL
set "MUApath=%MUApath:"=%"

set "tp=%MUApath%\texs"
set "sp=%~dp0%tex%\texs"
set "dp=%MUApath%\data\"
set "ix=%~dp0tools\colors.txt"
set "tx=%temp%\colors.txt"
set "ox=%dp%colors.xmlb"
set vl=value = 
set pl=unk
echo "%tex%" | find /i "\ps" >nul && set pl=ps2, ps3, 
echo "%tex%" | find /i "\xbox" >nul && set pl=xbox, 360, 
find "%pl%pc" "%ox%" >nul && goto patch
if %pl:~,1%==p call :pcol & goto patch
if %pl:~,1%==x call :xcol & goto patch

:chooseC
if %askc%==false goto patch
echo.
choice /m "Do you want to change the button challenge and hint effect colours"
if errorlevel 2 goto patch
CALL :TITLE 6
echo.
echo https://www.w3schools.com/colors/colors_rgb.asp
for %%b in (Attack, Smash, Use, Jump) do call :askCb %%b

:patch
ver>nul
set fm=fix%devcode:~-2%mapping

if defined devices (
 (call :pR)>"%temp%\%fm%.reg"
 "%temp%\%fm%.reg"
 set FBdone=%sm%
)
if %errorlevel% EQU 0 ( del "%temp%\%fm%.reg"
) else set tex=& set FBdone=

if defined tex call :pT && set ITdone=%sm% && if defined A call :pC

echo.
if %errorlevel% EQU 0 ( goto chooseO
) else echo Fix failed.
pause
goto chooseO

:TITLE
SET "dev=Controller:  %device:"=%"
IF %1 GTR 1 SET "dev=%dev% -- %devcode:~-2%"
CLS
IF %1 EQU 1 ECHO.
IF %1 GEQ 1 ECHO %dev%
IF %1 LEQ 1 GOTO TEND
ECHO Player:      %pn%
IF %1 EQU 2 ECHO.
ECHO Texture:     "%tpp:\= - %"
IF %1 LEQ 2 GOTO TEND
IF %1 EQU 3 ECHO.
ECHO Texture Alt: "%tpp3:\= - %"
IF %1 LEQ 3 GOTO TEND
IF %1 EQU 4 GOTO TPSTR
IF %1 EQU 5 GOTO TPSTR
ECHO Path:        "%MUApath%"
GOTO TEND
:TPSTR
ECHO.
ECHO Please choose a PS icon set to go with the transparent icons.
ECHO PS Texture:  "!tpp%1:\= - !"
:TEND
ECHO.
EXIT /B

:PStrSw
if defined tpp4 set "tpp5=%tpp4%" & set "tex5=%tex4%" & EXIT /b
echo "!%3!" | find "PlayStation" | find "Transparent" && goto switchT
EXIT /b
:switchT
call :switch %1 tex%2 m || EXIT /b
set "tpp%2=!tex%2:*\=!"
CALL :TITLE %2
CHOICE /C AS /M "Press 'A' to accept and use this texture, press 'S' to switch"
IF ERRORLEVEL 2 goto switchT
SET m=
EXIT /B

:readDC
set "RCS=%RKL%\%~1\ConfigGamepadCustom\Player"
for /f "delims=" %%c in ('reg query "%RCS%0\Attack" ^| find "Device0"') do set devcode=%%c
set devcode=00000000%devcode:*x=%
set devcode=%devcode:~-8%
set input=xinput
if %devcode% GTR 3 set input=dinput
EXIT /b

:pR
echo REGEDIT4
echo.
if %player% EQU 4 ( for /l %%p in (0,1,3) do call :pRd %%p
) else call :pRd %player%
EXIT /b
:pRd
for %%d in (%device%) do (
 call :readDC "%%~d"
 call :fixMapping %1
)
call :regMUAman %1
EXIT /b

:pT
mkdir "%tp%\" >nul 2>nul
set k=Fullkeyset
set f=FontTexture0_beenox
set h=HudLogitech
call :TexFB 1
call :TexCY %f% 1 Logitech
call :TexCY %f% 1 Logitech _hd
set "sp=%~dp0%tex3%\texs"
if "%device:"=%" == "Controller (XBOX 360 For Windows)" set ds=3
call :TexFB %ds%
call :TexCY %f% %ds:2=1% 360
call :TexCY %f% %ds:2=1% 360 _hd
set k=%k%_%lang%.png
if not exist "%~dp0\textures\%k%" copy "%~dp0\textures\Fullkeyset_eng.png" "%~dp0\textures\%k%"
tools\convert -background none "%~dp0\textures\%k%" %k1%  !k%ds%! -layers flatten "%tp%\%k%"
copy /y "%sp%\%RI%%h%.png" "%tp%\Hud%HUDc%.png" || copy /y "%~dp0%tex4%\texs\%RI%%h%.png" "%tp%\Hud%HUDc%.png"
REM if %devcode% LEQ 3 set ds=3
EXIT /b
:TexFB
set t=0
if %1==1 set "fb=PC Icons & Buttons\Default Logitech Icons" & set t=4
if %1==2 set "fb=Xbox Controllers\Xbox One Buttons\Default" & set t=5
if %1==3 set "fb=Xbox Controllers\Xbox 360 Buttons"
if exist "%sp%\%k%%1r.png" set tr= "%sp%\%k%%1r.png"
if defined tex%t% set tr= "%~dp0!tex%t%!\texs\%k%%1r.png"
if exist "%sp%\%k%%1.png" ( set k%1="%sp%\%k%%1.png"%tr%
) else set k%1="%~dp0textures\%fb%\texs\%k%%1.png"%tr%
EXIT /b
:TexCY
copy /y "%sp%\%RI%%1%2%4.png" "%tp%\%1%3%4.png" || copy /y "%~dp0textures\%fb%\texs\%RI%%1%2%4.png" "%tp%\%1%3%4.png"
EXIT /b

:pC
set rpl=-replace '%vl%.* ;'
set "pc=$fc = Get-Content -Path '%ix%'; "
set pc=%pc%$fc[388] = $fc[388] %rpl%,'%A%'; 
set pc=%pc%$fc[394] = $fc[394] %rpl%,'%S%'; 
set pc=%pc%$fc[400] = $fc[400] %rpl%,'%U%'; 
set pc=%pc%$fc[406] = $fc[406] %rpl%,'%J%'; 
set "pc=%pc%Set-Content -Path '%tx%' -Value $fc"
Powershell "%pc%" || EXIT /b
mkdir "%dp%" >nul 2>nul
tools\xmlb-compile -s "%tx%" "%ox%"
del "%tx%"
EXIT /b
(call :replCol)>"%temp%\%fm%.ps1"
Powershell -executionpolicy remotesigned -File "%temp%\%fm%.ps1"
if %errorlevel% NEQ 0 EXIT /b 1
del "%temp%\%fm%.ps1"

:pcol
set A=%vl%0.26 0.72 1 1 ;
set S=%vl%1 0.38 0.51 1 ;
set U=%vl%0.88 0.49 0.92 1 ;
set J=%vl%0 0.8 0.49 1 ;
EXIT /b

:xcol
set A=%vl%0.3 0.84 0 1 ;
set S=%vl%0.83 0 0 1 ;
set U=%vl%0.31 0.31 1 1 ;
set J=%vl%1 0.91 0.25 1 ;
EXIT /b

:askCb
echo.
echo Enter the RGB values (0-255) of the color you wish to use for the %1 button.
for %%c in (Red, Green, Blue) do call :askCol %%c
set w=%1
set %w:~,1%=%vl%%R% %G% %B% 1 ;
EXIT /b

:replCol
set rpl=-replace '%vl%.* ;'
echo $fc = Get-Content -Path "%ix%"
echo $fc[388] = $fc[388] %rpl%,'%A%'
echo $fc[394] = $fc[394] %rpl%,'%S%'
echo $fc[400] = $fc[400] %rpl%,'%U%'
echo $fc[406] = $fc[406] %rpl%,'%J%'
echo Set-Content -Path "%tx%" -Value $fc
EXIT /b

:askCol
set w=%1
set /p c=%1: || goto askCol
for /f %%c in ('PowerShell %c%/255') do set c=%%c
if %c% LSS 0 goto askCol
if %c% LSS 1 ( set %w:~,1%=%c:~,4%
) else for /f "delims=." %%c in ("%c%") do set %w:~,1%=%%c
EXIT /b
REM Faster without powershell (not crucial), but has upper limit, and forces two decimals
if %c% GTR 9999999 goto askCol
if %c% LSS 0 goto askCol
set /a c=c*100/255
if %c% LSS 10 set c=0%c%
if %c% LSS 100 set c=0%c%
if %c:~-2%==00 (set /a %w:~0,1%=c/100) else set %w:~0,1%=%c:~0,-2%.%c:~-2%

:commonMapping
call :regMUA %1 Guard 48
call :regMUA %1 HeroDown 42
call :regMUA %1 HeroLeft 41
call :regMUA %1 HeroRight 40
call :regMUA %1 HeroUp 43
call :regMUA %1 Jump 47
call :regMUA %1 MoveDown 02
call :regMUA %1 MoveLeft 01
call :regMUA %1 MoveRight 00
call :regMUA %1 MoveUp 03
call :regMUA %1 ScrollMap 49
EXIT /b

:defaultMapping all other controllers
call :regMUA %1 Attack 45
call :regMUA %1 CallAllies 4a
call :regMUA %1 CameraDown 0a
call :regMUA %1 CameraLeft 05
call :regMUA %1 CameraRight 04
call :regMUA %1 CameraUp 0b
call :regMUA %1 Map 4f
call :regMUA %1 Pause 4d
call :regMUA %1 PowerMode 4b
call :regMUA %1 Smash 46
call :regMUA %1 TeamManagement 4c
call :regMUA %1 Use 44
goto commonMapping

:fixMapping
:defaultMapping Controller (XBOX 360 For Windows) 03 (genuine)
call :regMUA %1 Attack 44
call :regMUA %1 CallAllies 04
call :regMUA %1 CameraDown 08
call :regMUA %1 CameraLeft 07
call :regMUA %1 CameraRight 06
call :regMUA %1 CameraUp 09
call :regMUA %1 Map 4d
call :regMUA %1 Pause 4b
call :regMUA %1 PowerMode 05
call :regMUA %1 Smash 45
call :regMUA %1 TeamManagement 4a
call :regMUA %1 Use 46
goto commonMapping

:regMUA
echo [%RCS%%1\%2]
echo "Device0"=dword:%devcode%
echo "Code0"=dword:000000%3
echo "Device1"=dword:00000000
echo "Code1"=dword:00000000
echo.
EXIT /b

:regMUAman
echo [%RKL:Device=Player%\Player%1]
echo "Config"=dword:00000001
echo.
EXIT /b


:addBT
set "bt=%bt:~0,-6%"
set %1=!%1!"!bt:%~dp0=!" 
EXIT /b

:switch
if "!%1!"=="" EXIT /b 1
call :varcount %1 %3
set /a x+=1
call :findInString %1 %x% %2
if %x% EQU !%3! set x=0
set "%2=!%2:..=:!"
EXIT /b 0
:varcount
if defined %2 EXIT /b
set "v=!%1:~,-1!"
for %%v in (%v%) do set /a %2+=1
set v=%v::=..%
set v=%v:" "=:%
set "%1=%v:"=%"
EXIT /b

:findInString var token outVar
REM delimeter is customized for this batch.
if "%~3" == "" (set outVar=%~1) else set outVar=%~3
call set "search=%%%~1%%"
for /f "tokens=%2 delims=:" %%s in ("%search%") do set %outVar%=%%s
EXIT /b