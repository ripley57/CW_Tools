@ECHO off 

set arg=%1

if "%arg%"=="" (
    set arg="."
)

for %%f in ("%arg%"\*) do (
	call :sub_runit "%%f"
)

:sub_runit
	if "%1"=="" (
		rem echo No file name passes
		GOTO:EOF
	)
	
	set attr=%~a1
	set dirattr=%attr:~0,1%
	if /I "%dirattr%"=="d" (
		rem echo Skipping folder %1
		GOTO:EOF
	)
	
    if "%~nx1"=="filetimesvbs.bat" (
		rem echo Skipping %~f1
		GOTO:EOF
	)
	
	if "%~nx1"=="filetimes.vbs" (
		rem echo Skipping %~f1
		GOTO:EOF
	)

	echo.	
	cscript  //nologo .\filetimes.vbs "%~f1"
	GOTO:EOF