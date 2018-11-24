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
#	...and display the total counts like this:
#  ----------------------------------------------
#  Extension       | File count      | Line count
#  ----------------------------------------------
#  .awk            | 1               | 60
#  .bat            | 2               | 3
#  .classpath      | 1               | 9
#  .java           | 11              | 516
#  .launch         | 2               | 24
#  .log            | 1               | 8
#  .prefs          | 1               | 11
#  .project        | 1               | 27
#  .props          | 1               | 7
#  .sh             | 1               | 41
#  .txt            | 2               | 71
#  .xml            | 1               | 60
#
#  no extension    | 1               | 1
#  ==============================================
#  Total           | 26              | 838
#  ----------------------------------------------
# 
# JeremyC 24-11-2018


# Return the size of the passed array.
function alen(a,	i) {
	for (i in a)
		i++;
	return i;
}

# Parse the number from a string like this:
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
function getFileExtension(str,	localvar1,localvar2) {
	localvar1=getFilePath(str);
	
	# Remove and leading "./" in the file path.
	sub(/^\.\//,"",localvar1);
	
	match(localvar1, /.*\.(.*)/, localvar2);
	if (alen(localvar2) < 2) 
		return tolower(key_no_extension);
	else 
		return tolower(localvar2[1]); 
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

BEGIN {
	key_no_extension="no extension";

	file_count_total=0;
	file_linecount_total=0;

	delete file_count_by_extension_array;
	delete file_linecount_by_extension_array;
}

{
	if ($0 ~ /^[0-9]+ .*/) {
		file_path=getFilePath($0);
		
		if (file_path ~ /codecounter.sh|codecounter.awk|codecounter_files.log/) {
			# Do not count the files used by this script!
			printf("*** IGNORING ***: %s\n", file_path);
		}
		else {
		
		file_linecount=getFileLineCount($0);
		file_extension=getFileExtension($0);
		
		file_count_total += 1;
		file_linecount_total += file_linecount;
		
		file_count_by_extension_array[file_extension] += 1;
		file_linecount_by_extension_array[file_extension] += file_linecount;
		}
	}
}

END {
	printf("\n\n");
	printResultSeparatorLine("-");
	printResultLine("Extension", "File count", "Line count", "|");
	printResultSeparatorLine("-");
	
	# Sort by file extension and iterate our results using that.
	n = asorti(file_count_by_extension_array, extensions_sorted);
		
	no_extension_count_present = 0;
	for (i=1; i<=n; i++) {
		extension = extensions_sorted[i];
	
		if (extension == key_no_extension) {
			no_extension_count_present = 1;
			continue;
		}
		
		printResultLine(	sprintf(".%s", extension), 
							file_count_by_extension_array[extension], 
							file_linecount_by_extension_array[extension],
							"|"	);
	}
	
	# If we have a count for "no file extension" then print it now.
	if (no_extension_count_present == 1) {
		# Empty spacer line.
		printResultLine("", "", "", "|");
		
		printResultLine(	"no file extension", 
							file_count_by_extension_array[key_no_extension], 
							file_linecount_by_extension_array[key_no_extension],
							"|"	);
	}
	
	printResultSeparatorLine("=");
	printResultLine("Total", file_count_total, file_linecount_total, "|");
	printResultSeparatorLine("-");
}
