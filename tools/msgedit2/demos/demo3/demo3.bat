@echo off
setlocal enabledelayedexpansion

set cwhome=D:\CW\V715
set cwmsgtopsthome=%cwhome%\exe\pst

set lfcopyexe=.\lfcopy.exe
set lfgenexe=.\lfgen.exe

REM Full path to current directory
set pwd=%~dp0

goto END_FUNCTION_DEFS

REM Function to create a pst file containing the msg files.
REM The msgedit.bat script leaves a file behind called msgtopst.csv.
REM NOTE: This program must be run from the directory D:\CW\V714\exe\pst
:FUNC_CWMSGTOPST
d: || echo ERROR: Could not change to d drive && exit /b 1
cd %cwmsgtopsthome% && cwmsgtopst.exe -i %pwd%\cwmsgtopst_in.csv -o %pwd%\cwmsgtopst_out.csv 
exit /b 0
goto :eof

:END_FUNCTION_DEFS
REM Create multiple copies of a single msg file, each with a unique file name.
rd /q /s msgs
%lfcopyexe% test_email.msg 1 50 "msgs\test_email_%%02lu.msg"

REM We will be adding our msg files to a single pst file using cwmsgtopst.exe.
if exist cwmsgtopst_in.csv del cwmsgtopst_in.csv
echo OPEN,%pwd%\generated.pst,generatedpst > cwmsgtopst_in.csv

REM For each msg file copy created, change the subject (to make the email unique), and
REM attach several copies of the same large attachment (we are trying to reproduce
REM a PSTCrawler out-of-memory situation).
if exist msgedit2_in.csv del msgedit2_in.csv
FOR /L %%G IN (1,1,50) DO (
REM Build the name of the next msg file to do. 
REM Note: We need to ensure that we have the correct number of leading zeros.
set j=00%%G
set k=!j:~-2!
set msgname=test_email_!k!.msg
REM echo !msgname!

REM Update input file for msgedit2.exe.
echo "UPDATE","SUBJECT","msgs\!msgname!","Email !msgname!"  >> msgedit2_in.csv
%lfgenexe% 1 10 \"ADD\",\"ATTACH\",\"BODY_FILE\",\"msgs\!msgname!\",\"attach_%%lu.docx\",\"test_attachment.docx\" >> msgedit2_in.csv

REM Update input file for cwmsgtopst.exe.
echo WRITE,%pwd%\msgs\!msgname!,generatedpstfolder >> cwmsgtopst_in.csv
)

REM Run msgedit2.exe to update our test msg files.
call msgedit2.exe -i msgedit2_in.csv

REM Run cwmsgtopst.exe to add our test msg files to a pst file.
echo CLOSE>> cwmsgtopst_in.csv
call :FUNC_CWMSGTOPST 

echo "Finished!"