@echo off
REM Description:
REM   Call the demo5.bat script to create several pst files.
REM
REM 8/4/2016 JeremyC.

REM Create multiple pst files based on the templat emsg file test_email.msg.
REM This template msg file has a large recipient list. 
REM Create each pst with 5000 unique messages.

call demo5 test_email.msg generatedpst1  5000     1
call demo5 test_email.msg generatedpst2  5000  5001
call demo5 test_email.msg generatedpst3  5000 10001 
call demo5 test_email.msg generatedpst4  5000 15001
call demo5 test_email.msg generatedpst5  5000 20001
call demo5 test_email.msg generatedpst6  5000 25001
call demo5 test_email.msg generatedpst7  5000 30001
call demo5 test_email.msg generatedpst8  5000 35001
call demo5 test_email.msg generatedpst9  5000 40001
call demo5 test_email.msg generatedpst10 5000 45001 

echo Finished!
