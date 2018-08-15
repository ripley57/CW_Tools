@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Description:
REM     Add attachments to an MSG file.

REM Check input arguments.
if [%3]==[] goto :BAD_INPUT_ARGS
goto GOOD_INPUT_ARGS
:BAD_INPUT_ARGS
echo.
echo ERROR: Bad input arguments.
echo.
echo Usage:
echo   %~nx0 msgname startattachnum endattachnum
echo.
goto DONE

:GOOD_INPUT_ARGS
set msgname=%1
set startnum=%2
set endnum=%3

REM Remove any surrounding double quotes.
set x=%msgname:"=%
set msgname=%x%
set x=%startnum:"=%
set startnum=%x%
set x=%endnum:"=%
set endnum=%x%

REM Remove file suffix from msgname.
set x=%msgname:~0,-4%
set msgname_nosuff=%x%

goto END_FUNCTION_DEFS

REM Function to generate csv input file for msgedit2.exe.
:FUNC_CSVGEN
echo "UPDATE","SUBJECT","%msgname%","Email %msgname_nosuff% with %endnum% attachments" > out.csv
.\lfgen.exe %startnum% %endnum% \"ADD\",\"ATTACH\",\"BODY_INLINE\",\"%msgname%\",\"%msgname_nosuff%_attach%%06lu.txt\",\"text_body_for_%msgname_nosuff%_attach_%%06lu\" >> out.csv
exit /b 0
goto :eof

REM Call msgedit2.exe
:FUNC_MSGEDIT
.\msgedit2.exe -i out.csv
exit /b 0
goto :eof

:END_FUNCTION_DEFS

call :FUNC_CSVGEN  || goto DONE
call :FUNC_MSGEDIT || goto DONE

:DONE
echo.
echo Finished.
echo.
