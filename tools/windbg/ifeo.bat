@echo off

rem Description:
rem 	This script takes advantage of the "Image File Execution Options" registry 
rem		debugging feature in order to pause the invoked exe for 60 seconds before 
rem		it starts, allowing any temporary files to be examined before it starts.
rem		To prevent recusion, the script has to remove the registry entry, and then
rem		re-add it again afterwards.
rem
rem JeremyC 5/8/2017

rem Note: This script needs to be as administrator in order to update the registry.

rem Backup the IFEO reg key.
reg export  "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\pdfmeld64.exe" c:\temp\backup.reg /y

rem Delete the IFEO reg key. To prevent recursion.
reg delete 	"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\pdfmeld64.exe" /f

echo %* > C:\temp\output.log

rem Add a 60 second delay before we call the program invoked by IFEO.
echo Sleeping for 60 seconds... >> C:\temp\output.log
ping 127.0.0.1 -n 61 > nul
rem timeout 60

rem Call the program invoked by IFEO.
echo Calling program... >> C:\temp\output.log
echo %* > C:\temp\temp.bat
cmd /c C:\temp\temp.bat

rem Restore the IFEO reg key.
reg import	c:\temp\backup.reg

echo Finished >> C:\temp\output.log
