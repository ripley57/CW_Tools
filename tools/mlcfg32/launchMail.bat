@echo off
REM ---------------------------------------------------------------------------------------------------------
REM Launch the Mail icon 
REM ---------------------------------------------------------------------------------------------------------

:outlook2013
IF NOT EXIST "%ProgramFiles(x86)%\Microsoft Office\Office15" GOTO outlook201064bit
   echo Launching "%ProgramFiles(x86)%\Microsoft Office\Office15\MLCFG32.CPL
   "%ProgramFiles(x86)%\Microsoft Office\Office15\MLCFG32.CPL
   goto alldone

:outlook201064bit
IF NOT EXIST "%ProgramFiles(x86)%\Microsoft Office\Office14" GOTO outlook201032bit
   echo Launcing %ProgramFiles(x86)%\Microsoft Office\Office14\MLCFG32.CPL
   "%ProgramFiles(x86)%\Microsoft Office\Office14\MLCFG32.CPL"
   goto alldone

:outlook201032bit
   IF NOT EXIST "%ProgramFiles%\Microsoft Office\Office14" GOTO outlook2003mapi
   echo Launcing %ProgramFiles%\Microsoft Office\Office14\MLCFG32.CPL
   "%ProgramFiles%\Microsoft Office\Office14\MLCFG32.CPL"
   goto alldone

:outlook2003mapi
   IF NOT EXIST "%ProgramFiles%\Common Files\System\MSMAPI\1033\MLCFG32.CPL" GOTO outlook2003mapi-64bit
   echo Launcing %ProgramFiles%\Common Files\System\MSMAPI\1033\MLCFG32.CPL
   "%ProgramFiles%\Common Files\System\MSMAPI\1033\MLCFG32.CPL"
   goto alldone

:outlook2003mapi-64bit
   echo Launcing %ProgramFiles(x86)%\Common Files\System\MSMAPI\1033\MLCFG32.CPL
   "%ProgramFiles(x86)%\Common Files\System\MSMAPI\1033\MLCFG32.CPL"
   goto alldone

:alldone


