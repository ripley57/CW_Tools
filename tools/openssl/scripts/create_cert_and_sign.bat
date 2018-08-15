@echo off

REM Description:
REM
REM 1. Create a private key cert.
REM 2. Create a self-signed public cert.
REM 3. Create a CSR.
REM 3. Sign the CSR to create a signed public cert.
REM
REM You should be able to run this script from any directory.
REM All generated certificates are copied to c:\temp\
REM
REM JeremyC 11-02-2018

set openssl_tools_dir=%HOMEDRIVE%%HOMEPATH%\Cygwin\home\%USERNAME%\CW_Tools\tools\openssl
set openssl_dir=%openssl_tools_dir%\OpenSSL-Win32_0_9_8k
set openssl_exe=%openssl_dir%\bin\openssl.exe

REM Create private key (key.pem).
if exist key.pem del key.pem
%openssl_exe% genrsa -aes256 -out key.pem 2048

REM Create self-signed cert (cert.pem).
if exist cert.pem del cert.pem
%openssl_exe% rsa -in key.pem -outform PEM -pubout -out cert.pem

REM Create a CSR (csr.pem).
if exist csr.pem del csr.pem
set OPENSSL_CONF=%openssl_dir%\openssl.cnf
%openssl_exe% req -key key.pem -new -sha256 -out csr.pem

REM Make certs available for the next step.
copy key.pem  c:\temp\
copy cert.pem c:\temp\
copy csr.pem  c:\temp\

REM Sign the CSR to create a signed cert (signed-cert.pem).
cd %openssl_tools_dir%
copy c:\temp\csr.pem .
%openssl_exe% ca -config ca/intermediate/openssl.cnf -extensions usr_cert -days 375 -notext -md sha256 -in csr.pem -out signed-cert.pem
copy signed-cert.pem c:\temp\

REM Generate root and intermediate CA cert chain (for use with our new signed cert).
type ca\intermediate\certs\intermediate.cert.pem > ca-certs.pem
type ca\cacert.pem >> ca-certs.pem
copy ca-certs.pem c:\temp\

REM Validate our new signed cert.
rem %openssl_exe% verify -CAfile ca-certs.pem signed-cert.pem
