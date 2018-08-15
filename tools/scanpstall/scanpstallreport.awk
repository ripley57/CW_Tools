# Description:
#
#   This script parses the output log file from the scanpstall tool.
#   See http://www.rethinkit.com/blog/tech-tip-outlook-how-to-bulk-fix-pst-files-scanpstall/
#
#   Usage examples:
#     find . -iname ScanPSTOne.log -exec awk -f scanpstallreport.awk {} \; > out.log
#     awk -f scanpstallreport.awk -v showdetail=true ScanPSTOne.log > out.log
#
# 11/5/2014

function getpstfilename(s) {
	sub(/^\[v.* PST='/,"", s);
	sub(/'.*$/,"", s);
	#printf ("getpstfilename=%s\n", s);
	return s;
}

function printBegin() {
	#printf("printBegin:\n");

	# Input argument to request detailed output.
	if (showdetail == "true")
		detail=1; 
}

function printEnd() {
	printf("========\n");
	printf("FILENAME: %s\n", FILENAME);
	printf("========\n");

	for (pst in psts_repair_count) {
		if (pst in psts_no_errors)
			psts_repaired[pst]=psts_repair_count[pst];
		else 
			psts_not_repaired[pst]=psts_repair_count[pst];
	}

	for (pst in psts_no_errors) {
		if (pst in psts_repair_count) {
		} else {
			psts_no_repair_required[pst]=pst
		}
	}

	if (detail) printf("PST FILES SUCCESSFULLY REPAIRED (repair attempts in brackets):\n");
	psts_repaired_cnt=0;
	for (pst in psts_repaired) {
		if (detail) printf("%s [%s]\n", pst, psts_repaired[pst]);
		psts_repaired_cnt++;
	}
	if (detail) printf("Total=%d\n", psts_repaired_cnt);

	if (detail) printf("\nPST FILES THAT COULD NOT BE REPAIRED FULLY:\n");
	psts_not_repaired_cnt=0;
	for (pst in psts_not_repaired) {
		if (detail) printf("%s [%s]\n", pst, psts_not_repaired[pst]);
		psts_not_repaired_cnt++;
	}
	if (detail) printf("Total=%d\n", psts_not_repaired_cnt);

	if (detail) printf("\nPST FILES THAT DID NOT NEED TO BE REPAIRED (repair attempts in brackets):\n");
	psts_no_repair_required_cnt=0;
	for (pst in psts_no_repair_required) {
		if (detail) printf("%s\n", pst);
		psts_no_repair_required_cnt++;
	}
	if (detail) printf("Total=%d\n", psts_no_repair_required_cnt);

	psts_processed_cnt=0;
	for (pst in psts_processed)
		psts_processed_cnt++;

	printf("\n");
	printf("%-50s: %d\n", "PST files successfully repaired", psts_repaired_cnt);
	printf("%-50s: %d\n", "PST files that could not be repaired", psts_not_repaired_cnt);
	printf("%-50s: %d\n", "PST files that did not need to be repaired", psts_no_repair_required_cnt);
	printf("%-50s: %d\n", "PST files processed", psts_processed_cnt);
	printf("%-50s: %d\n", "PST files unaccounted for", psts_processed_cnt - psts_repaired_cnt - psts_not_repaired_cnt - psts_no_repair_required_cnt);
	printf("\nEND\n\n\n");
}

BEGIN {
	printBegin();
}

/^.*$/			{
			  pstfilename=getpstfilename($0); 
			  psts_processed[pstfilename]=pstfilename;
			}

/^.* No errors found/	{
			  pstfilename=getpstfilename($0); 
                          psts_no_errors[pstfilename]=pstfilename;
			}


/^.* File repaired/	{
			  pstfilename=getpstfilename($0); 
			  if (pstfilename in psts_repair_count) 
				psts_repair_count[pstfilename]++;
			  else
				psts_repair_count[pstfilename]=1;
			}

/^.* Minor inconsistencies repaired/	{
			  pstfilename=getpstfilename($0); 
			  if (pstfilename in psts_repair_count) 
				psts_repair_count[pstfilename]++;
			  else
				psts_repair_count[pstfilename]=1;
			}

END { 
	printEnd();

}
