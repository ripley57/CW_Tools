@echo off
REM Description:
REM		Script for running a Java program/tool/cutdown that was built against 
REM		the current CW product installation. 
REM
rem		See the comments and example below of where to add a call your program.
setlocal ENABLEDELAYEDEXPANSION

REM Set classpath.
call :FUNC_CWDIR
if "%RET%"=="" (
	REM CW dir not found so set LIB_PATH to local lib dir.
	echo CW dir not found, using local lib dir
	set  BASE_PATH=.
	set  WEB-INF_PATH=.
	set  LIB_PATH=lib
) else (
	REM CW dir found so set LIB_PATH for CW.
	echo CW dir: %RET%
	set  BASE_PATH=%RET%
	set  WEB-INF_PATH=%RET%\web\app\WEB-INF
	set  LIB_PATH=%RET%\web\app\WEB-INF\lib
)
call :FUNC_SET_CLASSPATH_DYNAMICALLY

REM Args for debugging: 
rem set debugargs=-Xdebug -Xrunjdwp:transport=dt_socket,address=8001,suspend=y,server=y 

REM Args for Fiddler: 
rem set proxyargs=-DproxySet=true -Dhttps.proxyHost=127.0.0.1 -Dhttps.proxyPort=8888

REM Run your program here
REM Example (WSClient.class):
java %debugargs% WSClient
goto :END

REM Build list of CW jar files to add to CLASSPATH.
:FUNC_SET_CLASSPATH_DYNAMICALLY
setlocal
set jar_files=
for /f %%A in ('dir /b /s %LIB_PATH%\*.jar 2^>nul') do (
   call set jar_files=%%jar_files%%;%%A
)
REM Include tomcat jar files in order to resolve symbols such as HttpServletRequest.
set jar_files_tomcat=
for /f %%A in ('dir /b /s %BASE_PATH%\tomcat\*.jar 2^>nul') do (
  REM echo %%~nxA
  REM Be picky about what we add to the classpath 
  REM here because we are very near the limit. This
  REM example only adds jar files with "tomcat" in 
  REM their name.
  echo %%~nxA | findstr /r /i /c:".*tomcat.*.jar" >nul && (
  call set jar_files_tomcat=%%jar_files_tomcat%%;%%A)
)
set _classpath=classes;%WEB-INF_PATH%\classes;%jar_files%;%jar_files_tomcat%
endlocal & set CLASSPATH=%_classpath%
goto :eof

REM Determine the CW home directory (e.g. D:\CW\V83).
:FUNC_CWDIR
setlocal
set dirname=""
for /f %%A in ('dir /b D:\CW\V* 2^>nul') do (
    set dirname=D:\CW\%%A
)
endlocal & set RET=%dirname%
goto :eof
:END