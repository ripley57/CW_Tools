@echo off
setlocal enabledelayedexpansion

REM Description:
REM    Create a PST file containing Y unique email messages. 
REM    Each email message will have 250 recipients.
REM
REM 8/4/2016 JeremyC.

REM You may need to change some of these.
set cwhome=D:\CW\V715
set cwmsgtopsthome=%cwhome%\exe\pst
set lfcopyexe=.\lfcopy.exe

REM Full path to current directory
set pwd=%~dp0

REM Check input arguments.
if [%4]==[] goto :BAD_INPUT_ARGS
goto GOOD_INPUT_ARGS

:BAD_INPUT_ARGS
echo.
echo ERROR: Bad input arguments.
echo.
echo Usage:
echo   %~nx0 templatemsg pstname messagecount startnum
echo.
goto DONE

:GOOD_INPUT_ARGS
REM Template email msg file to use.
set templatemsg=%1
REM Name of PST to create.
set pstname=%2
REM Number of email messages to create.
set messagecount=%3
REM Starting number to use in email subjects, to make each email unique.
set startnum=%4
REM Debugging.
REM echo templatemsg=%templatemsg% pstname=%pstname% messagecount=%messagecount% startnum=%startnum%

goto END_FUNCTION_DEFS

REM Create pst file using the msg files in cwmsgtopst_in.csv.
:FUNC_CWMSGTOPST
d: || echo ERROR: Could not change to d drive && exit /b 1
cd %cwmsgtopsthome% && cwmsgtopst.exe -i %pwd%\cwmsgtopst_in.csv -o %pwd%\cwmsgtopst_out.csv 
exit /b 0
goto :eof

:END_FUNCTION_DEFS

REM Create multiple copies of the template msg file, each with a unique file name.
rd /q /s %pwd%\msgs
md %pwd%\msgs
echo. && echo Creating %messagecount% copies of msg %templatemsg% ... && echo.
rd /q /s msgs
set /A endnum = %startnum% + %messagecount% - 1
%lfcopyexe% %templatemsg% %startnum% %endnum% "msgs\test_email_%%09lu.msg"

REM Begin creating new input csv file for cwmsgtopst.exe.
echo. && echo Creating csv file cwmsgtopst_in.csv ready for cwmsgtopst.exe ...
if exist cwmsgtopst_in.csv del cwmsgtopst_in.csv
echo OPEN,%pwd%\%pstname%.pst,%pstname%folder> cwmsgtopst_in.csv

REM Create an input csv file for msgedit2.exe, to make 
REM each email unique by giving each unique subject text.
if exist msgedit2_in.csv del msgedit2_in.csv
FOR /L %%G IN (%startnum%,1,%endnum%) DO (
    REM Build the name of the msg file that will be updated. 
    REM Note: We need to have the correct number of leading zeros,
    REM       so that the name matches the file we created earlier.
    set j=000000000%%G
    set k=!j:~-9!
    set msgname=test_email_!k!.msg
    REM Debugging.
    REM echo msgname=!msgname!

    REM Create an entry for msgedit2.exe to change the subject text.
    echo "UPDATE","SUBJECT","%pwd%\msgs\!msgname!","Email !msgname!" >> msgedit2_in.csv

    REM Create an entry for cwmsgpst.exe to add the email to the pst.
    echo WRITE,%pwd%\msgs\!msgname!,generatedpstfolder >> cwmsgtopst_in.csv
)

REM Run msgedit2.exe to edit our msg files.
echo. && echo Calling msgedit2.exe ... && echo.
call msgedit2.exe -i msgedit2_in.csv

REM Run cwmsgtopst.exe to add our msg files to our new pst file.
echo CLOSE>> cwmsgtopst_in.csv
echo. && echo Calling cwmsgtopst.exe ... && echo.
if exist %pstname%.pst del %pstname%.pst
call :FUNC_CWMSGTOPST 

REM Sleep for a second.
ping -n 1 127.0.0.1>nul

REM Tidy up.
goto DONE
echo. && echo Tidying up in directory %~dp0 ...
if exist %pwd%\msgedit2_in.csv    del %pwd%\msgedit2_in.csv
if exist %pwd%\cwmsgtopst_in.csv  del %pwd%\cwmsgtopst_in.csv
if exist %pwd%\cwmsgtopst_out.csv del %pwd%\cwmsgtopst_out.csv
rd /q /s %pwd%\msgs

:DONE
echo.
echo Finished. 
echo.