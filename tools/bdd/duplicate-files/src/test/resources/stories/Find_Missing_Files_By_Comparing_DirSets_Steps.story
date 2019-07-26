Identify mssing files by comparing two sets of directories.

Narrative:
In order to identify missing files
As a user
I want to know about any files in one given set of directories that are missing from a second given set of directories

Scenario: Identify missing files by comparing two sets of directories.
Given a directory set SETA consisting of directory DIRA containing file FILE1 with checksum CHECKSUM1 and file FILE2 with checksum CHECKSUM2 and directory set SETB consisting of directory DIRB containing file FILE3 with checksum CHECKSUM2
When I search for missing files
Then the only files listed should be: FILE1
