# DESCRIPTION:
#   Run this awk script against a processing job log (statusLog.txt) file, to
#   determine the average GB/hour processing performance.
#
# HISTORY:
#   Initial version. 6/8/2014. JeremyC.
#   Convert date string to US format. Print stats every X hours. 1/2/2016.
#
# Example output:
#
# $ awk -f procperf.awk statusLog_example.txt
# DATE                  DOCUMENTS  SIZE_GB    TIME_SECS  DOCS_PER_HOUR   GB_PER_HOUR   FILENAME
# 29/01/2016 16:07:41   6619       10.7793    7349       3242.4          5.28037       statusLog_example.txt
# 29/01/2016 18:14:12   7028       10.59      7591       3333            5.02226       statusLog_example.txt
# 29/01/2016 20:19:31   1574       5.99       7519       753.611         2.86793       statusLog_example.txt
# 29/01/2016 22:56:00   2067       8.23       9389       792.544         3.15561       statusLog_example.txt
#
# AVERAGE:
# 29/01/2016            114443     287.92     305596     1348.17         3.39177       statusLog_example.txt
#

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

function gettime(s) { return substr(s,12,8); }
function getdate(s) { return substr(s,0,10); }
function getdatetime(s) { return substr(s,0,19); }
 
# NOTE: See the following link if the date conversion to epoch
#       using the date command fails with error "invalid date". 
#	This is because, irrespective of the locale or LANG 
#	setting, the format is expected to be US ('mm/dd/yyyy').
#       See http://ubuntuforums.org/showthread.php?t=2217020
#
# Example of string to convert: 
#	12/03/2013 17:23:30
function convertdatetimetoepochsec(s,	d_format, cmd, m, datetime_month, 
							  datetime_day,
							  datetime_year,
							  datetime_time,
							  datetime_us, ret) {
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
		d_format = "uk";

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

function getprocessedcount(s,	where_Processed, where_count_start, where_documents, 
				where_count_end, where_count_len, count_with_comma, 
				count_without_comma) {
	# Example of string to extract processed count from:
	# 12/03/2013 17:20:32 CW1 Indexer           Processed 1,036 documents (82.57 MB)
	# For this example, this function will return "1036".

	where_Processed = match(s, "Processed");
        where_count_start = RSTART + length("Processed") + 1;
	where_documents = match(s, "documents");
	where_count_end = RSTART - 1;
	where_count_len = where_count_end - where_count_start;

	count_with_comma=substr(s,where_count_start,where_count_len);
	count_without_comma=count_with_comma;
        sub(/\,/,"", count_without_comma);

	return count_without_comma;
}

# Converts a value such as "1.42 GB" to "1488977.92".
function convertsizetokb(s,	a, size_val, size_unit, ret) {
	split(s, a);
	size_val=a[1];
	size_unit=a[2];

	switch (size_unit) {
	case "KB":
		ret=size_val;
		break;
	case "MB":
		ret=size_val * 1024;
		break;
	case "GB":
		ret=size_val * 1024 * 1024;
		break;
	}

	return ret;
}

function getprocessedsize(s,	where_size_start, where_size_start_pos, where_size_end, 
				where_size_end_pos, size_val_len, size_val, size_val_KB) {
	# Example of string to extract processed size from:
	# 12/03/2013 17:20:32 CW1 Indexer           Processed 1,036 documents (82.57 MB)
	# Note that the size can be GB, so we should convert to MB.
	# For this example, this function will return "82.57".

        where_size_start = match(s, " \\(");
       	where_size_start_pos = RSTART + 2;
	where_size_end = match(s, ")");
	where_size_end_pos = RSTART;

        size_val_len = where_size_end_pos - where_size_start_pos;
	size_val = substr(s, where_size_start_pos, size_val_len);
	size_val_KB=convertsizetokb(size_val);

	return size_val_KB;
}

# Skip files that do not look like the ones we want to examine.
function checkfile() {
	if (cwfilegood == 0) {
		printf("Ignoring file: %s\n", FILENAME);
		nextfile;
	}
}

function printheader() {
	printf("%-20s  %-10s %-10s %-10s %-15s %-12s %-14s  %s\n", 
		   "DATE", "DOCUMENTS", "SIZE_GB", "TIME_SECS", "DOCS_PER_HOUR", "GB_PER_HOUR", "AVG_DOC_SIZE_KB", "FILENAME");
}

function printline(date_in, documents_in, size_gb_in, time_secs_in, docs_per_hour_in, gb_per_hour_in, avg_doc_size, filename_in) {
	printf("%-20s  %-10s %-10s %-10s %-15s %-12s %-14s   %s\n", 
	 	   date_in, documents_in, size_gb_in, time_secs_in, docs_per_hour_in, gb_per_hour_in, avg_doc_size, filename_in);
}

BEGIN {
	printheader();
}

(ARGIND != lastARGIND)				{
							# This little 'trick' is to reset the global variables
							# before the next file is processed (in the event that
							# multiple input files have been specified on the cli).
							lastARGIND = ARGIND;

							# Reset variables.
							cwfilegood=0;
	  						cwdatetimestr_prev="";
	  					    cwdatetimesec_prev=0;
	  						cwprocessedcount_total=0;
	  					    cwprocessedsize_total_kb=0;
	  						cwprocessedtime_total_secs=0;
							}

/Starting scheduled job: .* : Process documents from/	{
						 	cwbatch=$0; 
							sub(/^.* in batch "/,"",cwbatch); sub(/"\.$/,"",cwbatch); 
							cwdate=getdate($0);
							}

/Indexer[ \t]* Starting crawling/			{ 
							# Good. This looks like the correct type of statusLog.txt file to examine.
							cwfilegood=1;
							} 

/Indexer[ \t]* Previously Processed/			{ 
							checkfile();
							cwdatetimestr_prev=getdatetime($0);
							cwdatetimesec_prev=convertdatetimetoepochsec(cwdatetimestr_prev);
							cwprocessedcount_prev=getprocessedcount($0);
							cwprocessedsize_prev=getprocessedsize($0);
							}
/Indexer[ \t]* Processed .* documents/			{
							checkfile();
							  
							cwdatetimestr=getdatetime($0);
							cwdatetimesec=convertdatetimetoepochsec(cwdatetimestr);

							cwprocessedcount=getprocessedcount($0);
							cwprocessedsize=getprocessedsize($0);

							cwdatetimesec_delta=cwdatetimesec-cwdatetimesec_prev;
							cwprocessedcount_delta=cwprocessedcount-cwprocessedcount_prev;
							cwprocessedsize_delta=cwprocessedsize-cwprocessedsize_prev;

							# Increment the total counts.
	  						cwprocessedtime_total_secs=cwprocessedtime_total_secs+cwdatetimesec_delta;
	 						cwprocessedcount_total=cwprocessedcount_total+cwprocessedcount_delta;
	  						cwprocessedsize_total_kb=cwprocessedsize_total_kb+cwprocessedsize_delta;

					# Print performance for the last X hours.
					period=1*60*60;
					secs_since_last_print=cwdatetimesec-time_last_print;
					if (secs_since_last_print >= period) {
						if (time_last_print > 0) {
							processedcount_since_last_print=cwprocessedcount_total-processedcount_total_last_print;
							processedsize_since_last_print=cwprocessedsize_total_kb-processedsize_total_last_print;
						  	printline(	cwdatetimestr,
						 			processedcount_since_last_print,
									processedsize_since_last_print/(1024*1024),
									secs_since_last_print,
									(processedcount_since_last_print/secs_since_last_print)*(60*60),
									(processedsize_since_last_print/secs_since_last_print)*60*60/(1024*1024),
									processedsize_since_last_print/processedcount_since_last_print,
									FILENAME);
						}

						# Save values for next time.
						time_last_print=cwdatetimesec;
						processedcount_total_last_print=cwprocessedcount_total;
						processedsize_total_last_print=cwprocessedsize_total_kb;
					}


							# Save current total values for next time.
							cwdatetimestr_prev=cwdatetimestr;
							cwdatetimesec_prev=cwdatetimesec;
							cwprocessedcount_prev=cwprocessedcount;
							cwprocessedsize_prev=cwprocessedsize;
							}

#/Indexer[ \t]*Completed/				{
END 						{
							# Print total averages. 
							if (cwprocessedcount_total == 0 || cwprocessedsize_total_kb == 0) {
								printf("WARNING: Skipping file \"%s\". It might not be a processing job log.\n", FILENAME);
							} else {
								printf("\nAVERAGE:\n");
						  		printline(cwdate,
							  	cwprocessedcount_total, 
								cwprocessedsize_total_kb/(1024*1024), 
								cwprocessedtime_total_secs,
								(cwprocessedcount_total/cwprocessedtime_total_secs)*60*60,
								(cwprocessedsize_total_kb/cwprocessedtime_total_secs)*60*60/(1024*1024),
								cwprocessedsize_total_kb/cwprocessedcount_total,
								FILENAME);
							}
						}

