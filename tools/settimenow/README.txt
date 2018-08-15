Instructions to set sequential last modified times of a list of files
=====================================================================

1. [OPTIONAL] Rename all the files in the source directory:

renameall.bat

This script prepends a "0" to each file name, so that these documents,
if already ingested into CW, are not de-duped when re-ingested.


2. Create a sorted list of the PDF files:

dir /s /b /o indir\*.pdf > list.txt

(In this example, "indir" is the directory containing the PDF files you want to update.)


3. Copy the setalltimesnow.bat script and settimenow.exe program into the same directory 
that contains list.txt and run the setalltimesnow.bat script:

setalltimesnow.bat

This script reads each file name from list.txt, sleeps for 5 seconds, and then updates the 
last modified time of that file to the current time using the settimenow.exe program.

NOTE: This script updates the files in-place. It does not create a copy and then make changes to the files.


4. Ingest the updated source directory into CW.

A metadata export should now show that the DateModified value is increasing by a few seconds 
for each file. This should then make the sorting in the UI by "Date" work as desired.


JeremyC 7/11/2012



