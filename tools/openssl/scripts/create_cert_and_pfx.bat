@echo off
REM Description:
REM   Windows script to create a PEM certificate using our own CA with intermediate CA.
REM   See the document "Using OpenSSL to create your own CA.docx" for more details.
REM
REM   Run this script from in the "CW_Tools\tools\openssl" directory.
REM
REM   Some of the steps in this script prompt for user input. You might 
REM   therefore want to comment-out each step below at a time, as you
REM   work through them.
REM
REM   To import the pfx file in Outlook 2013, see here:
REM   https://support.office.com/en-gb/article/Get-a-digital-ID-0eaa0ab9-b8a2-4a7e-828b-9bded6370b7b
REM
REM   To create an encrypted emaili in Outlook 2013 ready to send:
REM   http://www.dummies.com/how-to/content/how-to-encrypt-messages-in-outlook-2013.html
REM   Note: I actually get an error when I try to send an encrypted email from
REM         Outlook 2013, but I think this is because Outlook expects the recipient
REM         to be in the Global Address List (GAL) and have its own "digital ID" ,
REM         i.e. its own cert. However, I found that simply saving my email to the
REM         Drafts folder looks to be sufficient to create an encrypted email,
REM	    which I can then drag out of Outlook as an MSG file.
REM
REM   JeremyC 23/6/2016

REM location of the openssl.exe command.
set opensslexe=%HOMEDRIVE%%HOMEPATH%\Cygwin\home\%USERNAME%\CW_Tools\tools\openssl\OpenSSL-Win32_0_9_8k\bin\openssl.exe

REM create a private key (example-cert.key.pem).
REM %opensslexe% genrsa -aes256 -out example-cert.key.pem 2048

REM Use the private key to create a CSR (example-cert.csr.pem).
REM %opensslexe% req -config ca/intermediate/openssl.cnf -key example-cert.key.pem -new -sha256 -out example-cert.csr.pem

REM Create a new cert (example-cert.cert.pem). We do this by using the intermediate CA to sign our CSR.
REM %opensslexe% ca -config ca/intermediate/openssl.cnf -extensions usr_cert -days 375 -notext -md sha256 -in example-cert.csr.pem -out example-cert.cert.pem

REM Verify the new cert.
REM %opensslexe% x509 -noout -text -in example-cert.cert.pem

REM Validate the new cert (against the CA and Intermediate CA certs).
type ca\intermediate\certs\intermediate.cert.pem > ca-chain.pem
type ca\cacert.pem >> ca-chain.pem
REM %opensslexe% verify -CAfile ca-chain.pem example-cert.cert.pem

REM Create a pfx file (example-cert.pfx) using our new cert and its private key.
REM See also: https://www.ssl.com/how-to/create-a-pfx-p12-certificate-file-using-openssl/
REM See also: https://www.openssl.org/docs/manmaster/apps/pkcs12.html
REM These steps describe how to create a P12 certificate, but this is the same as PFX.
REM "PFX" was a Microsfost file extension name, where as "P12" was a Netscape one.
REM These are both X509 certificates, but ones that can also contain the private key.
REM We will also include the CA cert and Intermediate CA cert.
REM %opensslexe% pkcs12 -export -inkey example-cert.key.pem -in example-cert.cert.pem -out example-cert.pfx -chain -CAfile ca-chain.pem

REM Concert PEM cert to DER (.crt .cer .der) so that is can be imported into details of an Outlook 2013 contact.
REM See https://www.sslshopper.com/article-most-common-openssl-commands.html
REM     https://www.openssl.org/docs/manmaster/apps/x509.html
REM %opensslexe% x509 -inform pem -in example-cert.cert.pem -outform DER -out example-cert.cert.cer
