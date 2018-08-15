@echo off
REM Description:
REM		Create registry entry for our made-up protocol "appurl://",
REM		and copy appurl.exe to C:\TEMP\ to be used by the protocol.
REM
REM JeremyC 11-6-2018

set pwd=%~dp0

cls

if not exist c:\temp\appurl.exe (
	echo.
	echo Adding appurl protocol to the Registry...

	REM More on reg.exe here: https://ss64.com/nt/reg.html
	reg import ".\appurl.reg" || (
		echo.
		echo *******************************************
		echo * ERROR: Failed to update the Registry!   *
		echo * Re-run this script as an administrator. *
		echo *******************************************
		echo.
		goto :end
	)
	
	echo.
	echo Copying appurl.exe to c:\temp\...
	copy %pwd%\appurl.exe c:\temp\ 
	
	echo.
	echo Installation of appurl completed successfully!
	echo.
) else (
	echo Doing nothing. File appurl.exe is already installed.
)
:end
