@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Description:
REM     Display the fileid of each file in the current directory.
REM 
REM  Author:
REM     JeremyC
set version=Ver 1.00

REM Check input arguments.
if [%1]==[] goto :BAD_INPUT_ARGS
goto GOOD_INPUT_ARGS

:BAD_INPUT_ARGS
echo.
echo ERROR: Bad input arguments.
echo.
echo Usage:
echo   %~nx0 	cwdirectory
echo.
echo   Where:
echo.
echo   directory	Location of the CW directory, e.g. D:\CW\V811.
echo.
goto DONE

:GOOD_INPUT_ARGS
set cwhome=%1

REM Remove any surrounding double quotes.
set x=%cwhome:"=%
set cwhome=%x%

set fileidexe=%cwhome%\exe\filefilter\fileid.exe

goto END_FUNCTION_DEFS

REM Function to recursively find all files in the current directory.
REM We do this by listing everything, excluding directories (dir /A:-D).
REM see https://www.windows-commandline.com/dir-command-line-options/
:FUNC_FIND_ALL_FILES 
set indirname=%1
set outfilename=%2
if exist %outfilename% del %outfilename%
if not exist %indirname% (echo ERROR: No such directory %indirname% && exit /b 1)
FOR /f "tokens=*" %%G IN ('dir /A:-D %indirname%\* /s /b') DO (echo "%%G" >> %outfilename%)
exit /b 0
goto :eof

REM Function to run fileid.exe command against input file containing all the file paths.
:FUNC_RUN_FILEID
setlocal
set infile=%1
set outfile=%2
REM if not exit %fileidexe% (echo ERROR: Could not find fileid.exe. Please run this script from the CW appliance. && exit /b 1)
call %fileidexe% -i %infile% -o %outfile%
if not %errorlevel%==0 (echo ERROR: fileid.exe command failed. && exit /b 1)
exit /b 0
endlocal
goto :eof

:END_FUNCTION_DEFS

call :FUNC_FIND_ALL_FILES "." "files.txt" || goto DONE
call :FUNC_RUN_FILEID "files.txt" "results.txt" || goto DONE

type results.txt
del results.txt
del files.txt

:DONE
echo.
echo Finished. 
echo.
