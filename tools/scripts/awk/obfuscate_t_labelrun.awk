# Description:
# awk script to obfuscate specifif fields in a mysqldump of 
# the t_labelrun table, which is from the CASE datastore.
#
# Example data to obfuscate:
#  INSERT INTO `t_labelrun` VALUES (1352,'Groin_0003_20130425.b','DISCOVERY',3940662558851215,1366890326449,1366890454675,4790847040141630,
#  '#Thu Apr 25 12:47:34 BST 2013\r\nCreated=04/25/2013 12\\:47\r\nVersion=2008-09-01\r\n','Groin_0003_20130425.b:25/04/2013 12:45 PM BST');
#
# Corresponding table schema:
#+---------------+---------------------+------+-----+---------+----------------+
#| Field         | Type                | Null | Key | Default | Extra          |
#+---------------+---------------------+------+-----+---------+----------------+
#| LABELRUNID    | bigint(20)          | NO   | PRI | NULL    | auto_increment |
#| LABEL         | varchar(255)        | NO   |     | NULL    |                |
#| OPERATIONTYPE | varchar(255)        | NO   |     | NULL    |                |
#| USERID        | bigint(20)          | YES  |     | NULL    |                |
#| STARTTIME     | bigint(20) unsigned | YES  |     | NULL    |                |
#| STOPTIME      | bigint(20) unsigned | YES  |     | NULL    |                |
#| BITMAP        | bigint(20)          | YES  |     | NULL    |                |
#| PROPERTIES    | text                | YES  |     | NULL    |                |
#| DESCRIPTION   | varchar(255)        | YES  |     | NULL    |                |
#+---------------+---------------------+------+-----+---------+----------------+
#
# JeremyC 21/3/2015.

# Functions to trim quote characters surrounding string.
function ltrim(s) { sub(/^[ '\t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ '\t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }
function trim_value(s)
{
	return trim(s);
}
# The last field has the trailing ");" part, so we need to remove that too.
function trim_last_field(s,		ret)
{
	# Special quote trimming for the description value because it is the last field.
	ret=ltrim(s);
	sub(/[ ');\t\r\n]+$/, "", ret);
	return ret;
}
# Function to re-add the surround quote characters to a string.
function readd_quotes(s)
{
	return "'" s "'";
}

function print_string_to_file(s, f,		cmd, ret)
{
	# Note: awk append when using redirection, so we delete it here each time.
	cmd = "rm -f \"" f "\"";
	#printf("cmd=%s\n", cmd);
	cmd | getline ret;
	close(cmd);
	
	# Note: The close() is needed here, otherwise you won't see the output file created.
	print s > f;
	close(f);
}

# Function to display the obfuscated contents of a file. 
# This function calls my external obfuscate.exe tool, so it is not quick!
function obfuscate1(s, f,		cmd, ret)
{
	# The obfuscate.exe currently only handles input files, so we need to write the string to a file.
	print_string_to_file(s, f);
	
	cmd = "C:/Cygwin/home/Administrator/obfuscate.exe \"" f "\"";
	#printf("cmd=%s\n", cmd);
	cmd | getline ret;
	close(cmd);
	return ret;
}

# New improved quicker method to obfuscate a string by shifting the ascii value using a table.
# Ascii table to each shifting (obfuscating) of characters in a possible sensitive string.
# The following string consists of 127 characters; one for each character in the Ascii table.
# Special Ascii characters have been replaced with an underscore ("_"). This set of special
# characters also includes those that might cause problems in the generated output: 
# " ' ( ) , ; { } | ` ^ ? \ 
# A copy of the official Ascii table can be found here: http://www.asciitable.com/.
function obfuscate2(s,		chars, len, ascii_table, ret)
{
	ascii_table="_______________________________ !_#$%&___*+_-./0123456789:_<=>_@ABCDEFGHIJKLMNOPQRSTUVWXYZ[_]___abcdefghijklmnopqrstuvwxyz___~_";

	# Split input string into array of chars.
	split(s, chars, "")
	
	# Iterate through array of chars. For each char:
	#   Determine index position of char in ascii table.
	#   Shift the index position by one.
	#   Extract the shifted character from the ascii table.
	#   Add the character to the end of the new string being built.
	len = length(s);
	for (i=1; i <= len; i++) {
		num=index(ascii_table,substr(chars[i],1,1));
		if (num == 0) {
			num=1;
		} else {
			# Here is the crude shifting/obfuscating bit. 
			# I will shift by 21, say. No particular reason why.
			num=num+21;
			if (num > 127) {
				num=num-127;
			}
		}
		ret=ret substr(ascii_table,num,1);
	}
	return ret;
}

BEGIN {}

/^.*INSERT INTO .*/	{
	# Split string into the database field values.
	split($0, a, ",");
	prefix=a[1];
	label=a[2];
    	operationtype=a[3];
	userid=a[4];
	starttime=a[5];
	stoptime=a[6];
	bitmap=a[7]; 
	properties=a[8];
	description=a[9];

	# Obfuscate the label value.
	trimmed_label=trim_value(label);
	#obfuscated_label_tmp=obfuscate1(trimmed_label, "label.tmp");
	obfuscated_label_tmp=obfuscate2(trimmed_label);
	# Not sure why the extra trim() call is needed, but it is.
	obfuscated_label=sprintf("'%s'", trim(obfuscated_label_tmp));

	# Obfuscate the properties value.
	trimmed_properties=trim_value(properties);
	obfuscated_properties_tmp=obfuscate2(trimmed_properties);
	# Not sure why the extra trim() call is needed, but it is.
	obfuscated_properties=sprintf("'%s'", trim(obfuscated_properties_tmp));

	# Obfuscate the description value.
	trimmed_description=trim_last_field(description);
	obfuscated_description_tmp=obfuscate2(trimmed_description);	
	# Add quotes, plus trailing bit. Not sure why the extra trim() call is needed, but it is.
	obfuscated_description=sprintf("'%s');", trim(obfuscated_description_tmp));
		
	# Rejoin the fields and print.
	printf("%s,%s,%s,%s,%s,%s,%s,%s,%s\n", a[1], obfuscated_label, a[3], a[4], a[5], a[6], a[7], obfuscated_properties, obfuscated_description);
}

!/^.*INSERT INTO .*/	{
	print;
}

END {}
