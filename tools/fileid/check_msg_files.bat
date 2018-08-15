@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Description:
REM     Find all the ".msg" files in the specified input directory and
REM     verify that they are indeed true Outlook msg files, as identified
REM     by the Stellent code 1143 (FI_OUTLOOK_MSG 1143).
REM 
REM  Author:
REM     JeremyC
REM
REM  History:
REM  5th June 2015		Intial versionn 1.00.
set version=Ver 1.00

REM :The following variables may need to be changed appropriately.
set cwhome=D:\CW\V714
set fileidexe=%cwhome%\exe\filefilter\fileid.exe

REM Check input arguments.
if [%1]==[] goto :BAD_INPUT_ARGS
goto GOOD_INPUT_ARGS

:BAD_INPUT_ARGS
echo.
echo ERROR: Bad input arguments.
echo.
echo Usage:
echo   %~nx0 export-directory
echo.
echo   Where:
echo.
echo   export-diredctory	Location of export containing natives.
echo.
goto DONE

:GOOD_INPUT_ARGS
set dirname=%1

REM Remove any surrounding double quotes.
set x=%dirname:"=%
set dirname=%x%

goto END_FUNCTION_DEFS

REM Function to recursively find any ".msg" files in the specified directory.
REM http://ss64.com/nt/for.html
:FUNC_FIND_MSG_FILES 
set indirname=%1
set outfilename=%2
if exist %outfilename% del %outfilename%
if not exist %indirname% (echo ERROR: No such directory %indirname% && exit /b 1)
FOR /f "tokens=*" %%G IN ('dir %indirname%\*.msg /s /b') DO (echo "%%G" >> %outfilename%)
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

REM Function to check results from the fileid.exe command.
REM If any of the files are NOT true Outlook MSG files then we have a problem.
REM http://ss64.com/nt/for_cmd.html
:FUNC_CHECK_FILEID_RESULTS
set fileidresultsfile=%1
if not exist %fileidresultsfile% (echo ERROR: No such input file %fileidresultsfile% && exit /b 1)
for /f "tokens=* delims=," %%A in (results.txt) do (call :check_fileid_result %%A %%B)
exit /b 0
goto :eof
:check_fileid_result
set /a counter_files_checked=%counter_files_checked%+1
set msgfile=%1
set result=%2
REM Strip quotes from result.
set x=%result:"=%
set result=%x%
REM Indicate to user is this MSG file is not actually an MSG file.
if NOT "%result%" == "1143" set /a counter_bad_files=%counter_bad_files%+1 && echo NOT AN MSG FILE: %msgfile% - (Fileid is %result%) 
goto :eof

:END_FUNCTION_DEFS

call :FUNC_FIND_MSG_FILES "%dirname%" "files.txt" || goto DONE
call :FUNC_RUN_FILEID "files.txt" "results.txt" || goto DONE

set /a counter_files_checked=0
set /a counter_bad_files=0
call :FUNC_CHECK_FILEID_RESULTS "results.txt" || goto DONE
echo.
echo Number of MSG files found: %counter_files_checked%
echo Number of bad MSG files  : %counter_bad_files%
echo.
echo See files.txt for MSG files found. 
echo See results.txt for FILEID results. NOTE: An Outlook msg should have a fileid value of "1143".
echo.

:DONE
echo.
echo Finished. 
echo.
