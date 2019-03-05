@ECHO OFF
REM -- Automates cygwin installation
REM
REM Taken from https://gist.github.com/wjrogers/1016065
REM
REM Cywin setup-x86.exe:
REM https://www.cygwin.com/setup-x86.exe
REM
REM Cygwin setup-x86.exe command-line options:
REM https://www.cygwin.com/faq.html#faq.setup.cli
REM
REM How to determine which package an file is in:
REM https://cygwin.com/cgi-bin2/package-grep.cgi?grep=banner.exe&arch=x86_64
REM
REM Full list of Cygwin package names:
REM https://cygwin.com/packages/package_list.html
REM
REM JeremyC 22-04-2018
SETLOCAL

REM -- Change to the directory of the executing batch file
CD %~dp0

REM Download latest setup-x86.exe
wget https://cygwin.com/setup-x86.exe

REM -- Determine current date, in format: DDMMYYYY
FOR /F "tokens=* USEBACKQ" %%F IN (`date /t`) DO (
SET var=%%F
)
SET TODAYS_DATE=%var:/=%

REM -- Create directory for Cygwin install, in format:  Cygwin_Light_DDMMYYYY
SET CYGWIN_INSTALL_DIR=Cygwin_Light_%TODAYS_DATE%
IF EXIST %CYGWIN_INSTALL_DIR% (
	ECHO ERROR: Directory already exists: %CYGWIN_INSTALL_DIR%
	GOTO :EOF
)
mkdir %CYGWIN_INSTALL_DIR%

REM -- Packages we will install (in addition to the default packages)
SET PACKAGES=wget,diffutils,cygutils-extra,vim,bc,curl,unzip,inetutils,dos2unix,netcat
REM I did try adding "git" but it nearly quadruples the size from 57MB to over 200MB!

REM -- Cygwin mirror
SET MIRROR=http://mirrors.kernel.org/sourceware/cygwin/

REM -- Do it!
ECHO *** INSTALLING PACKAGES
setup-x86.exe -q --disable-buggy-antivirus -d -s %MIRROR% -R "%CYGWIN_INSTALL_DIR%" -C Base -P %PACKAGES%

ECHO.
ECHO.
ECHO cygwin installation updated
ECHO  - %PACKAGES%
ECHO.

ENDLOCAL