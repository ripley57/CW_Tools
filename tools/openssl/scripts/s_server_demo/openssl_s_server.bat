@echo off
REM Description:
REM   Use the OpenSSL s_server option to start a listening HTTPS server.
REM
REM JeremyC 13-02-2018

REM location of the openssl.exe command.
set opensslexe=%HOMEDRIVE%%HOMEPATH%\Cygwin\home\%USERNAME%\CW_Tools\tools\openssl\OpenSSL-Win32_0_9_8k\bin\openssl.exe

REM set OPENSSL_CONF=openssl.cnf
%opensslexe% s_server -accept 44443 -WWW -cert cert.pem -key key.pem
