@echo off
REM Description:
REM   Revoke a cert (identified from the id value in the ca/intermediate/index.txt.txt file).
REM
REM   Use this script if you see the following error when trying to sign a cert:
REM     Sign the certificate? [y/n]:y
REM     failed to update database
REM     TXT_DB error number 2
REM
REM   JeremyC 28/6/2016

REM location of the openssl.exe command.
set opensslexe=%HOMEDRIVE%%HOMEPATH%\Cygwin\home\%USERNAME%\CW_Tools\tools\openssl\OpenSSL-Win32_0_9_8k\bin\openssl.exe

REM Revoke the cert (i.e. remove it from the database).
%opensslexe% ca -config ca/intermediate/openssl.cnf -revoke ca/intermediate/newcerts/1005.pem 
