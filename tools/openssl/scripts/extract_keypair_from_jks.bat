@echo off

REM Description:
REM    Extract cert and private key from a Java Keystore (JKS).
REM	   These can then be used with "openssl s_server ...", etc.
REM
REM JeremyC 27/6/2015

REM location of keytool.exe
set keytoolexe="C:\Program Files (x86)\Java\jre1.8.0_73\bin\keytool.exe"

REM location of the openssl.exe command.
set opensslexe=%HOMEDRIVE%%HOMEPATH%\Cygwin\home\%USERNAME%\CW_Tools\tools\openssl\OpenSSL-Win32_0_9_8k\bin\openssl.exe

REM First convert keystore to PKCS#12 format.
%keytoolexe% -importkeystore -srckeystore server.keystore -destkeystore server.keystore.p12 -deststoretype PKCS12 -srcalias cwkey -deststorepass 123456

REM Export certificate using openssl.
%opensslexe% pkcs12 -in server.keystore.p12 -nokeys -out cert.pem

REM Export unencrypted (-nodes) private key using openssl.
%opensslexe% pkcs12 -in server.keystore.p12 -nodes -nocerts -out key.pem
