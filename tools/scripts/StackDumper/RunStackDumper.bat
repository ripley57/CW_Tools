@ECHO off 
REM Description:
REM   This batch script calls the StackDumper Java program in order
REM   to run the "b admin-client monitor.thread getAllStackTraces"
REM   command and capture the output in log4j log files.
REM   This script can be run from a Windows scheduled task.
REM
REM   NOTE: This script needs to be edited to specify the correct 
REM         arguments to pass to the StackDumper program. Once
REM         these have been specified, no arugments are required
REM         when calling this batch script.
REM
REM   JeremyC 03/09/2013.

SET CW_HOME=D:\CW\V711
SET STACKDUMPER_DIR=%CW_HOME%\logs\stackdumper
set JAVA_HOME=C:\jrockit-jdk1.6.0_29-R28.2.0-4.1.0-x64
set JRE_HOME=%JAVA_HOME%

REM Number of dumps to create
set NUM_DUMPS=1
if NOT [%1]==[] (
set NUM_DUMPS=%1
shift
)

REM Delays between dumps
set DELAY_SECS=60
if NOT [%1]==[] (
set DELAY_SECS=%1
shift
)

IF NOT EXIST "%STACKDUMPER_DIR%" GOTO NoSuchDir
REM Arguments to StackDumper Java program:
REM   1  - Path to the CW home directory (so it can find b.bat).
REM   2  - Path to the directory where you want the output logs to go.
%JAVA_HOME%\bin\java.exe -jar sd.jar -r "%NUM_DUMPS%" -d "%DELAY_SECS%" -h "%CW_HOME%" -s "%STACKDUMPER_DIR%"
GOTO End
:NoSuchDir
ECHO "Error: Directory %STACKDUMPER_DIR% does not exist!" 
:End
