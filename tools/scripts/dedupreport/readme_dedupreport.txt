dedupreport readme

This script parses the metadata XML from an export and does the following:
1. Creates a report of all source locations for each document (report1.log).
2. Creates a report of the number of source locations for each DOC id (most de-duped at top) (report2.log).
3. Calculates the de-duplication %.

NOTE: To run this script, you need to be on a system with Cygwin installed.
      After you have unzipped dedupreport.zip, you may need to adjust the
      path to the Cygwin installation (default location C:\cygwin).

To run the script:

1. Unzip dedupreport.zip into a temporary directory containing the clearwe_export_000*.xml files. 

2. Launch a DOS prompt and cd to the temporary directory created in step 1.

3. Run the dedup report script:

run_dedupreport.bat

4. You should see output similar to the following:

Parsing XML files. This may take several minutes...

Number of items processeed by CW:
66064

Number of unique items indexed by CW:
22397

De-dup%:
66%

See report1.log for all source locations of each Doc ID.
See report2.log for number of source locations of each Doc ID (most de-duped at top).


(JeremyC 15/10/2012)
