@echo off 

REM This script runs the dedupreport.sh script.
REM You must install this from a system where
REM Cygwin is installed in C:\cygwin.

set CYGWIN_DIR=C:\cygwin

set PWD_WINDOWS=%~dp0
%CYGWIN_DIR%\bin\cygpath %PWD_WINDOWS% > temp.txt
set /p PWD_CYGWIN= < temp.txt
del temp.txt

%CYGWIN_DIR%\bin\bash --login -i -c "cd %PWD_CYGWIN% ; source dedupreport.sh"
