@echo off
REM Description:
REM   Sign the CSR file "my.csr" to create a signed cert named "signed-cert.pem".
REM
REM   To run this script:
REM   1) cd to %HOMEDRIVE%%HOMEPATH%\Cygwin\home\%USERNAME%\CW_Tools\tools\openssl
REM   2) copy your my.csr file to the current directory.
REM   2) run "scripts\sign_cert.bat"
REM
REM   JeremyC 28/6/2016

REM location of the openssl.exe command.
set opensslexe=%HOMEDRIVE%%HOMEPATH%\Cygwin\home\%USERNAME%\CW_Tools\tools\openssl\OpenSSL-Win32_0_9_8k\bin\openssl.exe

REM Create a new cert (example-cert.cert.pem). We do this by using the intermediate CA to sign our CSR.
REM NOTE: If you want to add SANs, then you need to update the "usr_cert" section of ./ca/intermediate/openssl.cnf, e.g.:
REM       subjectAltName=DNS:cw.cwlab.com,DNS:betty.com,DNS:fred.com,DNS:localhost,IP:127.0.0.1
%opensslexe% ca -config ca/intermediate/openssl.cnf -extensions usr_cert -days 375 -notext -md sha256 -in my.csr -out signed-cert.pem

REM Verify the new cert.
rem %opensslexe% x509 -noout -text -in signed-cert.pem

REM Validate the new cert (against the CA and Intermediate CA certs).
type ca\intermediate\certs\intermediate.cert.pem > ca-chain.pem
type ca\cacert.pem >> ca-chain.pem
rem %opensslexe% verify -CAfile ca-chain.pem signed-cert.pem
