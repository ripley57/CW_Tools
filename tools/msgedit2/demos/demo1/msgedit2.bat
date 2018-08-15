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
REM  18th July 2015		Initial version 1.00.
set version=Ver 1.00

REM :The following variables may need to be changed appropriately.
set msgeditexe=.\msgedit2.exe

REM Check input arguments.
if [%1]==[] goto :BAD_INPUT_ARGS
goto GOOD_INPUT_ARGS

:BAD_INPUT_ARGS
echo.
echo ERROR: Bad input arguments.
echo.
echo Usage:
echo   %~nx0 input-directory pst-file-path
echo.
echo   Where:
echo.
echo   input-diredctory		Location directory containing msg files.
echo   pst-file-path		Path to pst to go in msgtopst.csv file.
echo.
goto DONE

:GOOD_INPUT_ARGS
set dirname=%1
set pstfilepath=%2

REM Remove any surrounding double quotes.
set x=%dirname:"=%
set dirname=%x%
set x=%pstfilepath:"=%
set pstfilepath=%x%

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

REM Function to call msgedit2.exe.
:FUNC_MSGEDIT
setlocal
call %msgeditexe%
if not %errorlevel%==0 (echo ERROR: msgedit2.exe failed. && exit /b 1)
exit /b 0
endlocal
goto :eof

REM Function to generate csv input files for both cwmsgtopst.exe and msgedit2.exe.
REM After generating the csv file for msgedit2.exe call msgedit2.exe.
:FUNC_CALL_MSGEDIT
set msgedit2file="in.csv"
if exist %msgedit2file% del %msgedit2file%
set msgtopstfile="msgtopst.csv"
if exist %msgtopstfile% del %msgtopstfile%
REM Generate input csv file for cwmsgtopst.exe
echo OPEN,%pstfilepath%,generatedpst > %msgtopstfile%
for /f "tokens=* delims=," %%A in (msgfiles.txt) do (call :call_add_csv_entry %%A)
echo CLOSE>> %msgtopstfile%
echo QUIT>> %msgtopstfile%
REM Call msgedit2.exe
call :FUNC_MSGEDIT
exit /b 0
goto :eof
:call_add_csv_entry
set msgfilepath=%1
set msgfilename=%~n1
echo WRITE,%msgfilepath%,generatedpstfolder >> %msgtopstfile%
echo "UPDATE","SUBJECT",%msgfilepath%,"%msgfilename%" >> %msgedit2file%
goto :eof

:END_FUNCTION_DEFS

call :FUNC_FIND_MSG_FILES "%dirname%" "msgfiles.txt" || goto DONE
call :FUNC_CALL_MSGEDIT "msgfiles.txt" || goto DONE

:DONE
echo.
REM echo Finished. 
echo.