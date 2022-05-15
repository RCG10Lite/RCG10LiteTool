@echo off
@setlocal DisableDelayedExpansion
title Please Start with Admin Rights
color 1F

::===========================================================================
fsutil dirty query %systemdrive%  >nul 2>&1 || (
echo ==== ERROR ====
echo This script require administrator privileges.
echo To do so, right click on this script and select 'Run as administrator'
echo.
echo Press any key to exit...
pause >nul
exit
)
::===========================================================================
title Windows Activation Tool (Pre-Realese V1.14.5+ by @rcg10)
:Start
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
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [1] Activate Windows 10/11 with Digital License       ^|               
Echo.                    ^|                                                         ^|
Echo.                    ^|   [2] Activate Windows 10/11 with Organisation Key      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [3] Activate Windows 8/8.1                            ^|  
Echo.                    ^|                                                         ^|
Echo.                    ^|   [4] Activate Windows 7                                ^|
Echo.                    ^|                   _______________                       ^|
echo.                    ^|                                                         ^| 
Echo.                    ^|   [5] Change Windows 10/11 Edition                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [6] $OEM$ (Pre Activate in ISO)                       ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [7] Check if Windows is Activated                     ^|
Echo.                    ^|                   _______________                       ^|
echo.                    ^|                                                         ^|  
Echo.                    ^|   [8] Read Me                                           ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [9] About Script                                      ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [10] Check for Newer Versions of This Script?         ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [11] Exit Script                                      ^|
Echo.                    ^|_________________________________________________________^|
ECHO.
echo.
echo.                        Enter your Choice: [1,2,3,4,5,6,7,8,9,10,11] :
SET /p wahl=
if '%wahl%' == '2' goto:Really
if '%wahl%' == '1' goto:HWIDActivate
if '%wahl%' == '3' goto:Really8
if '%wahl%' == '4' goto:Really7
if '%wahl%' == '5' goto:EdiChange10/11
if '%wahl%' == '6' goto:EInfo
if '%wahl%' == '9' goto:ReadMe
if '%wahl%' == '8' goto:ReadMe2
if '%wahl%' == '10' goto:CfnSc
if '%wahl%' == '7' goto:Checkiwa
if '%wahl%' == '11' goto:Close
if '%wahl%' == '69' goto:Website
if '%wahl%' == '420' goto:Win7anytime
if '%wahl%' == 'rcg10' goto:Secret1



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

 :CfnSc

echo Want to check for newer Version of this Script? (Y/N)

SET /p wahl=
if '%wahl%' == 'n' goto:Start
if '%wahl%' == 'N' goto:Start
if '%wahl%' == 'y' goto:LatestV
if '%wahl%' == 'Y' goto:LatestV
goto:CfnSc

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
goto:MainMenu
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

 :Really

echo ---
echo Really want to Activate your Edition of Windows 10/11 now? (Y/N)
echo ---
SET /p wahl=
if '%wahl%' == 'n' goto:Start
if '%wahl%' == 'N' goto:Start
if '%wahl%' == 'y' goto:Csl
if '%wahl%' == 'Y' goto:Csl
goto:Really
 :Csl

echo --- 
echo Your Edition of Windows gets now activated
echo ---
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

echo Windows was Activated
echo ---
pause
echo ---
goto:Start

:Really7
echo ---
echo Really want to Activate your Version of Windows 7 now? (Y/N)
echo ---
SET /p wahl=
if '%wahl%' == 'n' goto:Start
if '%wahl%' == 'y' goto:Win7ac
goto:Really7
 
:Win7ac
echo ---
echo Your Edition of Windows 7 gets Activated
echo ---
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 7JQWQ-K6KWQ-BJD6C-K3YVH-DVQJG >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk 33PXH-7Y6KF-2VJC9-XBBR8-HVTHH >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk YDRBP-3D83W-TY26F-D46B2-XCKRJ >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk C29WB-22CC8-VJ326-GHFJW-H9DH4 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4 >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk MRPKT-YTG23-K7D7T-X2JMM-QY7MG >nul
cscript //nologo c:\windows\system32\slmgr.vbs /ipk W82YF-2Q76Y-63HXB-FGJG9-GF7QX >nul
echo Your Edition of Windows 7 was Activated
echo ---
pause
echo ---
 goto:Start


:Win7anytime
echo ---
echo Search Windows Anytime Upgrade in the Search bar and enter this code:
echo ---
echo RHPQ2-RMFJH-74XYM-BH4JX-XM76F
echo ---
echo Then the Key gets Verifyd
echo ---
echo after that you have to accept the License of Terms in which you click "i accept"
echo ---
echo then you click "cancel"
echo ---
echo Now your Windows 7 Edition gots Upgraded to Windows 7 Home Premium
echo ---
echo after that you activate your Windows in this script
echo ---
echo (U)pgrade now or (R)eturn to Start
SET /p wahl=
if '%wahl%' == 'r' goto:Start
if '%wahl%' == 'R' goto:Start
if '%wahl%' == 'U' goto:Win7ac
if '%wahl%' == 'u' goto:Win7ac
goto:Win7anytime



 :Really8
echo ---
echo Really want to Activate your Edition of Windows 8/8.1 now? (Y/N)
echo ---
SET /p wahl=
if '%wahl%' == 'n' goto:Start
if '%wahl%' == 'y' goto:Win8ac
goto:Really8
:Win8ac
echo ---
echo Your Edition of Windows 8/8.1 gets Activated
echo ---
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
echo Your Edition of Windows 8/8.1 was Activated
echo ---
goto:Start
echo ---



:EInfo

echo This Action Requires the BIN Folder who you can find on rcg10.webador.de or with an Media Fire Link, if you dont have the BIN folder it only Drops empty Folder
echo (E)xtract, (B)IN Folder Download or (R)eturn to Start?
SET /p wahl=
if '%wahl%' == 'E' goto:Extract
if '%wahl%' == 'e' goto:Extract
if '%wahl%' == 'B' goto:BINf
if '%wahl%' == 'b' goto:BINf
if '%wahl%' == 'R' goto:Start
if '%wahl%' == 'r' goto:Start
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


 :ReadMe

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
echo.      
echo.                 
echo.                     _________________________________________________________
echo.                    ^|                                                         ^|
Echo.                    ^|   [Script coded by @RCG10]                              ^|               
Echo.                    ^|                                                         ^|
Echo.                    ^|   [Script is Version 1.14.5+ Pre-Realese]               ^|  
Echo.                    ^|                                                         ^|
Echo.                    ^|   [Other OS than 7/8/8.1/10/11 wont Work]               ^|
Echo.                    ^|                   _______________                       ^|
echo.                    ^|                                                         ^| 
Echo.                    ^|   [To find out your Windows Version and edition         ^|
echo                     ^|     click Windows + r at the same time and type in      ^|
echo.                    ^|      winver to lock your Windows Version and Edition]   ^|
Echo.                    ^|                                                         ^|
Echo.                    ^|   [Without the BIN File $OEM$ and other Functions       ^|
Echo.                    ^|    wont Work]                                           ^|
Echo.                    ^|_________________________________________________________^|
ECHO.
echo [1] Return to Start Menu
SET /p wahl=
if '%wahl%' == '1' goto:Start
goto:ReadMe

 :Preacread

echo ===============================================================================================
echo  # Windows 10 Preactivate:                                                                     
echo  -                                                                                               
echo  - To preactivate the system during installation,Do the following things.                      
echo  Use option No. 6 in script and extract the $OEM$ Folder to Desktop. Now copy this $OEM$     
echo    Folder to "sources" folder in the installation media.                                       
echo    The directory will appear like this. iso/usb: \sources\$OEM$\                               
echo    Now use this iso/usb to install Windows 10 and it'll auto activate at first online contact. 
echo  ===============================================================================================
echo [1] to Return to Start [2] for ReadMe
SET /p wahl=
if '%wahl%' == '1' goto:Start
if '%wahl%' == '2' goto:ReadMe
goto:Preacred

 :ReadMe2


echo. 
echo. ===============================================================================================
echo # Remarks:                                                                                    
echo.                                                                                               
echo - This script does not install any files in your system.                                      
echo.                                                                                              
echo - For Successful Instant Activation,The Windows Update Service and Internet Must be Enabled.  
echo   If you are running it anyway then system will auto-activate later when you enable the       
echo   Windows update service and Internet.                                                        
echo.                                                                                               
echo - Use of VPN, and privacy, anti spy tools, privacy-based hosts and firewall's rules           
echo   may cause (due to blocking of some MS servers) problems in successful Activation.           
echo.                                                                                               
echo - You may see an Error about 'Blocked key' or other errors in activation process. 
echo   Note that reasons behind these errors are either above mentioned reasons or corrupt 
echo   system files or rarely MS server problem.   
echo   'Blocked key' error appears because system couldn't contact MS servers for activation,  
echo   This script activation process actually doesn't use any Blocked Keys.
echo. ===============================================================================================
echo.
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
echo.  # Fix Tip:
echo.   If you having activation errors, try to rebuild licensing Tokens.dat as suggested:
echo.   https://support.microsoft.com/en-us/help/2736303
echo. 
echo.   launch command prompt as admin and execute these commands respectively:
echo.   net stop sppsvc
echo.   ren %windir%\System32\spp\store\2.0\tokens.dat tokens.bar
echo.   net start sppsvc
echo.   cscript %windir%\system32\slmgr.vbs /rilc
echo. 
echo.   then restart the system twice,
echo.   afterwards, run the script to activate. 																						   
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
echo ---
echo Change your Windows 10/11 to 
echo --- 
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

changepk.exe /productkey NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J

goto:Cls

 :Profw

slmgr /ipk DXG7C-N36C4-C4HTG-X4T3X-2YV77

slmgr /skms kms8.msguides.com

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

 goto:Cls

 :Enterprise

slmgr /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43

slmgr /skms kms8.msguides.com

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

pause

 goto:Csl
 
:Edu


slmgr /ipk YNMGQ-8RYV3-4PGQ3-C8XTP-7CFBY

slmgr /skms kms8.msguides.com

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

 goto:Cls

 :Edupro

slmgr /ipk 8PTT6-RNW4C-6V7J2-C2D3X-MHBPB

slmgr /skms kms8.msguides.com

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

 goto:Cls

 :Website
START "" https://rcg10.webador.de/tools
goto:Start

 :LatestV
echo [1]  All Versions (GitHub) [2] Newer Version (Website)[3] Return to Menu
SET /p wahl=
if '%wahl%' == '2' goto::WebadorNew
if '%wahl%' == '1' goto:Githubnew
if '%wahl%' == '3' goto:Start
goto:Start

:Githubnew
START "" https://github.com/RCG10Lite/Windows-Activation-Tool/releases

:WebadorNew
Start "" https://rcg10.webador.de/wam-latest
goto:Start

 :Mediafirenew
Start "" https://www.mediafire.com/file/i40axuxs767f7qx/Windows+Activation+Tool+V1.12.1+.bat/file
goto:Start

 :BINf
START "" https://www.mediafire.com/file/kbkd5anlsbbch5l/Bin+Folder.zip/file
goto:Start
 
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

:======================================================================================================================================================