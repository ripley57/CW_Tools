@echo off
setlocal enabledelayedexpansion

REM Description:
REM    Create a PST file containing all the msg files in the current directory. 
REM
REM 10/5/2016 JeremyC.

REM You may need to change some of these.
set cwhome=D:\CW\V715
set cwmsgtopsthome=%cwhome%\exe\pst

REM Full path to current directory
set pwd=%~dp0

goto END_FUNCTION_DEFS

REM Create pst file using the msg files in cwmsgtopst_in.csv.
:FUNC_CWMSGTOPST
d: || echo ERROR: Could not change to d drive && exit /b 1
cd %cwmsgtopsthome% && cwmsgtopst.exe -i %pwd%\cwmsgtopst_in.csv -o %pwd%\cwmsgtopst_out.csv 
exit /b 0
goto :eof

:END_FUNCTION_DEFS

REM Begin creating new input csv file for cwmsgtopst.exe.
echo. && echo Creating csv file cwmsgtopst_in.csv ready for cwmsgtopst.exe ...
if exist cwmsgtopst_in.csv del cwmsgtopst_in.csv
echo OPEN,%pwd%\generated.pst,mydisplayname > cwmsgtopst_in.csv
echo.
FOR /f "tokens=*" %%G IN ('dir /b /a:-d .\*.msg') DO (
	echo MSG file to add: %%G
	echo WRITE,%pwd%\%%G,myfoldername >> cwmsgtopst_in.csv
)
echo CLOSE>> cwmsgtopst_in.csv

REM Run cwmsgtopst.exe to add our msg files to our new pst file.
echo. && echo Calling cwmsgtopst.exe to create the pst... && echo.
if exist generated.pst del generated.pst
call :FUNC_CWMSGTOPST 

REM Tidy up.
if exist %pwd%\cwmsgtopst_in.csv  del %pwd%\cwmsgtopst_in.csv
if exist %pwd%\cwmsgtopst_out.csv del %pwd%\cwmsgtopst_out.csv

:DONE
echo Finished. 
echo.
