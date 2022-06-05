@echo off
@setlocal DisableDelayedExpansion
title Start with Admin Rights Required to Select Option [1]
color 1F

 :adminqu
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [any] Start with admin Rights (Recommended)           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Start without Admin Rights (many tools wont Work) ^|
Echo.                    ^|_________________________________________________________^|
echo.
SET /p wahl=
if '%wahl%' == '2' goto:Start

::===========================================================================
fsutil dirty query %systemdrive%  >nul 2>&1 || (
echo ==== ERROR ====
echo This script require administrator privileges.
echo To do so, right click on this script and select 'Run as administrator'
echo.
echo Press any key to exit...
pause >nul
goto:Start
)
::===========================================================================

:Start
title RCG10Lite Tool (Realese V1.1 by @rcg10)
cls
mode con cols=98 lines=30
FOR /F "TOKENS=2 DELIMS==" %%A IN ('"WMIC PATH SoftwareLicensingProduct WHERE (Name LIKE 'Windows%%' AND PartialProductKey is not NULL) GET LicenseFamily /VALUE"') DO IF NOT ERRORLEVEL 1 SET "osedition=%%A"
IF NOT DEFINED osedition (
cls
FOR /F "TOKENS=3 DELIMS=: " %%A IN ('DISM /English /Online /Get-CurrentEdition 2^>nul ^| FIND /I "Current Edition :"') DO SET "osedition=%%A"
echo        ==================================================================================
echo            No Product Key Found, Incorrect Windows Edition May Be Detected, If that's 
echo                   the Case then Use  "Change the windows 10 Edition" Option.
echo        ==================================================================================
echo.
pause
) 
cls                        
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Windows Menu                                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Software                                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Games                                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Entertaiment (Stream Series and Movies)           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Read Me                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Check for Newer Versions of This Script?          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Exit Script                                       ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' goto:ReallyWin
if '%wahl%' == '2' goto:Software
if '%wahl%' == '3' goto:gamesGUI
if '%wahl%' == '4' goto:stream
if '%wahl%' == '5' goto:MainReadme
if '%wahl%' == '6' goto:LatestV
if '%wahl%' == '7' goto:Close
 goto:Start

:Checkiwa
CLS
echo ======================================================================
echo.
cscript //nologo %systemroot%\System32\slmgr.vbs /dli
cscript //nologo %systemroot%\System32\slmgr.vbs /xpr
echo.
echo ======================================================================
echo.
echo Press any key to continue...
pause >nul
goto:Start
:======================================================================================================================================================
 :InsertProductKey
CLS
echo:
call:key
for /f "tokens=1-4 usebackq" %%a in ("%temp%\editions") do (if ^[%%a^]==^[%osedition%^] (
    set edition=%%a
    set key=%%b
    set sku=%%c
    set editionId=%%d
    goto :Insertkey))
echo %osedition% Digital License Activation is Not Supported.
echo Press any key to continue...
del /f "%temp%\editions"
pause >nul
goto:MainMenu
:Insertkey
CLS
echo:
echo =============================================================
echo Installing the Product key for Windows 10 %osedition%
echo =============================================================
echo:
cscript /nologo %windir%\system32\slmgr.vbs -ipk %key%
echo:
echo Press any key to continue...
del /f "%temp%\editions"
pause >nul
goto:Start

 :HWIDActivate
cls
echo    ==========================================================================================
echo     Note: For Successful Activation, The Windows Update Service and Internet Must be Enabled.
echo    ==========================================================================================
echo.
choice /C:GC /N /M "[C] Continue To Activation [G] Go Back : "
        if %errorlevel%==1 Goto:Start
		cls
::===========================================================
CLS
wmic path SoftwareLicensingProduct where (LicenseStatus='1' and GracePeriodRemaining='0' and PartialProductKey is not NULL) get Name 2>nul | findstr /i "Windows" 1>nul && (
echo.
echo ==================================================================
echo Checking: Windows 10 %osedition% is Permanently Activated.
echo Activation is not required.
echo ==================================================================
echo.
echo.
choice /C:AG /N /M "[A] I still want to Activate [G] Go Back : "
if errorlevel 2 goto:Start
if errorlevel 1 Goto:continue
)
::===========================================================
:continue
cls
call:key
for /f "tokens=1-4 usebackq" %%a in ("%temp%\editions") do (if ^[%%a^]==^[%osedition%^] (
    set edition=%%a
    set key=%%b
    set sku=%%c
    set editionId=%%d
    goto:parseAndPatch))
echo:
echo %osedition% Digital License Activation is Not Supported.
echo:
echo Press any key to continue...
del /f "%temp%\editions"
pause >nul
goto:Start
::===========================================================
:parseAndPatch
echo      =======================================================================================
echo                   Windows 10 %osedition% Digital License Activation
echo      =======================================================================================
echo.

cd /d "%~dp0"
set "gatherosstate=bin\gatherosstate.exe"

echo Installing Default product key for Windows 10 %osedition% ...
cscript /nologo %windir%\system32\slmgr.vbs -ipk %key%

echo Creating registry entries...
reg add "HKLM\SYSTEM\Tokens" /v "Channel" /t REG_SZ /d "Retail" /f
reg add "HKLM\SYSTEM\Tokens\Kernel" /v "Kernel-ProductInfo" /t REG_DWORD /d %sku% /f
reg add "HKLM\SYSTEM\Tokens\Kernel" /v "Security-SPP-GenuineLocalStatus" /t REG_DWORD /d 1 /f

echo Creating GenuineTicket.XML file for Windows 10 %osedition% ...
start /wait "" "%gatherosstate%"
timeout /t 3 >nul 2>&1

echo GenuineTicket.XML file is installing for Windows 10 %osedition% ...
clipup -v -o -altto bin\
cscript /nologo %windir%\system32\slmgr.vbs -ato

echo Deleting registry entries...
reg delete "HKLM\SYSTEM\Tokens" /f
del /f "%temp%\editions"

echo:
echo Press any key to continue...
pause >nul
goto:Start

 :Gamesrw
mode con cols=98 lines=30
Start "" https://rcg10.webador.de/games
goto:gamersrwreadme

 :gamesGUI
mode con cols=98 lines=30
echo. 
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Download PC Games                                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Download Emulators and Roms                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:gamesP1
if '%wahl%' == '2' goto:EmuGUI
if '%wahl%' == '3' goto:Start
goto:gamesGUI

 :EmuGUI
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Nintendo Emulation                                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Playstation Emulation                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:ninemu
if '%wahl%' == '2' goto:playemu
if '%wahl%' == '3' goto:Start
goto:EmuGUI

 :ninemuroms
Start https://vimm.net/vault/
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   on the right side of the website you can              ^|
Echo.                    ^|   select the console you want to download roms for.     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Return to Game or Emulation Menu                  ^|
Echo.                    ^|_________________________________________________________^|
Set /p wahl=
if '%wahl%' == '1' goto:ninemu
goto:ninemuroms

:playemu
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] PS X (Playstation 1)                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] PS 2 (Playstation 2)                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] PS 3 (Playstation 3)                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Download The Roms/Games (VimmsLair)               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' goto:playemuplay1
if '%wahl%' == '2' goto:playemuplay2
if '%wahl%' == '3' goto:playemuplay3
if '%wahl%' == '4' Start https://vimm.net/?p=vault
if '%wahl%' == '5' goto:Start
goto:playemu

 :playemuplay2
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] pcsx 2 (Windows/Linux)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] PS2emu (Windows,v0.1)                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Playstation Emulation Menu              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:pcsx2wl
if '%wahl%' == '2' Start https://dl.emulator-zone.com/download.php/emulators/ps2/ps2emu/PS2EMU_-_Alpha_01.zip
if '%wahl%' == '3' goto:playemu
goto:playemu

 :pcsx2wl
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] pcsx 2 (Windows,Portable,1.6.0,Stable_Realese)    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] pcsx 2 (Windows,Installer,1.6.0,Stable_Realese)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] pcsx 2 (Linux,binary,1.2.1,Stable_Realese)        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] pcsx 2 (MacOS,binary,v1.7.2861,Nightly_Realese    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Return to Playstation Emulation Menu              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://github.com/PCSX2/pcsx2/releases/download/v1.6.0/pcsx2-v1.6.0-windows-32bit-portable.7z
if '%wahl%' == '2' Start https://github.com/PCSX2/pcsx2/releases/download/v1.6.0/pcsx2-v1.6.0-windows-32bit-installer.exe
if '%wahl%' == '3' Start https://github.com/PCSX2/pcsx2/releases/download/v1.2.1/pcsx2-v1.2.2-linux-binary.7z
if '%wahl%' == '4' Start https://github.com/PCSX2/pcsx2/releases/download/v1.7.2861/pcsx2-v1.7.2861-macos-wxWidgets.tar.gz
if '%wahl%' == '5' goto:playemu
goto:pcsx2wl

 :playemuplay3
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] RPCS3 (Windows)                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] RPCS3 (Linux)                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] RPCS3 (MacOS)                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Return to Playstation Emulation Menu              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://github.com/RPCS3/rpcs3-binaries-win/releases/download/build-63669000ab7ff31c49be86acdc56c0f724007d05/rpcs3-v0.0.22-13543-63669000_win64.7z
if '%wahl%' == '2' Start https://github.com/RPCS3/rpcs3-binaries-linux/releases/download/build-63669000ab7ff31c49be86acdc56c0f724007d05/rpcs3-v0.0.22-13543-63669000_linux64.AppImage
if '%wahl%' == '3' Start https://github.com/RPCS3/rpcs3-binaries-mac/releases/download/build-63669000ab7ff31c49be86acdc56c0f724007d05/rpcs3-v0.0.22-13543-63669000_macos.dmg
if '%wahl%' == '4' goto:playemu

 :playemuplay1
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] ePSXe                                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] PS X (Windows)                                    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Playstation Emulation Menu              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '3' goto:epsxe
if '%wahl%' == '2' Start https://dl.emulator-zone.com/download.php/emulators/psx/psx_em/pSX_1_13.rar
if '%wahl%' == '1' goto:playemu
goto:playemuplay1

 :epsxe
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] ePSXe (Windows)                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] ePSXe (Linux)                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] ePSXe (MacOSX)                                    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] ePSXe (Android)                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Return to Playstation Emulation Menu              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://dl.emulator-zone.com/download.php/emulators/psx/epsxe/ePSXe205.zip
if '%wahl%' == '2' Start http://www.epsxe.com/files/ePSXe205linux_x64.zip
if '%wahl%' == '3' Start http://www.epsxe.com/files/epsxe.rb
if '%wahl%' == '4' Start https://play.google.com/store/apps/details?id=com.epsxe.ePSXe&amp;hl=
if '%wahl%' == '5' goto:playemuplay1
goto:epsxe
:ninemu
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Nintendo Entertaiment System (NES)                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Game Boy Original/Color/Advance (GB/GBC/GBA)      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Super Nintendo Entertaiment System (SNES)         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] VB (Virtual Boy)                                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] N64 (Nintendo 64)                                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] GC (GameCube)                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Nintendo DS                                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Wii                                               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] 3DS (Nintendo 3DS)                                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] Download The Roms/Games (VimmsLair)              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to Start Menu                             ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' goto:ninemunes
if '%wahl%' == '2' goto:ninemugb
if '%wahl%' == '3' goto:ninemusnes
if '%wahl%' == '4' goto:ninemuVB
if '%wahl%' == '5' goto:ninemu64
if '%wahl%' == '6' goto:ninemudolphin
if '%wahl%' == '7' goto:ninemuDS
if '%wahl%' == '8' goto:ninemudolphin
if '%wahl%' == '9' goto:ninemu3ds
if '%wahl%' == '10' goto:ninemuroms
if '%wahl%' == '11' goto:Start
goto:ninemu

 :ninemu3ds
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Citra latest (Windows x64)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Citra latest (Linux x64)                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Citra latest (Mac x64)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Return to Nintendo Emulation Menu                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://github.com/citra-emu/citra-web/releases/download/1.0/citra-setup-windows.exe
if '%wahl%' == '3' Start https://github.com/citra-emu/citra-web/releases/download/1.0/citra-setup-mac.dmg
if '%wahl%' == '2' Start https://dl.flathub.org/repo/appstream/org.citra_emu.citra.flatpakref
if '%wahl%' == '4' goto:ninemuemu
goto:ninemu3ds

 :ninemudolphin
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Dolphin 5.0 (Windows x64)                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Dolphin 4.0.2 (Windows x32)                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Dolphin 4.0 (Ubuntu 13.04 or Higher)              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Dolphin 5.0-16380 (MacOS (Arm/Intel Universal)    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Dolphin 4.0 (MacOSX)                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Dolphin 5.0-16380 (Android.apk)                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Return to Nintendo Emulation Menu                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://dl.emulator-zone.com/download.php/emulators/gamecube/dolphin/64bit/dolphin-x64-5.0.exe
if '%wahl%' == '2' Start https://dl.emulator-zone.com/download.php/emulators/gamecube/dolphin/32bit/dolphin-x86-4.0.2.exe
if '%wahl%' == '3' Start https://dl-mirror.dolphin-emu.org/4.0/dolphin-emu_4.0_amd64.deb
if '%wahl%' == '4' Start https://dl.dolphin-emu.org/builds/08/00/dolphin-master-5.0-16380-universal.dmg
if '%wahl%' == '5' Start https://dl-mirror.dolphin-emu.org/4.0/dolphin-4.0.dmg
if '%wahl%' == '6' Start https://dl.dolphin-emu.org/builds/9f/22/dolphin-master-5.0-16380.apk
if '%wahl%' == '7' goto:ninemuemu
goto:ninemuwii

 :ninemuDS
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] No$gba 3.0 (Windows,Online Support)               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] DeSmuMe (Windows x64)                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Nintendo Emulation Menu                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://dl.emulator-zone.com/download.php/emulators/gba/nocashgba/nocashgba_3.00.zip
if '%wahl%' == '2' Start https://dl.emulator-zone.com/download.php/emulators/nds/desmume/desmume-0.9.11-win64.zip
if '%wahl%' == '3' goto:ninemuemu
goto:ninemuDS

 :ninemu64
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Project 64 (Windows/Android)                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Mupen64++ Beta 0.1.3.12 (Windows)                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Nintendo Emulation Menu                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Project64GUI 
if '%wahl%' == '2' Start https://dl.emulator-zone.com/download.php/emulators/n64/Mupen64plusplus/Mupen64plusplus_Beta_0.1.3.12.zip
if '%wahl%' == '3' goto:ninemuemu
goto:ninemu64

:Project64GUI 
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Project 64 2.3.2 (Windows)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Project64K core 1.4 v0.13 (Windows) (Online       ^|
Echo.                    ^|       Multiplayer Support)                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Project64 2.3.3 (Android.apk)                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Nintendo Emulation Menu                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start http://www.pj64-emu.com/download/project64-latest
if '%wahl%' == '2' Start https://dl.emulator-zone.com/download.php/emulators/n64/project64/Project64k_core1.4_v0.13.zip
if '%wahl%' == '3' Start https://dw.malavida.com/aHM1Tnd6UDJsOHpIMk1iaTlJa29NenhFeTVoazdpbjZaaGNoenMzNEJITGoxeGd4MXN5aHdpd0t6T3U4Qnk1d24wRlppNU5tQkMr/Vjk2WGludTRXZ1hPZk1MdUFvU3ZNR3hQc3NXcUMxRjN0WHJBUjUvQWVvVWRQVHVQZzZBdG91U2FqTVo5M1VzYUphZHd6eHJNMzc0/VUtEcno4d1FoVkk2UFFjbEhIem45NzVrbFRGYzY4TDZUWncrd1NXb1lJMkxGUkhLSTdqYmRZam1jdEF0UUtwNGRPQzhvR0ZvN2h4/dVRhYzBaa0pVaU1WR2w2aE50OGFBTHpBUjcwZDA4UEpTcmFYbEF6Wjl5eXBNYjQwbFJrMEhiS3FZNllha3JWRGl2YW5LSElITG1B/ZGpTeUExVFp2R3lxbFRtL1dLbFRLeVI4VXMxUnk3bWJ5MHJFb2xmYkh0bmFycURyZ1VrajArRWNiVmV5T1owcitNT1lLRFNPVFo4/L2Y1djFXZDdjVjdTdmxkMXpNc1N3TGxxNGJ2MzNjSytSVUViRG4wOGl1bWZFY01kcEUzdS8rMnhxamYxZDgzcVRQMS9qTTkrVEZE/MkVsSGtVbDlpeUxNVUtKakE5SFlRNlRLcVpad2xTemNXeCtmdUFPYnVMV3NyM3hVbmdnR25xUEJ6MW9ETzNQRUJ4bzFxTnVlVDhL/clV3NEdoUG44VEFHMWR5eTBjWkRZR01YazVreGpRZjhLQVJza1lqTi9oNW94bEpHNEtoeGZ5WWkvYWVxck9KbEZNVEJIaEJ5QT09/9f0a466da6dfe85f
if '%wahl%' == '4' goto:ninemuemu
goto:Project64GUI

 :ninemuVB
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] vbjin svn61 (Windows)                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Reality Boy 0.84 (Windows)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Nintendo Emulation Menu                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://dl.emulator-zone.com/download.php/emulators/virtualboy/vbjin/VBjin-svn61.zip
if '%wahl%' == '2' Start https://dl.emulator-zone.com/download.php/emulators/virtualboy/reality_boy/rboy_084_win.zip
if '%wahl%' == '3' goto:ninemuemu
goto:ninemuVB

:ninemusnes
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Snes9x 1.60 (Windows 64x                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Snes9x 1.60 (Windows 32x                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Mesen 0.9.8 (Windos/Linux)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Return to Nintendo Emulation Menu                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://dl.emulator-zone.com/download.php/emulators/snes/snes9x/snes9x-1.60-win32-x64.zip
if '%wahl%' == '2' Start https://dl.emulator-zone.com/download.php/emulators/snes/snes9x/snes9x-1.60-win32.zip
if '%wahl%' == '3' Start https://www.mesen.ca/download.php
if '%wahl%' == '4' goto:ninemuemu
goto:ninemunes

:ninemugb
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Visual Boy Advance (Windows) (All Gameboys)       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] BizHawk 2.3 (Windows) (Color and Advance)         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Nintendo Emulation Menu                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://dl.emulator-zone.com/download.php/emulators/gba/vboyadvance/VisualBoyAdvance-1.8.0-beta3.zip 
if '%wahl%' == '2' Start https://dl.emulator-zone.com/download.php/emulators/misc/bizhawk/BizHawk-2.3.zip
if '%wahl%' == '3' goto:ninemuemu
goto:ninemugb

 :ninemunes
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Nestopiu UE 1.49 (Windos/Linux)                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Mesen -S (Windows/Linux) (SNES/GB/GBC)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Nintendo Emulation Menu                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://dl.emulator-zone.com/download.php/emulators/nes/nestopia/nestopia_1.49-win32.zip
if '%wahl%' == '2' Start https://www.mesen.ca/snes/download.php
if '%wahl%' == '3' goto:ninemuemu
goto:ninemunes

 :gamesP1
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Plants VS Zombies GOTY Edition (Media Fire)       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Bendy and the INC Machine (Media Fire)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Minecraft Story Mode (Steamunlocked)              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Minecraft Story Mode 2 (Steamunlocked)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Geometry Dash (Media Fire)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Plague Inc (Media Fire)                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Rebel Inc (Media Fire)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Five Nights at Freddys (Media Fire)               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Five Nights at Freddys 2 (Media Fire)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] Return to Start Menu                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Page 2                                           ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/hr1k2zz0xxslil6/Plants_vs_Zombies_GOTY.zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/x74ksnxwodm1ixv/Bendy_and_the_inc_Machine_64-Bit_Complete_Edition.zip/file
if '%wahl%' == '3' Start https://steamunlocked.net/minecraft-story-mode-a-telltale-games-series-free-download/
if '%wahl%' == '4' Start https://steamunlocked.net/minecraft-story-mode-season-two-free-download/
if '%wahl%' == '5' Start https://www.mediafire.com/file/mno4cjtxmd21rmc/Geometrie+Dash.zip/file
if '%wahl%' == '6' Start https://www.mediafire.com/file/nvzdmasvz5rzqoe/Plague+Inc+Evolved.zip/file
if '%wahl%' == '7' Start https://www.mediafire.com/file/1vjhtsejgytm4rj/Rebel+Inc+Escalation.zip/file
if '%wahl%' == '8' Start https://www.mediafire.com/file/6e6xeejb4scm106/Five_Nights_at_Freddys.zip/file
if '%wahl%' == '9' Start https://www.mediafire.com/file/w4gi2add192ys6f/Five_Nights_at_Freddy%25C2%25B4s_2.zip/file
if '%wahl%' == '10' goto:Start
if '%wahl%' == '11' goto:gamesP2
goto:gamesP1

 :gamesP2
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Five Nights at Freddys 3 (Media Fire)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Five Nights at Freddys 4 (Halloween,Steamunlocked)^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Baldis Basics + (Media Fire)                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Undertale (Media Fire)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Night of the Consumer (Media Fire)                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Half Life (Media Fire)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Half Life 2 Steamunlocked)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] South Park Rally (My Abondonware)                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Beach Buggy Racing 2 Island Adventure (Media Fire)^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] Page 1                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Page 3                                           ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' Start http://www.mediafire.com/file/6yrqx1rc42vlulj/Five_Nights_at_Freddy%25C2%25B4s_3.zip/file
if '%wahl%' == '2' Start https://steamunlocked.net/five-nights-at-freddys-4-free-download/
if '%wahl%' == '3' Start https://www.mediafire.com/file/r4y8n479vum8xd2/Baldis_Basics_Plus.zip/file
if '%wahl%' == '4' Start https://www.mediafire.com/file/1qj7h1lxb0322xl/Undertale.zip/file
if '%wahl%' == '5' Start http://www.mediafire.com/file/0kbc69xll0vwp3c/NIGHTOFTHECONSUMERS0.04.rar/file
if '%wahl%' == '6' goto:HalfLifepk
if '%wahl%' == '7' Start https://steamunlocked.net/47-half-life-2-free-game-download/
if '%wahl%' == '8' Start https://www.myabandonware.com/game/south-park-rally-a64#download
if '%wahl%' == '9' Start https://www.mediafire.com/file/becvb846o8befll/BBR_2_Island_Adventure_%2528Build_6471156%2529.zip/file
if '%wahl%' == '10' goto:gamesP1
if '%wahl%' == '11' goto:gamesP3
goto:gamesP2

 :gamesP3
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] The GodFather (Media Fire)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Simpsons Hit and Run (Old Media Fire)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] GTA III (Steamunlocked)                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] GTA Vice City (Steamunlocked)                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] GTA San Andreas (Media Fire)                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] GTA IV (Steamunlocked)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] GTA IV and Liberty City Stories (Steamunlocked)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] GTA The Trilogy Defenitive Edition (Steamunlocked)^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] GTA V (Steamunlocked)                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] Page 2                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Page 4                                           ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/d2gp71g5aivy9gw/The+Godfather.zip/file
if '%wahl%' == '2' Start http://www.mediafire.com/file/v6c8dwbqs6e6aq4/Simpsons_game_By_TimeForATutorial.zip/file
if '%wahl%' == '3' Start https://steamunlocked.net/13-grand-theft-auto-iii-free-v14-download/
if '%wahl%' == '4' Start https://steamunlocked.net/grand-theft-auto-vice-city-free-pc-download/
if '%wahl%' == '5' goto:gtasatuto
if '%wahl%' == '6' Start https://steamunlocked.net/59-grand-theft-auto-iv-free-v10-download/
if '%wahl%' == '7' Start https://steamunlocked.net/28-grand-theft-auto-iv-the-complete-edition-free-v15-download/
if '%wahl%' == '8' Start https://steamunlocked.net/20-grand-theft-auto-the-trilogy-the-definitive-edition-free-download/
if '%wahl%' == '9' Start https://steamunlocked.net/51-grand-theft-auto-v-free-v4-download/ 
if '%wahl%' == '10' goto:gamesP2
if '%wahl%' == '11' goto:gamesP4
goto:gamesP3

 :gamesP4
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Chrono Trigger (Limited Edition) (Media Fire)     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Hitman GOTY (Steamunlocked)                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Hitman 2 (Steamunlocked)                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Hitman 3 (Steamunlocked)                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Smart Factory Tycoon (Media Fire)                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Sims (Steamunlocked)                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Sims 2 (Steamunlocked)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Sims 3 (Steamunlocked)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Sims 4  (Steamunlocked)                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] Page 3                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Page 5                                           ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/hyxot5i351qhe5w/Chrono+Trigger+Limited+Edition+(Update+5).zip/file 
if '%wahl%' == '2' Start https://steamunlocked.net/2-hitman-free-download/
if '%wahl%' == '3' Start https://steamunlocked.net/4-hitman-2-free-v3-download/
if '%wahl%' == '4' Start https://steamunlocked.net/7-hitman-3-free-v3-download/
if '%wahl%' == '5' Start https://www.mediafire.com/file/3umkj6w7pavvlsw/Smart+Factory+Ticoon.zip/file
if '%wahl%' == '6' Start https://steamunlocked.net/1-the-sims-complete-edition-free-download/
if '%wahl%' == '7' Start https://steamunlocked.net/6-the-sims-2-free-v9-download/
if '%wahl%' == '8' Start https://steamunlocked.net/8-the-sims-3-free-v11-download/
if '%wahl%' == '9' Start https://steamunlocked.net/22-the-sims-4-free-pc-download/
if '%wahl%' == '10' goto:gamesP3
if '%wahl%' == '11' goto:gamesP5
goto:gamesP3

:gamesP5
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Terraria (Media Fire)                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Stardew Valley (Media Fire)                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Bloons Tower Defense 5 (Media Fire)               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Bloons Tower Defense 6 (Steamunlocked)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Tetris Effect (Steamunlocked)                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Tetris Effect Connect (all Dlcs) (Steamunlocked)  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Cities Skylines (all DLCs) (Steamunlocked)        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Pac-Man Championship Edition 2 (Steamunlocked)    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Pac Man Championsship Edition DX (Media Fire)     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] Page 4                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Page 6                                           ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/6nr89kpd2hd0cqn/Terraria.zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/fp45nqbucz6rlub/Stardew+Valley.zip/file 
if '%wahl%' == '3' Start https://www.mediafire.com/file/iaftxtgse3yfrte/Bloons+Tower+Defense+5.zip/file
if '%wahl%' == '4' Start https://steamunlocked.net/2-bloons-td-6-free-download/
if '%wahl%' == '5' Start https://steamunlocked.net/tetris-effect-free-download/
if '%wahl%' == '6' Start https://steamunlocked.net/5-tetris-effect-connected-free-download/
if '%wahl%' == '7' Start https://steamunlocked.net/18-cities-skylines-free-pc-download/
if '%wahl%' == '8' Start https://steamunlocked.net/pac-man-championship-edition-2-free-download/ 
if '%wahl%' == '9' Start https://www.mediafire.com/file/2ht24x7wsyguazf/Pac+Man+Championship+DX+.zip/file
if '%wahl%' == '10' goto:gamesP4
if '%wahl%' == '11' goto:gamesP6
goto:gamesP5

:gamesP6
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Pac Man 256 (Media Fire)                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Pac-Man Museum (Media Fire)                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Farming Simulator 17 (all DLCs) (Steamunlocked)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Farming Simulator 19 (all DLCs) (Steamunlocked)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Farming Simulator 22 (all DLCs) (Steamunlocked)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] HALO Combat Evolved (Media Fire)                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] HALO 2 (Steamunlocked)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] HALO Wars (Steamunlocked)                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] HALO Spartan Strike (Steamunlocked)               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] Page 5                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Page 7                                           ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/cktmebgbz5qg5q3/Pac+Man+256.zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/a2uq4vayeumvkxu/PAC-MAN+MUSEUM.zip/file
if '%wahl%' == '3' Start https://steamunlocked.net/farming-simulator-17-free-download/
if '%wahl%' == '4' Start https://steamunlocked.net/6-farming-simulator-19-free-pc-download/
if '%wahl%' == '5' Start https://steamunlocked.net/13-farming-simulator-22-free-download/
if '%wahl%' == '6' Start https://www.mediafire.com/file/kf4ib27pewigyzy/HALO+1+(Combat+Evolved).zip/file
if '%wahl%' == '7' Start https://steamunlocked.net/6-halo-2-free-download/
if '%wahl%' == '8' Start https://steamunlocked.net/halo-wars-definitive-edition-free-download/
if '%wahl%' == '9' Start https://steamunlocked.net/halo-spartan-strike-free-download/
if '%wahl%' == '10' goto:gamesP5
if '%wahl%' == '11' goto:gamesP7
goto:gamesP6

:gamesP7
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] HALO Spartan Asssault (Steamunlocked)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Half-Life Blue Shift (Steamunlocked)              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Half-Life 2 Ep1 (Steamunlocked)                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Half-Life 2 EP2 (Steamunlocked)                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Half-Life opossing Force (Steamunlocked)          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Red Dead Redemption 2 (Steamunlocked)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Cyberpunk 2077 (Steamunlocked)                    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Jump Force V3.00 (All Dlcs) (Steamunlocked)       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Spyro Reignited Trilogy (Steamunlocked)           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] Page 6                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Page 8                                           ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' Start https://steamunlocked.net/halo-spartan-assault-free-download/
if '%wahl%' == '2' Start https://steamunlocked.net/1-half-life-blue-shift-free-download/
if '%wahl%' == '3' Start https://steamunlocked.net/1-half-life-2-episode-one-free-download/
if '%wahl%' == '4' Start https://steamunlocked.net/2-half-life-2-episode-2-free-download/
if '%wahl%' == '5' Start https://steamunlocked.net/1-half-life-opposing-force-free-download/
if '%wahl%' == '6' Start https://steamunlocked.net/79-red-dead-redemption-2-free-v14-download/
if '%wahl%' == '7' Start https://steamunlocked.net/36-cyberpunk-2077-free-v37-download/
if '%wahl%' == '8' Start https://steamunlocked.net/jump-force-free-download/
if '%wahl%' == '9' Start https://steamunlocked.net/2-spyro-reignited-trilogy-free-download/
if '%wahl%' == '10' goto:gamesP6
if '%wahl%' == '11' goto:gamesP8
goto:gamesP7

 :gamesP8
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Five Nights at Freddys SL (Steamunlocked)         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] FNAF Help Wanted (non-VR) (Steamunlocked)         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] FNAF Help Wanted (Steamunlocked)                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] FNAF Security Breach (Steamunlocked)              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] FNAF Ultimate Custom Night (Steam)                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] FNAF Pizzeria Simulator (Steam)                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] DOOM 64 (Steamunlocked)                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Forza Horizon 4 Ultimate Edtion (Steamunlocked)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Forza Horizon 5 (All DLC,Steamunlocked)           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] Page 7                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Page 9                                           ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=
if '%wahl%' == '1' Start https://steamunlocked.net/five-nights-at-freddy-s-sister-location-free-download/
if '%wahl%' == '3' Start https://steamunlocked.net/five-nights-at-freddys-vr-help-wanted-free-download/
if '%wahl%' == '2' Start https://steamunlocked.net/five-nights-at-freddys-help-wanted-non-vr-free-pc-download/
if '%wahl%' == '4' Start https://steamunlocked.net/13-five-nights-at-freddys-security-breach-free-download/
if '%wahl%' == '5' Start https://store.steampowered.com/app/871720/Ultimate_Custom_Night/
if '%wahl%' == '6' Start https://store.steampowered.com/app/738060/Freddy_Fazbears_Pizzeria_Simulator/
if '%wahl%' == '7' Start https://steamunlocked.net/doom-64-free-download/
if '%wahl%' == '8' Start https://steamunlocked.net/57-forza-horizon-4-free-v4-download/
if '%wahl%' == '9' Start https://steamunlocked.net/21-forza-horizon-5-free-download/
if '%wahl%' == '10' goto:gamesP7
if '%wahl%' == '11' goto:gamesP9

 :gamesP9
echo.
echo maybe in the next Update
echo.
echo Press any Key to Return to Page 8
pause >nul
goto:gamesP8
 :gtasatuto
Start https://www.mediafire.com/file/t0attojmq9xanqu/GTA_San_Andreas_by_GamerLPs.zip/file
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   Extract the Game in a folder and name it GTA SA, then ^|
Echo.                    ^|   drag the folder to:                                   ^|
Echo.                    ^|   C:\Program Files (x86)\Rockstar Games if there is     ^|
Echo.                    ^|   no Rockstar Games Folder in Program Files x86,        ^|
Echo.                    ^|   then create one name it Rockstar Games and drag       ^|
Echo.                    ^|   the GTA SA Folder in it                               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Return to Page 3 of Game Section                  ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:gamesP3
goto:gtasatuto




 :HalfLifepk
Start https://www.mediafire.com/file/cr99fi34jdsbezf/Half+Life.zip/file
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   Product Key is:                                       ^|
Echo.                    ^|   2335-40262-8334                                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Return Games Page 2                               ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:gamesP2
goto:Halflifepk

 :gamersrwreadme
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   Website was coded by me if you want any game on this  ^|
Echo.                    ^|   or on this Script please dm me on email:              ^|
Echo.                    ^|   rcg10lite@gmail.com                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Return Games Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Start
goto:gamersrwreadme

 :ReallyWin
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Windows Activation Menu                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Check Windows 10/11 Activation Status             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] $OEM$ (Preactivate in Installation USB/ISO)       ^|
Echo.                    ^|       for Windows 10/11                                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Modded Windows OS for Gaming                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Return Start Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Really
if '%wahl%' == '2' goto:Checkiwa
if '%wahl%' == '3' goto:EInfo
if '%wahl%' == '4' goto:MWOS
if '%wahl%' == '5' goto:Start
goto:ReallyWin

:MWOS
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Atlas OS (Recommended)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Win 7/8.1/10/11 Lite                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return Start Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:AtlasOSGUI 
if '%wahl%' == '2' goto:winliteGUI
if '%wahl%' == '3' goto:Start
goto:MWOS

:AtlasOSGUI
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Atlas OS 20H2                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Atlas OS 1803                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Atlas OS 20H2 Faceit Edition                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Atlas OS Website                                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Return to OS Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://github.com/Atlas-OS/atlas-releases/releases/download/20H2/Atlas_v0.5.1.iso
if '%wahl%' == '2' Start https://github.com/Atlas-OS/atlas-releases/releases/download/1803/Atlas_1803_v0.2.iso
if '%wahl%' == '3' Start https://github.com/Atlas-OS/atlas-releases/releases/download/20H2-Faceit/Atlas_v0.5.1_Faceit_Edition.iso
if '%wahl%' == '4' Start https://atlasos.net/
if '%wahl%' == '5' goto:MWOS
 goto:AltasOSGUI

 :winliteGUI
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Windows 11 Lite                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Windows 10 Lite                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Windows 8.1 Lite                                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Windows 7 Lite                                    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Return to OS Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '2' Start https://bit.ly/3MY5hUP
if '%wahl%' == '1' Start https://zeroupload.com/7899432067cfb5ca?pt=d1JVeDdTbUxVN2RoMDlyWVkwQzdLblJNVms1YWIyOWhVV3REZVhWRGVubHdZbVE0UVhjOVBRPT0%3D
if '%wahl%' == '4' Start https://wpc.epubg691.workers.dev/0:/Xtreme.LiteOS.7.x64.[The.World.Of.PC].rar
if '%wahl%' == '3' Start https://archive.org/download/windows-8.1-super-lite-2021-by-cm-team-pk/Windows%208.1%20Super%20Lite%202021%20By%20CmTeamPk.rar
if '%wahl%' == '5' goto:MWOS
 goto:winliteGUI

 :Software
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Programms                                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Tools                                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return Start Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Softwarep
if '%wahl%' == '2' goto:Tools
if '%wahl%' == '3' goto:Start
goto:Software

 :Softwarep
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Adobe                                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Office                                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] VMWare                                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Vegas                                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Wonder Share Filmora                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] AESprite                                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Virtual PC 2007                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Return Software Menu                              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Adobedown
if '%wahl%' == '2' goto:Office
if '%wahl%' == '3' goto:VMWareGUI
if '%wahl%' == '4' goto:VegasGUI
if '%wahl%' == '5' Start https://www.mediafire.com/file/pgq1nux7ucclocg/Wondershare+Filmora+10.1.20.15.exe/file
if '%wahl%' == '6' Start https://www.mediafire.com/file/1gluffyxq6ewqgx/AESprite.zip/file
if '%wahl%' == '7' goto:VMPC
if '%wahl%' == '8' goto:Software
goto:Softwarep

:VMPC
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Download Virtual PC 2007 x64                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Download Virtual PC 2007 x32                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Software Menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/28gs3g38i07g4ll/VirtualPC2007+(x64).zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/lpymi6no6qd7fk9/VirtualPC2007.zip/file
if '%wahl%' == '3' goto:Software
goto:VMPC

 :Adobedown
mode con cols=98 lines=30
echo. 
echo.                            (Only run Autoplay.exe and it installs+activates!)
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
echo.                    ^|   [1] Adobe Photoshop 2022 (autoplay.exe)               ^|
echo.                    ^|                                                         ^|
echo.                    ^|   [2] Adobe Premiere Pro 2022 (autoplay.exe)            ^|
echo.                    ^|                                                         ^|
echo.                    ^|   [3] Adobe After Effects 2022 (autoplay.exe)           ^|
echo.                    ^|                                                         ^|
echo.                    ^|   [4] Adobe CC Cleaner                                  ^|
echo.                    ^|                                                         ^|
echo.                    ^|   [5] Return to Programms Menu                          ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/o2yc7bjt6bh3x0u/Adobe+Photoshop+2022.iso/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/mee64hnnwzn9uco/Adobe+Premiere+Pro+2022.iso/file
if '%wahl%' == '3' Start https://www.mediafire.com/file/2r3lvq0z25uyaz7/Adobe+After+Effects+2022.iso/file
if '%wahl%' == '4' START https://dl.malwarewatch.org/software/useful/adobe/AdobeCCCleaner430.exe
if '%wahl%' == '5' goto:Softwarep
goto:Adobedown

 :VegasGUI
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|    [1] Download Vegas                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [2] Vegas Keys                                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [3] Return to Software Menu                          ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Vegasdown
if '%wahl%' == '2' goto:VegasKeys
if '%wahl%' == '3' goto:Software
goto:VegasGUI

:VegasKeys
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|    Vegas 8 Pro is already preactivated                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    Vegas 13 Pro has a keygen                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    Vegas 15 Pro Has a .ddl file that you put in the     ^|
Echo.                    ^|    installation directory of Vegas 15                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    Vegeas 16 Pro has Proteine.ddl file that you put in  ^|
Echo.                    ^|    the Installation directory of Vegas 16 before you    ^|
Echo.                    ^|    start the Programm                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    Vegas 17 Pro has vegas170.exe and proteine folder    ^|
Echo.                    ^|    that you put into the Vegas17 installation directory ^|
Echo.                    ^|    before you start the Programm                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    Vegas 18 Pro has Vegas180.exe and proteine folder    ^|
Echo.                    ^|    that you put into the Vegas18 installation directory ^|
Echo.                    ^|    before you start the Programm                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [1] Return to VegasGUI Menu                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:VegasGUI
goto:VegasKeys

:Vegasdown
mode con cols=98 lines=30
echo.     
echo.                 If you downloaded your Version go to Vegas Key Menu to activate it
echo.  
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|    [1] Vegas 8 Pro                                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [2] Vegas 13 Pro                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [3] Vegas 15 Pro                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [4] Vegas 16 Pro                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [5] Vegas 17 Pro                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [6] Vegas 18 Pro                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [7] Go to Vegas Key Menu                             ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/3ofh3fhgafpo185/VEGAS8Pro.zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/xerw6r2iqj3r0h4/Vegas13Pro.zip/file
if '%wahl%' == '3' Start https://www.mediafire.com/file/8qgbpuyr5vai8ip/VEGASPro15.zip/file
if '%wahl%' == '4' Start https://www.mediafire.com/file/uk64mmffckjacl7/VEGASPro16.zip/file
if '%wahl%' == '5' Start https://www.mediafire.com/file/guxca9la08t24qw/VEGASPro17.zip/file
if '%wahl%' == '6' Start https://www.mediafire.com/file/3jnoztcnxfnc5bs/VEGASPro18.zip/file
if '%wahl%' == '7' goto:VegasKeys
goto:Vegasdown

 :VMWareGUI
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] VMWare Downloads                                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] VMWare Keys                                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return Software Menu                              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:VMWaredown
if '%wahl%' == '2' goto:VMWareKeys
if '%wahl%' == '3' goto:Software
goto:VMWareGUI

:VMWareKeys
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|    VMWare 9 Pro has a keygen                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    VMWare 12 Pro Keys:                                   ^|
Echo.                    ^|    GY7EA-66D53-M859P-5FM7Z-QVH96                        ^|
Echo.                    ^|    CC15K-AYF01-H897Q-75Y7E-PU89A                        ^|
Echo.                    ^|    UC3WA-DFE01-M80DQ-AQP7G-PFKEF                        ^|
Echo.                    ^|    ZA1RA-82EDM-M8E2P-YGYEZ-PC8ED                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    VMWare 14 ProKey:                                    ^|
Echo.                    ^|    YV54A-2ZW5P-M887Y-UWXNE-QPUXD                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    VMWare 15 Pro is Preactivated                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    VMWare 16 Pro Key:                                   ^|
Echo.                    ^|    ZF3R0-FHED2-M80TY-8QYGC-NPKYF                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [1] Return to VMWare Menu                            ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:VMWareGUI
goto:VMWareKeys

:VMWaredown
mode con cols=98 lines=30
echo.     
echo.                          If you installed go to VMWare Keys Menu!
echo.  
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] VMWare Workstation 9                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] VMWare Workstation 12                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] VMWare Workstation 14                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] VMWare Workstation 15                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] VMWare Workstation 16                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Return to VMWare Menu                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/khtwcsdau1nih50/VMwareWorkstation9.zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/0ic5mg9tdpqwefg/VMwareWorkstation12.zip/file
if '%wahl%' == '3' Start https://www.mediafire.com/file/9kz35sbxlzt16q2/VMwareWorkstation14.zip/file
if '%wahl%' == '4' Start https://www.mediafire.com/file/uuvrabpi1dcj1yi/VMwareWorkstation15.zip/file
if '%wahl%' == '5' Start https://www.mediafire.com/file/tex7m6myuy39mxg/VMwareWorkstation16.zip/file
if '%wahl%' == '6' goto:VMWareGUI
goto:VMWaredown

 :Really
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Windows 10/11                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Windows 8/8.1                                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Windows 7                                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Return Start Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Really1
if '%wahl%' == '2' goto:Win8ac1
if '%wahl%' == '3' goto:Win7ac1
if '%wahl%' == '4' goto:Start
goto:Really

 :Mainreadme
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] How to                                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] About Script                                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|

SET /p wahl=
if '%wahl%' == '1' goto:ReadMe2
if '%wahl%' == '2' goto:ReadMe
if '%wahl%' == '3' goto:Start
goto:MainReadme

:Win8ac1
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Activate with Digital License Key                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Activate with Volume Key                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Win8lac
if '%wahl%' == '2' goto:Win8ac
if '%wahl%' == '3' goto:Start
goto:Win8ac1

 :Win8lac
mode con cols=98 lines=30
title Activate Windows 8 / Windows 8.1 ALL   &cls&echo =====================================================================================&echo #Supported products:&echo - Windows 8 Core&echo - Windows 8 Core Single Language&echo - Windows 8 Professional&echo - Windows 8 Professional N&echo - Windows 8 Professional WMC&echo - Windows 8 Enterprise&echo - Windows 8 Enterprise N&echo - Windows 8.1 Core&echo - Windows 8.1 Core N&echo - Windows 8.1 Core Single Language&echo - Windows 8.1 Professional&echo - Windows 8.1 Professional N&echo - Windows 8.1 Professional WMC&echo - Windows 8.1 Enterprise&echo - Windows 8.1 Enterprise N&echo.&echo.&echo ============================================================================&echo Activating your Windows...&cscript //nologo slmgr.vbs /ckms >nul&cscript //nologo slmgr.vbs /upk >nul&cscript //nologo slmgr.vbs /cpky >nul&set i=1&wmic os | findstr /I "enterprise" >nul
if %errorlevel% EQU 0 (cscript //nologo slmgr.vbs /ipk MHF9N-XY6XB-WVXMC-BTDCT-MKKG7 >nul||cscript //nologo slmgr.vbs /ipk TT4HM-HN7YT-62K67-RGRQJ-JFFXW >nul||cscript //nologo slmgr.vbs /ipk 32JNW-9KQ84-P47T8-D8GGY-CWCK7 >nul||cscript //nologo slmgr.vbs /ipk JMNMF-RHW7P-DMY6X-RF3DR-X2BQT >nul&goto skms) else (cscript //nologo slmgr.vbs /ipk GCRJD-8NW9H-F2CDX-CCM8D-9D6T9 >nul||cscript //nologo slmgr.vbs /ipk HMCNV-VVBFX-7HMBH-CTY9B-B4FXY >nul||cscript //nologo slmgr.vbs /ipk NG4HW-VH26C-733KW-K6F98-J8CK4 >nul||cscript //nologo slmgr.vbs /ipk XCVCF-2NXM9-723PB-MHCB7-2RYQQ >nul||cscript //nologo slmgr.vbs /ipk GNBB8-YVD74-QJHX6-27H4K-8QHDG >nul||cscript //nologo slmgr.vbs /ipk M9Q9P-WNJJT-6PXPY-DWX8H-6XWKK >nul||cscript //nologo slmgr.vbs /ipk 7B9N3-D94CG-YTVHR-QBPX3-RJP64 >nul||cscript //nologo slmgr.vbs /ipk BB6NG-PQ82V-VRDPW-8XVD2-V8P66 >nul||cscript //nologo slmgr.vbs /ipk 789NJ-TQK6T-6XTH8-J39CJ-J8D3P >nul||goto notsupported)
:skms
if %i% GTR 10 goto busy
if %i% EQU 1 set KMS=s9.us.to
if %i% EQU 2 set KMS=s8.uk.to
if %i% EQU 3 set KMS=kms7.MSGuides.com
if %i% GTR 3 goto ato
cscript //nologo slmgr.vbs /skms %KMS%:1688 >nul
:ato
echo ============================================================================&echo.&echo.&cscript //nologo slmgr.vbs /ato | find /i "successfully" && (echo.&echo ============================================================================&choice /n /c YN /m "Would you like to visit my Website [Y,N]?" & if errorlevel 2 goto:Start) || (echo The connection to my server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto skms)
explorer "http://rcg10.webador.de"&goto:Start
:notsupported
echo Sorry, your version is not supported&goto:Start
:busy
echo Sorry, the server is busy and can't respond to your request. Please try again&goto:Start
:halt
goto:Start


 :Csl
mode con cols=98 lines=30
echo.                     ____________________________________________________________________________ 
Echo.                    ^|                                                                          ^|
Echo.                    ^|  Your Edition of Windows 10/11 gets Activated now                        ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|  With a Volume Key                                                       ^|
Echo.                    ^|__________________________________________________________________________^|
cscript //nologo c:\windows\system32\slmgr.vbs /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 3KHY7-WNT83-DGQKR-F7HPR-844BM >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk PVMJN-6DFY6-9CCP6-7BKTT-D3WVR >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk MH37W-N47XK-V7XM9-C7227-GCQG9 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk NW6C2-QMPVW-D7KKK-3GKT6-VCFB2 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 2WH4N-8QGBV-H22JP-CT43Q-MDWWJ >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk YYVX9-NTFWV-6MDM3-9PT4T-4M68B >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 44RPN-FTY23-9VTTB-MP9BX-T84FV >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk WNMTR-4C88C-JK8YV-HQ7T2-76DF9 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 2F77B-TNFGY-69QQF-B8YKP-D69TJ >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk QFFDN-GRT3P-VKWWX-X7T3R-8B639 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 92NFX-8DJQP-P6BBQ-THF9C-7CG2H >nul
mode con cols=98 lines=30
echo.                     ____________________________________________________________________________ 
Echo.                    ^|                                                                          ^|
Echo.                    ^|  Your Edition of Windows 10/11 was Activated with a Volume Key           ^|
Echo.                    ^|__________________________________________________________________________^|
pause
goto:Start
 
 :Win7ac1
mode con cols=98 lines=30
echo.                     ____________________________________________________________________________ 
Echo.                    ^|                                                                          ^|
Echo.                    ^|  Do you want to activate Windows 7 with                                  ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|  [1] With a Digital License Key                                          ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|  [2] With a Volume Key                                                   ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|  [3] Return to Start Menu                                                ^|
Echo.                    ^|__________________________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Win7lac
if '%wahl%' == '2' goto:Win7ac
if '%wahl%' == '3' goto:Start


 :Win7lac
mode con cols=98 lines=30
echo.                     ____________________________________________________________________________ 
Echo.                    ^|                                                                          ^|
Echo.                    ^|  Your Edition of Windows 7 gets Activated                                ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|  With a Digital License Key                                              ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|  Supported products:                                                     ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|   Windows 7 Home                                                         ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|   Windows 7 Pro                                                          ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|   Windows 7 Enterprise                                                   ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|   Windows 7 Ultimate                                                     ^|
Echo.                    ^|__________________________________________________________________________^|
cscript //nologo c:\windows\system32\slmgr.vbs /ipk FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4
echo ************************************************* &echo.&echo.&set i=1
:server
if %i%==1 set KMS_Sev=kms.digiboy.ir
if %i%==2 set KMS_Sev=kms8.MSGuides.com
if %i%==3 set KMS_Sev=kms.chinancce.com
cscript //nologo c:\windows\system32\slmgr.vbs /skms %KMS_Sev% >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ato | find /i "successfully" && echo.& echo *************************************************
goto:Start



 :Win7ac
echo.                     ____________________________________________________________________________ 
Echo.                    ^|                                                                          ^|
Echo.                    ^|  Your Edition of Windows 7 gets Activated                                ^|
Echo.                    ^|__________________________________________________________________________^|
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 7JQWQ-K6KWQ-BJD6C-K3YVH-DVQJG >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 33PXH-7Y6KF-2VJC9-XBBR8-HVTHH >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk YDRBP-3D83W-TY26F-D46B2-XCKRJ >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk C29WB-22CC8-VJ326-GHFJW-H9DH4 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk MRPKT-YTG23-K7D7T-X2JMM-QY7MG >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk W82YF-2Q76Y-63HXB-FGJG9-GF7QX >nul
echo.                     ____________________________________________________________________________ 
Echo.                    ^|                                                                          ^|
Echo.                    ^|  Your Edition of Windows 7 was Activated                                 ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|  With a Volume Key                                                       ^|
Echo.                    ^|__________________________________________________________________________^|
pause
 goto:Start





 :Win8ac
echo.                     ____________________________________________________________________________ 
Echo.                    ^|                                                                          ^|
Echo.                    ^|  Your Edition of Windows 8/8.1 gets Activated                            ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|  With a Volume Key                                                       ^|
Echo.                    ^|__________________________________________________________________________^|
cscript //nologo c:\windows\system32\slmgr.vbs /ipk MHF9N-XY6XB-WVXMC-BTDCT-MKKG7 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk TT4HM-HN7YT-62K67-RGRQJ-JFFXW >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 32JNW-9KQ84-P47T8-D8GGY-CWCK7 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk JMNMF-RHW7P-DMY6X-RF3DR-X2BQT >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk GCRJD-8NW9H-F2CDX-CCM8D-9D6T9 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk HMCNV-VVBFX-7HMBH-CTY9B-B4FXY >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk NG4HW-VH26C-733KW-K6F98-J8CK4 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk XCVCF-2NXM9-723PB-MHCB7-2RYQQ >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk GNBB8-YVD74-QJHX6-27H4K-8QHDG >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk M9Q9P-WNJJT-6PXPY-DWX8H-6XWKK >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 7B9N3-D94CG-YTVHR-QBPX3-RJP64 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk BB6NG-PQ82V-VRDPW-8XVD2-V8P66 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 789NJ-TQK6T-6XTH8-J39CJ-J8D3P >nul
mode con cols=98 lines=30
echo.                    ____________________________________________________________________________ 
Echo.                    ^|                                                                          ^|
Echo.                    ^|  Your Edition of Windows 8/8.1 was Activated                             ^|
Echo.                    ^|                                                                          ^|
Echo.                    ^|  Press key to return to Start Menu                                       ^|
Echo.                    ^|__________________________________________________________________________^|
pause >nul
goto:Start



:EInfo
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Extract                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Download Bin folder                               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return Start Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Extract
if '%wahl%' == '2' goto:BINf
if '%wahl%' == '3' goto:Start
 goto:EInfo

:======================================================================================================================================================
:Extract
cls
mode con cols=98 lines=30
echo     ==================================================================================
echo       Note: This Option Will Create $OEM$ Folder of This Activator on Your Desktop,   
echo             Which You Can Use to Create Preactivated Windows Install. 
echo             For More Info Use ReadMe.
echo     ==================================================================================
echo.
choice /C:GC /N /M "[C] Create $OEM$ Folder [G] Go Back : "
        if %errorlevel%==1 Goto:ReadMe
		cls
echo WScript.Echo WScript.CreateObject^("WScript.Shell"^).SpecialFolders^("Desktop"^) >"%temp%\desktop.vbs"
for /f "tokens=* delims=" %%a in ('cscript //nologo "%temp%\desktop.vbs"') do (set DESKTOPDIR=%%a&del "%temp%\desktop.vbs">nul)
cd /d "%desktopdir%"
IF EXIST $OEM$ (
echo.
echo.
echo               ================================================
echo                 Error - $OEM$ folder was not created because 
echo                      $OEM$ Folder already exists on Desktop.
echo               ================================================
echo. 
echo Press any key to continue...
pause >nul
goto:Start

) ELSE (
md $OEM$\$$\Setup\Scripts\BIN
cd /d "%~dp0"
copy BIN\gatherosstate.exe "%desktopdir%\$OEM$\$$\Setup\Scripts\BIN"
copy BIN\slc.dll "%desktopdir%\$OEM$\$$\Setup\Scripts\BIN"
)
cd /d "%desktopdir%\$OEM$\$$\Setup\Scripts\"

call :create_file  %0 "%desktopdir%\$OEM$\$$\Setup\Scripts\SetupComplete.cmd" "REM SetupComplete Start" "REM SetupComplete End"

goto :Preacread

REM SetupComplete Start
@Echo off 
pushd "%~dp0"
cd /d "%~dp0"
::===========================================================================
:===========================================================================

 :Really1
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|    Which Activation do you want to use?                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Windows Digital License Key                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Insert the Digital License Key                    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Change Edition and Activate it                    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Volume Activation                                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Return Start Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:HWIDActivate
if '%wahl%' == '2' goto:InsertProductKey
if '%wahl%' == '3' goto:EdiChange10/11
if '%wahl%' == '4' goto:Csl
if '%wahl%' == '5' goto:Start
 goto:Really1

 :ReadMe
mode con cols=98 lines=30
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [Script coded by @RCG10]                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [Script is Version 1.1 [Realese]                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [Other OS than 7/8/8.1/10/11 wont Work]               ^|
Echo.                    ^|                   _______________                       ^|
echo.                    ^|                                                         ^|
Echo.                    ^|   [To find out your Windows Version and edition         ^|
echo                     ^|     click Windows + r at the same time and type in      ^|
echo.                    ^|      winver to lock your Windows Version and Edition]   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [Without the BIN File $OEM$ Windows Digital License   ^|
Echo.                    ^|    Activation and other Functions wont Work]            ^|
Echo.                    ^|_________________________________________________________^|
ECHO.
echo [1] Return to Start Menu
SET /p wahl=
if '%wahl%' == '1' goto:Start
goto:ReadMe

 :stream
mode con cols=98 lines=30
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Stream Series and Movies (direct Link,fastest)    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Websites for Stream                               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
ECHO.
SET /p wahl=
if '%wahl%' == '3' goto:Start
if '%wahl%' == '1' goto:streamdl
if '%wahl%' == '2' goto:streamserver
goto:stream

 :streamdl
mode con cols=98 lines=30
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Bobs Burgers [German]                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
ECHO.
SET /p wahl=
if '%wahl%' == '2' goto:Start
if '%wahl%' == '1' goto:bbP1
goto:streamdl

 :bbP1
mode con cols=98 lines=30
echo.
echo.                         Make sure you installed adblock plus extension in your Browser!!!
echo.                     __________________________________________________________________________
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [1] Staffel 1 [German] [Streamtape]                                   ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [2] Staffel 2 [German] [Streamtape]                                   ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [3] Staffel 3 [German] [Streamtape]                                   ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [4] Staffel 4 [German] [Streamtape]                                   ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [5] Staffel 5 [German] [Streamtape]                                   ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [6] Staffel 6 [German] [Streamtape]                                   ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [7] Staffel 7 [German] [Streamtap and VOE]                            ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [8] Staffel 8 [German] [Streamtape and Doodstream]                    ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [9] Staffel 9 [German] [Streamtape and VOE]                           ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [10] Page 2                                                           ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [100] Other                                                           ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [exit] Exit Script                                                    ^|
Echo.                    ^|_________________________________________________________________________^|
echo.
SET /p wahl=
if '%wahl%' == '1' goto:ST1
if '%wahl%' == '2' goto:ST2
if '%wahl%' == '3' goto:ST3
if '%wahl%' == '4' goto:ST4
if '%wahl%' == '5' goto:ST5
if '%wahl%' == '6' goto:ST6
if '%wahl%' == '7' goto:ST7
if '%wahl%' == '8' goto:ST8
if '%wahl%' == '9' goto:ST9
if '%wahl%' == '10' goto:bbP2
if '%wahl%' == '100' goto:otherbb
if '%wahl%' == 'exit' goto:Close
goto:bbP1
:bbP2
mode con cols=98 lines=30
echo.
echo.                                If any Graphic Bug Apears just resize the Windows
echo.                     __________________________________________________________________________
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [1] Staffel 10 [German] [Streamtape,VOE]                              ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [2] Staffel 11 [German] [Streamtape]                                  ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [3] Staffel 12 [German] [Streamtape]                                  ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [4] Page 1                                                            ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [100] Other                                                           ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [exit] Exit Script                                                    ^|
Echo.                    ^|_________________________________________________________________________^|
echo.
SET /p wahl=
if '%wahl%' == '1' goto:ST10
if '%wahl%' == '2' goto:ST11
if '%wahl%' == '3' goto:ST12
if '%wahl%' == '4' goto:bbP1
if '%wahl%' == '100' goto:otherbb
if '%wahl%' == 'exit' goto:Close
goto:bbP2
 :ST1
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape J                               ^|
Echo.                    ^|   [2] Folge 2 Streamtape J                               ^|
Echo.                    ^|   [3] Folge 3 Streamtape J                               ^|
Echo.                    ^|   [4] Folge 4 Streamtape J                               ^|
Echo.                    ^|   [5] Folge 5 Streamtape J                               ^|
Echo.                    ^|   [6] Folge 6 Streamtape J                               ^|
Echo.                    ^|   [7] Folge 7 Streamtape J                               ^|
Echo.                    ^|   [8] Folge 8 Streamtape J                               ^|
Echo.                    ^|   [9] Folge 9 Streamtape J                               ^|
Echo.                    ^|   [10] Folge 10 Streamtape N                             ^|
Echo.                    ^|   [11] Folge 11 Streamtape W                             ^|
Echo.                    ^|   [12] Folge 12 Streamtape W                             ^|
Echo.                    ^|   [13] Folge 13 Streamtape W                             ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/o1WL40ggz7FJ6xV 
if '%wahl%' == '2' Start https://streamadblockplus.com/e/PJpg1pMOG2s02bk
if '%wahl%' == '3' Start https://streamadblockplus.com/e/JXLj9M0vOWu69V 
if '%wahl%' == '4' Start https://streamadblockplus.com/e/r3WY26xBqVfgK9
if '%wahl%' == '5' Start https://streamadblockplus.com/e/Z2ZPKVWzWwhd7x
if '%wahl%' == '6' Start https://streamadblockplus.com/e/1pgmmdbZ99Se48g
if '%wahl%' == '7' Start https://streamadblockplus.com/e/MxrL00dqReIm3b3
if '%wahl%' == '8' Start https://streamadblockplus.com/e/4GKKjMrobmsKgqK
if '%wahl%' == '9' Start https://streamadblockplus.com/e/PjO88yRXLZi013y
if '%wahl%' == '10' Start https://streamadblockplus.com/e/lk0V8Gld29iZp2
if '%wahl%' == '11' Start https://streamadblockplus.com/e/llgjy8xp0BC743Y
if '%wahl%' == '12' Start https://streamadblockplus.com/e/3OKLgzYddxU6bx 
if '%wahl%' == '13' Start https://streamadblockplus.com/e/QyY8ZRDDwKTw7G
if '%wahl%' == '100' goto:bbP1
goto:ST1
 :ST2
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape                                 ^|
Echo.                    ^|   [2] Folge 2 Streamtape                                 ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 Streamtape                                 ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 Streamtape                                 ^|
Echo.                    ^|   [7] Folge 7 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 Streamtape                                 ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/xZez9YxMK8Sqva
if '%wahl%' == '2' Start https://streamadblockplus.com/e/XgOkaPqyKvSDRZQ
if '%wahl%' == '3' Start https://streamadblockplus.com/e/XrgX93AYrViD9Za
if '%wahl%' == '4' Start https://streamadblockplus.com/e/WGoqXBrAQPSbv3J
if '%wahl%' == '5' Start https://streamadblockplus.com/e/2ap4RRG2VptZb9d
if '%wahl%' == '6' Start https://streamadblockplus.com/e/AJolrRB96rTXoeX
if '%wahl%' == '7' Start https://streamadblockplus.com/e/Zq8PlrwJX4cqvvm
if '%wahl%' == '8' Start https://streamadblockplus.com/e/jOOzbVp964uzX8o
if '%wahl%' == '9' Start https://streamadblockplus.com/e/88kAymYxX6UogvQ
if '%wahl%' == '100' goto:bbP1
goto:ST2
 :ST3
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape                                 ^|
Echo.                    ^|   [2] Folge 2 Streamtape                                 ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 Streamtape                                 ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 Streamtape                                 ^|
Echo.                    ^|   [7] Folge 7 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 Streamtape                                 ^|
Echo.                    ^|   [10] Folge 10 Streamtape                               ^|
Echo.                    ^|   [11] Folge 11 Streamtape                               ^|
Echo.                    ^|   [12] Folge 12 Streamtape                               ^|
Echo.                    ^|   [13] Folge 13 Streamtape                               ^|
Echo.                    ^|   [14] Folge 14 Streamtape                               ^|
Echo.                    ^|   [15] Folge 15 Streamtape                               ^|
Echo.                    ^|   [16] Folge 16 Streamtape                               ^|
Echo.                    ^|   [17] Folge 17 Streamtape                               ^|
Echo.                    ^|   [18] Folge 18 Streamtape                               ^|
Echo.                    ^|   [19] Folge 19 Streamtape                               ^|
Echo.                    ^|   [20] Folge 20 Streamtape                               ^|
Echo.                    ^|   [21] Folge 21 Streamtape                               ^|
Echo.                    ^|   [22] Folge 22 Streamtape                               ^|
Echo.                    ^|   [23] Folge 23 Streamtape                               ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/DAQ8191v4Aukpyk
if '%wahl%' == '2' Start https://streamadblockplus.com/e/lkkZOx7prXc70PR
if '%wahl%' == '3' Start https://streamadblockplus.com/e/drG0L1lA31ukXqy
if '%wahl%' == '4' Start https://streamdblockplus.com/e/WXkAxW79RMIbdro
if '%wahl%' == '5' Start https://streamadblockplus.com/e/YDxDG0a1K2fpoR
if '%wahl%' == '6' Start https://streamadblockplus.com/e/YqrePY4V13TBjd
if '%wahl%' == '7' Start https://streamadblockplus.com/e/PjYW8JwvggS00X9
if '%wahl%' == '8' Start https://streamdblockplus.com/e/m9LVzLADoXHbP3Z
if '%wahl%' == '9' Start https://streamadblockplus.com/e/bZv3oZOYllsPZXj
if '%wahl%' == '10' Start https://streamadblockplus.com/e/a0mY404AyqhMoa
if '%wahl%' == '11' Start https://streamadblockplus.com/e/zbX8XKkKaMTYdRJ
if '%wahl%' == '12' Start https://streamadblockplus.com/e/0ewJbwLQqkCb33D
if '%wahl%' == '13' Start https://streamadblockplus.com/e/wJmwD2ZjLkCJMxZ
if '%wahl%' == '14' Start https://streamadblockplus.com/e/xe48lZ1PZBikG98
if '%wahl%' == '15' Start https://streamadblockplus.com/e/466PZjxzXOCp1l
if '%wahl%' == '16' Start https://streamadblockplus.com/e/KkR7vG939MU0Mrk
if '%wahl%' == '17' Start https://streamadblockplus.com/e/e262zaMpR3cJrp
if '%wahl%' == '18' Start https://streamadblockplus.com/e/7D0j0OpbvASA9Mj
if '%wahl%' == '19' Start https://streamadblockplus.com/e/KXXGW03aYxt0dmo
if '%wahl%' == '20' Start https://streamadblockplus.com/e/26BMerbMO8SA69
if '%wahl%' == '21' Start https://streamadblockplus.com/e/VPaJy1BeBeFK12X
if '%wahl%' == '22' Start https://streamadblockplus.com/e/OJKXrYBp9gIZJ2Y
if '%wahl%' == '23' Start https://streamadblockplus.com/e/V841JwlJeQIKAo3
if '%wahl%' == '100' goto:bbP1
goto:ST3
 :ST4
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape                                 ^|
Echo.                    ^|   [2] Folge 2 Streamtape                                 ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 Streamtape                                 ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 Streamtape                                 ^|
Echo.                    ^|   [7] Folge 7 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 Streamtape                                 ^|
Echo.                    ^|   [10] Folge 10 Streamtape                               ^|
Echo.                    ^|   [11] Folge 11 Streamtape                               ^|
Echo.                    ^|   [12] Folge 12 Streamtape                               ^|
Echo.                    ^|   [13] Folge 13 Streamtape                               ^|
Echo.                    ^|   [14] Folge 14 Streamtape                               ^|
Echo.                    ^|   [15] Folge 15 Streamtape                               ^|
Echo.                    ^|   [16] Folge 16 Streamtape                               ^|
Echo.                    ^|   [17] Folge 17 Streamtape                               ^|
Echo.                    ^|   [18] Folge 18 Streamtape                               ^|
Echo.                    ^|   [19] Folge 19 Streamtape                               ^|
Echo.                    ^|   [20] Folge 20 Streamtape                               ^|
Echo.                    ^|   [21] Folge 21 Streamtape                               ^|
Echo.                    ^|   [22] Folge 22 Streamtape                               ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/7kB7g2Ydj3FA6md
if '%wahl%' == '2' Start https://streamadblockplus.com/e/zpAOL9loblcvmz
if '%wahl%' == '3' Start https://streamadblockplus.com/e/m73mBrlm0jibqQd
if '%wahl%' == '4' Start https://streamadblockplus.com/e/e2BYkjRpWLHY071
if '%wahl%' == '5' Start https://streamadblockplus.com/e/M6zmBKvaoRSdal
if '%wahl%' == '6' Start https://streamadblockplus.com/e/xvgvXBY9reFkPza
if '%wahl%' == '7' Start https://streamadblockplus.com/e/3JlaO4v4v2fdPpy
if '%wahl%' == '8' Start https://streamadblockplus.com/e/DG8mzWQrjmTkkYQ
if '%wahl%' == '9' Start https://streamadblockplus.com/e/bglp1kz2mqcPa0z
if '%wahl%' == '10' Start https://streamadblockplus.com/e/VXgpGKypZKcx0J
if '%wahl%' == '11' Start https://streamadblockplus.com/e/mLJlW1evQefb4m7
if '%wahl%' == '12' Start https://streamadblockplus.com/e/PyqgyPRWLMhGyJ
if '%wahl%' == '13' Start https://streamadblockplus.com/e/4dlm6Xg6qrsKbPY
if '%wahl%' == '14' Start https://streamadblockplus.com/e/3wg3GV9gJVSdV2z
if '%wahl%' == '15' Start https://streamadblockplus.com/e/oMwVlQz0l6IW0k
if '%wahl%' == '16' Start https://streamadblockplus.com/e/2PZ9Q2y3oMIZdRD
if '%wahl%' == '17' Start https://streamadblockplus.com/e/1qjwQWAjY3fe4qp
if '%wahl%' == '18' Start https://streamadblockplus.com/e/46Qw6VGVv3TKY6B
if '%wahl%' == '19' Start https://streamadblockplus.com/e/LXawYrPm7ZhRpY4
if '%wahl%' == '20' Start https://streamadblockplus.com/e/GXbVBqypVZFdM7
if '%wahl%' == '21' Start https://streamadblockplus.com/e/Wq7bxWjvapibPmB
if '%wahl%' == '22' Start https://streamadblockplus.com/e/78RwdejZbbFA3KJ
if '%wahl%' == '100' goto:bbP1
goto:ST4
 :ST5
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape                                 ^|
Echo.                    ^|   [2] Folge 2 Streamtape                                 ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 Streamtape                                 ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 Streamtape                                 ^|
Echo.                    ^|   [7] Folge 7 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 Streamtape                                 ^|
Echo.                    ^|   [10] Folge 10 Streamtape                               ^|
Echo.                    ^|   [11] Folge 11 Streamtape                               ^|
Echo.                    ^|   [12] Folge 12 Streamtape                               ^|
Echo.                    ^|   [13] Folge 13 Streamtape                               ^|
Echo.                    ^|   [14] Folge 14 Streamtape                               ^|
Echo.                    ^|   [15] Folge 15 Streamtape                               ^|
Echo.                    ^|   [16] Folge 16 Streamtape                               ^|
Echo.                    ^|   [17] Folge 17 Streamtape                               ^|
Echo.                    ^|   [18] Folge 18 Streamtape                               ^|
Echo.                    ^|   [19] Folge 19 Streamtape                               ^|
Echo.                    ^|   [20] Folge 20 Streamtape                               ^|
Echo.                    ^|   [21] Folge 21 Streamtape                               ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/v2PrkOmQq7Hw7q
if '%wahl%' == '2' Start https://streamadblockplus.com/e/JoGeARwBAvcj4QG
if '%wahl%' == '3' Start https://streamadblockplus.com/e/X1bGZyKaL7FPg4
if '%wahl%' == '4' Start https://streamadblockplus.com/e/y7Bx1oeYD2u1Ldr
if '%wahl%' == '5' Start https://streamadblockplus.com/e/KzZDrO6woptblY
if '%wahl%' == '6' Start https://streamadblockplus.com/e/7X0bX0Y0L9HAkRy
if '%wahl%' == '7' Start https://streamadblockplus.com/e/LOYea1kOWDtRzBb
if '%wahl%' == '8' Start https://streamadblockplus.com/e/3PZWlyXGxjsdPYv
if '%wahl%' == '9' Start https://streamadblockplus.com/e/q380OWJx8vcAXY
if '%wahl%' == '10' Start https://streamadblockplus.com/e/drDOg2MVPMHZyG
if '%wahl%' == '11' Start https://streamadblockplus.com/e/ea22ZYg6zZtY068
if '%wahl%' == '12' Start https://streamadblockplus.com/e/j6xZqR8L9Dfzpa6
if '%wahl%' == '13' Start https://streamadblockplus.com/e/8JxXe6bxMquor1Q
if '%wahl%' == '14' Start https://streamadblockplus.com/e/ajg8jQv7B1u2bo
if '%wahl%' == '15' Start https://streamadblockplus.com/e/xq83ZWM4wBhkpRJ
if '%wahl%' == '16' Start https://streamadblockplus.com/e/z1ZV6bXZWlfYwRb
if '%wahl%' == '17' Start https://streamadblockplus.com/e/YK2QYq3r6Xsvv3L
if '%wahl%' == '18' Start https://streamadblockplus.com/e/eaB6q46z17CYzR0
if '%wahl%' == '19' Start https://streamadblockplus.com/e/Rq9ARlKyoRidwXY
if '%wahl%' == '20' Start https://streamadblockplus.com/e/Dlmj9pxqgpukypw
if '%wahl%' == '21' Start https://streamadblockplus.com/e/pkR2kAWDVVSlod
if '%wahl%' == '100' goto:bbP1
goto:ST5
 :ST6
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape                                 ^|
Echo.                    ^|   [2] Folge 2 Streamtape                                 ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 Streamtape                                 ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 Streamtape                                 ^|
Echo.                    ^|   [7] Folge 7 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 Streamtape                                 ^|
Echo.                    ^|   [10] Folge 10 Streamtape                               ^|
Echo.                    ^|   [11] Folge 11 Streamtape                               ^|
Echo.                    ^|   [12] Folge 12 Streamtape                               ^|
Echo.                    ^|   [13] Folge 13 Streamtape                               ^|
Echo.                    ^|   [14] Folge 14 Streamtape                               ^|
Echo.                    ^|   [15] Folge 15 Streamtape                               ^|
Echo.                    ^|   [16] Folge 16 Streamtape                               ^|
Echo.                    ^|   [17] Folge 17 Streamtape                               ^|
Echo.                    ^|   [18] Folge 18 Streamtape                               ^|
Echo.                    ^|   [19] Folge 19 Streamtape                               ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/1R7a238roqFrZz
if '%wahl%' == '2' Start https://streamadblockplus.com/e/YPX8a0X82xTvbvM
if '%wahl%' == '3' Start https://streamadblockplus.com/e/rx7KdX63XMub7xl
if '%wahl%' == '4' Start https://streamadblockplus.com/e/g9oKQwKj0xiqRlq
if '%wahl%' == '5' Start https://streamadblockplus.com/e/pYjMBKJrwduW0W
if '%wahl%' == '6' Start https://streamadblockplus.com/e/WZPZyvVoAbfbvx2
if '%wahl%' == '7' Start https://streamadblockplus.com/e/gR6Wmy3r1RS3ge
if '%wahl%' == '8' Start https://streamadblockplus.com/e/4wDz2ZG8k9FKaO1
if '%wahl%' == '9' Start https://streamadblockplus.com/e/dqpyyZzgRxckoyl
if '%wahl%' == '10' Start https://streamadblockplus.com/e/kvXxkLY6vVte7p
if '%wahl%' == '11' Start https://streamadblockplus.com/e/XBX2KAmgZViDyYo
if '%wahl%' == '12' Start https://streamadblockplus.com/e/XBX2KAmgZViDyYo
if '%wahl%' == '13' Start https://streamadblockplus.com/e/b2o8Y1kl2dio7V
if '%wahl%' == '14' Start https://streamadblockplus.com/e/G6v36XwemwFaWp
if '%wahl%' == '15' Start https://streamadblockplus.com/e/JJazz1YXGVujMPa
if '%wahl%' == '16' Start https://streamadblockplus.com/e/0LgyDqGyL1CboQj
if '%wahl%' == '17' Start https://streamadblockplus.com/e/1qpeDK8vMoUeRoR
if '%wahl%' == '18' Start https://streamadblockplus.com/e/jAb1alQyGouzeyK
if '%wahl%' == '19' Start https://streamadblockplus.com/e/O4xOQVgjJRHz4L
if '%wahl%' == '100' goto:bbP1
goto:ST6
 :ST7
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape                                 ^|
Echo.                    ^|   [2] Folge 2 Streamtape                                 ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 VOE                                        ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 Streamtape                                 ^|
Echo.                    ^|   [7] Folge 7 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 VOE                                        ^|
Echo.                    ^|   [10] Folge 10 Streamtape                               ^|
Echo.                    ^|   [11] Folge 11 Streamtape                               ^|
Echo.                    ^|   [12] Folge 12 Streamtape                               ^|
Echo.                    ^|   [13] Folge 13 Streamtape                               ^|
Echo.                    ^|   [14] Folge 14 Streamtape                               ^|
Echo.                    ^|   [15] Folge 15 Streamtape                               ^|
Echo.                    ^|   [16] Folge 16 Streamtape                               ^|
Echo.                    ^|   [17] Folge 17 Streamtape                               ^|
Echo.                    ^|   [18] Folge 18 Streamtape                               ^|
Echo.                    ^|   [19] Folge 19 Streamtape                               ^|
Echo.                    ^|   [20] Folge 20 Streamtape                               ^|
Echo.                    ^|   [21] Folge 21 Streamtape                               ^|
Echo.                    ^|   [22] Folge 22 Streamtape                               ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/JKPxOd9aRmi9K1
if '%wahl%' == '2' Start https://streamadblockplus.com/e/Mqk87Gj6xxsmKXY
if '%wahl%' == '3' Start https://streamadblockplus.com/e/6Q6rYdkO23H9AGg
if '%wahl%' == '4' Start https://voeunblock3.com/e/7sfzaduizq7v
if '%wahl%' == '5' Start https://streamadblockplus.com/e/mDdrPJwqD2fb8Lv
if '%wahl%' == '6' Start https://streamadblockplus.com/e/QKW2zaoqK6C016v
if '%wahl%' == '7' Start https://streamadblockplus.com/e/Qkz6w8lGL1iRex
if '%wahl%' == '8' Start https://streamadblockplus.com/e/j60xKxYb6ZSz1Rr
if '%wahl%' == '9' Start https://voeunblock3.com/e/9g62o6errdzt
if '%wahl%' == '10' Start https://streamadblockplus.com/e/KAyWJZjRgoF0kAg
if '%wahl%' == '11' Start https://streamadblockplus.com/e/XgKBdmWly2UD89R
if '%wahl%' == '12' Start https://streamadblockplus.com/e/kvb9dejjklT8q1
if '%wahl%' == '13' Start https://streamadblockplus.com/e/MY7XVL8dQAfmZMJ
if '%wahl%' == '14' Start https://streamadblockplus.com/e/qM4V97JOvAUzGXJ
if '%wahl%' == '15' Start https://streamadblockplus.com/e/vwPqoPa43oib4M
if '%wahl%' == '16' Start https://streamadblockplus.com/e/Xdyp8d0GB7UDvM7
if '%wahl%' == '17' Start https://streamadblockplus.com/e/zxZW4x8pzjCY60p
if '%wahl%' == '18' Start https://streamadblockplus.com/e/vrWa4OaxGRs4vow
if '%wahl%' == '19' Start https://streamadblockplus.com/e/P87kdPkZAyT0qvP
if '%wahl%' == '20' Start https://streamadblockplus.com/e/ro7g16QjdbIxmX
if '%wahl%' == '21' Start https://streamadblockplus.com/e/vprpwGl2lRc4Rqd
if '%wahl%' == '22' Start https://streamadblockplus.com/e/J3YMJjWPkjCjldr
if '%wahl%' == '100' goto:bbP1
goto:ST7
  :ST8
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Doodstream                                 ^|
Echo.                    ^|   [2] Folge 2 Streamtape                                 ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 Streamtape                                 ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 7 is included in Folge 6                     ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 Streamtape                                 ^|
Echo.                    ^|   [10] Folge 10 Streamtape                               ^|
Echo.                    ^|   [11] Folge 11 Streamtape                               ^|
Echo.                    ^|   [12] Folge 12 Streamtape                               ^|
Echo.                    ^|   [13] Folge 13 Streamtape                               ^|
Echo.                    ^|   [14] Folge 14 Streamtape                               ^|
Echo.                    ^|   [15] Folge 15 Streamtape                               ^|
Echo.                    ^|   [16] Folge 16 Streamtape                               ^|
Echo.                    ^|   [17] Folge 17 Streamtape                               ^|
Echo.                    ^|   [18] Folge 18 Streamtape                               ^|
Echo.                    ^|   [19] Folge 19 Streamtape                               ^|
Echo.                    ^|   [20] Folge 20 Streamtape                               ^|
Echo.                    ^|   [21] Folge 21 Streamtape                               ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://dood.pm/e/6dle5ea0rhrj
if '%wahl%' == '2' Start https://streamadblockplus.com/e/Bb6MPekBaquyBbO
if '%wahl%' == '3' Start https://streamadblockplus.com/e/29LyeDWwXAtZM81
if '%wahl%' == '4' Start https://streamadblockplus.com/e/LDM4wmdVx3fWPQ
if '%wahl%' == '5' Start https://streamadblockplus.com/e/g2y867vQrwtqROQ
if '%wahl%' == '6' Start https://streamadblockplus.com/e/ewzPyDlzOGt9yX
if '%wahl%' == '7' Start https://streamadblockplus.com/e/ewzPyDlzOGt9yX
if '%wahl%' == '8' Start https://streamadblockplus.com/e/bvpqZ7rxMrsPYmZ
if '%wahl%' == '9' Start https://streamadblockplus.com/e/mv08DKX3OeCbrk1
if '%wahl%' == '10' Start https://streamadblockplus.com/e/Q2eLL79o26f8Ak
if '%wahl%' == '11' Start https://streamadblockplus.com/e/LqR38bmqzzfRL9y
if '%wahl%' == '12' Start https://streamadblockplus.com/e/bq9A2JpQl2UK23
if '%wahl%' == '13' Start https://streamadblockplus.com/e/1pB3qKoLJOfezxq
if '%wahl%' == '14' Start https://streamadblockplus.com/e/9kzgXzZYZAiaQ94
if '%wahl%' == '15' Start https://streamadblockplus.com/e/9Rl9vL0AwVia2Ma
if '%wahl%' == '16' Start https://streamadblockplus.com/e/RBKWdz3XgBh06b
if '%wahl%' == '17' Start https://streamadblockplus.com/e/vY8M4AxppOUwxa
if '%wahl%' == '18' Start https://streamadblockplus.com/e/kgqgO2m1wgirYy
if '%wahl%' == '19' Start https://streamadblockplus.com/e/JJA6v7zvexSjwdW
if '%wahl%' == '20' Start https://streamadblockplus.com/e/904LGbp938caGPr
if '%wahl%' == '21' Start https://streamadblockplus.com/e/DXjgeKDDPbukOLZ
if '%wahl%' == '100' goto:bbP1
goto:ST8
 :ST9
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape                                 ^|
Echo.                    ^|   [2] Folge 2 VOE                                        ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 Streamtape                                 ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 Streamtape                                 ^|
Echo.                    ^|   [7] Folge 7 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 Streamtape                                 ^|
Echo.                    ^|   [10] Folge 10 Streamtape                               ^|
Echo.                    ^|   [11] Folge 11 Streamtape                               ^|
Echo.                    ^|   [12] Folge 12 Streamtape                               ^|
Echo.                    ^|   [13] Folge 13 Streamtape                               ^|
Echo.                    ^|   [14] Folge 14 Streamtape                               ^|
Echo.                    ^|   [15] Folge 15 Streamtape                               ^|
Echo.                    ^|   [16] Folge 16 Streamtape                               ^|
Echo.                    ^|   [17] Folge 17 Streamtape                               ^|
Echo.                    ^|   [18] Folge 18 Streamtape                               ^|
Echo.                    ^|   [19] Folge 19 Streamtape                               ^|
Echo.                    ^|   [20] Folge 20 Streamtape                               ^|
Echo.                    ^|   [21] Folge 21 Streamtape                               ^|
Echo.                    ^|   [22] Folge 22 Streamtape                               ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/aYA1xzdJ1QhxDxD
if '%wahl%' == '2' Start https://voeunblock3.com/e/zip2k4txdxnm
if '%wahl%' == '3' Start https://streamadblockplus.com/e/rd8Mw88qdOhbrQ8
if '%wahl%' == '4' Start https://streamadblockplus.com/e/BLmgvaQza1UyD8O
if '%wahl%' == '5' Start https://streamadblockplus.com/e/VdpyBRJVQGsKA8A
if '%wahl%' == '6' Start https://streamadblockplus.com/e/dqQpq4PlPAIkvel
if '%wahl%' == '7' Start https://streamadblockplus.com/e/DXGealvqeKIDvk
if '%wahl%' == '8' Start https://streamadblockplus.com/e/e09a3870MKiYy9o
if '%wahl%' == '9' Start https://streamadblockplus.com/e/lWoqy813Z9H7pDg
if '%wahl%' == '10' Start https://streamadblockplus.com/e/4xm4zb1ge1uKg9Z
if '%wahl%' == '11' Start https://streamadblockplus.com/e/M7XbrBvJk4Imjo1
if '%wahl%' == '12' Start https://streamadblockplus.com/e/4m3ePB98geTOO3
if '%wahl%' == '13' Start https://streamadblockplus.com/e/ol2VRODdX3fJl8w
if '%wahl%' == '14' Start https://streamadblockplus.com/e/rbLxemQwybubvKj
if '%wahl%' == '15' Start https://streamadblockplus.com/e/263694qG0OiZrpr
if '%wahl%' == '16' Start https://streamadblockplus.com/e/arWLvD7bYXuxqdD
if '%wahl%' == '17' Start https://streamadblockplus.com/e/Jqjy8drYkdc9lK
if '%wahl%' == '18' Start https://streamadblockplus.com/e/x9WbvDVeZwIk6d9
if '%wahl%' == '19' Start https://streamadblockplus.com/e/dr16Rx0VrwSkarj
if '%wahl%' == '20' Start https://streamadblockplus.com/e/6qMwQRl6ZDs9yPL
if '%wahl%' == '21' Start https://streamadblockplus.com/e/VB2JOxBgBPuKLWG
if '%wahl%' == '22' Start https://streamadblockplus.com/e/oDyQ9qKRyvTJwGl
if '%wahl%' == '100' goto:bbP1
goto:ST9
 :ST10
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape                                 ^|
Echo.                    ^|   [2] Folge 2 Streamtape                                 ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 Streamtape                                 ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 VOE                                        ^|
Echo.                    ^|   [7] Folge 7 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 VOE                                        ^|
Echo.                    ^|   [10] Folge 10 Streamtape                               ^|
Echo.                    ^|   [11] Folge 11 Streamtape                               ^|
Echo.                    ^|   [12] Folge 12 Streamtape                               ^|
Echo.                    ^|   [13] Folge 13 Streamtape                               ^|
Echo.                    ^|   [14] Folge 14 Streamtape                               ^|
Echo.                    ^|   [15] Folge 15 Streamtape                               ^|
Echo.                    ^|   [16] Folge 16 Streamtape                               ^|
Echo.                    ^|   [17] Folge 17 Streamtape                               ^|
Echo.                    ^|   [18] Folge 18 Streamtape                               ^|
Echo.                    ^|   [19] Folge 19 Streamtape                               ^|
Echo.                    ^|   [20] Folge 20 Streamtape                               ^|
Echo.                    ^|   [21] Folge 21 Streamtape                               ^|
Echo.                    ^|   [22] Folge 22 Streamtape                               ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/WZp7ePWV8Bhbaw3
if '%wahl%' == '2' Start https://streamadblockplus.com/e/ZVA7KopQ7rUKzG
if '%wahl%' == '3' Start https://streamadblockplus.com/e/RBM9J3JoxyskOx
if '%wahl%' == '4' Start https://streamadblockplus.com/e/bGV9364g0aSQGJ
if '%wahl%' == '5' Start https://streamadblockplus.com/e/r8m3pa2LapSbPrW
if '%wahl%' == '6' Start https://voeunblock3.com/e/n4k5lgbuqz3v
if '%wahl%' == '7' Start https://streamadblockplus.com/e/94mR4OrOp7UOrM
if '%wahl%' == '8' Start https://streamadblockplus.com/e/k90GJxjxlJhDp7
if '%wahl%' == '9' Start https://voeunblock3.com/e/vqfsl6kbr8io
if '%wahl%' == '10' Start https://streamadblockplus.com/e/kqdjPZj0ZefOgv0
if '%wahl%' == '11' Start https://streamadblockplus.com/e/DX7P93bl6ZtDJd
if '%wahl%' == '12' Start https://streamadblockplus.com/e/4D9RwG477bUK08d
if '%wahl%' == '13' Start https://streamadblockplus.com/e/zMQJ6OlP0RherX
if '%wahl%' == '14' Start https://streamadblockplus.com/e/jPbjyaggyQtz9eY
if '%wahl%' == '15' Start https://streamadblockplus.com/e/ZoKGVlzjBQuqXoo
if '%wahl%' == '16' Start https://streamadblockplus.com/e/bPZp17L9k4sPkm6
if '%wahl%' == '17' Start https://streamadblockplus.com/e/aqm9XLvRq8hxvxz
if '%wahl%' == '18' Start https://streamadblockplus.com/e/yrvKvKdOrgS1AqQ
if '%wahl%' == '19' Start https://streamadblockplus.com/e/oAm7D4MmJlCJoWL
if '%wahl%' == '20' Start https://streamadblockplus.com/e/41mW2q4PkZIKgkd
if '%wahl%' == '21' Start https://streamadblockplus.com/e/6kajLAM07et9BJK
if '%wahl%' == '22' Start https://streamadblockplus.com/e/29LqDbKDAAhZg3q
if '%wahl%' == '100' goto:bbP2
goto:ST10
 :ST11
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape                                 ^|
Echo.                    ^|   [2] Folge 2 Streamtape                                 ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 Streamtape                                 ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 Streamtape                                 ^|
Echo.                    ^|   [7] Folge 7 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 Streamtape                                 ^|
Echo.                    ^|   [10] Folge 10 Streamtape                               ^|
Echo.                    ^|   [11] Folge 11 Streamtape                               ^|
Echo.                    ^|   [12] Folge 12 Streamtape                               ^|
Echo.                    ^|   [13] Folge 13 Streamtape                               ^|
Echo.                    ^|   [14] Folge 14 Streamtape                               ^|
Echo.                    ^|   [15] Folge 15 Streamtape                               ^|
Echo.                    ^|   [16] Folge 16 Streamtape                               ^|
Echo.                    ^|   [17] Folge 17 Streamtape                               ^|
Echo.                    ^|   [18] Folge 18 Streamtape                               ^|
Echo.                    ^|   [19] Folge 19 Streamtape                               ^|
Echo.                    ^|   [20] Folge 20 Streamtape                               ^|
Echo.                    ^|   [21] Folge 21 Streamtape                               ^|
Echo.                    ^|   [22] Folge 22 Streamtape                               ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/7B6xVa9PRRtAKpv
if '%wahl%' == '2' Start https://streamadblockplus.com/e/wkP8VLPL6ZUJORz
if '%wahl%' == '3' Start https://streamadblockplus.com/e/0pLJyZLpjjFbrxV
if '%wahl%' == '4' Start https://streamadblockplus.com/e/jlvbeqM6orIzwMz
if '%wahl%' == '5' Start https://streamadblockplus.com/e/jpm2QDkKe2uzyml
if '%wahl%' == '6' Start https://streamadblockplus.com/e/mOWjVWo3eZcbm1k
if '%wahl%' == '7' Start https://streamadblockplus.com/e/V0vPL3Z9GwtY7D
if '%wahl%' == '8' Start https://streamadblockplus.com/e/X2DkM3Z3wqsDqZd
if '%wahl%' == '9' Start https://streamadblockplus.com/e/kZWj3JX6eysOGlj
if '%wahl%' == '10' Start https://streamadblockplus.com/e/dvJkxPWQmrckmBe
if '%wahl%' == '11' Start https://streamadblockplus.com/e/1RkRwXzwjjUJmA
if '%wahl%' == '12' Start https://streamadblockplus.com/e/1poK3BODa0HeKRj
if '%wahl%' == '13' Start https://streamadblockplus.com/e/j4Agj60ROkU2X4
if '%wahl%' == '14' Start https://streamadblockplus.com/e/MXrmK2PRYqimaqj
if '%wahl%' == '15' Start https://streamadblockplus.com/e/Ye3edP8BdXCv792
if '%wahl%' == '16' Start https://streamadblockplus.com/e/JYV1J9bdPrHj0WV
if '%wahl%' == '17' Start https://streamadblockplus.com/e/9eAXwkx706faKJL
if '%wahl%' == '18' Start https://streamadblockplus.com/e/m62rYGOX1MubPPW
if '%wahl%' == '19' Start https://streamadblockplus.com/e/aYpOVWl3DkixyaY
if '%wahl%' == '20' Start https://streamadblockplus.com/e/LQb4p02gjriRVdy
if '%wahl%' == '21' Start https://streamadblockplus.com/e/03O7K4rWK8Tbq71
if '%wahl%' == '22' Start https://streamadblockplus.com/e/3GbQXGgBp6TdYPb
if '%wahl%' == '100' goto:bbP2
goto:ST11
 :ST12
mode con cols=100 lines=30
echo.                     ___________________________________________________________
Echo.                    ^|                                                          ^|
Echo.                    ^|   [1] Folge 1 Streamtape                                 ^|
Echo.                    ^|   [2] Folge 2 Streamtape                                 ^|
Echo.                    ^|   [3] Folge 3 Streamtape                                 ^|
Echo.                    ^|   [4] Folge 4 Streamtape                                 ^|
Echo.                    ^|   [5] Folge 5 Streamtape                                 ^|
Echo.                    ^|   [6] Folge 6 Streamtape                                 ^|
Echo.                    ^|   [7] Folge 7 Streamtape                                 ^|
Echo.                    ^|   [8] Folge 8 Streamtape                                 ^|
Echo.                    ^|   [9] Folge 9 Streamtape                                 ^|
Echo.                    ^|   [10] Folge 10 Streamtape                               ^|
Echo.                    ^|   [11] Folge 11 Streamtape                               ^|
Echo.                    ^|   [12] Folge 12 Streamtape                               ^|
Echo.                    ^|   [13] Folge 13 Streamtape                               ^|
Echo.                    ^|   [14] Folge 14 Streamtape                               ^|
Echo.                    ^|   [15] Folge 15 Streamtape                               ^|
Echo.                    ^|   [16] Folge 16 Streamtape                               ^|
Echo.                    ^|   [17] Folge 17 Streamtape                               ^|
Echo.                    ^|   [18] Folge 18 Streamtape                               ^|
Echo.                    ^|   [19] Folge 19 Streamtape                               ^|
Echo.                    ^|   [20] Folge 20 Streamtape                               ^|
Echo.                    ^|   [21] Folge 21 Streamtape                               ^|
Echo.                    ^|   [22] Folge 22 Streamtape                               ^|
Echo.                    ^|                                                          ^|
Echo.                    ^|   [100] Return to Start menu                             ^|
Echo.                    ^|__________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://streamadblockplus.com/e/ZxXpLZBbldtqXkV
if '%wahl%' == '2' Start https://streamadblockplus.com/e/3wkvoAgxyVCdvvO
if '%wahl%' == '3' Start https://streamadblockplus.com/e/YewRMz8mZqcvP3w
if '%wahl%' == '4' Start https://streamadblockplus.com/e/zxQWYox046tYPwZ
if '%wahl%' == '5' Start https://streamadblockplus.com/e/7DrpqR1mkLhAd0W
if '%wahl%' == '6' Start https://streamadblockplus.com/e/1d1LRyJd20Ueowo
if '%wahl%' == '7' Start https://streamadblockplus.com/e/wD1zdoeJj4tJbP8
if '%wahl%' == '8' Start https://streamadblockplus.com/e/OdzXmyvKMoiZdbB
if '%wahl%' == '9' Start https://streamadblockplus.com/e/rAgq30JB6jFbp3R
if '%wahl%' == '10' Start https://streamadblockplus.com/e/r8qBOk1aK0Tbbzx
if '%wahl%' == '11' Start https://streamadblockplus.com/e/KkV2beQKrjT0eQX
if '%wahl%' == '12' Start https://streamadblockplus.com/e/BG0p9bXQdOuyDmK
if '%wahl%' == '13' Start https://streamadblockplus.com/e/wYOW3oVZqvUJwWa
if '%wahl%' == '14' Start https://streamadblockplus.com/e/PyVB4PYzYRh0vo9
if '%wahl%' == '15' Start https://streamadblockplus.com/e/M6w81eoorrC13y
if '%wahl%' == '16' Start https://streamadblockplus.com/e/VaVAq1bb6pIKDwv
if '%wahl%' == '17' Start https://streamadblockplus.com/e/rd6OJxY0A9faOk
if '%wahl%' == '18' Start https://streamadblockplus.com/e/LqLYkvzxmkCaYG
if '%wahl%' == '19' Start https://streamadblockplus.com/e/8zelPq03wXFooow
if '%wahl%' == '20' Start https://streamadblockplus.com/e/K0Q4oJxg7BS00dX
if '%wahl%' == '21' Start https://streamadblockplus.com/e/DPjeKkYM4oSDaA
if '%wahl%' == '22' Start https://streamadblockplus.com/e/2rPKO0VVPGhZMxg
if '%wahl%' == '100' goto:bbP2
goto:ST12
 :otherbb
mode con cols=98 lines=30
echo.                     __________________________________________________________________________
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [1] S.to Websites to watch other Movies and Series                    ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [2] Download my Script for more Stuff                                 ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [3] About Bobs Burgers [German]                                       ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [100] return to Start Menu                                            ^|
Echo.                    ^|_________________________________________________________________________^|
SET /p wahl=
if '%wahl%' == '2' Start https://github.com/RCG10Lite/Windows-Activation-Tool/releases
if '%wahl%' == '1' goto:WTW
if '%wahl%' == '3' goto:abbbg
if '%wahl%' == '100' goto:bbP1
goto:otherbb
:abbbg
mode con cols=98 lines=30
echo.   
echo.                                          Bobs Burgers (2011-Heute)
echo.  
echo.                    __________________________________________________________________________
Echo.                    ^|                                                                         ^|
Echo.                    ^|   In einem heruntergekommenen Stadtteil betreiben Bob und seine Familie ^|
Echo.                    ^|   ein kleines Burgerrestaurtant. Auch wenn die Geschaefte derzeit       ^|
Echo.                    ^|   ziemlich mies laufen ist Bob ueberzeugt davon, mit seinen Burgern     ^|
Echo.                    ^|   irgendwann einmal den ganz großen Erfolg zu erzielen.                ^|
Echo.                    ^|   Doch vorher machen ihm seine Frau und Kinder das Leben Schwer.        ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   Regisseure/innen:                                                     ^|
Echo.                    ^|  Bernard DerrimanTyree DillihayChris SongTony GennaroJennifer CoyleBrian^|
Echo.                    ^|  LoSchiavoBoo Hwan LimKyoung  Hee LimDon MacKinnonIan HamiltonAnthony   ^|
Echo.                    ^|  ChunWesley ArcherMauricio PardoRyan MattosKevin WottonJohn RiceCecilia ^|
Echo.                    ^|  Aranovich  Damon WongMario Anna Jr.Matthew LongTom Riggin              ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|  Schauspieler/innen:                                                    ^|
Echo.                    ^|  Dan MintzEugene MirmanH. Jon BenjaminJohn RobertsKristen SchaalLarry   ^|
Echo.                    ^|  MurphyDavid HermanBobby TisdaleAndy KindlerSarah SilvermanJenny        ^|
Echo.                    ^|  SlateLaura SilvermanJay JohnstonBrian HuskeyKevin KlineSam SederMelissa^|
Echo.                    ^|  Bardin GalskyBrooke DillmanMegan MullallyTim MeadowsPamela AdlonAziz   ^|
Echo.                    ^|  AnsariRon Lynch                                                        ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   Produzenten/innen:                                                    ^|
Echo.                    ^|   Loren BouchardJim DauteriveNora SmithDelna BhesaniaRalph Guggenheim   ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   Land: USA, Alter: 12, Genre: Zeichentrick                             ^|
Echo.                    ^|_________________________________________________________________________^|
pause >nul
goto:otherbb

 :WTW
mode con cols=98 lines=30
echo.                     __________________________________________________________________________
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [1] S.to [Main]                                                       ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [2] 190.115.18.20 [Second]                                            ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [3] serien.cam [Slow]                                                 ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [4] SerienStream.to [Slowest]                                         ^|
Echo.                    ^|                                                                         ^|
Echo.                    ^|   [5] Return to Start                                                   ^|
Echo.                    ^|_________________________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://s.to
if '%wahl%' == '2' Start https://190.115.18.20
if '%wahl%' == '3' Start https://serien.cam
if '%wahl%' == '4' Start https://SerienStream.to
if '%wahl%' == '5' goto:bbP1
goto:WTW

:streamserver
mode con cols=98 lines=30
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   Sites to Strean:                                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   Anime: (aniworld.to)                                  ^|
Echo.                    ^|   aniworld.to,anicloud.io                               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   Movies and Series: (s.to)                             ^|
Echo.                    ^|   s.to,190.115.18.20,SerienStream.tom,serien.cam        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
ECHO.
SET /p wahl=
if '%wahl%' == '1' goto:Start
goto:streams

:Tools
mode con cols=98 lines=30
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Download 7-Zip                                    ^|               
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Download WinRAR                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Download Winaero Tweaker                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Joy to Key (a tool that converts your controller  ^|
Echo.                    ^|        input into keyboard input)                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Download Unlocker (Chip direct download)          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] KMS Tool download                                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] GTA Connect (GTA III-GTA IV Online Server)        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Virus scan with Command Prompt (sfc and DISM)     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://7-zip.org/download.html
if '%wahl%' == '2' goto:winrar
if '%wahl%' == '3' Start "" https://winaero.com/downloads/winaerotweaker.zip
if '%wahl%' == '4' Start https://joytokey.net/download/JoyToKeySetup_en.exe
if '%wahl%' == '5' Start "" https://securedl.cdn.chip.de/downloads/2159922/unlocker1.9.0-portable.zip?cid=54407951&platform=chip&1653156027-1653163527-24e5e3-B-ba595e5347eaffe4ed6a099ae2e182cf
if '%wahl%' == '6' goto:KMSdown
if '%wahl%' == '7' goto:GTAC
if '%wahl%' == '8' goto:vsc
if '%wahl%' == '9' goto:Start
goto:Tools

:vsc
mode con cols=98 lines=30
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|  [1] sfc /scannow (usually do not work with modded-     ^|
Echo.                    ^|      -Windows versions)                                 ^|               
Echo.                    ^|                                                         ^|
Echo.                    ^|  [2] DISM /Online /Cleanup Image                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|  [3] Return to Tools Menu                               ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' sfc /scannow
if '%wahl%' == '2' goto:DISM
if '%wahl%' == '3' goto:Tools
goto:vsc

 :DISM
Dism /Online /Cleanup-Image /ScanHealth
Dism /Online /Cleanup-Image /CheckHealth
Dism /Online /Cleanup-Image /RestoreHealth
echo.
echo Finished!!!
echo. 
echo Press any key to return to Tools Menu
pause >nul
goto:Tools


:GTAC
Start https://gtaconnected.com/downloads/GTAC-1.4.1.zip
mode con cols=98 lines=30
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|  After download select Tools and click on Game settings ^|               
Echo.                    ^|  there you select the game and where the games location ^|
Echo.                    ^|  is after that click ok, then click on tools and select ^|
Echo.                    ^|  Launcher Settings and type your name                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|  (you must own the games in order to play them online)  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|  These games are supported by GTA Connect :             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|  -GTA III                                               ^|
Echo.                    ^|  -GTA Vice City                                         ^|
Echo.                    ^|  -GTA San Andreas                                       ^|
Echo.                    ^|  -GTA IV                                                ^|
Echo.                    ^|  -GTA Stories from Libertie City                        ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo Press any Key to Return to Tools Menu
pause >nul
goto:Tools

 :KMSdown
Start https://dl.malwarewatch.org/windows/activation/KMSTools.zip
mode con cols=98 lines=30
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   Password is:                                          ^|               
Echo.                    ^|                                                         ^|
Echo.                    ^|   mysubsarethebest                                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|  (Only run KMStool.exe the other files you can Delete)  ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo Press any Key to return to the Tools Menu
pause >nul
goto:Tools

 :winrar
mode con cols=98 lines=30
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Download WinRAR New Demo (Official Website)       ^|               
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Download WinRAR New pre-activated (Media Fire)    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Download Old WinRAR pre-activated (Media Fire)    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Return to Software Menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start "" https://winrar.de/downld.php
if '%wahl%' == '3' goto:winrardownmtuto
if '%wahl%' == '2' Start "" https://www.mediafire.com/file/yjkikdj5n3hi7te/WinRAR+(New,Pre-activated).zip/file
if '%wahl%' == '4' goto:Software
goto:winrar

 :winrardownmtuto
Start "" https://www.mediafire.com/file/uxosbpmbx97agft/WinRAR+pre-activated.zip/file
mode con cols=98 lines=30
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   Extract the Folder and launch WinRAR.exe              ^|               
Echo.                    ^|   a menu promt where you set a checkamrk at that        ^|
Echo.                    ^|   Datatypes you want to open with winrar then           ^|
echo.                    ^|   drag the Extracted Folder to C:\Program Files         ^|
echo.                    ^|   and rename the Folder to WinRAR.                      ^|
echo.                    ^|   Then Right click on a .zip file and select properties ^|
echo.                    ^|   then on opens with "click change", then a window pops ^|
echo.                    ^|   up, on this Window you click "more apps", then scroll ^|
echo.                    ^|   down and click "look for another app on this pc"      ^|
echo.                    ^|   then you select this File                             ^|
echo.                    ^|                                                         ^|
echo.                    ^|   C:\Program Files\WinRAR\WinRAR.exe                    ^|
echo.                    ^|                                                         ^|
echo.                    ^|   And Finished                                          ^|
echo.                    ^|                                                         ^|
echo.                    ^|   [1] Return to Tools Menu                              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Tools
goto:winrardownmtuto

 :Preacread
mode con cols=98 lines=30
echo ===============================================================================================
echo  # Windows 10 Preactivate:                                                                     
echo.                                                                                              
echo  - To preactivate the system during installation,Do the following things.                      
echo   extract the $OEM$ Folder to Desktop. Now copy this $OEM$     
echo    Folder to "sources" folder in the installation media.                                       
echo    The directory will appear like this. iso/usb: \sources\$OEM$\                               
echo    Now use this iso/usb to install Windows 10 and it'll auto activate at first online contact. 
echo  ===============================================================================================
echo [1] to Return to Start [2] for ReadMe
SET /p wahl=
if '%wahl%' == '1' goto:Start
if '%wahl%' == '2' goto:ReadMe
goto:Preacred

::===========================================================================
 :Office
::===========================================================================
mode con cols=98 lines=30
echo.
echo.
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   Welcome to office section what do you want to do?     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [1] Activate your Office                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [2] Download Heidoc for Office Isos                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|    [3] Return to Software Menu                          ^|
Echo.                    ^|_________________________________________________________^|
ECHO.
echo.
echo.                       Enter a menu option in the Keyboard [1,2,3] :
SET /p wahl=
if '%wahl%' == '1' goto:Officeact
if '%wahl%' == '2' goto:Heidocinstf
if '%wahl%' == '3' goto:Software
goto:Office
::===========================================================================

 :Officeact
mode con cols=98 lines=30
::===========================================================================
echo.
echo.
echo.      
echo.                      Only Works if you have the Office Version!!!
echo. 
echo.                      you can get the Office Versions from Heidoc
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   What for an Office Version you want to Activate?      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Office 2013                                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Office 2016                                       ^|
Echo.                    ^|                                                         ^|
echo.                    ^|   [3] Office 2019                                       ^|
Echo.                    ^|                                                         ^|
echo                     ^|   [4] Office 2021                                       ^|
echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Office 365                                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Return to Start Menu                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|_________________________________________________________^|
ECHO.
echo.
echo.                       Enter a menu option in the Keyboard [1,2,3,4,5,6,7] :
echo.
::===========================================================================
SET /p wahl=
if '%wahl%' == '1' goto:OF2013
if '%wahl%' == '2' goto:OF2016
if '%wahl%' == '3' goto:OF2019
if '%wahl%' == '4' goto:OF2021
if '%wahl%' == '5' goto:OF365
if '%wahl%' == '6' goto:Start
goto:Officeact

:OF365
color 1F
title Activate Office 365 ProPlus for FREE - RCG10lite___&cls&echo =====================================================================================&echo #Project: Activating Microsoft software products for FREE without additional software&echo =====================================================================================&echo.&echo #Supported products: Office 365 ProPlus (x86-x64)&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16")&(for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&(for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&echo.&echo ============================================================================&echo Activating your Office...&cscript //nologo slmgr.vbs /ckms >nul&cscript //nologo ospp.vbs /setprt:1688 >nul&cscript //nologo ospp.vbs /unpkey:WFG99 >nul&cscript //nologo ospp.vbs /unpkey:DRTFM >nul&cscript //nologo ospp.vbs /unpkey:BTDRB >nul&set i=1&cscript //nologo ospp.vbs /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99 >nul||cscript //nologo ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP >nul||goto notsupported
:skms
if %i% GTR 10 goto busy
if %i% EQU 1 set KMS=kms7.MSGuides.com
if %i% EQU 2 set KMS=s8.uk.to
if %i% EQU 3 set KMS=s9.us.to
if %i% GTR 3 goto ato
cscript //nologo ospp.vbs /sethst:%KMS% >nul
:ato
:notsupported
echo ============================================================================&echo.&echo Sorry, your version is not supported.&echo.&goto halt
:busy
echo ============================================================================&echo.&echo Sorry, the server is busy and can't respond to your request. Please try again.&echo.
:halt
pause
goto:Officeact

 :OF2021
color 1F
title Activate Microsoft Office 2021 (by RCG10)&cls&echo =====================================================================================&echo #Project: Activating Microsoft software products for FREE without additional software&echo =====================================================================================&echo.&echo #Supported products:&echo - Microsoft Office Standard 2021&echo - Microsoft Office Professional Plus 2021&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16")&(for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2021VL_KMS*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&echo.&echo =====================================================================================&echo Activating your product...&cscript //nologo slmgr.vbs /ckms >nul&cscript //nologo ospp.vbs /setprt:1688 >nul&cscript //nologo ospp.vbs /unpkey:6F7TH >nul&set i=1&cscript //nologo ospp.vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH >nul||goto notsupported
:skms
if %i% GTR 10 goto busy
if %i% EQU 1 set KMS=kms7.MSGuides.com
if %i% EQU 2 set KMS=s8.uk.to
if %i% EQU 3 set KMS=s9.us.to
if %i% GTR 3 goto ato
cscript //nologo ospp.vbs /sethst:%KMS% >nul
:ato
echo =====================================================================================&echo.&echo.&cscript //nologo ospp.vbs /act | find /i "successful" && &choice /n /c YN /m "Would you like to visit my Website [Y,N]?" & if errorlevel 2 goto:Start) || (echo The connection to my KMS server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto skms)
explorer "http://rcg10.webador.de"&goto halt
:notsupported
echo =====================================================================================&echo.&echo Sorry, your version is not supported.&echo.&goto halt
:busy
echo =====================================================================================&echo.&echo Sorry, the server is busy and can't respond to your request. Please try again.&echo.
:halt
pause
goto:Officeact

:OF2019
color 1F
title Activate Microsoft Office 2019 (by RCG10)!&cls&echo ============================================================================&echo #Project: Activating Microsoft software products for FREE without software&echo ============================================================================&echo.&echo #Supported products:&echo - Microsoft Office Standard 2019&echo - Microsoft Office Professional Plus 2019&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16")&(for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&(for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&echo.&echo ============================================================================&echo Activating your Office...&cscript //nologo ospp.vbs /unpkey:6MWKP >nul&cscript //nologo ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP >nul&set i=1
:server
if %i%==1 set KMS_Sev=kms7.MSGuides.com
if %i%==2 set KMS_Sev=kms8.MSGuides.com
if %i%==3 set KMS_Sev=kms9.MSGuides.com
if %i%==4 goto notsupported
cscript //nologo ospp.vbs /sethst:%KMS_Sev% >nul&echo ============================================================================&echo.&echo.
cscript //nologo ospp.vbs /act | find /i "successful" && (echo.&echo ============================================================================&choice /n /c YN /m "Would you like to visit my Website [Y,N]?" & if errorlevel 2 goto:Start) || (echo The connection to my KMS server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto server)
explorer "rhttps://rcg10.webador.de"&goto halt
:notsupported
echo.&echo ============================================================================&echo Sorry! Your version is not supported
:halt
pause
goto:Officeact

:OF2016
color 1F
title Activate Microsoft Office 2016 by RCG10 &cls&echo ============================================================================&echo #Project: Activating Microsoft software products for FREE without software&echo ============================================================================&echo.&echo #Supported products:&echo - Microsoft Office Standard 2016&echo - Microsoft Office Professional Plus 2016&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16")&(for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&(for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&echo.&echo ============================================================================&echo Activating your Office...&cscript //nologo ospp.vbs /unpkey:WFG99 >nul&cscript //nologo ospp.vbs /unpkey:DRTFM >nul&cscript //nologo ospp.vbs /unpkey:BTDRB >nul&cscript //nologo ospp.vbs /unpkey:CPQVG >nul&cscript //nologo ospp.vbs /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99 >nul&set i=1
:server
if %i%==1 set KMS_Sev=kms7.MSGuides.com
if %i%==2 set KMS_Sev=kms8.MSGuides.com
if %i%==3 set KMS_Sev=kms9.MSGuides.com
if %i%==4 goto notsupported
cscript //nologo ospp.vbs /sethst:%KMS_Sev% 
cscript //nologo ospp.vbs /act | find /i "successful" && (echo.&echo ============================================================================&choice /n /c YN /m "Would you like to visit my Website [Y,N]?" & if errorlevel 2 goto:Start) || (echo The connection to my KMS server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto server)
explorer "http://rcg10.webador.de"&goto halt
:notsupported
echo Sorry! Your version is not supported
:halt
pause
goto:Officeact

:OF2013
mode con cols=98 lines=30
title Activate Microsoft Office 2013 by rcg10&cls&echo ===========================================================================&echo #Project: Activating Microsoft software products for FREE without software&echo ============================================================================&echo.&echo #Supported products:&echo - Microsoft Office 2013 Standard Volume&echo - Microsoft Office 2013 Professional Plus Volume&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office15\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office15")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office15\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office15")&echo.&echo ============================================================================&echo Activating your Office...&cscript //nologo ospp.vbs /unpkey:92CD4 >nul&cscript //nologo ospp.vbs /unpkey:GVGXT >nul&cscript //nologo ospp.vbs /inpkey:KBKQT-2NMXY-JJWGP-M62JB-92CD4 >nul&cscript //nologo ospp.vbs /inpkey:YC7DK-G2NP3-2QQC3-J6H88-GVGXT >nul&set i=1
:server
if %i%==1 set KMS_Sev=kms7.MSGuides.com
if %i%==2 set KMS_Sev=kms8.MSGuides.com
if %i%==3 set KMS_Sev=kms9.MSGuides.com
if %i%==4 goto notsupported
cscript //nologo ospp.vbs /sethst:%KMS_Sev% >nul
cscript //nologo ospp.vbs /act | find /i "successful" && (echo.&echo ============================================================================&choice /n /c YN /m "Would you like to visit my Website [Y,N]?" & if errorlevel 2 goto:Officeact) || (echo The connection to my server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto server)
explorer "http://rcg10.webador.de"&goto halt
:notsupported
echo Sorry! Your version is not supported
:halt
pause
goto:Officeact

 :ReadMe2
mode con cols=98 lines=30
echo. ===============================================================================================
echo # Remarks:                                                                                    
echo.                                                                                               
echo - This script does not install any files in your system.                                      
echo.                                                                                              
echo - For Successful Instant Activation,The Windows Update Service and Internet Must be Enabled.  
echo   If you are running it anyway then system will auto-activate later when you enable the       
echo   Windows update service and Internet.                                                                                                                                             
echo - Use of VPN, and privacy, anti spy tools, privacy-based hosts and firewall's rules           
echo   may cause (due to blocking of some MS servers) problems in successful Activation.                                                                                                  
echo - You may see an Error about 'Blocked key' or other errors in activation process. 
echo   Note that reasons behind these errors are either above mentioned reasons or corrupt 
echo   system files or rarely MS server problem.   
echo   'Blocked key' error appears because system couldn't contact MS servers for activation,  
echo   This script activation process actually doesn't use any Blocked Keys.
echo. ===============================================================================================
echo # Windows 10 Preactivate:                                                                     
echo.                                                                                               
echo - To preactivate the system during installation,Do the following things.                      
echo   Use option No. 6 in script and extract the $OEM$ Folder to Desktop. Now copy this $OEM$     
echo   Folder to "sources" folder in the installation media.                                       
echo   The directory will appear like this. iso/usb: \sources\$OEM$\                               
echo   Now use this iso/usb to install Windows 10 and it'll auto activate at first online contact. 
echo.  ===============================================================================================
echo [1] Back to Start Menu [2] Page 2
SET /p wahl=
if '%wahl%' == '1' goto:Start
if '%wahl%' == '2' goto:ReadMe2p2
goto:ReadMe2

 :ReadMe2p2
mode con cols=98 lines=30
echo.  # Fix Tip:
echo.   If you having activation errors, try to rebuild licensing Tokens.dat as suggested:
echo.   https://support.microsoft.com/en-us/help/2736303
echo.   launch command prompt as admin and execute these commands respectively:
echo.   net stop sppsvc
echo.   ren %windir%\System32\spp\store\2.0\tokens.dat tokens.bar
echo.   net start sppsvc
echo.   cscript %windir%\system32\slmgr.vbs /rilc
echo.   then restart the system twice,																						   
echo.  ===============================================================================================
echo. # Supported Windows 10 Editions:                                                                                                                                                           
echo. Core (Home) and (N)                                                                           
echo. CoreSingleLanguage and (N)                                                                    
echo. Professional and (N)                                                                          
echo. ProfessionalEducation and (N)                                                                 
echo. ProfessionalWorkstation and (N)                                                               
echo. Education and (N)                                                                             
echo. Enterprise and (N)                                                                            
echo. EnterpriseS (LTSB) 2016 and (N)                                                                                                                                                            
echo. (This activator does not support Windows 10 1507 version)                                                                                                                                   
echo. ===============================================================================================
echo [1] Back to Page 1 [2] go to About Script [3] Return to Start Menu
SET /p wahl=
if '%wahl%' == '3' goto:Start
if '%wahl%' == '2' goto:ReadMe
if '%wahl%' == '1' goto:ReadMe2
goto:ReadMe2p2

 :EdiChange10/11
mode con cols=98 lines=30
echo ==================================
echo Change your Windows 10/11 to 
echo ==================================
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Pro Edition Upgrade                               ^|               
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Pro for Workstation Edition Upgrade               ^|  
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Enterprise Edition Upgrade                        ^|
echo.                    ^|                                                         ^| 
Echo.                    ^|   [4] Education Edition Upgrade                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Pro Education Edition Upgrade                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
ECHO.
echo.
echo.                           Enter your Choice [1,2,3,4,5,6] :


SET /p wahl=
if '%wahl%' == '1' goto:Pro
if '%wahl%' == '2' goto:Profw
if '%wahl%' == '3' goto:Enterprise
if '%wahl%' == '4' goto:Edu
if '%wahl%' == '5' goto:Edupro
if '%wahl%' == '6' goto:Start
goto:EdiChange10/11

:key
rem              Edition                          Key              SKU EditionId
(
echo Cloud                          V3WVW-N2PV2-CGWC3-34QGF-VMJ2C 178 X21-32983
echo CloudN                         NH9J3-68WK7-6FB93-4K3DF-DJ4F6 179 X21-32987
echo Core                           YTMG3-N6DKC-DKB77-7M9GH-8HVX7 101 X19-98868
echo CoreCountrySpecific            N2434-X9D7W-8PF6X-8DV9T-8TYMD  99 X19-99652
echo CoreN                          4CPRK-NM3K3-X6XXQ-RXX86-WXCHW  98 X19-98877
echo CoreSingleLanguage             BT79Q-G7N6G-PGBYW-4YWX6-6F4BT 100 X19-99661
echo Education                      YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY 121 X19-98886
echo EducationN                     84NGF-MHBT6-FXBX8-QWJK7-DRR8H 122 X19-98892
echo Enterprise                     XGVPP-NMH47-7TTHJ-W3FW7-8HV2C   4 X19-99683
echo EnterpriseN                    3V6Q6-NQXCX-V8YXR-9QCYV-QPFCT  27 X19-98746
echo EnterpriseS                    NK96Y-D9CD8-W44CQ-R8YTK-DYJWX 125 X21-05035
echo EnterpriseSN                   2DBW3-N2PJG-MVHW3-G7TDK-9HKR4 126 X21-04921
echo Professional                   VK7JG-NPHTM-C97JM-9MPGT-3V66T  48 X19-98841
echo ProfessionalEducation          8PTT6-RNW4C-6V7J2-C2D3X-MHBPB 164 X21-04955
echo ProfessionalEducationN         GJTYN-HDMQY-FRR76-HVGC7-QPF8P 165 X21-04956
echo ProfessionalN                  2B87N-8KFHP-DKV6R-Y2C8J-PKCKT  49 X19-98859
echo ProfessionalWorkstation        DXG7C-N36C4-C4HTG-X4T3X-2YV77 161 X21-43626
echo ProfessionalWorkstationN       WYPNQ-8C467-V2W6J-TX4WX-WT2RQ 162 X21-43644
echo ServerRdsh                     NJCF7-PW8QT-3324D-688JX-2YV66 175 X21-41295
) > "%temp%\editions" &exit /b

 :Pro

slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX

slmgr /skms kms8.msguides.com

slmgr /ipk VK7JG-NPHTM-C97JM-9MPGT-3V66T

slmgr /ato

echo If error message popup its not worked, maybe try Method 2? (Y/N)
SET /p wahl=
if '%wahl%' == 'Y' goto:Prot2
if '%wahl%' == 'y' goto:Prot2
if '%wahl%' == 'N' goto:EdiChange10/11
if '%wahl%' == 'n' goto:EdiChange10/11


 :Prot2

Dism /Online /Get-TargetEditions

sc config LicenseManager start= auto & net start LicenseManager

sc config wuauserv start= auto & net start wuauserv

changepk.exe /productkey VK7JG-NPHTM-C97JM-9MPGT-3V66T

echo Activate Pro Editon with [1] Digital License [2] Volume Key

SET /p wahl=
if '%wahl%' == '2' goto:Csl
if '%wahl%' == '1' goto:HWIDActivate
 goto:Start

 :Profw

slmgr /ipk DXG7C-N36C4-C4HTG-X4T3X-2YV77

slmgr /skms kms8.msguides.com

slmgr /ipk DXG7C-N36C4-C4HTG-X4T3X-2YV77

slmgr /ato

echo If error message popup its not worked, maybe try Method 2? (Y/N)
SET /p wahl=
if '%wahl%' == 'Y' goto:Profwt2
if '%wahl%' == 'y' goto:Profwt2
if '%wahl%' == 'n' goto:EdiChange10/11
if '%wahl%' == 'N' goto:EdiChange10/11

 :Profwt2

Dism /Online /Get-TargetEditions

sc config LicenseManager start= auto & net start LicenseManager

sc config wuauserv start= auto & net start wuauserv

changepk.exe /productkey NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J

echo Activate Professional Workstation Editon with [1] Digital License [2] Volume Key

SET /p wahl=
if '%wahl%' == '2' goto:Csl
if '%wahl%' == '1' goto:HWIDActivate
 goto:Start

 :Enterprise

slmgr /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43

slmgr /skms kms8.msguides.com

slmgr /ipk XGVPP-NMH47-7TTHJ-W3FW7-8HV2C

slmgr /ato

echo If error message popup its not worked, maybe try Method 2? (Y/N)
SET /p wahl=
if '%wahl%' == 'Y' goto:Enterpriset2
if '%wahl%' == 'y' goto:Enterpriset2
if '%wahl%' == 'N' goto:EdiChange10/11
if '%wahl%' == 'n' goto:EdiChange10/11

 :Enterpriset2

Dism /Online /Get-TargetEditions

sc config LicenseManager start= auto & net start LicenseManager

sc config wuauserv start= auto & net start wuauserv

changepk.exe /productkey NPPR9-FWDCX-D2C8J-H872K-2YT43

echo Activate Enterprise Editon with [1] Digital License [2] Volume Key

SET /p wahl=
if '%wahl%' == '2' goto:Csl
if '%wahl%' == '1' goto:HWIDActivate
 goto:Start
 
:Edu


slmgr /ipk YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY

slmgr /skms kms8.msguides.com

slmgr /ipk YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY

slmgr /ato

echo If error message popup its not worked, maybe try Method 2? (Y/N)
SET /p wahl=
if '%wahl%' == 'Y' goto:Edut2
if '%wahl%' == 'y' goto:Edut2
if '%wahl%' == 'N' goto:EdiChange10/11
if '%wahl%' == 'n' goto:EdiChange10/11

:Edut2


Dism /Online /Get-TargetEditions

sc config LicenseManager start= auto & net start LicenseManager

sc config wuauserv start= auto & net start wuauserv

changepk.exe /productkey YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY

echo Activate Education Editon with [1] Digital License [2] Volume Key

SET /p wahl=
if '%wahl%' == '2' goto:Csl
if '%wahl%' == '1' goto:HWIDActivate
 goto:Start

 :Edupro

slmgr /ipk 8PTT6-RNW4C-6V7J2-C2D3X-MHBPB

slmgr /skms kms8.msguides.com

slmgr /ipk 8PTT6-RNW4C-6V7J2-C2D3X-MHBPB

slmgr /ato

echo If error message popup its not worked, maybe try Method 2? (Y/N)
echo (Y/N)
SET /p wahl=
if '%wahl%' == 'Y' goto:Eduprot2
if '%wahl%' == 'y' goto:Eduprot2
if '%wahl%' == 'N' goto:EdiChange10/11
if '%wahl%' == 'n' goto:EdiChange10/11

:Eduprot2

Dism /Online /Get-TargetEditions

sc config LicenseManager start= auto & net start LicenseManager

sc config wuauserv start= auto & net start wuauserv

changepk.exe /productkey YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY

echo Activate Education Pro Editon with [1] Digital License [2] Volume Key

SET /p wahl=
if '%wahl%' == '2' goto:Csl
if '%wahl%' == '1' goto:HWIDActivate
 goto:Start

 :LatestV
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] GitHub link (all versions)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Website (Redirect to Github)                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return Start Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Githubnew
if '%wahl%' == '2' goto:WebadorNew
if '%wahl%' == '3' goto:Start
 :LatestV
goto:LatestV

:Githubnew
START "" https://github.com/RCG10Lite/Windows-Activation-Tool/releases
goto:Start

:WebadorNew
START "" https://rcg10.webador.de/wam-latest 
 goto:Start

 :Githubnew
START "" https://github.com/RCG10Lite/Windows-Activation-Tool/releases
goto:Start

 :Heidocinstf
 START "" https://securedl.cdn.chip.de/downloads/46912125/Windows-ISO-Downloader_8_46.exe?cid=95133733&platform=chip&1653591332-1653598832-ba2aeb-B-35dc6fc8a5b4f04ab235d56257c0c884.exe
goto:Office

:======================================================================================================================================================
:Close
cls
echo.
echo.
echo.
echo.                        ===========================================
echo.                                                                   
echo.                                    Created by @RCG10
echo.                                                                    
echo.                        ===========================================
echo.
echo.
echo Press any key to Exit.
pause > nul
exit
echo HEHEHEHA
:======================================================================================================================================================