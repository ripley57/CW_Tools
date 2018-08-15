@echo off
:: No dir passed so assume current dir
if %1.==. set PST_FILE_MASK="%~dp0*.pst"

:: If file passed use the file
if exist "%~dpnx1" set PST_FILE_MASK="%~dpnx1"

:: If dir passed use the dir
if exist "%~dpnx1\*.pst" set PST_FILE_MASK="%~dpnx1\*.pst"

:: Use path of Outlook to find SCANPST.EXE
set TESTK=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\OUTLOOK.EXE
set TESTV=Path
FOR /F "tokens=2* delims=	 " %%A IN ('REG QUERY "%TESTK%" /v %TESTV%') DO SET RETURN=%%B
set SCANPST_PATH="%RETURN%SCANPST.EXE"

echo --------------------------------------------------
echo - %~nx0
echo -
echo - PST file cleanup tool
echo -
echo - There are 3 methods of starting this tool
echo - 1 Put %~nx0 and ScanPSTOne.exe
echo -   in the PST folder and dbl-click %~nx0
echo - 2 Drag and drop single a PST files onto %~nx0
echo - 3 Drag and drop a folder onto %~nx0
echo - 
echo - About to run 'scanpst.exe' against these .pst files
echo - %PST_FILE_MASK%
echo -
echo - Scanpst.exe: %SCANPST_PATH%
echo --------------------------------------------------
set /P scanmax=Enter max repair attempts for each file (Press enter for 5):||set scanmax=5

if not exist %SCANPST_PATH% GOTO :ERR1
::if not "%PST_FILE_MASK:~2,1%"==":" GOTO :ERR2 no longer needed
::cd "%~dp0"
echo -------- List of files to be repaired -----------
:: ----------------------- Display files
SETLOCAL ENABLEDELAYEDEXPANSION
set c=0
for %%i in (%PST_FILE_MASK%) do (
	set pst=%%~i
	set /a c=!c!+1
	@echo !c!: !pst!
)
:: ----------------------- Display files

pause
if exist "%~dp0ScanPSTOne.log" del "%~dp0ScanPSTOne.log"
echo -------- Cleaning files  -----------
:: ----------------------- Loop through files
SETLOCAL ENABLEDELAYEDEXPANSION
set c=0
for %%i in (%PST_FILE_MASK%) do (
	set pst=%%~i
	set /a c=!c!+1
	@echo !c!: !pst!
	set scancount=0
	CALL :CHECK
)
GOTO :DONESCAN

:CHECK
	set /a "scancount=scancount+1"
	if %scancount% GTR %scanmax% echo ...Max scans (%scanmax%) giving up. & GOTO :CHECKEXIT
	"%~dp0ScanPSTOne.exe" %SCANPST_PATH% "!pst!" N
	if errorlevel 3 goto :ERR3
	if errorlevel 2 if not errorlevel 3 echo ...Errors found and repaired. & GOTO :CHECK
	if errorlevel 1 if not errorlevel 2 echo ...Minor inconcistancies found and repaired. & GOTO :CHECK
	if errorlevel 0 if not errorlevel 1 echo ...OK
:CHECKEXIT
exit /b
:: ----------------------- Loop through files

:DONESCAN
if not exist "%~dp0ScanPSTOne.log" GOTO :done
start "" notepad.exe "%~dp0ScanPSTOne.log"
GOTO :done

:ERR1
echo Err. Couldn't find %SCANPST_PATH%
GOTO :done

:ERR2
echo Err. %PST_FILE_MASK% can't be a UNC path.
GOTO :done

:ERR3
echo Err. STOPPED. Last file shown had a problem. Will now show 'ScanPSTOne.log'
pause
start "" notepad.exe "%~dp0ScanPSTOne.log"
GOTO :done

:done
echo --------------------------------------------------
echo Done.
pause
EXIT /b 0
