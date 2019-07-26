Identify duplicate files present in a single set of directories

Narrative:
In order to identify duplicate files  
As a user
I want to know about any duplicates existing in a given set of directories

Scenario: Identify duplicate files in a single directory
Given a directory set consisting of directory DIRA containing file FILE1 with checksum CHECKSUM1, file FILE2 with checksum CHECKSUM1, and file FILE3 with checksum CHECKSUM3
When I search for duplicates
Then the only files listed should be: FILE1, FILE2
