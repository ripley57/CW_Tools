@ECHO OFF

setlocal enabledelayedexpansion

for /f "tokens=*" %%f in (list.txt) do (
   set abs_p=%%f
   call :sub_rename "!abs_p!"
)

:sub_rename
if not "%~1"=="" rename "%~1" "0%~nx1"
exit /b