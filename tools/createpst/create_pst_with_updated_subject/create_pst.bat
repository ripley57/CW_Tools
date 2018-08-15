@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Description:
REM     Create a PST of emails based on a single MSG file,
REM		but with different subject text.
REM 
REM  Author:
REM     JeremyC
REM
REM  History:
REM  13th July 2015		Intial versionn 1.00.
set version=Ver 1.00

REM :The following variables may need to be changed appropriately.
set cwhome=D:\CW\V714
set cwmsgtopsthome=%cwhome%\exe\pst
set cwmsgtopstexe=cwmsgtopst.exe
set msgeditexe=.\msgedit.exe
set lfcopyexe=.\lfcopy.exe

REM Check input arguments.
if [%5]==[] goto :BAD_INPUT_ARGS
goto GOOD_INPUT_ARGS

:BAD_INPUT_ARGS
echo.
echo ERROR: Bad input arguments.
echo.
echo Usage:
echo   %~nx0 msgname pstname startnum endnum outputdir
echo.
goto DONE

:GOOD_INPUT_ARGS
set msgname=%1
set pstname=%2
set startnum=%3
set endnum=%4
set outdir=%5

REM Remove any surrounding double quotes.
set x=%msgname:"=%
set msgname=%x%
set x=%pstname:"=%
set pstname=%x%
set x=%startnum:"=%
set startnum=%x%
set x=%endnum:"=%
set endnum=%x%
set x=%outdir:"=%
set outdir=%x%

goto END_FUNCTION_DEFS

REM Function to generate copies of the input msg file.
:FUNC_LFCOPY
rd /q /s msgs
%lfcopyexe% %msgname% %startnum% %endnum% "msgs\test_msg_%%06lu.msg"
exit /b 0
goto :eof

REM Function to update subject text on each msg file.
:FUNC_MSGEDIT
call msgedit.bat "msgs" %outdir%\%pstname%
exit /b 0
goto :eof

REM Function to change to the D:\CW\V714\exe\pst directory.
:FUNC_CHDIR_CWEXEPST
d: || echo ERROR: Could not change to d drive && exit /b 1
cd %cwmsgtopsthome% || echo ERROR: Could not change to exe pst dir && exit /b 1
exit /b 0
goto :eof

REM Function to create a pst file containing the msg files.
REM The msgedit.bat script leaves a file behind called msgtopst.csv.
REM NOTE: This program must be run from the directory D:\CW\V714\exe\pst
:FUNC_CWMSGTOPST
d: || echo ERROR: Could not change to d drive && exit /b 1
cd %cwmsgtopsthome% && %cwmsgtopstexe% -i %outdir%\msgtopst.csv -o %outdir%\out.csv 
exit /b 0
goto :eof

:END_FUNCTION_DEFS

call :FUNC_LFCOPY || goto DONE
call :FUNC_MSGEDIT || goto DONE
call :FUNC_CHDIR_CWEXEPST || goto DONE
calL :FUNC_CWMSGTOPST || goto DONE

:DONE
echo.
echo Finished. 
echo.