@echo off
copy test.msg c:\temp\
copy ..\..\msgedit2.exe .
.\msgedit2.exe
dir /b