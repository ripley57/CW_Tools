@echo off
setlocal ENABLEDELAYEDEXPANSION

set displayusage=false
if [%1]==[/?] set displayusage=true
if [%1]==[-h] set displayusage=true
if "%displayusage%"=="true" (
	call :FUNC_DISPLAY_USAGE
	goto END
)

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

rem call :FUNC_SET_CLASSPATH_MANUALLY
call :FUNC_SET_CLASSPATH_DYNAMICALLY

rem Debugging
rem echo BASE_PATH=%BASE_PATH%
rem echo WEB-INF_PATH=%WEB-INF_PATH%
rem echo LIB_PATH=%LIB_PATH%
rem echo CLASSPATH=%CLASSPATH%

REM By default compile local java files.
set command=compile
set option=
if [%1]==[-i] (
    set command=install
	if [%2]==[-f] (
		set option=force
	)
) 
if [%1]==[-b] (
	set command=backup
) 
if [%1]==[-r] (
	set command=restore
) 
goto END_FUNCTION_DEFS


:FUNC_DISPLAY_USAGE
echo.
echo Usage:
echo    Compile the Java files in the local "src" directory:
echo        %~n0 [-c]
echo.
echo    Install our compiled Java files into the product:
echo        %~n0 -i
echo.
echo    Backup the original product class files into the local "orig" directory:
echo        %~n0 -b
echo.
echo    Restore the original product class files into the product:
echo        %~n0 -r
goto :eof


:FUNC_SET_CLASSPATH_DYNAMICALLY
REM Build list of jar files to add to CLASSPATH.
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
set _classpath=%WEB-INF_PATH%\classes;%jar_files%;%jar_files_tomcat%
endlocal & set CLASSPATH=%_classpath%
goto :eof


:FUNC_SET_CLASSPATH_MANUALLY
REM Set CLASSPATH using hard-coded list of jar files.
setlocal
set _classpath=%WEB-INF_PATH%\classes;^
%BASE_PATH%\Myrmidon.jar;^
%BASE_PATH%\tomcat\lib\servlet-api.jar;^
%LIB_PATH%\commons-fileupload-1.3.2.jar;^
%LIB_PATH%\struts-1.2.4.jar;^
%LIB_PATH%\json-1.0-cw.jar;^
%LIB_PATH%\jdom-1.0.1-cw.jar;^
%LIB_PATH%\es_luceneIndexer.jar;^
%LIB_PATH%\mysql-connector-java-5.1.28.jar;^
%LIB_PATH%\lucene-analyzers-3.6.1-cw.jar;^
%LIB_PATH%\lucene-core-3.6.1-cw.jar;^
%LIB_PATH%\commons-io-2.1.jar;^
%LIB_PATH%\lucene-queries-3.6.1-cw.jar^
%LIB_PATH%\ehcache-core-2.5.1-cw.jar;^
%LIB_PATH%\lucene-analyzers-3.6.1-esa.jar;^
%LIB_PATH%\lucene-core-3.6.1-esa.jar;^
%LIB_PATH%\lucene-demos-3.6.1-esa.jar;^
%LIB_PATH%\lucene-queries-3.6.1-esa.jar;^
%LIB_PATH%\lucene-spellchecker-3.6.1-esa.jar;^
%LIB_PATH%\xstream-1.4.2.jar;^
%LIB_PATH%\guava-12.0.1.jar;^
%LIB_PATH%\annotations.jar;^
%LIB_PATH%\annotations-1.3.9-cw.jar;^
%LIB_PATH%\jsr305.jar;^
%LIB_PATH%\log4j.jar;^
%LIB_PATH%\log4j-1.2.17-cw.jar;^
%LIB_PATH%\hibernate3.jar;^
%LIB_PATH%\hibernate-3.2.5.ga.jar;^
%LIB_PATH%\lucene-core-2.4-esa.jar;^
%LIB_PATH%\xstream.jar;^
%LIB_PATH%\commons-collections.jar;^
%LIB_PATH%\poi-3.5-beta5-20090219.jar;^
%LIB_PATH%\poi-scratchpad-3.5-beta5-20090219.jar;^
%LIB_PATH%\PDFBox-0.7.0.jar;^
%LIB_PATH%\mysql-connector-java-5.0.6-bin.jar;^
%LIB_PATH%\commons-io-1.1.jar;^
%LIB_PATH%\Tidy.jar;^
%LIB_PATH%\icu4j-4_0.jar;^
%LIB_PATH%\jakarta-regexp-1.5.jar;^
%LIB_PATH%\mail.jar;^
%LIB_PATH%\jcifs.jar;^
%LIB_PATH%\itext-1.3.1.jar;^
%LIB_PATH%\Notes.jar;^
%LIB_PATH%\geronimo-servlet_2.5_spec-1.2.jar;^
%LIB_PATH%\commons-fileupload-1.2.1.jar;^
%LIB_PATH%\json.jar;^
%LIB_PATH%\flexjson-1.7-cw.jar;^
%LIB_PATH%\jdom.jar;^
%LIB_PATH%\btrlp.jar;^
%LIB_PATH%\btutil.jar;^
%LIB_PATH%\struts.jar;^
%LIB_PATH%\ehcache.jar;^
%LIB_PATH%\jfreechart-0.9.21.jar;^
%LIB_PATH%\CleanContent.jar;^
%LIB_PATH%\CleanContent-2010.2.2137.jar;^
%LIB_PATH%\jasperreports-3.0.0.jar;^
%LIB_PATH%\jasperreports-3.0.0-cw.jar;^
%LIB_PATH%\jcommon-0.9.6.jar;^
%LIB_PATH%\poi-contrib-3.5-beta5-20090219.jar;^
%LIB_PATH%\jsr305-1.3.9.jar;^
%BASE_PATH%\tomcat\server\lib\catalina.jar;^
%BASE_PATH%\tomcat\server\lib\catalina-optional.jar;
endlocal & set CLASSPATH=%_classpath%
goto :eof


:FUNC_CWDIR
REM Determine the CW home directory (e.g. D:\CW\V83).
setlocal
set dirname=""
for /f %%A in ('dir /b D:\CW\V* 2^>nul') do (
    set dirname=D:\CW\%%A
)
endlocal & set RET=%dirname%
goto :eof


:FUNC_BACKUP_ALL_ORIG_CLASS_FILES
REM Make backup copies of the current 'live' versions of our new class files. 
setlocal

REM We do not want to potentially overwrite our copies of the original class files.
if exist orig echo WARN: Backup directory orig already exists. Aborting new backup. && exit /b 1

REM Check that we have compiled some class files, so we know which files we need to backup.
set foundlocalclassfiles=0

FOR /f "tokens=*" %%G IN ('dir /s /b /a:-d classes\*.class') DO (
	set foundlocalclassfiles=1
	call :FUNC_BACKUP_SINGLE_ORIG_CLASS_FILE %%G
)

if %foundlocalclassfiles%==0 echo WARN: Compile some files, so I know the original class files to backup. && exit /b 1
endlocal
goto :eof


:FUNC_BACKUP_SINGLE_ORIG_CLASS_FILE
REM Backup a single 'live' class file to the "orig" backup directory.
setlocal
set filepath_build=%1
set filepath_live_tmp=%filepath_build%

REM Split file path into folder path and file name.
for %%A in ("%filepath_build%") do (
    set folder=%%~dpA
    set name=%%~nxA
)

REM Strip current directory from front of folder path.
set curDir=%~dp0
set classesDir=%curDir%classes\
set folderpath_local=!folder:%classesDir%=!

REM Before we go any further, verify that the 'live' file exists,
REM because this could be a new class file that we have created.
set filepath_live=!filepath_live_tmp:%curDir%=%WEB-INF_PATH%\!
if exist %filepath_live% (
	REM Create directory structure for the file under the local "orig" directory.
	if not exist orig\%folderpath_local% md orig\%folderpath_local%

	REM Copy class file from 'live' location to local "orig" directory.
	call :FUNC_YES_NO "* BACKUP *  %filepath_live% (y/n)? "
	if !answer!==y (
		copy "%filepath_live%" "orig\%folderpath_local%"
	)
)
endlocal
goto :eof


:FUNC_INSTALL_ALL_NEW_CLASS_FILES
REM Copy all our new class files from our local "classes" directory to the 'live' directory.
setlocal
set option=%1
FOR /f "tokens=*" %%G IN ('dir /s /b /a:-d classes\*.class') DO (
	call :FUNC_INSTALL_SINGLE_NEW_CLASS_FILE %%G %option%
)
endlocal
goto :eof


:FUNC_INSTALL_SINGLE_NEW_CLASS_FILE
REM Copy a single new class file to its 'live' directory.
setlocal
set option=%2
set filepath_build=%1
set filepath_live_tmp=%filepath_build%

REM Determine 'live' location of class file.
set curDir=%~dp0
set filepath_dst=!filepath_live_tmp:%curDir%=%WEB-INF_PATH%\!

if [%option%]==[force] (
	echo * INSTALL * %filepath_dst%
	copy "%filepath_build%" "%filepath_dst%"
) else (
	call :FUNC_YES_NO "* INSTALL *  %filepath_dst% (y/n)? "
	if !answer!==y (
		copy "%filepath_build%" "%filepath_dst%"
	)
)
endlocal
goto :eof


:FUNC_COMPILE_ALL_NEW_CLASS_FILES
REM Compile our local java files into our local classes directory.
setlocal

REM Verify that a local "src" directory exists.
if not exist src echo WARN: Could not find local "src" directory. Aborting compile. && exit /b 1

dir /s /b /a:-d src > sources_list.txt
if not exist classes md classes
javac -g -d classes @sources_list.txt
if exist sources_list.txt del sources_list.txt
endlocal
goto :eof


:FUNC_RESTORE_ALL_ORIG_CLASS_FILES
REM Restore the original copies of the class files.
REM Note: This will not remove any new class files we have created.
setlocal
FOR /f "tokens=*" %%G IN ('dir /s /b /a:-d orig\*.class') DO (
	call :FUNC_RESTORE_SINGLE_ORIG_CLASS_FILE %%G
)
endlocal
goto :eof


:FUNC_RESTORE_SINGLE_ORIG_CLASS_FILE
setlocal
set filepath_orig=%1
set filepath_live_tmp=%filepath_orig%

REM Determine 'live' location of class file.
set curDir=%~dp0
set origDir=%curDir%orig\
set filepath_live=!filepath_live_tmp:%origDir%=%WEB-INF_PATH%\classes\!

call :FUNC_YES_NO "* RESTORE *  %filepath_orig% (y/n)? "
if !answer!==y (
    copy "%filepath_orig%" "%filepath_live%"
)
endlocal
goto :eof


:FUNC_YES_NO
rem Ask question and return y or n.
:START_YES_NO
set /P answer=%1
if "%answer%"=="n" set answer=n&& goto END_YES_NO
if "%answer%"=="N" set answer=n&& goto END_YES_NO
if "%answer%"=="y" set answer=y&& goto END_YES_NO
if "%answer%"=="Y" set answer=y&& goto END_YES_NO
echo Bad input value. Try again. && goto START_YES_NO
:END_YES_NO
goto :eof

:END_FUNCTION_DEFS


if [%command%]==[install] (
	if not exist orig echo. && echo WARN: Backup directory "orig" does not exist. Run backup command first ^(-b^). Aborting install. && goto END
	call :FUNC_INSTALL_ALL_NEW_CLASS_FILES %option%
) 
if [%command%]==[backup] (
	call :FUNC_BACKUP_ALL_ORIG_CLASS_FILES
) 
if [%command%]==[compile] (
    call :FUNC_COMPILE_ALL_NEW_CLASS_FILES
) 
if [%command%]==[restore] (
	call :FUNC_RESTORE_ALL_ORIG_CLASS_FILES
)

:END
