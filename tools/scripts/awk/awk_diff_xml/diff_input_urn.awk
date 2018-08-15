#
# Description:
#	Compare two input_urn.xml files, using either StrictChecksum or CrawlerChecksum.
#
# Usage:
#	awk -f diff_input_urn.awk file1 file2 [sc=1] [cc=1] [display=docid,sender,date,subject,dbid,ftid]
#
# Where:
#   sc=1    -   Compare by StrictChecksum values (default).
#   cc=1    -   Compare by CrawlerChecksum values.
#	display -   Comma-separated list of document fields to display.
#
# Example:
#   $ gawk.exe -f diff_input_urn.awk input_urn.xml_tempcase input_urn.xml_emea_jet display=docid,ftid,dbid,subject
#   StrictChecksums in input_urn.xml_tempcase that are not in input_urn.xml_emea_jet:
#   d5c0eb4dc934146d68c0368275e24925   0.7.355.65570    3379225507678414 1971849550430242 Some subject here
#   eb83d484c79c310d9c72ec008ebb4daa   0.7.355.65224    3379225507677942 1971849550429896 Ablieferung subject here
#   8f5a7d19a8ecf0a4e6e331f0541b1cff   0.7.355.63981    3379225507677527 1971849550428653 Some other subject here
#
# JeremyC 18/12/2015

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

function getSender(m,	c) {
	c=m;
	sub(/^.*Sender="/,"",c);
    sub(/".*/,"",c);
	c=trim(c);
	return c;
}

function getDate(m,		c) {
	c=m;
	sub(/^.*Date="/,"",c);
    sub(/".*/,"",c);
	c=trim(c);
	return c;
}

function getSubject(m,	c) {
	c=m;
	sub(/^.*Subject="/,"",c);
    sub(/".*/,"",c);
	c=trim(c);
	return c;
}

function getDBID(m,		c) {
	c=m;
	sub(/^.*DBID="/,"",c);
    sub(/".*/,"",c);
	c=trim(c);
	return c;
}

function getFTID(m,		c) {
	c=m;
	sub(/^.*FTID="/,"",c);
    sub(/".*/,"",c);
	c=trim(c);
	return c;
}

function getCrawlerChecksum(m,	c) {
	c=m;
	sub(/^.*CrawlerChecksum="/,"",c);
    sub(/".*/,"",c);
	c=trim(c);
	return c;
}

function getStrictChecksum(m,	c) {
	c=m;
	sub(/^.*StrictChecksum="/,"",c);
    sub(/".*/,"",c);
	c=trim(c);
	return c;
}
	
function getDocID(m,	d) {
	d=m;
	sub(/^.*DOCID="/,"",d);
    sub(/".*/,"",d);
	d=sprintf("%-15s ", d);
	return d;
}

function compareChecksums(checksumname, file1, array1, file2, array2,		cnt1,cnt2,cntboth) {
	cntboth=0;
	cnt1=0;
	printf("\n%ss in %s that are not in %s:\n", checksumname, file1, file2);
	for (c1 in array1) {
	    if (c1 in array2) {
			cntboth++;
	    } 
	    else {
			printf("%-32s  %s\n", c1, array1[c1]);
			cnt1++;
	    }
	}
	printf("Total count: %d\n", cnt1);
	cnt2=0;
	printf("\n%ss in %s that are not in %s:\n", checksumname, file2, file1);
	for (c2 in array2) {
	    if (c2 in array1) {
	    }
	    else {
			printf("%-32s  %s\n", c2, array2[c2]);
			cnt2++;
	    }
	}
	printf("Total count: %d\n", cnt2);
	printf("\nTotal count in both files: %d\n", cntboth);
}

function buildDisplayString(fields, line,		fields_array, s, s1, f, v) {
	split(fields,fields_array,",");
	for (f in fields_array) {
		v=fields_array[f];
		if (v=="docid") {
			s1=sprintf("%s %s", s, getDocID(line));
			s=s1;
		}
		else
		if (v=="sender") {
			s1=sprintf("%s %s", s, getSender(line));
			s=s1;
		}
		else
		if (v=="date") {
			s1=sprintf("%s %s", s, getDate(line));
			s=s1;
		}
		else
		if (v=="subject") {
			s1=sprintf("%s %s", s, getSubject(line));
			s=s1;
		}
		else
		if (v=="dbid") {
			s1=sprintf("%s %s", s, getDBID(line));
			s=s1;
		}
		else
		if (v=="ftid") {
			s1=sprintf("%s %s", s, getFTID(line));
			s=s1;
		}
	}
	return s;
}

BEGIN {

debug=0;

RS="</Message>";

file1=ARGV[1];
file2=ARGV[2];

# Defaults
compareStrictChecksums=1;
compareCrawlerChecksums=0;
displayString="";

for (i = 3; i < ARGC; i++) {
	arg=ARGV[i];
    if (arg=="sc=1") {
		compareStrictChecksums=1;
		compareCrawlerChecksums=0;
	}
	if (arg=="cc=1") {
		compareCrawlerChecksums=1;
		compareStrictChecksums=0;
	}
	else
    if (arg ~ /display=/) {
		split(arg,a,"=");
		displayString=a[2];
	}
}

if (debug) printf("file1=%sm file2=%s, compareStrictChecksums=%d, compareCrawlerChecksums=%d, displayString=%s\n", 
					file1, file2, compareStrictChecksums, compareCrawlerChecksums, displayString);

delete file1_sc_array;
delete file2_sc_array;

delete file1_cc_array;
delete file2_cc_array;

}

{
	if ($0 ~ /CrawlerChecksum/ ) {
		sc=getStrictChecksum($0); 
		cc=getCrawlerChecksum($0); 
		
		s=buildDisplayString(displayString, $0);
		
		if (FILENAME==file1) {
			file1_sc_array[sc]=s;
			file1_cc_array[cc]=s;
			if (debug) printf("%s: sc=%s, cc=%s, s=%s\n", file1, sc, cc, s);
		}
		
		if (FILENAME==file2) {
			file2_sc_array[sc]=s;
			file2_cc_array[cc]=s;
			if (debug) printf("%s: sc=%s, cc=%s, s=%s\n", file2, sc, cc, s);
		}
	}
}

END {
	if (compareStrictChecksums==1)  compareChecksums("StrictChecksum", file1, file1_sc_array, file2, file2_sc_array);
	if (compareCrawlerChecksums==1)	compareChecksums("CrawlerChecksum", file1, file1_cc_array, file2, file2_cc_array);
}
