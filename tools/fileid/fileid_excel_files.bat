@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Description:
REM     Find all the ".xls*" files and display the fileid value.
REM 
REM  Author:
REM     JeremyC

set version=Ver 1.00

set cwhome=D:\CW\V711
set fileidexe=%cwhome%\exe\filefilter\fileid.exe

REM Check input arguments.
if [%1]==[] goto :BAD_INPUT_ARGS
goto GOOD_INPUT_ARGS

:BAD_INPUT_ARGS
echo.
echo ERROR: Bad input arguments.
echo.
echo Usage:
echo   %~nx0 	directory
echo.
echo   Where:
echo.
echo   directory	Location of export containing natives.
echo.
goto DONE

:GOOD_INPUT_ARGS
set dirname=%1

REM Remove any surrounding double quotes.
set x=%dirname:"=%
set dirname=%x%

goto END_FUNCTION_DEFS

REM Function to recursively find any ".xls*" files in the specified directory.
REM http://ss64.com/nt/for.html
:FUNC_FIND_MSG_FILES 
set indirname=%1
set outfilename=%2
if exist %outfilename% del %outfilename%
if not exist %indirname% (echo ERROR: No such directory %indirname% && exit /b 1)
FOR /f "tokens=*" %%G IN ('dir %indirname%\*.xls* /s /b') DO (echo "%%G" >> %outfilename%)
exit /b 0
goto :eof

REM Function to run fileid.exe command against input file containing all the msg file paths.
:FUNC_RUN_FILEID
setlocal
set infile=%1
set outfile=%2
rem if not exit %fileidexe% (echo ERROR: Could not find fileid.exe. Please run this script from the CW appliance. && exit /b 1)
call %fileidexe% -i %infile% -o %outfile%
if not %errorlevel%==0 (echo ERROR: fileid.exe command failed. && exit /b 1)
exit /b 0
endlocal
goto :eof

:END_FUNCTION_DEFS

call :FUNC_FIND_MSG_FILES "%dirname%" "files.txt" || goto DONE
call :FUNC_RUN_FILEID "files.txt" "results.txt" || goto DONE

:DONE
echo.
echo Finished. 
echo.
