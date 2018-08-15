# DESCRIPTION:
#   Run this awk script against a server log to determine the time (seconds) of IGC operations like this:
#
#2016-07-21 05:57:10,556 INFO  [imaging.provider.ImageConversionTask] (pool-77-thread-2:) CaseName:[SECvTamas]  UserName:[superuser-275330470] Starting OFFICE imaging job 0.7.14.27852:BODY: on source files [D:\CW\V715\scratch\temp\esadb\dataStore_case_a82593ltl3_77637146\cache02\msgFileCache\1c5\ba6\a586881a4d3cb00414a74bcdf1\d00\CWMsgFile.msg].
#2016-07-21 05:57:10,568 INFO  [provider.igc.IGCJobSubmitterImpl] (pool-77-thread-2 - 0.7.14.27852:BODY::) CaseName:[SECvTamas]  UserName:[superuser-275330470] IGC conversion invoked for source file:\\192.168.2.120\CWShared\IGC\in\6066\CWMsgFile.msg
#2016-07-21 05:57:10,878 INFO  [plan.nativeview.NativeImagingPlan] (currName - 0.7.14.27853:BODY::) CaseName:[SECvTamas]  UserName:[superuser-275330470] Retrieved source files for Doc ID: 0.7.14.27853:BODY:, filepath=[D:\CW\V715\scratch\temp\esadb\dataStore_case_a82593ltl3_77637146\cache02\msgFileCache\f45\945\2bb39e5ee1606c9d237a7648f9\d00\CWMsgFile.msg]
#2016-07-21 05:57:10,878 INFO  [plan.nativeview.NativeImagingPlan] (currName - 0.7.14.27853:BODY::) CaseName:[SECvTamas]  UserName:[superuser-275330470] Resolved Doc Type: OFFICE
#2016-07-21 05:57:10,878 INFO  [plan.nativeview.NativeImagingPlan] (currName - 0.7.14.27853:BODY::) CaseName:[SECvTamas]  UserName:[superuser-275330470] Attempting IGC Native -> XDL conversion for #DocID: 0.7.14.27853:BODY: with timeout 180 seconds seconds.
#2016-07-21 05:57:24,141 INFO  [imaging.provider.ImageConversionTask] (pool-77-thread-2:) CaseName:[SECvTamas]  UserName:[superuser-275330470] Completed OFFICE imaging job 0.7.14.27852:BODY:.
#
# Example output:
#$ gawk.exe -f igcperf.awk server.log
#Time taken (seconds)  File Type       Start Time                End Time                  Start Line   End Line
#    2                 xls             2016-07-21 06:15:01,923   2016-07-21 06:15:03,452   6            15
#    2                 msg             2016-07-21 06:15:03,452   2016-07-21 06:15:05,870   16           20
#    3                 msg             2016-07-21 06:15:03,280   2016-07-21 06:15:06,353   11           25
#    2                 doc             2016-07-21 06:15:05,870   2016-07-21 06:15:07,866   21           30
#    2                 doc             2016-07-21 06:15:07,866   2016-07-21 06:15:09,317   31           35
#    3                 xls             2016-07-21 06:15:06,353   2016-07-21 06:15:09,660   26           40
#    2                 msg             2016-07-21 06:15:09,317   2016-07-21 06:15:11,735   36           45
#    3                 DOC             2016-07-21 06:15:09,660   2016-07-21 06:15:12,266   41           50
#    3                 msg             2016-07-21 06:15:11,735   2016-07-21 06:15:14,153   46           55
#    2                 doc             2016-07-21 06:15:12,266   2016-07-21 06:15:14,496   51           60
#    2                 doc             2016-07-21 06:15:14,496   2016-07-21 06:15:16,556   61           65
#    3                 msg             2016-07-21 06:15:16,556   2016-07-21 06:15:19,551   66           70
#    6                 doc             2016-07-21 06:15:14,153   2016-07-21 06:15:20,705   56           75
#    3                 msg             2016-07-21 06:15:19,566   2016-07-21 06:15:22,640   71           88
#    3                 msg             2016-07-21 06:15:20,705   2016-07-21 06:15:23,092   76           93
#    1                 htm             2016-07-21 06:15:23,092   2016-07-21 06:15:24,855   94           98
#    3                 xls             2016-07-21 06:15:22,640   2016-07-21 06:15:25,073   89           103
#    2                 doc             2016-07-21 06:15:24,855   2016-07-21 06:15:26,555   99           108
#    2                 xls             2016-07-21 06:15:25,073   2016-07-21 06:15:27,179   104          113
#    1                 xls             2016-07-21 06:15:27,179   2016-07-21 06:15:28,880   114          118
#    2                 msg             2016-07-21 06:15:26,555   2016-07-21 06:15:28,973   109          123
#    3                 xls             2016-07-21 06:15:28,880   2016-07-21 06:15:31,173   119          128
#    3                 msg             2016-07-21 06:15:28,973   2016-07-21 06:15:31,376   124          133
#    2                 ppt             2016-07-21 06:15:31,376   2016-07-21 06:15:33,560   134          138
#    3                 ppt             2016-07-21 06:15:31,173   2016-07-21 06:15:34,262   129          143
#    4                 ppt             2016-07-21 06:15:33,560   2016-07-21 06:15:37,132   139          148
#    3                 msg             2016-07-21 06:15:34,262   2016-07-21 06:15:37,241   144          151
#
#SUMMARY:
#
#Total items exmained : 28
#Total time of items  : 73
#Total average (secs) : 2.60714
#
#File Type       Count           Slowest (secs)  Average (secs)
#htm             1               1               1          (1/1)
#xls             6               3               2.33333    (14/6)
#DOC             1               3               3          (3/1)
#ppt             3               4               3          (9/3)
#doc             6               6               2.66667    (16/6)
#msg             11              3               2.72727    (30/11)
#	
# JeremyC 22/7/2016. 

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

function gettime(s) 			{ return substr(s,12,8); }
function getdate(s) 			{ return substr(s,0,10); }
function getdatetime(s)			{ return substr(s,0,19); }
function getdatetimeincms(s) 	{ return substr(s,0,23); }
 
function convertdatetimetoepochsec(s,	d_format, cmd, m, datetime_month, 
										datetime_day,
										datetime_year,
										datetime_time,
										ret) {
	ret = "";
	m = match(s, "[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] ");
	if (m > 0) {
        # Example: 2016-07-21 05:57:10,878
		datetime_year  = substr(s, 0,  4);
		datetime_day   = substr(s, 9,  2);
		datetime_month = substr(s, 6,  2);
		datetime_time  = substr(s, 12, 8);

		#printf("Input: %s\n", s);
		#printf("year  = %s\n", datetime_year);
		#printf("day   = %s\n", datetime_day);
		#printf("month = %s\n", datetime_month);
		#printf("time  = %s\n", datetime_time);

		# Convert to format we can convert.
		datetime_s = sprintf("%02d/%02d/%4d %s", datetime_month, datetime_day, datetime_year, datetime_time);

		# Convert from date string to epoch seconds.
		#system("date +%s -d\"" s "\"");
		cmd = "date +%s -d\"" datetime_s "\""
		cmd | getline ret;
		close(cmd);
	}
	#if (debug) printf("DEBUG: convertdatetimetoepochsec(): Returning:%s\n", ret);
	return ret;
}

# Extract job id. 
#
# Examples:
# ...Starting OFFICE imaging job 0.7.14.31482:BODY: on source files...
# ...Starting OFFICE imaging job 0.7.1.0:STANDALONE_ATT:2f5a28545069ef8ec7e8b48a712f2138 on source files...
#
# ...Completed OFFICE imaging job 0.7.14.31514:BODY:.
# ...Completed OFFICE imaging job 0.7.1.0:STANDALONE_ATT:095a583d854312f76be2fbd88046d64e.
#
function getjobid(s,		where_jobid_start, 	where_jobid_start_pos,
							where_jobid_end,	where_jobid_end_pos,
							jobid_len,			jobid_val) {
	jobid_val = "unknown";
	jobid_start = match(s, " OFFICE imaging job ");
	if (jobid_start) {
		jobid_start_pos = RSTART + RLENGTH;
		jobid_end = match(s, ":BODY:");
		if (jobid_end) {
			# ":BODY:" found.
			jobid_end_pos = RSTART;
			if (debug) printf("DEBUG: getjobid(): Line:%s :BODY: jobid_end=%s\n", NR, jobid_end);
		} else {
			# ":BODY:" not found, look for ":STANDALONE_ATT:".
			# Note: We need to include the checksum value too.
			jobid_end = match(s, ":STANDALONE_ATT:[a-zA-Z0-9]+");
			if (jobid_end) {
				jobid_end_pos = RSTART + RLENGTH;
			}
			if (debug) printf("DEBUG: getjobid(): Line:%s :STANDALONE_ATT: jobid_end=%s\n", NR, jobid_end);
		}
		if (jobid_end_pos) {
			jobid_len = jobid_end_pos - jobid_start_pos;
			jobid_val = substr(s, jobid_start_pos, jobid_len);
		}
	} else {
		if (debug) printf("WARNING: getjobid(): Line:%s not matched:\n%s\n\n", NR, s);
	}
	if (debug) printf("DEBUG: getjobid(): Returning:%s\n", jobid_val);
	return jobid_val;

}

# Extract file type
#
# Examples:
#   ...[D:\CW\V715\scratch\temp\esadb\dataStore_case_a82593ltl3_77637146\cache02\msgFileCache\1c5\ba6\a586881a4d3cb00414a74bcdf1\d00\CWMsgFile.msg].
#   ...[D:\CW\V715\scratch\temp\esadb\dataStore_case_a82593ltl3_77637146\imaging\0.7.14.31450.1\1\1.doc].
#
function getfiletype(s,		ext, t) {
    t=s; 
	sub(/.*\\/, "", t); 
	match(t, "\\.");
	ext = substr(t, RSTART);
	sub(/]./,"", ext);
	sub(/\./,"", ext);
	#if (debug) printf("DEBUG: getfiletype(): Returning:%s\n", ext);
	return ext;
}

# Print results header.
function printheader() {
	printf("\n%-21s %-15s %-25s %-25s %-12s %-12s\n\n", "Time taken (seconds)", "File Type", "Start Time", "End Time", "Start Line", "End Line");
}

BEGIN {
	# Change this from 0 to 1 to see debug logging.
	debug=0;
	
	# Total number of IGC jobs examined.
	count_total=0;
	
	# Total time of IGC jobs examined.
	time_total=0;

	printheader();
}

/Starting OFFICE imaging job / 			{
							cwjobid=getjobid($0);
							type=getfiletype($0);
							starttimeincms=getdatetimeincms($0);
							starttimenoms=getdatetime($0);
	
							starttimeepochsecs=convertdatetimetoepochsec(starttimenoms);
							jobids[cwjobid]["starttimeepochsecs"]=starttimeepochsecs;
							jobids[cwjobid]["starttimestr"]=starttimeincms;
							jobids[cwjobid]["type"]=type;
							jobids[cwjobid]["line_start"]=NR;
										}

/Completed OFFICE imaging job /			{
							cwjobid=getjobid($0);
							endtimeincms=getdatetimeincms($0);
							endtimenoms=getdatetime($0);
							endtimeepochsecs=convertdatetimetoepochsec(endtimenoms);
							line_end=NR;
							
							found=jobids[cwjobid]["starttimeepochsecs"];
							if (found) {
								type=jobids[cwjobid]["type"];
								line_start=jobids[cwjobid]["line_start"];
								starttimeepochsecs=jobids[cwjobid]["starttimeepochsecs"];
								starttimestr=jobids[cwjobid]["starttimestr"];

								timetakensecs = endtimeepochsecs - starttimeepochsecs;

								warn="";
								if (jobtimetakensecs > 180) 
									warn="*";
									
								printf("%-3s %-17s %-15s %-25s %-25s %-12s %-12s\n", warn, timetakensecs, type, starttimestr, endtimeincms, line_start, line_end);

								# Make output easily readable by repeating the header.
								total_count++;
								if (count_total % 100 == 0) {
									printheader();
								}
								
								# Save values for results summary.
								longest = types[type]["longest"];
								if (longest) {
									if (timetakensecs > longest) {
										types[type]["longest"]=timetakensecs;
										types[type]["longest_jobid"]=cwjobid;
									}
								} else {
									types[type]["longest"]=timetakensecs;
									types[type]["longest_jobid"]=cwjobid;
								}
								types[type]["time_total"]+=timetakensecs;
								time_total+=timetakensecs;
								types[type]["count"]+=1;
								count_total+=1;
							} else {
								printf("WARNING: Found end time but not start time for job: %s\n", cwjobid);
							}
										} 
										
END {
							printf("\nSUMMARY:\n\n");
							
							printf("\nTotal items exmained : %s\n", count_total);
							printf("Total time of items  : %s\n", time_total);
							printf("Total average (secs) : %s\n\n", time_total / count_total);
							
							printf("%-15s %-15s %-15s %-10s\n",     "File Type",  "Count",           "Slowest (secs)",    "Average (secs)");
							for (t in types) {
								printf("%-15s %-15s %-15s %-10s (%s/%s)\n", t,            types[t]["count"], types[t]["longest"], types[t]["time_total"] / types[t]["count"], types[t]["time_total"], types[t]["count"]); 
							}
}
