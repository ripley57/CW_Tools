@ECHO off 

set arg=%1

if [%arg%]==[] (
    set arg="."
)

for %%f in (%arg%\*) do (
	call :sub_runit "%%f"
)

:sub_runit
    if [%1]==[] (
		rem echo No file name passed
		GOTO:EOF
	)

	set attr=%~a1
	set dirattr=%attr:~0,1%
	if /I "%dirattr%"=="d" (
		rem echo Skipping folder %1
		GOTO:EOF
	)
	
    if "%~nx1"=="allfiletimes.bat" (
		echo Skipping %~f1
		GOTO:EOF
	)
	
	if "%~nx1"=="filetimes.exe" (
		echo Skipping %~f1
		GOTO:EOF
	)

	echo.
	echo %~f1
	filetimes.exe "%~f1"
	GOTO:EOF