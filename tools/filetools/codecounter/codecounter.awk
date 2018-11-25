# Description:
# 	Awk script to read an input file of file line counts like this...
#
#	...
#   34 ./src/props2objs/demo/ant/AutoPropTask.java
#   35 ./src/props2objs/demo/Config.java
#   9 ./src/props2objs/demo/Entity.java
#   8 ./src/props2objs/demo/EntityFactory.java
#   59 ./src/props2objs/demo/FilteredProps.java
#	....
#
#	...and display the total file and line counts like this:
#
#  Results:
#  --------------------------------------------------
#  Extension         | File count        | Line count
#  --------------------------------------------------
#  .bat              | 58                | 3101
#  .bsh              | 4                 | 822
#  .c                | 7                 | 2929
#  .cc               | 1                 | 4
#  .cpp              | 516               | 246849
#  .cs               | 98                | 30184
#  .css              | 219               | 993287
#  .h                | 609               | 82678
#  .java             | 12612             | 2485468
#  .js               | 1791              | 828754
#  .jsp              | 242               | 54945
#  .pl               | 198               | 22159
#  .ps1              | 1                 | 69
#  .sh               | 9                 | 1145
#  .tcl              | 1                 | 1556
#  .vbs              | 25                | 1427
#  ==================================================
#  Total             | 16391             | 4755377
#  --------------------------------------------------
# 
# JeremyC 25-11-2018


# Return the size of the passed array.
function alen(a,	i) {
	for (i in a)
		i++;
	return i;
}

# Parse the number from a line like this:
#
# 34 ./src/props2objs/demo/ant/AutoPropTask.java
#
function getFileLineCount(str,	localvar) {
	match(str, /(^[0-9]+) .*/, localvar);
	return localvar[1]; 
}

# Parse the file path from a string like this:
#
# 34 ./src/props2objs/demo/ant/AutoPropTask.java
#
function getFilePath(str,	localvar) {
	match(str, /^[0-9]+ (.*)/, localvar);
	return localvar[1]; 
}

# Parse the file extension from a string like this:
#
# 34 ./src/props2objs/demo/ant/AutoPropTask.java
#
function getFileExtension(str,	localvar1,localvar2,localvar3) {
	localvar1=getFilePath(str);
	
	# File path count include directories with a "." character in them,
	# so first of all we must strip away anything that is a directory.
	sub(".*/", "", localvar1);
	
	# We now have just the file name, so look for a file extension.
	match(localvar1, /.*\.(.+)/, localvar2);
	if (alen(localvar2) < 2) 
		localvar3 = key_no_extension;
	else 
		localvar3 = localvar2[1]; 
		
	# debugging.
	#printf("ext=\"%s\", path=\"%s\"\n", localvar3, localvar1);
	
	return tolower(localvar3);
}

function repeatCharacter(char,count,	localvar1,localvar2) {
	for (localvar1=0; localvar1<count; localvar1++) {
		localvar2=sprintf("%s%s", localvar2, char);
	}
	return localvar2;
}

function printResultLine(val1, val2, val3, sep) {
	printf("%-17s %s %-17s %s %-17s\n", val1, sep, val2, sep, val3);
}

function printResultSeparatorLine(sep,		localvar1) {
	printf("%s\n", repeatCharacter(sep,50));
}

function printResultsTable(title,file_count_total,line_count_total, file_counts_array,line_counts_array,	extensions_sorted,extension,no_extension_count_present,n,i) {
	printf("%s\n", title);
	printResultSeparatorLine("-");
	printResultLine("Extension", "File count", "Line count", "|");
	printResultSeparatorLine("-");
	
	# Sort file counts array by extension and iterate using that.
	n = asorti(file_counts_array, extensions_sorted);
	
	no_extension_count_present = 0;
	for (i=1; i<=n; i++) {
		extension = extensions_sorted[i];
	
		if (extension == key_no_extension) {
			no_extension_count_present = 1;
			continue;
		}
		
		printResultLine(	sprintf(".%s", extension), 
							file_counts_array[extension], 
							line_counts_array[extension],
							"|"	);
	}
	
	# If we have a count for "no file extension" then print it now.
	if (no_extension_count_present == 1) {
		# Empty spacer line.
		printResultLine("", "", "", "|");
		
		printResultLine(	"no file extension", 
							file_counts_array[key_no_extension], 
							line_counts_array[key_no_extension],
							"|"	);
	}
	
	printResultSeparatorLine("=");
	printResultLine("Total", file_count_total, line_count_total, "|");
	printResultSeparatorLine("-");
	
}

function logIt(str) {
	if (logging_enabled == "yes")
		printf("%s", str) >> logfile;
}

function showFilesIgnoredByExtension() {
	if (show_files_ignored_by_extension == "yes")
		return "yes";
	return "";
}

BEGIN {
	# Initialise any variables that can be passed as script arguments.
	show_files_ignored_by_extension="no";
	logging_dir=".";
	logging_enabled="yes";
	
	# Redefine any variables that can be passed as script arguments
	#
	# NOTE: Variables with names beginning "var_" are passed 
	#		as input (-v) arguments when invoking this script.
	#
	if (var_showfilesignoredbyextension == "yes")	show_files_ignored_by_extension="yes";
	if (var_loggingdir != "")						logging_dir=var_loggingdir;
	if (var_logging == "no")						logging_enabled="no";
	
	logfile=sprintf("%s/codecounter_output.log", logging_dir);
	
	# Initialise an empty log file.
	if (logging_on == "yes") {
		print "" > logfile;
	}
	
	# Extension string we use for files that have no file extension.
	key_no_extension="no extension";

	# Initialise counts and arrays.
	file_count_total=0;
	file_linecount_total=0;
	delete file_count_by_extension_array;
	delete file_linecount_by_extension_array;
	ignored_file_count_due_to_extension_total=0;
	ignored_file_linecount_due_to_extension_total=0;
	delete ignored_file_count_due_to_extension_array;
	delete ignored_file_linecount_due_to_extension_array;
	ignored_file_count_due_to_path_total=0;
}

{
	if ($0 ~ /^[0-9]+ .*/) {
		file_path=getFilePath($0);
		
		if (tolower(file_path) ~ /codecounter.sh|codecounter.awk|codecounter_files.log/) {
			# Ignore the files used/generated by this script!
			logIt(sprintf("** IGNORED FILE FROM THIS SCRIPT **: %s\n", file_path));
		}
		else 
		if (tolower(file_path) ~ /test|unitest|\.git/) {
			# Here we ignore files based on their file path, e.g. any "unittest" files.
			logIt(sprintf("** IGNORED BASED ON PATH **: %s\n", file_path));
			ignored_file_count_due_to_path_total += 1;
		}
		else {
			file_linecount=getFileLineCount($0);
			file_extension=getFileExtension($0);
			
			if (tolower(file_extension) ~/^bat$|^bsh$|^c$|^cc$|^cpp$|^cs$|^css$|^h$|^java$|^js$|^jsp$|^pl$|^ps1$|^py$|^sh$|^tcl$|^vbs$/) {
				# Here we only consider the files with extensions included in the above regular expression.
				file_count_total += 1;
				file_linecount_total += file_linecount;
				file_count_by_extension_array[file_extension] += 1;
				file_linecount_by_extension_array[file_extension] += file_linecount;
			}
			else {
				# Here we ignore all other files extensions, but we make a record of them.
				logIt(sprintf("** IGNORED BASED ON EXTENSION **: %s\n", file_path));
				ignored_file_count_due_to_extension_total += 1;
				ignored_file_linecount_due_to_extension_total += file_linecount;
				ignored_file_count_due_to_extension_array[file_extension] += 1;
				ignored_file_linecount_due_to_extension_array[file_extension] += file_linecount;
			}
		}
	}
}

END {
	if (ignored_file_count_due_to_extension_total > 0) {
		printf("\n\n** WARNING: %d FILES WERE IGNORED DUE TO EXTENSION **\n", ignored_file_count_due_to_extension_total);
		if (showFilesIgnoredByExtension()) {
			printResultsTable(	"\n\nIgnored files (due to extension):",
								ignored_file_count_due_to_extension_total,
								ignored_file_linecount_due_to_extension_total,
								ignored_file_count_due_to_extension_array,
								ignored_file_linecount_due_to_extension_array	);
		}
		else {
			printf("For details, see the log file:\n%s\n", logfile);
			printf("\nTo see a table of the extensions ignored, re-run this awk script with the following argument:\n");
			printf("-v var_showfilesignoredbyextension=\"yes\"\n\n");
		}
	}
	
	if (ignored_file_count_due_to_path_total > 0) {
		printf("\n\n** WARNING: %d FILES WERE IGNORED DUE TO PATH **\n", ignored_file_count_due_to_path_total);
		printf("For details, see the log file:\n%s\n\n", logfile);
	}
	
	# These are the results we are always interested in seeing.
	printResultsTable(	"\n\nResults:",
						file_count_total,
						file_linecount_total,
						file_count_by_extension_array,
						file_linecount_by_extension_array	);
}
