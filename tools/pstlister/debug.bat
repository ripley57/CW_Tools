@echo off

set pwd=%~dp0

rem Note the escaped exclamation in the breakpoint being set.

"c:\Program Files (x86)\Windows Kits\10\Debuggers\x86\windbg.exe" -y "%pwd%" -srcpath "%pwd%" -c "bc *;bp pstlister^!main;g" pstlister.exe d:\generated.pst
