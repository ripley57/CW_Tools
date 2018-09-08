
Demo of the "createsearchfolder" and "deletesearchfolder" options to pstlister.exe
==================================================================================
1) Delete any existing MAPI profile that might exist for our pst file, from a previous execution of pstlister.exe:
pstlister.exe generated.pst -d

2) Create the "mysearchfolder" search folder in the pst:
pstlister.exe generated.pst createsearchfolder
(Note: the "createsearchfolder" option automatically uses "-p" to create a MAPI profile, and then uses "-d" to remove the profile).

3) Examine the pst file in MFCMAPI.
First we have to create the MAPI profile again (because it was removed by the "createsearchfolder" execution previously):
pstlister.exe generated.pst -p
Now we launch MFCMAPI and examine the PST, by using the usual "Session > Logon..." option to point to the MAPI profile.
Note: The new "mysearchfolder" should be under "Root Container >  Search Root".
After examining the pst, delete the profile again:
pstlister.exe generated.pst -d

4) Delete the "mysearchfolder" search folder in the pst:
pstlister.exe generated.pst deletesearchfolder

JeremyC 08-09-2018
