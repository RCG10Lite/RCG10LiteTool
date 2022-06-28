@echo off
@setlocal DisableDelayedExpansion
title Start with Admin Rights Required to Select Option [1]
color 1F

echo at least give credits if you steal >nul
echo some of this code "[RCG10]" >nul

 :adminqu
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Start with admin Rights (Recommended)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Start without Admin Rights (many tools wont Work) ^|
Echo.                    ^|_________________________________________________________^|
echo.
SET /p wahl=
if '%wahl%' == '1' goto:adminatstart
if '%wahl%' == '2' goto:Start
goto:adminqu
 :Adminatstart
mode con cols=98 lines=30
fsutil dirty query %systemdrive%  >nul 2>&1 || (
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|                    ==== ERROR ====                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   You startet the Script without Admin Rights.          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   Please select Start without Admin Rights to Start     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|                      The Script                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   Press any key to select Script Start                  ^|
Echo.                    ^|_________________________________________________________^|
pause >nul
goto:adminqu
)

:Start
title RCG10Lite Tool (Realese V1.3.1 by @rcg10)
mode con cols=98 lines=30                     
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Windows Menu                                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Software                                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Games                                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Read Me                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Check for Newer Versions of This Script?          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Exit Script                                       ^|
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
if '%wahl%' == '4' goto:MainReadme
if '%wahl%' == '5' goto:LatestV
if '%wahl%' == '6' goto:Close
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
Echo.                    ^|   [1] Plants VS Zombies GOTY Edition (Collection)       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Bendy and the INC Machine (Media Fire)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Minecraft (Collection)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Celeste (Media Fire)                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Geometry Dash (Media Fire)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Plague Inc (Media Fire)                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Rebel Inc (Media Fire)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Baldis Basics Normal/Plus (Collection)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Undertale (Collection)                            ^|
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
if '%wahl%' == '1' goto:pvztuto
if '%wahl%' == '2' Start https://www.mediafire.com/file/x74ksnxwodm1ixv/Bendy_and_the_inc_Machine_64-Bit_Complete_Edition.zip/file
if '%wahl%' == '3' goto:mctuto
if '%wahl%' == '4' Start https://www.mediafire.com/file/7zidh1api7mzwg6/Celeste.zip/file
if '%wahl%' == '5' Start https://www.mediafire.com/file/mno4cjtxmd21rmc/Geometrie+Dash.zip/file
if '%wahl%' == '6' Start https://www.mediafire.com/file/nvzdmasvz5rzqoe/Plague+Inc+Evolved.zip/file
if '%wahl%' == '7' Start https://www.mediafire.com/file/1vjhtsejgytm4rj/Rebel+Inc+Escalation.zip/file
if '%wahl%' == '8' goto:baldistuto
if '%wahl%' == '9' goto:undertaletuto 
if '%wahl%' == '10' goto:Start
if '%wahl%' == '11' goto:gamesP2
if '%wahl%' == '14' goto:gamesP2
goto:gamesP1

:mctuto
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Minecraft Dungeons (Steamunlocked,All Dlcs)       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Minecraft Story Mode (Steamunlocked)              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Minecraft Story Mode 2 (Steamunlocked)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Games page 1                                      ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=  
if '%wahl%' == '1' Start https://steamunlocked.net/16-minecraft-dungeons-free-v4-download/
if '%wahl%' == '2' Start https://steamunlocked.net/minecraft-story-mode-a-telltale-games-series-free-download/
if '%wahl%' == '3' Start https://steamunlocked.net/minecraft-story-mode-season-two-free-download/
if '%wahl%' == '4' goto:gamesP1

 :baldistuto
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Baldis Basics Plus V0.3.2 (Media Fire)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Baldis Basics V1.4.3 64-bit (Media Fire)          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Baldis Basics V1.4.3 32-bit (Media Fire)          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Baldis Basics V1.3.2 (Media Fire)                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Baldis Basics V1.2.2 (Media Fire)                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] All Versions in one Packet                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Games page 1                                      ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=  
if '%wahl%' == '1' Start https://www.mediafire.com/file/u1lkh4v5bacziv6/Baldis+Basics+Plus.zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/7a9vzevm573ttou/Baldi_1.4.3_%252864x%2529.zip/file
if '%wahl%' == '3' Start https://www.mediafire.com/file/fmgsfbwd48gzm6x/Baldi_1.4.3_%2528x64%2529.zip/file
if '%wahl%' == '4' Start https://www.mediafire.com/file/moh624lk7myvl8e/Baldi_1.3.2_%2528x64%2529.zip/file
if '%wahl%' == '5' Start https://www.mediafire.com/file/zfv92evalau3nkb/Baldi_1.2.2_%2528x64%2529.zip/file
if '%wahl%' == '6' Start https://www.mediafire.com/file/n2rb0s7oc2iw0xs/Baldis_Basics_Packet.zip/file
if '%wahl%' == '7' goto:gamesP1
goto:baldistuto

 :undertaletuto
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Install Undertale V1.08 (English) (Media Fire)    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Install Undertale V1.08 German Patch (Media Fire) ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Install Undertale V1.01 Spanish Patch (Media Fire)^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Install Undertale V1.08 French Patch (Media Fire) ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Install Undertale V1.08 Italy Patch (Media Fire)  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Games page 1                                      ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=  
if '%wahl%' == '1' Start https://www.mediafire.com/file/1qj7h1lxb0322xl/Undertale.zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/bwuwqwzvpmtghla/Undertale+German+Patch.zip/file
if '%wahl%' == '3' Start https://www.mediafire.com/file/e7emvxllyvcdmdp/Undertale+Spanish+Patch.zip/file
if '%wahl%' == '4' Start https://www.mediafire.com/file/0ww126r7ccet4kx/Undertale+French+Patch.zip/file
if '%wahl%' == '5' Start https://www.mediafire.com/file/q3keme6v1m625o3/Undertale+Italy+Patch.zip/file
if '%wahl%' == '6' goto:gamesP1
goto:undertaletuto

 :pvztuto
mode con cols=98 lines=30
echo.         
echo              What Plants VS Zombies Game of the Year Edition Game/Patch you want to install?
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Install Plants VS Zombies (English) (Media Fire)  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Install PVZ German Patch (Media Fire)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Install PVZ Spanish Patch (Media Fire)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Install PVZ French Patch (Media Fire)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Install PVZ Italian Patch (Media Fire)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Install PVZ English PS3+Emulator                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Games page 1                                      ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo.                   Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,9,10,11] :
echo.
echo.                                      Download Responsibly!!!
echo.
SET /p wahl=  
if '%wahl%' == '1' Start https://www.mediafire.com/file/hr1k2zz0xxslil6/Plants_vs_Zombies_GOTY.zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/4rcz8vl4hwikofc/Plants_VS_Zombies_German_Patch.zip/file
if '%wahl%' == '3' Start https://www.mediafire.com/file/5ehuiub48tlrg8m/PVZ_Spanish_Patch.zip/file
if '%wahl%' == '4' Start https://www.mediafire.com/file/e86raex1x0ks6n7/PVZ_French_Patch.zip/file
if '%wahl%' == '5' Start https://www.mediafire.com/file/e86raex1x0ks6n7/PVZ_French_Patch.zip/file
if '%wahl%' == '6' Start 
if '%wahl%' == '7' goto:gamesP1
goto:pvztuto

 :gamesP2
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Five Nights at Freddys (Collection)               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Half Life (Collection)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] GTA (Collection)                                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Sims (Collection)                                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Hitman (Collection)                               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Halo (Collection)                                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Farming Simulator (Collection)                    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Simpsons Hit and Run (Old Media Fire)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Night of the Consumer (Media Fire)                ^|
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
if '%wahl%' == '1' goto:fnafcollection
if '%wahl%' == '2' goto:hlcollection
if '%wahl%' == '3' Start goto:gtacollection
if '%wahl%' == '4' goto:simscollection 
if '%wahl%' == '5' goto:hitmancollection
if '%wahl%' == '6' goto:halocollection
if '%wahl%' == '7' goto:farmingsimcollection
if '%wahl%' == '8' Start http://www.mediafire.com/file/v6c8dwbqs6e6aq4/Simpsons_game_By_TimeForATutorial.zip/file
if '%wahl%' == '9' Start http://www.mediafire.com/file/0kbc69xll0vwp3c/NIGHTOFTHECONSUMERS0.04.rar/file
if '%wahl%' == '10' goto:gamesP1
if '%wahl%' == '11' goto:gamesP3
goto:gamesP2

 :halocollection
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] HALO Combat Evolved (Media Fire)                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] HALO 2 (Steamunlocked)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] HALO Wars Definitive Edition (Steamunlocked)      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] HALO Spartan Strike (Steamunlocked)               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] HALO Spartan Asssault (Steamunlocked)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to games page 3                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/kf4ib27pewigyzy/HALO+1+(Combat+Evolved).zip/file
if '%wahl%' == '2' Start https://steamunlocked.net/6-halo-2-free-download/
if '%wahl%' == '3' Start https://steamunlocked.net/halo-wars-definitive-edition-free-download/
if '%wahl%' == '4' Start https://steamunlocked.net/halo-spartan-strike-free-download/
if '%wahl%' == '5' Start https://steamunlocked.net/halo-spartan-assault-free-download/
if '%wahl%' == '11' goto:gamesP3
goto:halocollection

 :simscollection
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Sims (Steamunlocked)                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Sims 2 (Steamunlocked)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Sims 3 (Steamunlocked)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Sims 4 (Steamunlocked)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to games page 2                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://steamunlocked.net/1-the-sims-complete-edition-free-download/
if '%wahl%' == '2' Start https://steamunlocked.net/6-the-sims-2-free-v9-download/
if '%wahl%' == '4' Start https://steamunlocked.net/8-the-sims-3-free-v11-download/
if '%wahl%' == '3' Start https://steamunlocked.net/22-the-sims-4-free-pc-download/
if '%wahl%' == '11' goto:gamesP2
goto:simscollection

 :gtacollection
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] GTA III (Steamunlocked)                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] GTA Vice City (Steamunlocked)                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] GTA San Andreas (Media Fire)                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] GTA The Trilogy Defenitive Edition (Steamunlocked)^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] GTA IV (Steamunlocked)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] GTA IV and Liberty City Stories (Steamunlocked)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] GTA V (Steamunlocked)                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to games page 2                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://steamunlocked.net/13-grand-theft-auto-iii-free-v14-download/
if '%wahl%' == '2' Start https://steamunlocked.net/grand-theft-auto-vice-city-free-pc-download/
if '%wahl%' == '3' goto:gtasatuto
if '%wahl%' == '4' Start https://steamunlocked.net/20-grand-theft-auto-the-trilogy-the-definitive-edition-free-download/
if '%wahl%' == '5' Start https://steamunlocked.net/59-grand-theft-auto-iv-free-v10-download/
if '%wahl%' == '6' Start https://steamunlocked.net/28-grand-theft-auto-iv-the-complete-edition-free-v15-download/
if '%wahl%' == '7' Start https://steamunlocked.net/51-grand-theft-auto-v-free-v4-download/ 
if '%wahl%' == '11' goto:gamesP2
goto:gtacollection

 :hlcollection
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Half Life (Media Fire)                            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Half Life 2 Steamunlocked)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Half-Life 2 Ep1 (Steamunlocked)                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Half-Life 2 EP2 (Steamunlocked)                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Half-Life Blue Shift (Steamunlocked)              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Half-Life opossing Force (Steamunlocked)          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to games page 2                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:HalfLifepk
if '%wahl%' == '2' Start https://steamunlocked.net/47-half-life-2-free-game-download/ 
if '%wahl%' == '3' Start https://steamunlocked.net/1-half-life-2-episode-one-free-download/ 
if '%wahl%' == '4' Start https://steamunlocked.net/2-half-life-2-episode-2-free-download/
if '%wahl%' == '5' Start https://steamunlocked.net/1-half-life-blue-shift-free-download/ 
if '%wahl%' == '6' Start https://steamunlocked.net/1-half-life-opposing-force-free-download/
if '%wahl%' == '11' goto:gamesP2
goto:hlcollection

 :hitmancollection
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Hitman GOTY (Steamunlocked)                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Hitman 2 (Steamunlocked)                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Hitman 2 Silent Assassin (Steamunlocked)          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Hitman 3 (Steamunlocked)                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Hitman Codename 47 (Steamunlocked)                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Hitman Absolution Professional (Steamunlocked)    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Hitman Blood Money (Steamunlocked)                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Hitman Contracts (Steamunlocked)                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Hitman GO Definitve Edition (Steamunlocked)       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to games page 2                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://steamunlocked.net/2-hitman-free-download/
if '%wahl%' == '2' Start https://steamunlocked.net/4-hitman-2-free-v3-download/
if '%wahl%' == '4' Start https://steamunlocked.net/7-hitman-3-free-v3-download/
if '%wahl%' == '3' Start https://steamunlocked.net/hitman-2-silent-assassin-free-download/
if '%wahl%' == '5' Start https://steamunlocked.net/hitman-codename-47-free-download/
if '%wahl%' == '6' Start https://steamunlocked.net/hitman-absolution-free-drm-download/
if '%wahl%' == '7' Start https://steamunlocked.net/hitman-blood-money-free-download/
if '%wahl%' == '8' Start https://steamunlocked.net/hitman-contracts-free-full-download/
if '%wahl%' == '9' Start https://steamunlocked.net/hitman-go-definitive-edition-free-download/
if '%wahl%' == '11' goto:gamesP2
goto:hitmancollection

 :fnafcollection
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Five Nights at Freddys (Media Fire)               ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Five Nights at Freddys 2 (Media Fire)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Five Nights at Freddys 3 (Media Fire)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Five Nights at Freddys 4,Hallowenn (Media Fire)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Five Nights at Freddys SL (Media Fire)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] FNAF Pizzeria Simulator (Steam)                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] FNAF Ultimate Custom Night (Steam)                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] FNAF Help Wanted (non-VR) (Steamunlocked)         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] FNAF Help Wanted (Steamunlocked)                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] FNAF Security Breach (Steamunlocked)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to games page 2                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/6e6xeejb4scm106/Five_Nights_at_Freddys.zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/w4gi2add192ys6f/Five_Nights_at_Freddy%25C2%25B4s_2.zip/file 
if '%wahl%' == '3' Start http://www.mediafire.com/file/6yrqx1rc42vlulj/Five_Nights_at_Freddy%25C2%25B4s_3.zip/file
if '%wahl%' == '4' Start https://www.mediafire.com/file/zwzap31sm26kp9n/Five+Nights+at+Freddys+4.zip/file
if '%wahl%' == '5' Start https://www.mediafire.com/file/g0nrpnvhpqzbm8q/Five+Nights+at+Freddys+Sister+Location.zip/file
if '%wahl%' == '7 Start https://store.steampowered.com/app/871720/Ultimate_Custom_Night/
if '%wahl%' == '6' Start https://store.steampowered.com/app/738060/Freddy_Fazbears_Pizzeria_Simulator/
if '%wahl%' == '8' Start https://steamunlocked.net/five-nights-at-freddys-help-wanted-non-vr-free-pc-download/
if '%wahl%' == '9' Start https://steamunlocked.net/five-nights-at-freddys-vr-help-wanted-free-download/
if '%wahl%' == '10' Start https://steamunlocked.net/13-five-nights-at-freddys-security-breach-free-download/
if '%wahl%' == '11' goto:gamesP2
goto:fnafcollection

 :maxpaynecollection
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Max Payne (Steamunlocked)                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Max Payne 2 The Fall of Max Payne (Steamunlocked) ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Max Payne 3 (All DLCs) (Steamunlocked)            ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to games page 4                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://steamunlocked.net/max-payne-free-download/
if '%wahl%' == '2' Start https://steamunlocked.net/4-max-payne-2-the-fall-of-max-payne-free-download/
if '%wahl%' == '3' Start https://steamunlocked.net/max-payne-3-free-premium-download/
if '%wahl%' == '11' goto:gamesP4
goto:maxpaynecollection

 :southparkcollection
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] South Park 1998 (My Abandonware)                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] South Park Chefs Luv Shack (archive.org)          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] South Park Rally (My Abandonware)                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Soth Park the Stick of Truth (Steamunlocked)      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] South Park The Fracture but whole                 ^|
Echo.                    ^|       (All DLCs) (Steamunlocked)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to games page 4                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://www.myabandonware.com/download/mmt-south-park
if '%wahl%' == '2' Start https://archive.org/download/LUVSHACK/LUVSHACK.zip
if '%wahl%' == '3' Start https://www.myabandonware.com/game/south-park-rally-a64#download
if '%wahl%' == '4' Start https://steamunlocked.net/1-south-park-the-stick-of-truth-free-download/
if '%wahl%' == '5' Start South Park: The Fractured But Whole Free Download (Incl. ALL DLC’s)
if '%wahl%' == '11' goto:gamesP4
goto:southparkcollection

 :farmingsimcollection
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Farming Simulator 17 (all DLCs) (Steamunlocked)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Farming Simulator 19 (all DLCs) (Steamunlocked)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Farming Simulator 22 (all DLCs) (Steamunlocked)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to games page 3                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://steamunlocked.net/farming-simulator-17-free-download/
if '%wahl%' == '2' Start https://steamunlocked.net/6-farming-simulator-19-free-pc-download/
if '%wahl%' == '3' Start https://steamunlocked.net/13-farming-simulator-22-free-download/
if '%wahl%' == '11' goto:gamesP3
goto:farmingsimcollection


 :pacmancollection
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Pac Man Championship Edition DX (Media Fire)      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Pac-Man Championship Edition 2 (Steamunlocked)    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Pac Man 256 (Media Fire)                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Pac-Man Museum (Media Fire)                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Return to games page 4                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' https://www.mediafire.com/file/2ht24x7wsyguazf/Pac+Man+Championship+DX+.zip/file
if '%wahl%' == '2' https://steamunlocked.net/pac-man-championship-edition-2-free-download/ 
if '%wahl%' == '3' Start https://www.mediafire.com/file/cktmebgbz5qg5q3/Pac+Man+256.zip/file
if '%wahl%' == '4' Start https://www.mediafire.com/file/a2uq4vayeumvkxu/PAC-MAN+MUSEUM.zip/file
if '%wahl%' == '11' goto:gamesP4
goto:pacmancollection

:gamesP3
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
Echo.                    ^|   [8] Pac-Man (Collection)                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Beach Buggy Racing 2 Island Adventure (Media Fire)^|
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
if '%wahl%' == '1' Start https://www.mediafire.com/file/6nr89kpd2hd0cqn/Terraria.zip/file
if '%wahl%' == '2' Start https://www.mediafire.com/file/fp45nqbucz6rlub/Stardew+Valley.zip/file 
if '%wahl%' == '3' Start https://www.mediafire.com/file/iaftxtgse3yfrte/Bloons+Tower+Defense+5.zip/file
if '%wahl%' == '4' Start https://steamunlocked.net/2-bloons-td-6-free-download/
if '%wahl%' == '5' Start https://steamunlocked.net/tetris-effect-free-download/
if '%wahl%' == '6' Start https://steamunlocked.net/5-tetris-effect-connected-free-download/
if '%wahl%' == '7' Start https://steamunlocked.net/18-cities-skylines-free-pc-download/
if '%wahl%' == '8' goto:pacmancollection
if '%wahl%' == '9' Start https://www.mediafire.com/file/becvb846o8befll/BBR_2_Island_Adventure_%2528Build_6471156%2529.zip/file
if '%wahl%' == '10' goto:gamesP2
if '%wahl%' == '11' goto:gamesP4
goto:gamesP3

:gamesP4
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Red Dead Redemption 2 (Steamunlocked)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Cyberpunk 2077 (Steamunlocked)                    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Jump Force V3.00 (All DLCs) (Steamunlocked)       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Spyro Reignited Trilogy (Steamunlocked)           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Forza Horizon 4 Ultimate Edtion (Steamunlocked)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Forza Horizon 5 (All DLCs,Steamunlocked)          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] DOOM 64 (Steamunlocked)                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] The GodFather (Media Fire)                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] South Park (Collection)                           ^|
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
if '%wahl%' == '1' Start https://steamunlocked.net/79-red-dead-redemption-2-free-v14-download/
if '%wahl%' == '2' Start https://steamunlocked.net/36-cyberpunk-2077-free-v37-download/
if '%wahl%' == '3' Start https://steamunlocked.net/jump-force-free-download/
if '%wahl%' == '4' Start https://steamunlocked.net/2-spyro-reignited-trilogy-free-download/
if '%wahl%' == '5' Start https://steamunlocked.net/57-forza-horizon-4-free-v4-download/ 
if '%wahl%' == '6' Start Start https://steamunlocked.net/21-forza-horizon-5-free-download/
if '%wahl%' == '7' Start https://steamunlocked.net/doom-64-free-download/
if '%wahl%' == '8' Start https://www.mediafire.com/file/d2gp71g5aivy9gw/The+Godfather.zip/file
if '%wahl%' == '9' goto:southparkcollection
if '%wahl%' == '10' goto:gamesP3
if '%wahl%' == '11' goto:gamesP5
goto:gamesP4

 :gamesP5
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Chrono Trigger (Limited Edition) (Media Fire)     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Smart Factory Tycoon (Media Fire)                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Date Ariane Remastered (Uncensored)(Media Fire)   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Donut Dodo (Media Fire)                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Punch Club (All DLCs) (Media Fire)                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Theme Hospital (Media Fire)                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Diablo + Diablo Hellfire (Steamunlocked)          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [8] Diablo II Complete (Steamunlocked)                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] Max Payne (Collection)                            ^|
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
if '%wahl%' == '1' Start https://www.mediafire.com/file/hyxot5i351qhe5w/Chrono+Trigger+Limited+Edition+(Update+5).zip/file 
if '%wahl%' == '2' Start https://www.mediafire.com/file/3umkj6w7pavvlsw/Smart+Factory+Ticoon.zip/file
if '%wahl%' == '3' Start https://www.mediafire.com/file/1o7g3tg8sfofmac/Date+Ariane+Remastered.zip/file
if '%wahl%' == '4' Start https://www.mediafire.com/file/dk6cuduilxx6vjh/Donut+Dodo+V1.07.zip/file
if '%wahl%' == '5' Start https://www.mediafire.com/file/yq68rhvu8psv0v7/Punch+Club+V1.32&All+DLC´s.zip/file
if '%wahl%' == '6' Start https://www.mediafire.com/file/aupcsl2jxy7s0jx/Theme+Hospital.zip/file
if '%wahl%' == '7' Start https://steamunlocked.net/diablo-and-diablo-hellfire-free-download/
if '%wahl%' == '8' Start https://steamunlocked.net/diablo-2-complete-edition-free-download/
if '%wahl%' == '9' goto:maxpaynecollection
if '%wahl%' == '10' goto:gamesP4
if '%wahl%' == '11' goto:gamesP6
goto:gamesP5

 :gamesP6
mode con cols=98 lines=30
echo.
echo maybe in the next Update
echo.
echo Press any Key to Return to Page 5
pause >nul
goto:gamesP4

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
Echo.                    ^|   [5] Wondershare Filmora X                             ^|
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
if '%wahl%' == '5' Start https://www.mediafire.com/file/pgq1nux7ucclocg/Wondershare+Filmora+10.1.20.15.exe/file&goto:wsfXtuto
if '%wahl%' == '6' Start https://www.mediafire.com/file/1gluffyxq6ewqgx/AESprite.zip/file
if '%wahl%' == '7' goto:VMPC
if '%wahl%' == '8' goto:Software
goto:Softwarep

:wsfXtuto
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   Dont Upgrade to Wondershare Filmora 11 because only   ^|
Echo.                    ^|   Wondershare Filmora X will be activated               ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo    Press any key to return to Programms Menu
pause >nul
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
if '%wahl%' == '1' Start https://www.mediafire.com/file/o2yc7bjt6bh3x0u/Adobe+Photoshop+2022.iso/file&goto:autoplaydont
if '%wahl%' == '2' Start https://www.mediafire.com/file/mee64hnnwzn9uco/Adobe+Premiere+Pro+2022.iso/file&goto:autoplaydont
if '%wahl%' == '3' Start https://www.mediafire.com/file/2r3lvq0z25uyaz7/Adobe+After+Effects+2022.iso/file&goto:autoplaydont
if '%wahl%' == '4' START https://dl.malwarewatch.org/software/useful/adobe/AdobeCCCleaner430.exe
if '%wahl%' == '5' goto:Softwarep
goto:Adobedown

 :autoplaydont
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|    If the autoplay.exe dont work please go into the     ^|
Echo.                    ^|    Adobe 2022 folder and run the Set- up.exe            ^|
Echo.                    ^|_________________________________________________________^|
echo.
echo. Press any key to return to the Programms Menu
pause >nul
goto:Softwarep

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
Echo.                    ^|    installation directory of Vegas 15 before you launch ^|
Echo.                    ^|    the Programm the first time!                         ^|
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
Echo.                    ^|    Return to Vegas Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/3ofh3fhgafpo185/VEGAS8Pro.zip/file&goto:VegasKeys
if '%wahl%' == '2' Start https://www.mediafire.com/file/xerw6r2iqj3r0h4/Vegas13Pro.zip/file&goto:VegasKeys
if '%wahl%' == '3' Start https://www.mediafire.com/file/8qgbpuyr5vai8ip/VEGASPro15.zip/file&goto:VegasKeys
if '%wahl%' == '4' Start https://www.mediafire.com/file/uk64mmffckjacl7/VEGASPro16.zip/file&goto:VegasKeys
if '%wahl%' == '5' Start https://www.mediafire.com/file/guxca9la08t24qw/VEGASPro17.zip/file&goto:VegasKeys
if '%wahl%' == '6' Start https://www.mediafire.com/file/3jnoztcnxfnc5bs/VEGASPro18.zip/file&goto:VegasKeys
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
Echo.                    ^|    VMWare 12 Pro Keys:                                  ^|
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
fsutil dirty query %systemdrive%  >nul 2>&1 || (
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|                    ==== ERROR ====                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   This Action require administrator privileges.         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   To do so, right click on this script and select       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|               'Run as administrator'                    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   Press any key to Return to Start Menu...              ^|
Echo.                    ^|_________________________________________________________^|
pause >nul
goto:Start
)
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
fsutil dirty query %systemdrive%  >nul 2>&1 || (
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|                    ==== ERROR ====                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   This Action require administrator privileges.         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   To do so, right click on this script and select       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|                'Run as administrator'                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   Press any key to Return to Start Menu...              ^|
Echo.                    ^|_________________________________________________________^|
pause >nul
goto:Start
)
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
mode con cols=98 lines=30
fsutil dirty query %systemdrive%  >nul 2>&1 || (
echo.                     __________________________________________________________
Echo.                    ^|404 Code:0x023090694                                     ^|
Echo.                    ^|                    ==== ERROR ====                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   This Action require administrator privileges.         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   To do so, right click on this script and select       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|                'Run as administrator'                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   Press any key to return to Start Menu...              ^|
Echo.                    ^|_________________________________________________________^|
pause >nul
goto:Start
)
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|    Which Activation do you want to use?                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Windows Digital License Key (Core)                ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Insert the Digital License Key (Core)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Change Edition and Activate it (Core)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Change Edition and Activate it (non Core)         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Volume Activation (Core and non Core)             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Return Start Menu                                 ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:HWIDActivate
if '%wahl%' == '2' goto:InsertProductKey
if '%wahl%' == '3' goto:EdiChange10/11
if '%wahl%' == '4' goto:EdiChange10/11nc
if '%wahl%' == '5' goto:Csl
if '%wahl%' == '6' goto:Start
 goto:Really1

 :ReadMe
mode con cols=98 lines=30
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [Script coded by @RCG10]                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [Script is Version 1.3.1 [Realese]                    ^|
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
if '%wahl%' == '7' Start https://gtaconnected.com/downloads/GTAC-1.4.1.zip&goto:GTAC
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
if '%wahl%' == '1' Start https://winrar.de/downld.php
if '%wahl%' == '3' Start https://www.mediafire.com/file/lp9guxfnvd28win/WinRAR+New+Pre-activated.zip/file&goto:winrardownmtuto
if '%wahl%' == '2' Start https://www.mediafire.com/file/yjkikdj5n3hi7te/WinRAR+(New,Pre-activated).zip/file&goto:winrardownmtuto
if '%wahl%' == '4' goto:Software
goto:winrar

 :winrardownmtuto
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

=====================================================================================================

 :Office
title Office Tool [By RCG10]
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Install your Microsoft Office Version             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Activate your Microsoft Office                    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Other                                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Return to Programms Section                       ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:OFI
if '%wahl%' == '2' goto:Officeact
if '%wahl%' == '3' goto:officeother
if '%wahl%' == '4' goto:softwarep
goto:Office

 :officeother
title Office Tool [By RCG10]
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Check if your Office is activated                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Check Version and Edition this tool is running    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Return to Office Menu                             ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:IOFA
if '%wahl%' == '2' goto:WH
if '%wahl%' == '4' goto:Office
goto:officeother

:WH
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|       ==== Office Tool Version/Edition ====             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|         This Port of Office Tool is running             ^|
Echo.                    ^|            Teraluxe V0.03 -Build 2.6359                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|                 Edition/Key Server:                     ^|
Echo.                    ^|                  "rcg10deluxe key"                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|      Press any key to Return to Office Menu...          ^|
Echo.                    ^|_________________________________________________________^|
pause >nul
goto:Office

 :OFAc
mode con cols=98 lines=30
fsutil dirty query %systemdrive%  >nul 2>&1 || (
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|                    ==== ERROR ====                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   This Action require administrator privileges.         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   To do so, right click on this script and select       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|                'Run as administrator'                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   Press any key to Return to Office Menu...             ^|
Echo.                    ^|_________________________________________________________^|
pause >nul
goto:Office
)
echo.  
echo                           What Version of Office do you want to Activate ?
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 365                              ^|
Echo.                    ^|   [2] Microsoft Office 2021                             ^|
Echo.                    ^|   [3] Microsoft Office 2019                             ^|
Echo.                    ^|   [4] Microsoft Office 2016                             ^|
Echo.                    ^|   [5] Microsoft Office 2013                             ^|
Echo.                    ^|   [6] Microsoft Office 2010                             ^|
Echo.                    ^|   [7] Microsoft Office 2007                             ^|
Echo.                    ^|   [8] Microsoft Office 2002 XP                          ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:OF365Ac
if '%wahl%' == '2' goto:OF21Ac
if '%wahl%' == '3' goto:OF19Ac
if '%wahl%' == '4' goto:OF16Ac
if '%wahl%' == '5' goto:OF13Ac
if '%wahl%' == '6' goto:OF10Ac
if '%wahl%' == '7' goto:OF07Ac
if '%wahl%' == '8' goto:OF02Ac
if '%wahl%' == '100' goto:Office
goto:OFAc

:OF02Ac
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   Office XP 2002 dont uses Volume Activation so         ^|
Echo.                    ^|   the Product Key for The MS Office XP 2002             ^|
Echo.                    ^|   in this Script is:                                    ^|
Echo.                    ^|   FM9FY-TMF7Q-KCKCT-V9T29-TBBBG                         ^|
Echo.                    ^|   Just Copy out of this cmd                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '100' goto:Office
goto:OF02Ac


:OF07Ac
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   Office 2007 dont uses Volume Activation so            ^|
Echo.                    ^|   the Product Key for The MS Office 2007 Enterprise     ^|
Echo.                    ^|   in this Script is:                                    ^|
Echo.                    ^|   KGFVY-7733B-8WCK9-KTG64-BC7D8                         ^|
Echo.                    ^|   Just Copy out of this cmd                             ^|
Echo.                    ^|   (For English and German)                              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '100' goto:Office
goto:OF07Ac

 :OF10Ac
title Activate Microsoft Office 2010 Volume for FREE!&cls&echo ============================================================================&echo #Project: Activating Microsoft software products for FREE without software&echo ============================================================================&echo.&echo #Supported products:&echo – Microsoft Office 2010 Standard Volume&echo – Microsoft Office 2010 Professional Plus Volume&echo.&echo.&(if exist “%ProgramFiles%\Microsoft Office\Office14\ospp.vbs” cd /d “%ProgramFiles%\Microsoft Office\Office14”)&(if exist “%ProgramFiles(x86)%\Microsoft Office\Office14\ospp.vbs” cd /d “%ProgramFiles(x86)%\Microsoft Office\Office14”)&echo.&echo ============================================================================&echo Activating your Office…&cscript //nologo ospp.vbs /unpkey:8R6BM >nul&cscript //nologo ospp.vbs /unpkey:H3GVB >nul&cscript //nologo ospp.vbs /inpkey:V7QKV-4XVVR-XYV4D-F7DFM-8R6BM >nul&cscript //nologo ospp.vbs /inpkey:VYBBJ-TRJPB-QFQRF-QFT4D-H3GVB >nul&set i=1
:server
if %i%==1 set KMS_Sev=kms7.MSGuides.com
if %i%==2 set KMS_Sev=kms8.MSGuides.com
if %i%==3 set KMS_Sev=kms9.MSGuides.com
if %i%==4 goto notsupported
cscript //nologo ospp.vbs /sethst:%KMS_Sev% >nul&echo ============================================================================&echo.&echo.
cscript //nologo ospp.vbs /act | find /i “successful” && (echo.&echo============================================================================&choice /n /c YN /m “Would you like to visit my Website [Y,N]?” & if errorlevel 2 goto:Start) || (echo The connection to my KMS server failed! Trying to connect to another one… & echo Please wait… & echo. & echo. & set /a i+=1 & goto server)
explorer “http://rcg10.webador.de”&goto halt
:notsupported
echo.&echo ============================================================================&echo Sorry! Your version is not supported.
:halt
echo Press any key to return to Office Menu
pause >nul
goto:Office

 :OF13Ac
title Activate Microsoft Office 2013 Volume for FREE!&cls&echo ============================================================================&echo #Project: Activating Microsoft software products for FREE without software&echo ============================================================================&echo.&echo #Supported products:&echo - Microsoft Office 2013 Standard Volume&echo - Microsoft Office 2013 Professional Plus Volume&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office15\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office15")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office15\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office15")&echo.&echo ============================================================================&echo Activating your Office...&cscript //nologo ospp.vbs /unpkey:92CD4 >nul&cscript //nologo ospp.vbs /unpkey:GVGXT >nul&cscript //nologo ospp.vbs /inpkey:KBKQT-2NMXY-JJWGP-M62JB-92CD4 >nul&cscript //nologo ospp.vbs /inpkey:YC7DK-G2NP3-2QQC3-J6H88-GVGXT >nul&set i=1
:server
if %i%==1 set KMS_Sev=kms7.MSGuides.com
if %i%==2 set KMS_Sev=kms8.MSGuides.com
if %i%==3 set KMS_Sev=kms9.MSGuides.com
if %i%==4 goto notsupported
cscript //nologo ospp.vbs /sethst:%KMS_Sev% >nul&echo ============================================================================&echo.&echo.
cscript //nologo ospp.vbs /act | find /i "successful" && (echo.&echo============================================================================&choice /n /c YN /m "Would you like to visit my Website [Y,N]?" & if errorlevel 2 goto:Start) || (echo The connection to my KMS server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto server)
explorer "http://rcg10.webador.de"&goto halt
:notsupported
echo.&echo ============================================================================&echo Sorry! Your version is not supported.
:halt
echo Press any key to return to Office Menu
pause >nul
goto:Office

 :OF16Ac
title Activate Microsoft Office 2016 ALL versions for FREE!&cls&echo ============================================================================&echo #Project: Activating Microsoft software products for FREE without software&echo ============================================================================&echo.&echo #Supported products:&echo - Microsoft Office Standard 2016&echo - Microsoft Office Professional Plus 2016&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16")&(for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&(for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&echo.&echo ============================================================================&echo Activating your Office...&cscript //nologo ospp.vbs /unpkey:WFG99 >nul&cscript //nologo ospp.vbs /unpkey:DRTFM >nul&cscript //nologo ospp.vbs /unpkey:BTDRB >nul&cscript //nologo ospp.vbs /unpkey:CPQVG >nul&cscript //nologo ospp.vbs /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99 >nul&set i=1
:server
if %i%==1 set KMS_Sev=kms7.MSGuides.com
if %i%==2 set KMS_Sev=kms8.MSGuides.com
if %i%==3 set KMS_Sev=kms9.MSGuides.com
if %i%==4 goto notsupported
cscript //nologo ospp.vbs /sethst:%KMS_Sev% >nul&echo ============================================================================&echo.&echo.
cscript //nologo ospp.vbs /act | find /i "successful" && (echo.&echo============================================================================&choice /n /c YN /m "Would you like to visit my Website [Y,N]?" & if errorlevel 2 goto:Start) || (echo The connection to my KMS server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto server)
explorer "http://rcg10.webador.de"&goto halt
:notsupported
echo.&echo ============================================================================&echo Sorry! Your version is not supported.&echo Please try installing the latest version here: bit.ly/downloadmsp
:halt
echo Press any key to return to Office Menu
pause >nul
goto:Office

 :OF19Ac
title Activate Microsoft Office 2019 ALL versions for FREE!&cls&echo ============================================================================&echo #Project: Activating Microsoft software products for FREE without software&echo ============================================================================&echo.&echo #Supported products:&echo - Microsoft Office Standard 2019&echo - Microsoft Office Professional Plus 2019&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16")&(for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&(for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2019VL*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&echo.&echo ============================================================================&echo Activating your Office...&cscript //nologo ospp.vbs /unpkey:6MWKP >nul&cscript //nologo ospp.vbs /inpkey:NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP >nul&set i=1
:server
if %i%==1 set KMS_Sev=kms7.MSGuides.com
if %i%==2 set KMS_Sev=kms8.MSGuides.com
if %i%==3 set KMS_Sev=kms9.MSGuides.com
if %i%==4 goto notsupported
cscript //nologo ospp.vbs /sethst:%KMS_Sev% >nul&echo ============================================================================&echo.&echo.
cscript //nologo ospp.vbs /act | find /i "successful" && (echo.&echo============================================================================&choice /n /c YN /m "Would you like to visit my Website [Y,N]?" & if errorlevel 2 goto:Start) || (echo The connection to my KMS server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto server)
explorer "http://rcg10.webador.de"&goto halt
:notsupported
echo.&echo ============================================================================&echo Sorry! Your version is not supported.&echo Please try installing the latest version here: bit.ly/aiomsp
:halt
echo Press anykey to Return to the Office Menu
pause >nul
goto:Office

 :OF21Ac
mode con cols=98 lines=30
title Activate Microsoft Office 2021 (ALL versions) for FREE - [rcg10lite]&cls&echo =====================================================================================&echo #Project: Activating Microsoft software products for FREE without additional software&echo =====================================================================================&echo.&echo #Supported products:&echo - Microsoft Office Standard 2021&echo - Microsoft Office Professional Plus 2021&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16")&(for /f %%x in ('dir /b ..\root\Licenses16\ProPlus2021VL_KMS*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&echo.&echo =====================================================================================&echo Activating your product...&cscript //nologo slmgr.vbs /ckms >nul&cscript //nologo ospp.vbs /setprt:1688 >nul&cscript //nologo ospp.vbs /unpkey:6F7TH >nul&set i=1&cscript //nologo ospp.vbs /inpkey:FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH >nul||goto notsupported
:skms
if %i% GTR 10 goto busy
if %i% EQU 1 set KMS=kms7.MSGuides.com
if %i% EQU 2 set KMS=s8.uk.to
if %i% EQU 3 set KMS=s9.us.to
if %i% GTR 3 goto ato
cscript //nologo ospp.vbs /sethst:%KMS% >nul
:ato
echo =====================================================================================&echo.&echo.&cscript //nologo ospp.vbs /act | find /i "successful" && (echo.&echo=====================================================================================&choice /n /c YN /m "Would you like to visit my Website [Y,N]?" & if errorlevel 2 goto:Start) || (echo The connection to my KMS server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto skms)
explorer "http://www.rcg10.webador.de"&goto halt
:notsupported
echo =====================================================================================&echo.&echo Sorry, your version is not supported.&echo.&goto halt
:busy
echo =====================================================================================&echo.&echo Sorry, the server is busy and can't respond to your request. Please try again.&echo.
:halt
Press any Key to return to Office menu
pause >nul
goto:Office

 :OF365Ac
title Activate Office 365 ProPlus for FREE - MSGuides.com&cls&echo ============================================================================&echo #Project: Activating Microsoft software products for FREE without software&echo ============================================================================&echo.&echo #Supported products: Office 365 ProPlus (x86-x64)&echo.&echo.&(if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles%\Microsoft Office\Office16")&(if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" cd /d "%ProgramFiles(x86)%\Microsoft Office\Office16")&(for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&(for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul)&echo.&echo ============================================================================&echo Activating your Office...&cscript //nologo slmgr.vbs /ckms >nul&cscript //nologo ospp.vbs /setprt:1688 >nul&cscript //nologo ospp.vbs /unpkey:WFG99 >nul&cscript //nologo ospp.vbs /unpkey:DRTFM >nul&cscript //nologo ospp.vbs /unpkey:BTDRB >nul&cscript //nologo ospp.vbs /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99 >nul&set i=1
:server
if %i%==1 set KMS_Sev=kms7.MSGuides.com
if %i%==2 set KMS_Sev=kms8.MSGuides.com
if %i%==3 set KMS_Sev=kms9.MSGuides.com
if %i%==4 goto notsupported
cscript //nologo ospp.vbs /sethst:%KMS_Sev% >nul&echo ============================================================================&echo.&echo.
cscript //nologo ospp.vbs /act | find /i "successful" && (echo.&echo ============================================================================&choice /n /c YN /m "Would you like to visit my Website [Y,N]?" & if errorlevel 2 goto:Start) || (echo The connection to my KMS server failed! Trying to connect to another one... & echo Please wait... & echo. & echo. & set /a i+=1 & goto server)
explorer "http://rcg10.webador.de"&goto halt
:notsupported
echo.&echo ============================================================================&echo Sorry! Your version is not supported.&echo Please try installing the latest version here: bit.ly/odt2k16
:halt
echo Press any key to return to Office Menu
pause >nul
goto:Office

  :OFI
mode con cols=98 lines=30
echo.                     __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 365 German                       ^|
Echo.                    ^|   [2] Microsoft Office 365 English                      ^|
Echo.                    ^|   [3] Microsoft Office 2021 German                      ^|
Echo.                    ^|   [4] Microsoft Office 2021 English                     ^|
Echo.                    ^|   [5] Microsoft Office 2019 German                      ^|
Echo.                    ^|   [6] Microsoft Office 2019 English                     ^|
Echo.                    ^|   [7] Microsoft Office 2016 German                      ^|
Echo.                    ^|   [8] Microsoft Office 2016 English                     ^|
Echo.                    ^|   [9] Microsoft Office 2013 German                      ^|
Echo.                    ^|   [10] Microsoft Office 2013 English                    ^|
Echo.                    ^|   [11] Microsoft Office 2010 German                     ^|
Echo.                    ^|   [12] Microsoft Office 2010 English                    ^|
Echo.                    ^|   [13] Microsoft Office 2007 English                    ^|
Echo.                    ^|   [13] Microsoft Office 2007 German                     ^|
Echo.                    ^|   [15] Microsoft Office XP 2002 German                  ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:OF365G
if '%wahl%' == '2' goto:OF365E
if '%wahl%' == '3' goto:OF21G
if '%wahl%' == '4' goto:OF21E
if '%wahl%' == '5' goto:OF19G
if '%wahl%' == '6' goto:OF19E
if '%wahl%' == '7' goto:OF16G
if '%wahl%' == '8' goto:OF16E
if '%wahl%' == '9' goto:OF13G
if '%wahl%' == '10' goto:OF13E
if '%wahl%' == '11' goto:OF10G
if '%wahl%' == '12' goto:OF10E
if '%wahl%' == '13' goto:OF07E
if '%wahl%' == '14' goto:OF07G
if '%wahl%' == '15' goto:OF02xpG
if '%wahl%' == '100' goto:Office
goto:OFI

 :OF365G
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 365 German Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 365 Pro Plus                     ^|
Echo.                    ^|   [2] Microsoft Office 365 Home Premium                 ^|
Echo.                    ^|   [3] Microsoft Office 365 Business                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '3' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/O365BusinessRetail.img
if '%wahl%' == '2' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/O365HomePremRetail.img
if '%wahl%' == '1' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/O365ProPlusRetail.img
if '%wahl%' == '100' goto:Office
goto:OF365G

 :OF365E
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 365 English Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 365 Pro Plus                     ^|
Echo.                    ^|   [2] Microsoft Office 365 Home Premium                 ^|
Echo.                    ^|   [3] Microsoft Office 365 Business                     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '3' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/O365ProPlusRetail.img
if '%wahl%' == '2' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/O365HomePremRetail.img
if '%wahl%' == '1' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/O365BusinessRetail.img
if '%wahl%' == '100' goto:Office
goto:OF365E

 :OF21G
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2021 German Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2021 Pro Plus                    ^|
Echo.                    ^|   [2] Microsoft Office 2021 Home Business               ^|
Echo.                    ^|   [3] Word 2021                                         ^|
Echo.                    ^|   [4] Excel 2021                                        ^|
Echo.                    ^|   [5] Powerpoint 2021                                   ^|
Echo.                    ^|   [6] Outlook 2021                                      ^|
Echo.                    ^|   [7] Publisher 2021                                    ^|
Echo.                    ^|   [8] Access 2021                                       ^|
Echo.                    ^|   [9] Project Pro 2021                                  ^|
Echo.                    ^|   [10] Visio Pro 2021                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/ProPlus2021Retail.img
if '%wahl%' == '2' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/HomeBusiness2021Retail.img
if '%wahl%' == '3' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/Word2021Retail.img
if '%wahl%' == '4' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/Excel2021Retail.img
if '%wahl%' == '5' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/PowerPoint2021Retail.img
if '%wahl%' == '6' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/Outlook2021Retail.img
if '%wahl%' == '7' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/Publisher2021Retail.img
if '%wahl%' == '8' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/Access2021Retail.img
if '%wahl%' == '9' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/ProjectPro2021Retail.img
if '%wahl%' == '10' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/VisioPro2021Retail.img
if '%wahl%' == '100' goto:Office
goto:OF21G

 :OF21E
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2021 English Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2021 Pro Plus (+MS Teams)        ^|
Echo.                    ^|   [2] Microsoft Office 2021 Home Business (+MS Teams)   ^|
Echo.                    ^|   [3] Word 2021                                         ^|
Echo.                    ^|   [4] Excel 2021                                        ^|
Echo.                    ^|   [5] Powerpoint 2021                                   ^|
Echo.                    ^|   [6] Outlook 2021                                      ^|
Echo.                    ^|   [7] Publisher 2021                                    ^|
Echo.                    ^|   [8] Access 2021                                       ^|
Echo.                    ^|   [9] Project Pro 2021                                  ^|
Echo.                    ^|   [10] Visio Pro 2021                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/ProPlus2021Retail.img
if '%wahl%' == '2' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/HomeBusiness2021Retail.img
if '%wahl%' == '3' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/Word2021Retail.img
if '%wahl%' == '4' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/Excel2021Retail.img
if '%wahl%' == '5' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/PowerPoint2021Retail.img
if '%wahl%' == '6' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/Outlook2021Retail.img
if '%wahl%' == '7' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/Publisher2021Retail.img
if '%wahl%' == '8' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/Access2021Retail.img
if '%wahl%' == '9' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/ProjectPro2021Retail.img
if '%wahl%' == '10' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/VisioPro2021Retail.img
if '%wahl%' == '100' goto:Office
goto:OF21E

 :OF19G
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2019 German Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2019 Pro Plus (+MS Teams)        ^|
Echo.                    ^|   [2] Microsoft Office 2019 Home Business (+MS Teams)   ^|
Echo.                    ^|   [3] Word 2019                                         ^|
Echo.                    ^|   [4] Excel 2019                                        ^|
Echo.                    ^|   [5] Powerpoint 2019                                   ^|
Echo.                    ^|   [6] Outlook 2019                                      ^|
Echo.                    ^|   [7] Publisher 2019                                    ^|
Echo.                    ^|   [8] Access 2019                                       ^|
Echo.                    ^|   [9] Project Pro 2019                                  ^|
Echo.                    ^|   [10] Visio Pro 2019                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/ProPlus2019Retail.img
if '%wahl%' == '2' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/HomeBusiness2019Retail.img
if '%wahl%' == '3' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/Word2019Retail.img
if '%wahl%' == '4' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/Excel2019Retail.img
if '%wahl%' == '5' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/PowerPoint2019Retail.img
if '%wahl%' == '6' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/Outlook2019Retail.img
if '%wahl%' == '7' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/Publisher2019Retail.img
if '%wahl%' == '8' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/Access2019Retail.img
if '%wahl%' == '9' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/ProjectPro2019Retail.img
if '%wahl%' == '10' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/VisioPro2019Retail.img
if '%wahl%' == '100' goto:Office
goto:OF19G


 :OF19E
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2019 English Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2019 Pro Plus (+MS Teams)        ^|
Echo.                    ^|   [2] Microsoft Office 2019 Home Business (+MS Teams)   ^|
Echo.                    ^|   [3] Word 2019                                         ^|
Echo.                    ^|   [4] Excel 2019                                        ^|
Echo.                    ^|   [5] Powerpoint 2019                                   ^|
Echo.                    ^|   [6] Outlook 2019                                      ^|
Echo.                    ^|   [7] Publisher 2019                                    ^|
Echo.                    ^|   [8] Access 2019                                       ^|
Echo.                    ^|   [9] Project Pro 2019                                  ^|
Echo.                    ^|   [10] Visio Pro 2019                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/ProPlus2019Retail.img
if '%wahl%' == '2' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/HomeBusiness2019Retail.img
if '%wahl%' == '3' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/Word2019Retail.img
if '%wahl%' == '4' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/Excel2019Retail.img
if '%wahl%' == '5' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/PowerPoint2019Retail.img
if '%wahl%' == '6' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/Outlook2019Retail.img
if '%wahl%' == '7' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/Publisher2019Retail.img
if '%wahl%' == '8' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/Access2019Retail.img
if '%wahl%' == '9' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/ProjectPro2019Retail.img
if '%wahl%' == '10' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/VisioPro2019Retail.img
if '%wahl%' == '100' goto:Office
goto:OF19GE

  :OF16G
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2016 German Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2016 Pro Plus                    ^|
Echo.                    ^|   [2] Microsoft Office 2016 Home Business               ^|
Echo.                    ^|   [3] Word 2016                                         ^|
Echo.                    ^|   [4] Excel 2016                                        ^|
Echo.                    ^|   [5] Powerpoint 2016                                   ^|
Echo.                    ^|   [6] Outlook 2016                                      ^|
Echo.                    ^|   [7] Publisher 2016                                    ^|
Echo.                    ^|   [8] Access 2016                                       ^|
Echo.                    ^|   [9] Project Pro 2016                                  ^|
Echo.                    ^|   [10] Visio Pro 2016                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/ProPlusRetail.img
if '%wahl%' == '2' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/HomeBusinessRetail.img
if '%wahl%' == '3' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/WordRetail.img
if '%wahl%' == '4' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/ExcelRetail.img
if '%wahl%' == '5' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/PowerPointRetail.img
if '%wahl%' == '6' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/OutlookRetail.img
if '%wahl%' == '7' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/PublisherRetail.img
if '%wahl%' == '8' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/AccessRetail.img
if '%wahl%' == '9' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/ProjectProRetail.img
if '%wahl%' == '10' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/de-DE/VisioProRetail.img
if '%wahl%' == '100' goto:Office
goto:OF16G


  :OF16E
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2016 English Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2016 Pro Plus                    ^|
Echo.                    ^|   [2] Microsoft Office 2016 Home Business               ^|
Echo.                    ^|   [3] Word 2016                                         ^|
Echo.                    ^|   [4] Excel 2016                                        ^|
Echo.                    ^|   [5] Powerpoint 2016                                   ^|
Echo.                    ^|   [6] Outlook 2016                                      ^|
Echo.                    ^|   [7] Publisher 2016                                    ^|
Echo.                    ^|   [8] Access 2016                                       ^|
Echo.                    ^|   [9] Project Pro 2016                                  ^|
Echo.                    ^|   [10] Visio Pro 2016                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/ProPlusRetail.img
if '%wahl%' == '2' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/HomeBusinessRetail.img
if '%wahl%' == '3' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/WordRetail.img
if '%wahl%' == '4' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/ExcelRetail.img
if '%wahl%' == '5' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/PowerPointRetail.img
if '%wahl%' == '6' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/OutlookRetail.img
if '%wahl%' == '7' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/PublisherRetail.img
if '%wahl%' == '8' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/AccessRetail.img
if '%wahl%' == '9' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/ProjectProRetail.img
if '%wahl%' == '10' Start https://officecdn.microsoft.com/db/492350F6-3A01-4F97-B9C0-C7C6DDF67D60/media/en-US/VisioProRetail.img
if '%wahl%' == '100' goto:Office
goto:OF16E

  :OF13G
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2013 German Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2013 Pro                         ^|
Echo.                    ^|   [2] Microsoft Office 2013 Home Business               ^|
Echo.                    ^|   [3] Word 2013                                         ^|
Echo.                    ^|   [4] Excel 2013                                        ^|
Echo.                    ^|   [5] Powerpoint 2013                                   ^|
Echo.                    ^|   [6] One Note 2013                                     ^|
Echo.                    ^|   [7] Outlook 2013                                      ^|
Echo.                    ^|   [8] Publisher 2013                                    ^|
Echo.                    ^|   [9] Access 2013                                       ^|
Echo.                    ^|   [10] Project Pro 2013                                 ^|
Echo.                    ^|   [11] Visio Pro 2013                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=ProfessionalRetail
if '%wahl%' == '2' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=HomeBusinessRetail
if '%wahl%' == '3' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=WordRetail
if '%wahl%' == '4' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=ExcelRetail
if '%wahl%' == '5' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=PowerPointRetail
if '%wahl%' == '6' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=OneNoteRetail
if '%wahl%' == '7' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=OutlookRetail
if '%wahl%' == '8' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=PublisherRetail
if '%wahl%' == '9' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=AccessRetail
if '%wahl%' == '10' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=ProjectProRetail
if '%wahl%' == '11' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=de-DE&p3=VisioProRetail
if '%wahl%' == '100' goto:Office
goto:OF13G

  :OF13E
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2013 English Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2013 Pro                         ^|
Echo.                    ^|   [2] Microsoft Office 2013 Home Business               ^|
Echo.                    ^|   [3] Word 2013                                         ^|
Echo.                    ^|   [4] Excel 2013                                        ^|
Echo.                    ^|   [5] Powerpoint 2013                                   ^|
Echo.                    ^|   [6] One Note 2013                                     ^|
Echo.                    ^|   [7] Outlook 2013                                      ^|
Echo.                    ^|   [8] Publisher 2013                                    ^|
Echo.                    ^|   [9] Access 2013                                       ^|
Echo.                    ^|   [10] Project Pro 2013                                 ^|
Echo.                    ^|   [11] Visio Pro 2013                                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=ProfessionalRetail
if '%wahl%' == '2' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=HomeBusinessRetail
if '%wahl%' == '3' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=WordRetail
if '%wahl%' == '4' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=ExcelRetail
if '%wahl%' == '5' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=PowerPointRetail
if '%wahl%' == '6' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=OneNoteRetail
if '%wahl%' == '7' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=OutlookRetail
if '%wahl%' == '8' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=PublisherRetail
if '%wahl%' == '9' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=AccessRetail
if '%wahl%' == '10' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=ProjectProRetail
if '%wahl%' == '11' Start https://officeredir.microsoft.com/r/rlidO15C2RMediaDownload?p1=db&p2=en-US&p3=VisioProRetail
if '%wahl%' == '100' goto:Office
goto:OF13E

  :OF10G
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2010 German Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2010 Pro Plus (x64)              ^|
Echo.                    ^|   [2] Microsoft Office 2010 Pro Plus (x32)              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://download1.winandoffice.com/Volume/office/2010/DE/Office_Professional_Plus_2010_64Bit_German.ISO
if '%wahl%' == '2' Start https://download1.winandoffice.com/Volume/office/2010/DE/Office_Professional_Plus_2010_32Bit_German.ISO
if '%wahl%' == '100' goto:Office
goto:OF10G

  :OF10E
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2010 English Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2010 Pro Plus (x64)              ^|
Echo.                    ^|   [2] Microsoft Office 2010 Pro Plus (x32)              ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://download1.winandoffice.com/Volume/office/2010/EN/MicrosoftOffice2010ProfessionalPlus64bit.ISO
if '%wahl%' == '2' Start https://download1.winandoffice.com/Volume/office/2010/EN/MicrosoftOffice2010ProfessionalPlus32bit.ISO
if '%wahl%' == '100' goto:Office
goto:OF10E

  :OF07E
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2007 English Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2007 Enterprise English (x64)    ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://drive.google.com/uc?id=1JwY6NZQdeRvKYRh2qAkW2q601c6BTJ8y&export=download&goto:of07keyE
if '%wahl%' == '100' goto:Office
goto:OF07E

:of07keyE
mode con cols=98 lines=30
echo.      
echo                                    Microsoft Office English 2007    
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   Password for Extracting is 123SL                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   Extract to Desktop not to the TEMP Folder             ^|
Echo.                    ^|   Then after extracting run setup.exe                   ^|
Echo.                    ^|   then enter Product Key:                               ^|
Echo.                    ^|   Product Key is: KGFVY-7733B-8WCK9-KTG64-BC7D8         ^|
Echo.                    ^|   and it Installs Microsoft Office 2007 Enterprise      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '100' goto:Office
goto:of07keyE

  :OF07G
mode con cols=98 lines=30
echo.      
echo                                 Microsoft Office 2007 German Downloads   
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office 2007 Enterprise German (x64)     ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://mega.nz/file/p4JXBQLZ#AGoTaQ5Cku-IAQ2X2esl0LYeVzLanSBU-hcXz911ZZM&goto:of07keyG
if '%wahl%' == '100' goto:Office
goto:OF07G

 :of07keyG
mode con cols=98 lines=30
echo.      
echo                                    Microsoft Office German 2007    
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   Extract the Folder with WinRAR                        ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   Then after extracting run setup.exe                   ^|
Echo.                    ^|   then enter Product Key:                               ^|
Echo.                    ^|   Product Key is: KGFVY-7733B-8WCK9-KTG64-BC7D8         ^|
Echo.                    ^|   and it Installs Microsoft Office 2007 Enterprise      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '100' goto:Office
goto:of07keyG

 :OF02xpG
mode con cols=98 lines=30
echo.      
echo                                    Microsoft Office XP 2002 German    
echo.                      __________________________________________________________
Echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Microsoft Office XP 2002 German                   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [100] Return to Office menu                           ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' Start https://www.mediafire.com/file/f0ngas8hmkbts6v/Office+XP+2002++[by+RCG10].zip/file
if '%wahl%' == '100' goto:Office
goto:OF02xpG


=================================================================================================================

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

:EdiChange10/11nc
mode con cols=98 lines=30
echo.      
echo                        Which edition do you want to upgrade your Win 10/11 to
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Pro Edition Product Key 1                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Pro Edition Product Key 2                         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Pro for Workstation Edition                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Enterprise Edition                                ^|
echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Education Edition                                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Pro Education Edition                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
SET /p wahl=
if '%wahl%' == '1' goto:Pronc1
if '%wahl%' == '2' goto:Pronc2
if '%wahl%' == '3' goto:Profwnc
if '%wahl%' == '4' goto:Enterprisenc
if '%wahl%' == '5' goto:Edunc
if '%wahl%' == '6' goto:Edupronc
if '%wahl%' == '7' goto:Start
goto:EdiChange10/11nc

 :Pronc1
Dism /Online /Get-TargetEditions
sc config LicenseManager start= auto & net start LicenseManager
sc config wuauserv start= auto & net start wuauserv
changepk.exe /productkey MH37W-N47XK-V7XM9-C7227-GCQG9
echo.
echo Finished, in 10Sec you get redirectet to Start Menu
echo.
Timeout 10 /NOBREAK >nul
goto:Start

 :Pronc2
Dism /Online /Get-TargetEditions >nul
sc config LicenseManager start= auto & net start LicenseManager
sc config wuauserv start= auto & net start wuauserv
changepk.exe /productkey 2B87N-8KFHP-DKV6R-Y2C8J-PKCKT
echo.
echo Finished, in 10Sec you get redirectet to Start Menu
echo.
Timeout 10 /NOBREAK >nul
goto:Start

 :Prownc
Dism /Online /Get-TargetEditions >nul
sc config LicenseManager start= auto & net start LicenseManager
sc config wuauserv start= auto & net start wuauserv
changepk.exe /productkey WYPNQ-8C467-V2W6J-TX4WX-WT2RQ
echo.
echo Finished, in 10Sec you get redirectet to Start Menu
echo.
Timeout 10 /NOBREAK >nul
goto:Start

 :Enterprisenc
Dism /Online /Get-TargetEditions >nul
sc config LicenseManager start= auto & net start LicenseManager
sc config wuauserv start= auto & net start wuauserv
changepk.exe /productkey 2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
echo.
echo Finished, in 10Sec you get redirectet to Start Menu
echo.
Timeout 10 /NOBREAK >nul
goto:Start

 :Edunc
Dism /Online /Get-TargetEditions >nul
sc config LicenseManager start= auto & net start LicenseManager
sc config wuauserv start= auto & net start wuauserv
changepk.exe /productkey 3V6Q6-NQXCX-V8YXR-9QCYV-QPFCT
echo.
echo Finished, in 10Sec you get redirectet to Start Menu
echo.
Timeout 10 /NOBREAK >nul
goto:Start

 :Edupronc
Dism /Online /Get-TargetEditions >nul
sc config LicenseManager start= auto & net start LicenseManager
sc config wuauserv start= auto & net start wuauserv
changepk.exe /productkey GJTYN-HDMQY-FRR76-HVGC7-QPF8P
echo.
echo Finished, in 10Sec you get redirectet to Start Menu
echo.
Timeout 10 /NOBREAK >nul
goto:Start

 :EdiChange10/11
mode con cols=98 lines=30
echo.      
echo                        Which edition do you want to upgrade your Win 10/11 to
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Pro Edition                                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Pro for Workstation Edition                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Enterprise Edition                                ^|
echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Education Edition                                 ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [5] Pro Education Edition                             ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] Return to Start Menu                              ^|
Echo.                    ^|_________________________________________________________^|
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

 :Prot2
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr /skms kms8.msguides.com
slmgr /ipk VK7JG-NPHTM-C97JM-9MPGT-3V66T
slmgr /ato
echo Activate Pro Editon with [1] Digital License [2] Volume Key
echo.
SET /p wahl=
if '%wahl%' == '2' goto:Csl
if '%wahl%' == '1' goto:HWIDActivate
 goto:Start

 :Pro
Dism /Online /Get-TargetEditions >nul
sc config LicenseManager start= auto & net start LicenseManager >nul
sc config wuauserv start= auto & net start wuauserv >nul
changepk.exe /productkey VK7JG-NPHTM-C97JM-9MPGT-3V66T >nul
echo.
echo If error message popup its not worked, maybe try Method 2? (Y/N)
SET /p wahl=
if '%wahl%' == 'Y' goto:Prot2
if '%wahl%' == 'y' goto:Prot2
if '%wahl%' == 'N' goto:EdiChange10/11
if '%wahl%' == 'n' goto:EdiChange10/11
goto:Pro

 :Profw
Dism /Online /Get-TargetEditions >nul
sc config LicenseManager start= auto & net start LicenseManager >nul
sc config wuauserv start= auto & net start wuauserv >nul
changepk.exe /productkey NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J >nul
echo If error message popup its not worked, maybe try Method 2? (Y/N)
SET /p wahl=
if '%wahl%' == 'Y' goto:Profwt2
if '%wahl%' == 'y' goto:Profwt2
if '%wahl%' == 'n' goto:EdiChange10/11
if '%wahl%' == 'N' goto:EdiChange10/11


 :Profwt2
slmgr /ipk DXG7C-N36C4-C4HTG-X4T3X-2YV77 >nul
slmgr /skms kms8.msguides.com >nul
slmgr /ato >nul
echo.
echo Activate Professional Workstation Editon with [1] Digital License [2] Volume Key
echo.
SET /p wahl=
if '%wahl%' == '2' goto:Csl
if '%wahl%' == '1' goto:HWIDActivate
 goto:Start



 :Enterprise
Dism /Online /Get-TargetEditions >nul
sc config LicenseManager start= auto & net start LicenseManager >nul
sc config wuauserv start= auto & net start wuauserv >nul
changepk.exe /productkey NPPR9-FWDCX-D2C8J-H872K-2YT43 >nul
echo.
echo If error message popup its not worked, maybe try Method 2? (Y/N)
echo.
SET /p wahl=
if '%wahl%' == '2' goto:Csl
if '%wahl%' == '1' goto:HWIDActivate
 goto:Start


 :Enterpriset2
slmgr /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43 >nul
slmgr /skms kms8.msguides.com >nul
slmgr /ipk XGVPP-NMH47-7TTHJ-W3FW7-8HV2C >nul
slmgr /ato >nul
echo.
echo Activate Enterprise Editon with [1] Digital License [2] Volume Key
echo.
SET /p wahl=
if '%wahl%' == 'Y' goto:Enterprise
if '%wahl%' == 'y' goto:Enterprise
if '%wahl%' == 'N' goto:EdiChange10/11
if '%wahl%' == 'n' goto:EdiChange10/11
goto:Enterpriset2

 
:Edu
Dism /Online /Get-TargetEditions >nul
sc config LicenseManager start= auto & net start LicenseManager >nul
sc config wuauserv start= auto & net start wuauserv >nul
changepk.exe /productkey YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY >nul
echo.
echo If error message popup its not worked, maybe try Method 2? (Y/N)
echo.
SET /p wahl=
if '%wahl%' == 'Y' goto:Edut2
if '%wahl%' == 'y' goto:Edut2
if '%wahl%' == 'N' goto:EdiChange10/11
if '%wahl%' == 'n' goto:EdiChange10/11
 goto:Start



:Edut2
slmgr /ipk YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY´
slmgr /skms kms8.msguides.com
slmgr /ipk YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY
slmgr /ato
echo.
echo Activate Education Editon with [1] Digital License [2] Volume Key
echo.
SET /p wahl=
if '%wahl%' == '2' goto:Csl
if '%wahl%' == '1' goto:HWIDActivate
goto:Edut2



:Eduprot2
slmgr /ipk 8PTT6-RNW4C-6V7J2-C2D3X-MHBPB >nul´
slmgr /skms kms8.msguides.com >nul
slmgr /ipk 8PTT6-RNW4C-6V7J2-C2D3X-MHBPB >nul
slmgr /ato >nul
echo.
echo Activate Education Pro Editon with [1] Digital License [2] Volume Key
echo.
SET /p wahl=
if '%wahl%' == '2' goto:Csl
if '%wahl%' == '1' goto:HWIDActivate
:Edupro

Dism /Online /Get-TargetEditions >nul
sc config LicenseManager start= auto & net start LicenseManager >nul
sc config wuauserv start= auto & net start wuauserv >nul
changepk.exe /productkey YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY >nul
echo.
echo If error message popup its not worked, maybe try Method 2? (Y/N)
echo.
SET /p wahl=
if '%wahl%' == 'Y' goto:Eduprot2
if '%wahl%' == 'y' goto:Eduprot2
if '%wahl%' == 'N' goto:EdiChange10/11
if '%wahl%' == 'n' goto:EdiChange10/11
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
if '%wahl%' == '1' Start https://github.com/RCG10Lite/Windows-Activation-Tool/releases
if '%wahl%' == '2' Start https://rcg10.webador.de/wam-latest 
if '%wahl%' == '3' goto:Start
goto:LatestV

:Close
mode con cols=98 lines=30
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
echo.
pause > nul
echo cleaning up Temporary Files...
Timeout 10 /NOBREAK >nul
ping https://rcg10.webador.de >nul
del %temp%\tem1EFD.tmp >nul
del %temp%\editions >nul
del %username%\Desktop\BIN\GenuineTicket.xml >nul
exit

:IOFA
set WMI_VBS=0

@cls
set "_cmdf=%~f0"
if exist "%SystemRoot%\Sysnative\cmd.exe" (
setlocal EnableDelayedExpansion
start %SystemRoot%\Sysnative\cmd.exe /c ""!_cmdf!" "
exit /b
)
if exist "%SystemRoot%\SysArm32\cmd.exe" if /i %PROCESSOR_ARCHITECTURE%==AMD64 (
setlocal EnableDelayedExpansion
start %SystemRoot%\SysArm32\cmd.exe /c ""!_cmdf!" "
exit /b
)
color 1F
title Check Activation Status [wmi]
set wspp=SoftwareLicensingProduct
set wsps=SoftwareLicensingService
set ospp=OfficeSoftwareProtectionProduct
set osps=OfficeSoftwareProtectionService
set winApp=55c92734-d682-4d71-983e-d6ec3f16059f
set o14App=59a52881-a989-479d-af46-f275c6370663
set o15App=0ff1ce15-a989-479d-af46-f275c6370663
for %%# in (spp_get,ospp_get,cW1nd0ws,sppw,c0ff1ce15,sppo,osppsvc,ospp14,ospp15) do set "%%#="
for /f "tokens=6 delims=[]. " %%# in ('ver') do set winbuild=%%#
set "spp_get=Description, DiscoveredKeyManagementServiceMachineName, DiscoveredKeyManagementServiceMachinePort, EvaluationEndDate, GracePeriodRemaining, ID, KeyManagementServiceMachine, KeyManagementServicePort, KeyManagementServiceProductKeyID, LicenseStatus, LicenseStatusReason, Name, PartialProductKey, ProductKeyID, VLActivationInterval, VLRenewalInterval"
set "ospp_get=%spp_get%"
if %winbuild% GEQ 9200 set "spp_get=%spp_get%, KeyManagementServiceLookupDomain, VLActivationTypeEnabled"
if %winbuild% GEQ 9600 set "spp_get=%spp_get%, DiscoveredKeyManagementServiceMachineIpAddress, ProductKeyChannel"
set "_work=%~dp0"
set "_batf=%~f0"
set "_batp=%_batf:'=''%"
set "_Local=%LocalAppData%"
set _Identity=0
setlocal EnableDelayedExpansion
dir /b /s /a:-d "!_Local!\Microsoft\Office\Licenses\*1*" 1>nul 2>nul && set _Identity=1
dir /b /s /a:-d "!ProgramData!\Microsoft\Office\Licenses\*1*" 1>nul 2>nul && set _Identity=1
pushd "!_work!"
setlocal DisableDelayedExpansion
if %winbuild% LSS 9200 if not exist "%SystemRoot%\servicing\Packages\Microsoft-Windows-PowerShell-WTR-Package~*.mum" set _Identity=0
set _pwrsh=1
if not exist "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" set _pwrsh=0
set "_csg=cscript.exe //NoLogo //Job:WmiMulti "%~nx0?.wsf""
set "_csq=cscript.exe //NoLogo //Job:WmiQuery "%~nx0?.wsf""
set "_csx=cscript.exe //NoLogo //Job:XPDT "%~nx0?.wsf""
if %winbuild% GEQ 22483 set WMI_VBS=1
if %WMI_VBS% EQU 0 (
set "_zz1=wmic path"
set "_zz2=where"
set "_zz3=get"
set "_zz4=/value"
set "_zz5=("
set "_zz6=)"
set "_zz7="wmic path"
set "_zz8=/value""
) else (
set "_zz1=%_csq%"
set "_zz2="
set "_zz3="
set "_zz4="
set "_zz5=""
set "_zz6=""
set "_zz7=%_csq%"
set "_zz8="
)

set "SysPath=%SystemRoot%\System32"
if exist "%SystemRoot%\Sysnative\reg.exe" (set "SysPath=%SystemRoot%\Sysnative")
set "Path=%SysPath%;%SystemRoot%;%SysPath%\Wbem;%SysPath%\WindowsPowerShell\v1.0\"
set "line2=************************************************************"
set "line3=____________________________________________________________"

set _WSH=1
reg query "HKCU\SOFTWARE\Microsoft\Windows Script Host\Settings" /v Enabled 2>nul | find /i "0x0" 1>nul && (set _WSH=0)
reg query HKU\S-1-5-19 1>nul 2>nul && (
reg query "HKLM\SOFTWARE\Microsoft\Windows Script Host\Settings" /v Enabled 2>nul | find /i "0x0" 1>nul && (set _WSH=0)
)
if %_WSH% EQU 0 if %WMI_VBS% NEQ 0 goto :E_VBS

set OsppHook=1
sc query osppsvc >nul 2>&1
if %errorlevel% EQU 1060 set OsppHook=0

net start sppsvc /y >nul 2>&1
call :casWpkey %wspp% %winApp% cW1nd0ws sppw
if %winbuild% GEQ 9200 call :casWpkey %wspp% %o15App% c0ff1ce15 sppo
if %OsppHook% NEQ 0 (
net start osppsvc /y >nul 2>&1
call :casWpkey %ospp% %o14App% osppsvc ospp14
if %winbuild% LSS 9200 call :casWpkey %ospp% %o15App% osppsvc ospp15
)


:casWcon
set winID=0
set verbose=1
if not defined c0ff1ce15 (
if defined osppsvc goto :casWospp
goto :casWend
)
echo %line2%
echo ***                   Office Status                      ***
echo %line2%
set "_qr=%_zz7% %wspp% %_zz2% %_zz5%ApplicationID='%o15App%' and PartialProductKey is not null%_zz6% %_zz3% ID %_zz8%"
for /f "tokens=2 delims==" %%# in ('%_qr%') do (
  set "chkID=%%#"
  call :casWdet "%wspp%" "%wsps%" "%spp_get%"
  call :casWout
  echo %line3%
  echo.
)
set verbose=0
if defined osppsvc goto :casWospp
goto :casWend

:casWospp
if %verbose% EQU 1 (
echo %line2%
echo ***                   Office Status                      ***
echo %line2%
)
set "_qr=%_zz7% %ospp% %_zz2% %_zz5%ApplicationID='%o15App%' and PartialProductKey is not null%_zz6% %_zz3% ID %_zz8%"
if defined ospp15 for /f "tokens=2 delims==" %%# in ('%_qr%') do (
  set "chkID=%%#"
  call :casWdet "%ospp%" "%osps%" "%ospp_get%"
  call :casWout
  echo %line3%
  echo.
)
set "_qr=%_zz7% %ospp% %_zz2% %_zz5%ApplicationID='%o14App%' and PartialProductKey is not null%_zz6% %_zz3% ID %_zz8%"
if defined ospp14 for /f "tokens=2 delims==" %%# in ('%_qr%') do (
  set "chkID=%%#"
  call :casWdet "%ospp%" "%osps%" "%ospp_get%"
  call :casWout
  echo %line3%
  echo.
)
goto :casWend

:casWpkey
set "_qr=%_zz1% %1 %_zz2% %_zz5%ApplicationID='%2' and PartialProductKey is not null%_zz6% %_zz3% ID %_zz4%"
%_qr% 2>nul | findstr /i ID 1>nul && (set %3=1&set %4=1)
exit /b

:casWdet
for %%# in (%~3) do set "%%#="
if /i %~1==%ospp% for %%# in (DiscoveredKeyManagementServiceMachineIpAddress, KeyManagementServiceLookupDomain, ProductKeyChannel, VLActivationTypeEnabled) do set "%%#="
set "cKmsClient="
set "cTblClient="
set "cAvmClient="
set "ExpireMsg="
set "_xpr="
set "_qr="wmic path %~1 where ID='%chkID%' get %~3 /value" ^| findstr ^="
if %WMI_VBS% NEQ 0 set "_qr=%_csg% %~1 "ID='%chkID%'" "%~3""
for /f "tokens=* delims=" %%# in ('%_qr%') do set "%%#"

set /a _gpr=(GracePeriodRemaining+1440-1)/1440
echo %Description%| findstr /i VOLUME_KMSCLIENT 1>nul && (set cKmsClient=1&set _mTag=Volume)
echo %Description%| findstr /i TIMEBASED_ 1>nul && (set cTblClient=1&set _mTag=Timebased)
echo %Description%| findstr /i VIRTUAL_MACHINE_ACTIVATION 1>nul && (set cAvmClient=1&set _mTag=Automatic VM)
cmd /c exit /b %LicenseStatusReason%
set "LicenseReason=%=ExitCode%"
set "LicenseMsg=Time remaining: %GracePeriodRemaining% minute(s) (%_gpr% day(s))"
if %_gpr% GEQ 1 if %_WSH% EQU 1 (
for /f "tokens=* delims=" %%# in ('%_csx% %GracePeriodRemaining%') do set "_xpr=%%#"
)
if %_gpr% GEQ 1 if %_pwrsh% EQU 1 if not defined _xpr (
for /f "tokens=* delims=" %%# in ('powershell "$([DateTime]::Now.addMinutes(%GracePeriodRemaining%)).ToString('yyyy-MM-dd HH:mm:ss')" 2^>nul') do set "_xpr=%%#"
title Check Activation Status [wmi]
)

if %LicenseStatus% EQU 0 (
set "License=Unlicensed"
set "LicenseMsg="
)
if %LicenseStatus% EQU 1 (
set "License=Licensed"
set "LicenseMsg="
if %GracePeriodRemaining% EQU 0 (
  if %winID% EQU 1 (set "ExpireMsg=The machine is permanently activated.") else (set "ExpireMsg=The product is permanently activated.")
  ) else (
  set "LicenseMsg=%_mTag% activation expiration: %GracePeriodRemaining% minute(s) (%_gpr% day(s))"
  if defined _xpr set "ExpireMsg=%_mTag% activation will expire %_xpr%"
  )
)
if %LicenseStatus% EQU 2 (
set "License=Initial grace period"
if defined _xpr set "ExpireMsg=Initial grace period ends %_xpr%"
)
if %LicenseStatus% EQU 3 (
set "License=Additional grace period (KMS license expired or hardware out of tolerance)"
if defined _xpr set "ExpireMsg=Additional grace period ends %_xpr%"
)
if %LicenseStatus% EQU 4 (
set "License=Non-genuine grace period."
if defined _xpr set "ExpireMsg=Non-genuine grace period ends %_xpr%"
)
if %LicenseStatus% EQU 6 (
set "License=Extended grace period"
if defined _xpr set "ExpireMsg=Extended grace period ends %_xpr%"
)
if %LicenseStatus% EQU 5 (
set "License=Notification"
  if "%LicenseReason%"=="C004F200" (set "LicenseMsg=Notification Reason: 0xC004F200 (non-genuine)."
  ) else if "%LicenseReason%"=="C004F009" (set "LicenseMsg=Notification Reason: 0xC004F009 (grace time expired)."
  ) else (set "LicenseMsg=Notification Reason: 0x%LicenseReason%"
  )
)
if %LicenseStatus% GTR 6 (
set "License=Unknown"
set "LicenseMsg="
)
if not defined cKmsClient exit /b

if %KeyManagementServicePort%==0 set KeyManagementServicePort=1688
set "KmsReg=Registered KMS machine name: %KeyManagementServiceMachine%:%KeyManagementServicePort%"
if "%KeyManagementServiceMachine%"=="" set "KmsReg=Registered KMS machine name: KMS name not available"

if %DiscoveredKeyManagementServiceMachinePort%==0 set DiscoveredKeyManagementServiceMachinePort=1688
set "KmsDns=KMS machine name from DNS: %DiscoveredKeyManagementServiceMachineName%:%DiscoveredKeyManagementServiceMachinePort%"
if "%DiscoveredKeyManagementServiceMachineName%"=="" set "KmsDns=DNS auto-discovery: KMS name not available"

set "_qr="wmic path %~2 get ClientMachineID, KeyManagementServiceHostCaching /value" ^| findstr ^="
if %WMI_VBS% NEQ 0 set "_qr=%_csg% %~2 "ClientMachineID, KeyManagementServiceHostCaching""
for /f "tokens=* delims=" %%# in ('%_qr%') do set "%%#"
if /i %KeyManagementServiceHostCaching%==True (set KeyManagementServiceHostCaching=Enabled) else (set KeyManagementServiceHostCaching=Disabled)

if %winbuild% LSS 9200 exit /b
if /i %~1==%ospp% exit /b

if "%KeyManagementServiceLookupDomain%"=="" set "KeyManagementServiceLookupDomain="

if %VLActivationTypeEnabled% EQU 3 (
set VLActivationType=Token
) else if %VLActivationTypeEnabled% EQU 2 (
set VLActivationType=KMS
) else if %VLActivationTypeEnabled% EQU 1 (
set VLActivationType=AD
) else (
set VLActivationType=All
)

if %winbuild% LSS 9600 exit /b
if "%DiscoveredKeyManagementServiceMachineIpAddress%"=="" set "DiscoveredKeyManagementServiceMachineIpAddress=not available"
exit /b

:casWout
echo.
echo Name: %Name%
echo Description: %Description%
echo Activation ID: %ID%
echo Extended PID: %ProductKeyID%
if defined ProductKeyChannel echo Product Key Channel: %ProductKeyChannel%
echo Partial Product Key: %PartialProductKey%
echo License Status: %License%
if defined LicenseMsg echo %LicenseMsg%
if not %LicenseStatus%==0 if not %EvaluationEndDate:~0,8%==16010101 echo Evaluation End Date: %EvaluationEndDate:~0,4%-%EvaluationEndDate:~4,2%-%EvaluationEndDate:~6,2% %EvaluationEndDate:~8,2%:%EvaluationEndDate:~10,2% UTC
if not defined cKmsClient (
if defined ExpireMsg echo.&echo.    %ExpireMsg%
exit /b
)
if defined VLActivationTypeEnabled echo Configured Activation Type: %VLActivationType%
echo.
if not %LicenseStatus%==1 (
echo Please activate the product in order to update KMS client information values.
exit /b
)
echo Most recent activation information:
echo Key Management Service client information
echo.    Client Machine ID (CMID): %ClientMachineID%
echo.    %KmsDns%
echo.    %KmsReg%
if defined DiscoveredKeyManagementServiceMachineIpAddress echo.    KMS machine IP address: %DiscoveredKeyManagementServiceMachineIpAddress%
echo.    KMS machine extended PID: %KeyManagementServiceProductKeyID%
echo.    Activation interval: %VLActivationInterval% minutes
echo.    Renewal interval: %VLRenewalInterval% minutes
echo.    KMS host caching: %KeyManagementServiceHostCaching%
if defined KeyManagementServiceLookupDomain echo.    KMS SRV record lookup domain: %KeyManagementServiceLookupDomain%
if defined ExpireMsg echo.&echo.    %ExpireMsg%
exit /b

:casWend
if %_Identity% EQU 1 if %_pwrsh% EQU 1 (
echo %line2%
echo ***                  Office vNext Status                 ***
echo %line2%
setlocal EnableDelayedExpansion
powershell "$f=[IO.File]::ReadAllText('!_batp!') -split ':vNextDiag\:.*';iex ($f[1])"
title Check Activation Status [wmi]
echo %line3%
echo.
)
echo.
echo Press any key to exit.
pause >nul
exit /b

:E_VBS
echo ==== ERROR ====
echo Windows Script Host is disabled.
echo It is required for this script to work.
echo.
echo Press any key to exit.
pause >nul
exit /b

:vNextDiag:
function PrintModePerPridFromRegistry
{
	$vNextRegkey = "HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\Licensing\LicensingNext"
	$vNextPrids = Get-Item -Path $vNextRegkey -ErrorAction Ignore | Select-Object -ExpandProperty 'property' | Where-Object -FilterScript {$_ -Ne 'InstalledGraceKey' -And $_ -Ne 'MigrationToV5Done' -And $_ -Ne 'test' -And $_ -Ne 'unknown'}
	If ($vNextPrids -Eq $null)
	{
		Write-Host "No registry keys found."
		Return
	}
	$vNextPrids | ForEach `
	{
		$mode = (Get-ItemProperty -Path $vNextRegkey -Name $_).$_
		Switch ($mode)
		{
			2 { $mode = "vNext"; Break }
			3 { $mode = "Device"; Break }
			Default { $mode = "Legacy"; Break }
		}
		Write-Host $_ = $mode
	}
}
function PrintSharedComputerLicensing
{
	$scaRegKey = "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
	$scaValue = Get-ItemProperty -Path $scaRegKey -ErrorAction Ignore | Select-Object -ExpandProperty "SharedComputerLicensing" -ErrorAction Ignore
	$scaRegKey2 = "HKLM:\SOFTWARE\Microsoft\Office\16.0\Common\Licensing"
	$scaValue2 = Get-ItemProperty -Path $scaRegKey2 -ErrorAction Ignore | Select-Object -ExpandProperty "SharedComputerLicensing" -ErrorAction Ignore
	$scaPolicyKey = "HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common\Licensing"
	$scaPolicyValue = Get-ItemProperty -Path $scaPolicyKey -ErrorAction Ignore | Select-Object -ExpandProperty "SharedComputerLicensing" -ErrorAction Ignore
	If ($scaValue -Eq $null -And $scaValue2 -Eq $null -And $scaPolicyValue -Eq $null)
	{
		Write-Host "No registry keys found."
		Return
	}
	$scaModeValue = $scaValue -Or $scaValue2 -Or $scaPolicyValue
	If ($scaModeValue -Eq 0)
	{
		$scaMode = "Disabled"
	}
	If ($scaModeValue -Eq 1)
	{
		$scaMode = "Enabled"
	}
	Write-Host "SharedComputerLicensing" = $scaMode
	Write-Host
	$tokenFiles = $null
	$tokenPath = "${env:LOCALAPPDATA}\Microsoft\Office\16.0\Licensing"
	If (Test-Path $tokenPath)
	{
		$tokenFiles = Get-ChildItem -Path $tokenPath -Recurse -File -Filter "*authString*"
	}
	If ($tokenFiles.length -Eq 0)
	{
		Write-Host "No tokens found."
		Return
	}
	$tokenFiles | ForEach `
	{
		$tokenParts = (Get-Content -Encoding Unicode -Path $_.FullName).Split('_')
		$output = [PSCustomObject] `
			@{
				ACID = $tokenParts[0];
				User = $tokenParts[3]
				NotBefore = $tokenParts[4];
				NotAfter = $tokenParts[5];
			} | ConvertTo-Json
		Write-Host $output
	}
}
function PrintLicensesInformation
{
	Param(
		[ValidateSet("NUL", "Device")]
		[String]$mode
	)
	If ($mode -Eq "NUL")
	{
		$licensePath = "${env:LOCALAPPDATA}\Microsoft\Office\Licenses"
	}
	ElseIf ($mode -Eq "Device")
	{
		$licensePath = "${env:PROGRAMDATA}\Microsoft\Office\Licenses"
	}
	$licenseFiles = $null
	If (Test-Path $licensePath)
	{
		$licenseFiles = Get-ChildItem -Path $licensePath -Recurse -File
	}
	If ($licenseFiles.length -Eq 0)
	{
		Write-Host "No licenses found."
		Return
	}
	$licenseFiles | ForEach `
	{
		$license = (Get-Content -Encoding Unicode $_.FullName | ConvertFrom-Json).License
		$decodedLicense = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($license)) | ConvertFrom-Json
		$licenseType = $decodedLicense.LicenseType
		$userId = $decodedLicense.Metadata.UserId
		$identitiesRegkey = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Office\16.0\Common\Identity\Identities\${userId}*" -ErrorAction Ignore
		$licenseState = $null
		If ((Get-Date) -Gt (Get-Date $decodedLicense.MetaData.NotAfter))
		{
			$licenseState = "RFM"
		}
		ElseIf (($decodedLicense.ExpiresOn -Eq $null) -Or
			((Get-Date) -Lt (Get-Date $decodedLicense.ExpiresOn)))
		{
			$licenseState = "Licensed"
		}
		Else
		{
			$licenseState = "Grace"
		}
		if ($mode -Eq "NUL")
		{
			$output = [PSCustomObject] `
			@{
				Version = $_.Directory.Name
				Type = "User|${licenseType}";
				Product = $decodedLicense.ProductReleaseId;
				Acid = $decodedLicense.Acid;
				LicenseState = $licenseState;
				EntitlementStatus = $decodedLicense.Status;
				ReasonCode = $decodedLicense.ReasonCode;
				NotBefore = $decodedLicense.Metadata.NotBefore;
				NotAfter = $decodedLicense.Metadata.NotAfter;
				NextRenewal = $decodedLicense.Metadata.RenewAfter;
				Expiration = $decodedLicense.ExpiresOn;
				TenantId = $decodedLicense.Metadata.TenantId;
			} | ConvertTo-Json
		}
		ElseIf ($mode -Eq "Device")
		{
			$output = [PSCustomObject] `
			@{
				Version = $_.Directory.Name
				Type = "Device|${licenseType}";
				Product = $decodedLicense.ProductReleaseId;
				Acid = $decodedLicense.Acid;
				DeviceId = $decodedLicense.Metadata.DeviceId;
				LicenseState = $licenseState;
				EntitlementStatus = $decodedLicense.Status;
				ReasonCode = $decodedLicense.ReasonCode;
				NotBefore = $decodedLicense.Metadata.NotBefore;
				NotAfter = $decodedLicense.Metadata.NotAfter;
				NextRenewal = $decodedLicense.Metadata.RenewAfter;
				Expiration = $decodedLicense.ExpiresOn;
				TenantId = $decodedLicense.Metadata.TenantId;
			} | ConvertTo-Json
		}
		Write-Output $output
	}
}
	Write-Host
	Write-Host "========== Mode per ProductReleaseId =========="
	Write-Host
PrintModePerPridFromRegistry
	Write-Host
	Write-Host "========== Shared Computer Licensing =========="
	Write-Host
PrintSharedComputerLicensing
	Write-Host
	Write-Host "========== vNext licenses =========="
	Write-Host
PrintLicensesInformation -Mode "NUL"
	Write-Host
	Write-Host "========== Device licenses =========="
	Write-Host
PrintLicensesInformation -Mode "Device"
:vNextDiag:
color 1F
----- Begin wsf script --->
<package>
   <job id="WmiQuery">
      <script language="VBScript">
         If WScript.Arguments.Count = 3 Then
            wExc = "Select " & WScript.Arguments.Item(2) & " from " & WScript.Arguments.Item(0) & " where " & WScript.Arguments.Item(1)
            wGet = WScript.Arguments.Item(2)
         Else
            wExc = "Select " & WScript.Arguments.Item(1) & " from " & WScript.Arguments.Item(0)
            wGet = WScript.Arguments.Item(1)
         End If
         Set objCol = GetObject("winmgmts:\\.\root\CIMV2").ExecQuery(wExc,,48)
         For Each objItm in objCol
            For each Prop in objItm.Properties_
               If LCase(Prop.Name) = LCase(wGet) Then
                  WScript.Echo Prop.Name & "=" & Prop.Value
                  Exit For
               End If
            Next
         Next
      </script>
   </job>
   <job id="WmiMulti">
      <script language="VBScript">
         If WScript.Arguments.Count = 3 Then
            wExc = "Select " & WScript.Arguments.Item(2) & " from " & WScript.Arguments.Item(0) & " where " & WScript.Arguments.Item(1)
         Else
            wExc = "Select " & WScript.Arguments.Item(1) & " from " & WScript.Arguments.Item(0)
         End If
         Set objCol = GetObject("winmgmts:\\.\root\CIMV2").ExecQuery(wExc,,48)
         For Each objItm in objCol
            For each Prop in objItm.Properties_
               WScript.Echo Prop.Name & "=" & Prop.Value
            Next
         Next
      </script>
   </job>
   <job id="XPDT">
      <script language="VBScript">
         WScript.Echo DateAdd("n", WScript.Arguments.Item(0), Now)
      </script>
   </job>
color 1F
</package>
color 1F