@ECHO OFF

setlocal enabledelayedexpansion

for /f "tokens=*" %%f in (list.txt) do (
   set abs_p=%%f
   
   echo Sleeping for 5 seconds...
   ping -n 5 127.0.0.1>nul
   
   echo Setting last modified for !abs_p!...
   settimenow.exe "!abs_p!"
   
)

:sub
if not "%~nx1"=="" echo robocopy "%~dp1\" "outdir%~p2\" "0%~nx1" /np
exit /b