
USAGE:

I like to use the following method to use scanpstall:
- Copy ScanPSTAll.cmd ScanPSTOne.exe to the directory containing all the PST files.
- Double-click ScanPSTAll.cmd. This launches a command window. In this command window you will see the progress and the Windows scanpst.exe UI popping-up and the button etc being pressed for you.


Things to be aware of when using scanpstall:

o The tool uses a compiled Autohotkey macro to do all the button pressing etc. This means that you cannot use the desktop while the tool is running - because you cannot take window focus away from the scanpst.exe UIs that pop-up. If you do, the tool will pause. You can get it to continue again, by manually doing the next step using the UI.

o The tool leaves a <pst_filename>.log file behind for each PST file processed.

o The tool leaves a single ScanPSTOne.log file behind. This shows the number of attempts made to repair each PST file. The following example shows two different PST files that were repaired after 3 attempts:

[v2.1] 2014-05-11 10:01 PST='D:\PST_orig - Copy\2005.pst'...(no backup 'N' option)...(SCANPST.EXE v14.0.6015.1000)...(2) File repaired
[v2.1] 2014-05-11 10:01 PST='D:\PST_orig - Copy\2005.pst'...(no backup 'N' option)...(SCANPST.EXE v14.0.6015.1000)...(2) File repaired
[v2.1] 2014-05-11 10:01 PST='D:\PST_orig - Copy\2005.pst'...(no backup 'N' option)...(SCANPST.EXE v14.0.6015.1000)...(2) File repaired
[v2.1] 2014-05-11 10:01 PST='D:\PST_orig - Copy\2005.pst'...(no backup 'N' option)...(SCANPST.EXE v14.0.6015.1000)...(0) No errors found
[v2.1] 2014-05-11 10:01 PST='D:\PST_orig - Copy\2006.pst'...(no backup 'N' option)...(SCANPST.EXE v14.0.6015.1000)...(2) File repaired
[v2.1] 2014-05-11 10:02 PST='D:\PST_orig - Copy\2006.pst'...(no backup 'N' option)...(SCANPST.EXE v14.0.6015.1000)...(2) File repaired
[v2.1] 2014-05-11 10:02 PST='D:\PST_orig - Copy\2006.pst'...(no backup 'N' option)...(SCANPST.EXE v14.0.6015.1000)...(2) File repaired
[v2.1] 2014-05-11 10:02 PST='D:\PST_orig - Copy\2006.pst'...(no backup 'N' option)...(SCANPST.EXE v14.0.6015.1000)...(0) No errors found

o Sometimes the tool gets stuck (e.g. with an empty file path specified). To restart the tool, you need to close the command window and also kill any scanpst.exe and ScanPSTOne.exe processes listed in the task manager.

o I have written the awk script to parse the output log file ScanPSTOne.log and give a summary of the results.
For summary output:
$ awk -f scanpstallreport.awk ScanPSTOne.log
========
FILENAME: ScanPSTOne.log
========
PST files successfully repaired                   : 47
PST files that could not be repaired              : 18
PST files that did not need to be repaired        : 0
PST files processed                               : 65
PST files unaccounted for                         : 0

For more verbose output:



JeremyC 12/5/2014
