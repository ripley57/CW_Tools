@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Description:
REM     Find all the ".msg" files in the specified input directory 
REM     and change the subject text to the msg file name.
REM 
REM  Author:
REM     JeremyC
REM
REM  History:
REM  12th July 2015		Intial versionn 1.00.
set version=Ver 1.00

REM :The following variables may need to be changed appropriately.
set cwhome=D:\CW\V714
set msgeditexe=.\msgedit.exe

REM Check input arguments.
if [%1]==[] goto :BAD_INPUT_ARGS
goto GOOD_INPUT_ARGS

:BAD_INPUT_ARGS
echo.
echo ERROR: Bad input arguments.
echo.
echo Usage:
echo   %~nx0 input-directory
echo.
echo   Where:
echo.
echo   input-diredctory		Location directory containing msg files.
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

REM Function to run msgedit.exe against input msg file to change the subject text.
:FUNC_MSGEDIT
setlocal
set msgfilepath=%1
set subjecttext=%2
REM echo calling %msgeditexe% %msgfilepath% %subjecttext%
call %msgeditexe% %msgfilepath% %subjecttext%
if not %errorlevel%==0 (echo ERROR: msgedit.exe failed. && exit /b 1)
exit /b 0
endlocal
goto :eof

REM Function to read input file of msg filenames and call FUNC_RUN_MSGEDIT for each.
:FUNC_CALL_MSGEDIT
for /f "tokens=* delims=," %%A in (msgfiles.txt) do (call :call_msgedit %%A)
exit /b 0
goto :eof
:call_msgedit
set msgfilepath=%1
set msgfilename=%~n1
REM echo calling msgedit.exe %msgfilepath% "%msgfilename%"
call :FUNC_MSGEDIT %msgfilepath% "%msgfilename%"
goto :eof

:END_FUNCTION_DEFS

call :FUNC_FIND_MSG_FILES "%dirname%" "msgfiles.txt" || goto DONE
call :FUNC_CALL_MSGEDIT "msgfiles.txt" || goto DONE

:DONE
echo.
echo Finished. 
echo.