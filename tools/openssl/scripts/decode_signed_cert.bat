@echo off
REM Description:
REM   Decode a cert signed by our CA.
REM
REM   JeremyC 28/6/2016

REM location of the openssl.exe command.
set opensslexe=%HOMEDRIVE%%HOMEPATH%\Cygwin\home\%USERNAME%\CW_Tools\tools\openssl\OpenSSL-Win32_0_9_8k\bin\openssl.exe

REM Create a new cert (example-cert.cert.pem). We do this by using the intermediate CA to sign our CSR.
REM %opensslexe% ca -config ca/intermediate/openssl.cnf -extensions usr_cert -days 375 -notext -md sha256 -in my.csr -out signed-cert.pem

REM Verify the new cert.
%opensslexe% x509 -noout -text -in signed-cert.pem

REM Validate the new cert (against the CA and Intermediate CA certs).
REM type ca\intermediate\certs\intermediate.cert.pem > ca-chain.pem
REM type ca\cacert.pem >> ca-chain.pem
REM %opensslexe% verify -CAfile ca-chain.pem signed-cert.pem
