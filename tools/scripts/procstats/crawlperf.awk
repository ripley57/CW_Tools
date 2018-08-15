# DESCRIPTION:
#   Run this awk script against a PSTCrawler_output.log file, to
#   show the processing times of individual PST files and to 
#   indicate PST files that were not crawled successfully.
#
# Usage:
#   gawk.exe -f crawlperf.awk <pst crawler log file> 	
#                           [date="YYYY-MM-DD"] 
#							[date-from="YYYY-MM-DD HH:MM:SS"] 
#							[date-to="YYYY-MM-DD HH:MM:SS"]
#							[[casename=<casename>]
#							[debug=0|1] 
#							[verbose=0|1]
#							[verbose_stages=START,SCANNED,END,DELETE]
# Where:
#   date		    :	Only consider log entries from this date.
#   date-from  	    :	Only consider log entries after this date/time.
#   date-to		    : 	Only consider log entries before this date/time.
#   casename	    :	Only consider log entries from this case.
#   debug		    :	Disable or enable debug logging.
#   verbose		    :	Disable or enable verbose logging.
#   verbose_stages	:	Display verbose logging only for these stages.
#
#
# Example output:
#
# CRAWL TIME (secs) | CRAWL START         | CRAWL END                             | PST
# -                 | 2016-10-03 17:03:38 | 2016-10-03 17:15:29 HeapAlloc failed! | \\files\20160307\G Ann\Export_15.pst (key=33944_2016-0198_1927826416325615_2016-0198__PST13)
# -                 | 2016-10-03 16:44:35 | 2016-10-03 17:00:08 HeapAlloc failed! | \\files\20160307\G Ann\Export_15.pst (key=12756_2016-0198_1927826416325615_2016-0198__PST6)
# 142               | 2016-10-03 12:26:46 | 2016-10-03 12:29:08                   | \\files\20160307\G Ann\Export_16.pst (key=39652_2016-0198_1927826416325615_2016-0198__PST14)
# -                 | 2016-10-03 17:03:38 | 2016-10-03 17:15:37 HeapAlloc failed! | \\files\20160307\G Ann\Export_19.pst (key=42440_2016-0198_1927826416325615_2016-0198__PST12)
# -                 | 2016-10-03 16:44:33 | 2016-10-03 17:00:08 HeapAlloc failed!
#
# HISTORY:
#   Initial version 15/2/2016. JeremyC.
#   Tidy 28/3/2016. JeremyC.

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

function quoteltrim(s) { sub(/^[\"]+/, "", s); return s }
function quotertrim(s) { sub(/[\"]+$/, "", s); return s }
function quotetrim(s)  { return quotertrim(quoteltrim(s)); }

function replacespaceswithunderscores(s) { sub(/ /, "_", s); return s }
function replaceunderscoreswithspaces(s) { sub(/_/, " ", s); return s }

function gettime(s)     { return substr(s,12,8); }
function getdate(s)     { return substr(s,0,10); }
function getdatetime(s) { return substr(s,0,19); }
						
# Convert date string to epoch seconds.
# See the following link if the date conversion to epoch
# using the date command fails with error "invalid date":
# http://ubuntuforums.org/showthread.php?t=2217020
# This is because, irrespective of the locale or LANG 
# setting, the format is expected to be US ('mm/dd/yyyy').
#
# Example of string to convert: 
# 12/03/2013
function convertdatetoepochsec(s,	cmd, ret) {
	ret = "";
	cmd = "date +%s -d\"" s "\""
	cmd | getline ret;
	close(cmd);
	return ret;
}

# Convert date/time string to epoch seconds.						
# See the following link if the date conversion to epoch
# using the date command fails with error "invalid date":
# http://ubuntuforums.org/showthread.php?t=2217020
# This is because, irrespective of the locale or LANG 
# setting, the format is expected to be US ('mm/dd/yyyy').
#
# Example of string to convert: 
# 12/03/2013 17:23:30
function convertdatetimetoepochsec(s,	d_format, cmd, m, 
										datetime_month, 
										datetime_day,
										datetime_year,
										datetime_time,
										datetime_us, 
										ret) {
	ret = "";
	m = match(s, "[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9] ");
	if (m > 0) {
		# Depending on the locale settings of the CW appliance, the
		# date strings in the processing job log will be either in
		# US format (mm/dd/yyy hh:mm:ss) or UK format (dd/mm/yyyy hh:mm:ss).
		# We will check if the month or day value is greater than 12. If 
		# either value is greater than 12 then we know what the date string
		# format is. If neither value is greater than 12 then we will assume
		# a US date string format.
		d_format = "us";

		# Assume UK date format to start with (dd/mm/yyyy NN:NN:NN).
		datetime_day   = substr(s, 0, 2);
		datetime_month = substr(s, 4, 2);

		# Attempt to determine date format from day and month values.
		if (datetime_day > 12) 
			d_format = "uk";
		else
		if (datetime_month > 12)
			d_format = "us";

		# Whatever the input format is, to convert from date string to
		# epoch seconds, the date command always expects a US input string.
		if (d_format=="uk") {
			# UK date format: dd/mm/yyyy NN:NN:NN.
			datetime_day   = substr(s, 0, 2);
			datetime_month = substr(s, 4, 2);
			datetime_year  = substr(s, 7, 4);
			datetime_time  = substr(s, 12, 8);
		} else {
			# US date format: mm/dd/yyyy NN:NN:NN.
			datetime_month = substr(s, 0, 2);
			datetime_day   = substr(s, 4, 2);
			datetime_year  = substr(s, 7, 4);
			datetime_time  = substr(s, 12, 8);
		}		
		datetime_s = sprintf("%02d/%02d/%4d %s", datetime_month, datetime_day, datetime_year, datetime_time);

		# Now convert from the date string to epoch seconds.
		# Notice the trick of how to run a system command and capture the output,
		# because capturing the return value from system() only returns success or
		# failure, i.e. not the output from the system command. Notice also the use
		# of the close() function. I've seen strange things happen with multiple
		# input files if this function is not called.
		#system("date +%s -d\"" s "\"");
		cmd = "date +%s -d\"" datetime_s "\""
		cmd | getline ret;
		close(cmd);
	}
	#printf("convertdatetimetoepochsec: ret=%s\n", ret);
	return ret;
}

# Convert epoch seconds to readable date string.
function convertepochsectodatetime(s,	cmd,ret) {
	ret = "";
	#cmd = "date -d @\"" s "\""
	cmd = "date +\"%F %T\" -d @\"" s "\""
	cmd | getline ret;
	close(cmd);
	return ret;
}

# Extract the pid and source values from a log line like this...
#
#    2016-02-01 12:22:31,637 [36360] INFO  adapter CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#    PerformanceTest__PST9_1923724722557935 - Created New Profile: EsaMapi7_f62e312b3451d9a4f1c8a1fcdf14f6ca
#    PST File: \\forensicsfs\projects\PerformanceTest\test\Andy Z\andyZ.pst_name
#
# ...and return the value of "<pid>_<source>".  
#  This value will be used as a lookup key for tracking each pst file being processed. 
#
function get_pid_source_key(s,	pid_start, 
								pid_end, 
								pid,source_start, 
								source, 
								ret) {
    # Extract pid value, e.g. "[36360]".
	pid_start = match(s, "\\[");
	pid_end   = match(s, "\\] INFO |\\] ERROR ");
	pid       = substr(s, pid_start+1, pid_end-pid_start-1);
	
	# Extract source value, e.g. "CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]"
	source_start = match(s, "CaseName:[^\\]]+\\]");
	source=substr(s, source_start, RLENGTH);
	sub(/^CaseName:\[/,"",source);
	sub(/\]$/,"",source);

	# Return "<pid>_<source>".
	ret = sprintf("%s_%s", pid, source);
	return ret;
}

# Extract the "EsaMapi" profile name from a log line like this...
#
#   2016-02-01 12:22:31,637 [36360] INFO  adapter CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - Created New Profile: EsaMapi7_f62e312b3451d9a4f1c8a1fcdf14f6ca
#   PST File: \\forensicsfs\projects\PerformanceTest\test\Andy Z\andyZ.pst
#
# ...and return it. 
# This log line is seen when a new profile is created to crawl a new pst file.
#
function get_mapi_profile_name_creatednewprofile(s,	mapi_name_start, 
													ret) {
	mapi_name_start=match(s, "EsaMapi[^ ]+ ");
	ret=substr(s, mapi_name_start, RLENGTH);
	return ret;
}

# Extract the "EsaMapi" profile name from a log line like this...
#
#   2016-02-01 12:24:47,973 [36360] INFO  crawler.session CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - Deleting profile: EsaMapi7_f62e312b3451d9a4f1c8a1fcdf14f6ca
#
# ...and return it.
# This log line it seen when a profile is deleted after crawling a pst file.
#
function get_mapi_profile_name_deletingprofile(s,	mapi_name_start,
													ret) {
	mapi_name_start=match(s, "EsaMapi.*$");
	ret=substr(s, mapi_name_start, RLENGTH);
	return ret;
}

# Extract the pst file name from a log line like this...
#
#   2016-02-01 12:22:31,637 [36360] INFO  adapter CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - Created New Profile: EsaMapi7_f62e312b3451d9a4f1c8a1fcdf14f6ca
#   PST File: \\forensicsfs\projects\PerformanceTest\test\Andy Z\andyZ.pst
#
# ...and return it.
#
function get_pst_name_creatednewprofile(s,	pst_name_start, 
											ret) {
	pst_name_start=match(s, "PST File:.+\\.pst");
	ret=substr(s, pst_name_start, RLENGTH);
	sub(/^PST File: /,"",ret);
	return ret;
}

# Extract the pst name from a log line like this...
#
#   2016-02-01 12:24:47,957 [36360] INFO  adapter CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - PST file scan finished:
#   \\forensicsfs\projects\PerformanceTest\test\Andy Z\andyZ.pst Message Count: 12244 Duplicate Count: 7890
#
# ...and return it.
#
function get_pst_name_pstfilescanfinished(s,	pst_name_start,
												ret) {
	pst_name_start=match(s, "PST file scan finished: .+\\.pst");
	ret=substr(s, pst_name_start, RLENGTH);
	sub(/^PST file scan finished: /,"",ret);
	return ret;
}

# Extract the epoch time from a log line like this...
#
#   2016-02-01 12:22:31,637 [36360] INFO  adapter CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - Created New Profile: EsaMapi7_f62e312b3451d9a4f1c8a1fcdf14f6ca
#   PST File: \\forensicsfs\projects\PerformanceTest\test\Andy Z\andyZ.pst
#
# ...and return it.
#
function get_epoch_time(s,	s1, s2,	
							ret) {
	s1=substr(s,0,19);

	# Convert to format "dd/mm/yyyy NN:NN:NN" as expected by convertdatetimetoepochsec().
	datetime_day   = substr(s1, 9, 2);
	datetime_month = substr(s1, 6, 2);
	datetime_year  = substr(s1, 0, 4);
	datetime_time  = substr(s1, 12, 8);
	s2=sprintf("%s/%s/%s %s", datetime_day, datetime_month, datetime_year, datetime_time);
	ret=convertdatetimetoepochsec(s2);
	return ret;
}

# Extract the "Message Count" value from a log line like this...
#
#   2016-02-01 12:24:47,957 [36360] INFO  adapter CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - PST file scan finished:
#   \\forensicsfs\projects\PerformanceTest\test\Andy Z\andyZ.pst Message Count: 12244 Duplicate Count: 7890
#
# ...and return it.
#
function get_message_count(s,		message_count_start,
									ret) {
	message_count_start=match(s, "Message Count: [0-9]+ ");
	ret=substr(s, message_count_start, RLENGTH);
	sub(/^Message Count: /,"", ret);
	sub(/ $/,"", ret);
	return ret;
}

# Extract the "Duplicate Count" vlue from a log line like this...
#
#   2016-02-01 12:24:47,957 [36360] INFO  adapter CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - PST file scan finished:
#   \\forensicsfs\projects\PerformanceTest\test\Andy Z\andyZ.pst Message Count: 12244 Duplicate Count: 7890
#
# ..and return it.
#
function get_duplicate_count(s,		duplicate_count_start,
									ret) {
	duplicate_count_start=match(s, "Duplicate Count: [0-9]+$");
	ret=substr(s, duplicate_count_start, RLENGTH);
	sub(/^Duplicate Count: /,"", ret);
	sub(/ $/,"", ret);
	return ret;
}

# Helper function to return the names of the different processing 
# values that we are tracking for each pst file being processed.
function get_value_names(	value_names_string) {
	value_names_string = 	"mapi_profile_name" 					"#" \
							"pst_name" 								"#" \
							"creatednewprofile_epoch" 				"#" \
							"pstfilescanfinished_message_count" 	"#" \
							"pstfilescanfinished_duplicate_count" 	"#" \
							"pstfilescanfinished_epoch" 			"#" \
							"endcrawlfor_epoch" 					"#" \
							"deletingprofile_epoch" 				"#" \
							"future_ignore" 						"#" \
							"pstheapallocfailed"					"#" \
							"pstheapallocfailed_epoch"				"#" \
							"case_name";
	return value_names_string;
}
function get_value_names_sep() {
	return "#";
}

# Reset all the values associated with a specific key.
function reset_values(key,		value_names, n) {
	split(get_value_names(),value_names,get_value_names_sep());
	for (n in value_names) {
		delete psts[key][value_names[n]];
	}
}

# Copy values from one key to another key.
function copy_values(key_from, key_to,		value_names, n) {
	split(get_value_names(),value_names,get_value_names_sep());
	for (n in value_names) {
		psts[key_to][value_names[n]]=psts[key_from][value_names[n]];
	}
}

# A new <pid>_<source> key has just been created that clashes with an existing key.
# We do not want to overwrite and lose the processing information associated with
# the old processing, so we create a new unique key for that old processing, by
# using mapi profile name as part of the key, and we then re-associate all the old 
# processing information with this new key. Finally, we reset all the old processing
# values associated with the old key, so that the old key can be re-used for this 
# new processing.
function renamekey(key_from, key_to) {
	if (debug) printf("DEBUG: (renamekey): Renaming key \"%s\" to \"%s\"\n", key_from, key_to);
	copy_values(key_from, key_to);
	reset_values(key_from);
}

function printValues(key,	value_names) {
	split(get_value_names(),value_names,get_value_names_sep());
	printf("\nkey=%s\n",		key);
	for (n in value_names) {
		printf("\t%-30s : %s\n", value_names[n], psts[key][values_names[n]]);
	}
}

# Extract the mapi profile name, pst name, and case name from a log line like this...
# 
#   2016-02-01 12:22:31,637 [36360] INFO  adapter CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - Created New Profile: EsaMapi7_f62e312b3451d9a4f1c8a1fcdf14f6ca
#   PST File: \\forensicsfs\projects\PerformanceTest\test\Andy Z\andyZ.pst
#
# ...and start tracking a new pst file being processed.
#
# Input arguments:
#	pid_source		-		<pid>_<source> key value to track the pst file being processed.
#	epochtime		-		Epoch time already extracted from log line.
#	s				-		The full log line.
#
function parseCreatedNewProfile(pid_source,epochtime,s,		mapi_profile_name,
															pst_name,
															pid_source_profile) {
	mapi_profile_name=get_mapi_profile_name_creatednewprofile(s);
	pst_name=get_pst_name_creatednewprofile(s);

	# Show progress during debugging.
	if (debug==1 && (NR % 10 == 0))
		printf("DEBUG: Processing line number %d...\n", NR);

	if (pid_source in psts) {
		# The same <pid>_<source> key is going to be re-used.
		# This is perfectly valid, but we do not want to overwrite
		# and lose the last processing that used this key, so we 
		# will re-associate the old values with a new unique key
		# that also includes the mapi profile name.
		if (debug) {
			printf("\nDEBUG: (parseCreatedNewProfile): key \"%s\" already exists:\n", pid_source);
			printValues(pid_source);
		}
		pid_source_profile=sprintf("%s_%s", pid_source, psts[pid_source]["mapi_profile_name"]);
		renamekey(pid_source,pid_source_profile);
	}

	# Save the initial values for the new pst file being crawled.
	psts[pid_source]["mapi_profile_name"]=trim(mapi_profile_name);
	psts[pid_source]["pst_name"]=trim(pst_name);
	psts[pid_source]["creatednewprofile_epoch"]=epochtime;

	# Initialise the "ignore" field. We use this field to indicate when there
	# was an issue during the pst crawling and we should ignore the values
	# from the remaining processing stages.
	psts[pid_source]["future_ignore"]=0;
	
	if (verbose_stage_start)
		printf("START   : %s [%s]\n",convertepochsectodatetime(epochtime), pst_name);
}

# Extract the HeapAlloc failed values from a log line like this:
#
#   2016-03-10 17:15:29,172 [33944] ERROR root CaseName:[2016-0198_1927826416325615_2016-0198__PST13] 2016-0198__PST13_1927826416325615 -
#   HeapAlloc failed for size:1300014 at alloc: 42754 Largest available continuous memory block is 1286144
#
function parseHeapAllocfailed(pid_source,epochtime,s,	pst_name) {
	if (pid_source in psts) {
	} else {
		# For some reason, we do not know anything about this pst file, so 
		# there is no point saving the processing values, because we have 
		# no previous values to compare them against.
		if (psts[pid_soure]["future_ignore"]==0)
			printf("WARN: (parseHeapAllocfailed): Could not find key \"%s\"\n", pid_source);
		psts[pid_soure]["future_ignore"]=1;
		return;
	}
	
	# Record processing values.
	psts[pid_source]["pstheapallocfailed"]=1;
	psts[pid_source]["pstheapallocfailed_epoch"]=epochtime;
}

# Extract the file scan completed values from a log line like this:
#
#   2016-02-01 12:24:47,957 [36360] INFO  adapter CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - PST file scan finished:
#   \\forensicsfs\projects\PerformanceTest\test\Andy Z\andyZ.pst Message Count: 12244 Duplicate Count: 7890
#
function parsePSTfilescanfinished(pid_source,epochtime,s,	pst_name, 
															message_count, 
															duplicate_count) {
	pst_name=get_pst_name_pstfilescanfinished(s);
	message_count=get_message_count(s);
	duplicate_count=get_duplicate_count(s);

	if (pid_source in psts) {
	} else {
		# For some reason, we do not know anything about this pst file, so 
		# there is no point saving the processing values, because we have 
		# no previous values to compare them against.
		if (psts[pid_soure]["future_ignore"]==0)
			printf("WARN: (parsePSTfilescanfinished): Could not find key \"%s\"\n", pid_source);
		psts[pid_soure]["future_ignore"]=1;
		return;
	}
 
	# Sanity checking.
	if (psts[pid_source]["pst_name"] != pst_name) {
		printf("WARN: (parsePSTfilescanfinished): pst file \"%s\" name not expected (\"%s\")\n", pst_name, psts[pid_source]["pst_name"]);
		return;
	}
	
	# Record processing values.
	psts[pid_source]["pstfilescanfinished_message_count"]=trim(message_count);
	psts[pid_source]["pstfilescanfinished_duplicate_count"]=trim(duplicate_count);
	psts[pid_source]["pstfilescanfinished_epoch"]=epochtime;

	if (verbose_stage_scanned)
		printf("SCANNED : %s message_count=%s duplicate_count=%s [%s]\n", convertepochsectodatetime(epochtime), message_count, duplicate_count, pst_name);
}

# Extract the end crawl values from a log line like this:
#
#   2016-02-01 12:24:47,973 [36360] INFO  crawler.session CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - End crawl for: PerformanceTest_1923724722557935_PerformanceTest__PST9_1923724722557935
#
function parseEndcrawlfor(pid_source,epochtime,s) {
	if (pid_source in psts) {
	} else {
		# For some reason, we do not know anything about this pst file, so 
		# there is no point saving the processing values, because we have 
		# no previous values to compare them against.
		if (psts[pid_soure]["future_ignore"]==0)
			printf("WARN: (parseEndcrawlfor): Could not find key \"%s\"\n", pid_source);
		psts[pid_soure]["future_ignore"]=1;
		return;
	}

	# Record processing values.
	psts[pid_source]["endcrawlfor_epoch"]=epochtime;

	if (verbose_stage_end)
		printf("END     : %s [%s]\n",convertepochsectodatetime(epochtime),psts[pid_source]["pst_name"]);
}

# Extract the deleting profile values from a log line like this:
#
#   2016-02-01 12:24:47,973 [36360] INFO  crawler.session CaseName:[PerformanceTest_1923724722557935_PerformanceTest__PST9]
#   PerformanceTest__PST9_1923724722557935 - Deleting profile: EsaMapi7_f62e312b3451d9a4f1c8a1fcdf14f6ca
#
function parseDeletingprofile(pid_source,epochtime,s,		mapi_profile_name) {
	mapi_profile_name=get_mapi_profile_name_deletingprofile(s);

	if (pid_source in psts) {
	} else {
		# For some reason, we do not know anything about this pst file, so 
		# there is no point saving the processing values, because we have 
		# no previous values to compare them against.
		if (psts[pid_soure]["future_ignore"]==0)
			printf("WARN: (parseDeletingprofile): Could not find key \"%s\"\n", pid_source);
		psts[pid_soure]["future_ignore"]=1;
		return;
	}

	# Sanity checking.
	if (psts[pid_source]["mapi_profile_name"] != mapi_profile_name) {
		printf("WARN: (parseDeletingprofile): mapi profile name \"%s\" does not match expected (\"%s\")\n", mapi_profile_name, psts[pid_source]["mapi_profile_name"]);
		return;
	}
	
	# Record the processing values.
	psts[pid_source]["deletingprofile_epoch"]=epochtime;

	# We are finished now, so we might as well clear the ignore field,
	# to indicate that we got successfully to the last processing stage.
	psts[pid_soure]["future_ignore"]=0;
	
	if (verbose_stage_delete)
		printf("DELETE  : %s [%s]\n",convertepochsectodatetime(epochtime),psts[pid_source]["pst_name"]);
}

# Extract case name from <pid>_<source> key.
# Example <pid>_<source> string to extract case name from:
#   45172_EXAMPLE-CASE-NAME_1927826416325615_EXAMPLE-CASE-NAME__PST13
function get_case_name(key,		i, s) {
	# Extract eveything up to that large number (the numeric case id I believe).
	i=match(key, "_[0-9]{10}");
	s=substr(key, 0, i-1);
	
	# Strip leading pid value.
	sub(/^[0-9]+_/,"",s);
	
	# Convert back to actual case name.
	s=replaceunderscoreswithspaces(s);
	
	return s;
}

# Given a <pid>_<source> key, indicate if the processing should be ignored or not
# based on the case name included in the key. Return 1 if the processing should be 
# ignored.
function filter_by_case(key,	case_name) {
	# Extract case name from key and add to list of total cases seen.
	case_name=get_case_name(key);
	cases[case_name]=1;

	if (filter_case == "") {
		# Do not filter. No filter requested from input arguments.
		return 0;
	}
	return match(key, filter_case) == 0;
}

# Given an epoch time value, indicate if the processing should be ignored or not.
# Return 1 if the processing should be ignored.
function filter_by_date(epochtime) {
	return !(epochtime >= filter_date_from && epochtime <= filter_date_to);
}

# For use with gawk.exe PROCINFO["sorted_in"] for sorting arrays.
function cmp_sort_by_pst_name(i1, v1, i2, v2) {
	# string comparison.
	v1_tmp=v1["pst_name"];
	v2_tmp=v2["pst_name"];
	if (v1_tmp < v2_tmp)
		return -1;
	return (v1_tmp != v2_tmp);
}

function cmp_sort_by_pst_name_and_creatednewprofile_epoch(i1, v1, i2, v2) {
	# string comparison.
	v1_tmp=sprintf("%s_%s", v1["pst_name"], v1["creatednewprofile_epoch"]);
	v2_tmp=sprintf("%s_%s", v2["pst_name"], v2["creatednewprofile_epoch"]);
	#printf("Comparing: \"%s\" with \"%s\"\n", v1_tmp, v2_tmp);
	if (v1_tmp < v2_tmp)
		return -1;
	return (v1_tmp != v2_tmp);
}

# For use with gawk.exe PROCINFO["sorted_in"] for sorting arrays.
function cmp_sort_by_crawl_start_time(i1, v1, i2, v2) {
	# numerical comparison, ascending order.
	v1_tmp=v1["creatednewprofile_epoch"];
	v2_tmp=v2["creatednewprofile_epoch"];
	return (v1_tmp - v2_tmp);
}

# For use with gawk.exe PROCINFO["sorted_in"] for sorting arrays.
function cmp_sort_by_crawl_time(i1, v1, i2, v2) {
	# numerical comparison, descending order.
	v1_tmp=v1["total_crawl_time_secs"];
	v2_tmp=v2["total_crawl_time_secs"];
	return (v2_tmp - v1_tmp);
}

BEGIN {
	# Set to 1 to see debug output.
	debug=0;

	# Set to 1 to see verbose output.
	verbose=0;

	# Default values.
	filter_date_from=0;
	filter_date_to=convertdatetoepochsec("2038-01-01");

	# Process command-line arguments.
	verbose_stages_requested=0;
	for (i = 1; i < ARGC; i++) {
		arg=ARGV[i];
		if (arg ~ /date=/) {
			# Only consider log entries on the following date.
			# Note: Date needs to be in US format: YYYY-MM-DD.
			split(arg,a,"=");
			filter_date_from=convertdatetoepochsec(a[2]);
			filter_date_to=convertdatetoepochsec(a[2]) + (24*60*60);
		} 
		else
		if (arg ~ /date-from=/) {
			# Only consider log entries after this date and time.
			# Note: Date needs to be in US format: YYYY-MM-DD [HH:MM:SS].
			split(arg,a,"=");
			filter_date_from=convertdatetoepochsec(a[2]);

		} 
		else
		if (arg ~ /date-to=/) {
			# Only consider log entries before this date and time.
			# Note: Date needs to be in US format: YYYY-MM-DD [HH:MM:SS].
			split(arg,a,"=");
			filter_date_to=convertdatetoepochsec(a[2]);
		} 
		else
		if (arg ~ /casename=/) {
			# Only consider log entries for the following case name.
			split(arg,a,"=");
			# Note: We need to generate the case name as it appears in the pst crawler log.
			filter_case=replacespaceswithunderscores(a[2]);
			if (debug) printf("DEBUG: argument casename=%s\n", filter_case);
		} 
		else 
		if (arg ~/debug=/) {
			split(arg,a,"=");
			debug=a[2];
		} 
		else 
		if (arg ~/verbose=/) {
			split(arg,a,"=");
			verbose=a[2];
		} 
		else
		if (arg ~/verbose_stages=/) {
			verbose_stages_requested=1;
			# We have a list of verbose stages specified,
			# so we will turn off each stage by default,
			# and let the input argument turn each back
			# on, if specified.
			verbose_stage_start=0
			verbose_stage_scanned=0
			verbose_stage_end=0;
			verbose_stage_delete=0;

			split(arg,a1,"=");

			# Ensure last field is seen after split.
			stages=sprintf("%s,", a1[2]);

			# Split string into each stage requested.
			n=split(stages,a2,",");
			for (j=1; j<n; j++) {
				verbose=1;
				if (a2[j] ~ /START/)
					verbose_stage_start=1;
				else
				if (a2[j] ~ /SCANNED/)
					verbose_stage_scanned=1;
				else
				if (a2[j] ~ /END/)
					verbose_stage_end=1;
				else
				if (a2[j] ~ /DELETE/)
					verbose_stage_delete=1;
			}
		}
	}

	# Specify the stages to log verbosely.
	if (verbose_stages_requested==0) {
		verbose_stage_start=verbose;
		verbose_stage_scanned=verbose;
		verbose_stage_end=verbose;
		verbose_stage_delete=verbose;
	}

	if (debug) printf("DEBUG: filter_date_from=%s, filter_date_to=%s\n", filter_date_from, filter_date_to);
	if (debug) printf("DEBUG: verbose_stage_start=%s, verbose_stage_scanned=%s, verbose_stage_end=%s, verbose_stage_delete=%s\n",
								verbose_stage_start, verbose_stage_scanned, verbose_stage_end, verbose_stage_delete);

	# For debugging input arguments.
	#exit(0);

}

/Created New Profile:/		{	
					epochtime=get_epoch_time($0);
					if (filter_by_date(epochtime)) {
					} else {
						key=get_pid_source_key($0)
						if (filter_by_case(key)) {
						} else
							parseCreatedNewProfile(key, epochtime, $0);
					}
				}

/PST file scan finished:/	{
					epochtime=get_epoch_time($0);
					if (filter_by_date(epoch_time)) {
					} else {
						key=get_pid_source_key($0)
						if (filter_by_case(key)) {
						} else
							parsePSTfilescanfinished(key, epochtime, $0);	
					}
				}

/End crawl for:/		{		
					epochtime=get_epoch_time($0);
					if (filter_by_date(epochtime)) {
					} else {
						key=get_pid_source_key($0)
						if (filter_by_case(key)) {
						} else
							parseEndcrawlfor(key, epochtime, $0);
					}
				}

/Deleting profile:/		{	
					epochtime=get_epoch_time($0);
					if (filter_by_date(epochtime))  {
					} else {
						key=get_pid_source_key($0)
						if (filter_by_case(key)) {
						} else
							parseDeletingprofile(key, epochtime, $0);
					}
				}

/HeapAlloc failed for size:/	{
					epochtime=get_epoch_time($0);
					if (filter_by_date(epochtime))  {
					} else {
						key=get_pid_source_key($0)
						if (filter_by_case(key)) {
						} else
							parseHeapAllocfailed(key, epochtime, $0);
					}	

				}				

END {
	# Calculate various timings.
	for (key in psts) {
		if (psts[key]["deletingprofile_epoch"]!="" && psts[key]["creatednewprofile_epoch"]!="") 
			crawl_time_total_secs=psts[key]["deletingprofile_epoch"]-psts[key]["creatednewprofile_epoch"];
		else
			crawl_time_total_secs=-1;
			
		#if (psts[key]["pstfilescanfinished_epoch"]!="" && psts[key]["creatednewprofile_epoch"]!="")
		#	crawl_time_pstfilescanfinished_secs=psts[key]["pstfilescanfinished_epoch"]-psts[key]["creatednewprofile_epoch"];
		#else
		#	crawl_time_pstfilescanfinished_secs=-1;
		
		#if (psts[key]["deletingprofile_epoch"]!="" && psts[key]["endcrawlfor_epoch"]!="")
		#	crawl_time_endcrawlfor_secs=psts[key]["deletingprofile_epoch"]-psts[key]["endcrawlfor_epoch"];
		#else
		#	crawl_time_endcrawlfor_secs=-1;

		# Save the calculted timings.
		psts[key]["crawl_time_total_secs"]=crawl_time_total_secs;
		#psts[key]["crawl_time_pstfilescanfinished_secs"]=crawl_time_pstfilescanfinished_secs;
		#psts[key]["crawl_time_endcrawlfor_secs"]=crawl_time_endcrawlfor_secs;
	}

	#
	# Display the results.
	#
	
	# Indicate if multiple cases appeared during analysis.
	cases_number=length(cases);
	if (cases_number > 1) {
		printf("\nWARNING: Multiple cases identified (%d). This can affect performance.\n", cases_number);
		printf("Cases:\n");
		for (c in cases) 
			printf("  %s\n", c);
		printf("\n");
	}
	
	# Sorting by pst_name + creatednewprofile_epoch.
	#PROCINFO["sorted_in"]="cmp_sort_by_pst_name";
	PROCINFO["sorted_in"]="cmp_sort_by_pst_name_and_creatednewprofile_epoch";
	printf("%-17s | %-19s | %-37s | %s\n\n", "CRAWL TIME (secs)","CRAWL START","CRAWL END","PST");
	for (j in psts) {
		if (psts[j]["future_ignore"]==1)
			continue;
		
		if (psts[j]["pst_name"]=="")
			continue;
	
		# Debugging.
		if (0) {
			printf("\nPST=%s\n", psts[j]["pst_name"]);
			printf("creatednewprofile_epoch=%s\n", psts[j]["creatednewprofile_epoch"]);
			printf("pstfilescanfinished_epoch=%s\n", psts[j]["pstfilescanfinished_epoch"]);
			printf("endcrawlfor_epoch=%s\n", psts[j]["endcrawlfor_epoch"]);
			printf("deletingprofile_epoch=%s\n", psts[j]["deletingprofile_epoch"]);
			printf("crawl_time_total_secs=%s\n", psts[j]["crawl_time_total_secs"]);
		}
			
		creatednewprofile_epoch=psts[j]["creatednewprofile_epoch"];
		if (creatednewprofile_epoch != "")
			creatednewprofile_epoch=convertepochsectodatetime(creatednewprofile_epoch);
			
		#pstfilescanfinished_epoch=psts[j]["pstfilescanfinished_epoch"];
		#if (pstfilescanfinished_epoch != "")
		#	pstfilescanfinished_epoch=convertepochsectodatetime(pstfilescanfinished_epoch);
			
		deletingprofile_epoch=psts[j]["deletingprofile_epoch"];
		if (deletingprofile_epoch != "")
			deletingprofile_epoch=convertepochsectodatetime(deletingprofile_epoch);
			
		crawl_time_total_secs=psts[j]["crawl_time_total_secs"];	
		if (crawl_time_total_secs == "-1")
			crawl_time_total_secs="-";
			
		if (psts[j]["pstheapallocfailed"]==1) 
			printf("%-17s | %-19s | %-19s %s | %s (key=%s)\n",
				crawl_time_total_secs, 
				
				creatednewprofile_epoch,
				
				convertepochsectodatetime(psts[j]["pstheapallocfailed_epoch"]),	"HeapAlloc failed!",
				
				psts[j]["pst_name"], j);
		else
			printf("%-17s | %-19s | %-19s                   | %s (key=%s)\n",
				crawl_time_total_secs, 
				
				creatednewprofile_epoch,
				
				deletingprofile_epoch, 
				
				psts[j]["pst_name"], j);
	}

	# TODO: Create a string array of array comparison functions, then add command-line
	#		argument consisting of comma-separated list of sorts to perform and display.
	# Do some different sortings...
	# Sort by crawl time.
	#PROCINFO["sorted_in"]="cmp_sort_by_crawl_time";
	# Sort by crawl start time.
	#PROCINFO["sorted_in"]="cmp_sort_by_crawl_start_time";
}
