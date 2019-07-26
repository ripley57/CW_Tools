Identify duplicate files by comparing two sets of directories.

Narrative:
In order to identify duplicate files
As a user
I want to know about any files in one given set of directories that also exist in a second given set of directories

Scenario: Identify duplicate files by comparing two sets of directories.
Given a directory set SETA consisting of directory DIRA containing file FILE1 with checksum CHECKSUM1 and directory set SETB consisting of directory DIRB containing file FILE2 with checksum CHECKSUM1 and file FILE3 with checksum CHECKSUM3
When I search for duplicates
Then the only files listed should be: FILE1, FILE2
