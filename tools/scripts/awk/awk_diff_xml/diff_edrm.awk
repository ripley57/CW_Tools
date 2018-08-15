# Description:
#	Compare two edrm xml files, by either StrictChecksum or CrawlerChecksum values.
#
# Usage:
#	awk -f diff_edrm.awk file1 file2 [sc=1] [cc=1] [display=docid,datesent,doctype,mimetype,subject,attachmentcount]
#
# Where:
#   sc=1    -   Compare using StrictChecksum values (default).
#   cc=1    -   Compare using CrawlerChecksum values.
#	display -   Comma-separated list of document fields to display.
#
# Example:
#   $ gawk.exe -f diff_edrm.awk edrm_file_1.xml edrm_file_2.xml display=docid,doctype,subject
#   StrictChecksums in edrm_file_1.xml that are not in edrm_file_2.xml:
#   97d2b1bf8461d6067e4ccc0572ae024b  0.7.355.64312    Message   Hello!
#   eb83d484c79c310d9c72ec008ebb4daa  0.7.355.65224    Message   Demo subject 2
#   717f271e917fd2d2d647e9b3e7e8ba3a  0.7.355.65435    Message   Some other subject 3
#   fc26e6bcd6199b6fe7b025e5326411e4  0.7.355.65222    Message   Another subject
#
# JeremyC 18/12/2015

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

function getDocID(m,	d) {
	d=m;
	sub(/^.*DocID="/,"",d);
    sub(/".*/,"",d);
	d=sprintf("%-15s ", d);
	return d;
}	

function getDocType(m,	d) {
	d=m;
	sub(/^.*DocType="/,"",d);
    sub(/".*/,"",d);
	d=sprintf("%-8s ", d);
	return d;
}	

function getMimeType(m,	d) {
	d=m;
	sub(/^.*MimeType="/,"",d);
    sub(/".*/,"",d);
	d=trim(d);
	return d;
}	

function getStrictChecksum(m,	c) {
	c=m;
	sub(/^.*<StrictChecksum>/,"",c);
    sub(/<.*/,"",c);
	c=trim(c);
	return c;
}

function getCrawlerChecksum(m,	c) {
	c=m;
	sub(/^.*<CrawlerChecksum>/,"",c);
    sub(/<.*/,"",c);
	c=trim(c);
	return c;
}

function getContentChecksum(m,	c) {
	c=m;
	sub(/^.*<ContentChecksum>/,"",c);
    sub(/<.*/,"",c);
	c=trim(c);
	return c;
}

function getDateSent(m,	c) {
	c=m;
	match(c,/#DateSent/);
	if (RSTART==0) {
		return "";
	}
	sub(/^.*#DateSent" TagDataType="DateTime" TagValue="/,"",c);
	match(c,/"/);
	c=substr(c,0,RSTART-1);
	return trim(c);
}

function getSubject(m,	c) {
	c=m;
	match(c,/#Subject/);
	if (RSTART==0) {
		return "";
	}
	sub(/^.*#Subject" TagDataType="Text" TagValue="/,"",c);
	match(c,/"/);
	c=substr(c,0,RSTART-1);
	return trim(c);
}

function getAttachmentCount(m,	c) {
	c=m;
	match(c,/#AttachmentCount/);
	if (RSTART==0) {
		return "";
	}
	sub(/^.*#AttachmentCount" TagDataType="Integer" TagValue="/,"",c);
	match(c,/"/);
	c=substr(c,0,RSTART-1);
	return trim(c);
}

function compareChecksums(checksumname, file1, array1, file2, array2,           cnt1,cnt2,cntboth) {
        cntboth=0;
        cnt1=0;
        printf("\n%ss in %s that are not in %s:\n", checksumname, file1, file2);
        for (c1 in array1) {
            if (c1 in array2) {
                cntboth++;
            }
            else {
                printf("%-32s %s\n", c1, array1[c1]);
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
                printf("%-32s %s\n", c2, array2[c2]);
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
		if (v=="datesent") {
			s1=sprintf("%s %s", s, getDateSent(line));
			s=s1;
		}
		else
		if (v=="doctype") {
			s1=sprintf("%s %s", s, getDocType(line));
			s=s1;
		}
		else
		if (v=="mimetype") {
			s1=sprintf("%s %s", s, getMimeType(line));
			s=s1;
		}
		else
		if (v=="subject") {
			s1=sprintf("%s %s", s, getSubject(line));
			s=s1;
		}
		else
		if (v=="attachmentcount") {
			s1=sprintf("%s %s", s, getAttachmentCount(line));
			s=s1;
		}
	}
	return s;
}
	
BEGIN {

debug=0;

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
	else
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

if (debug) printf("compareStrictChecksums=%d, compareCrawlerChecksums=%d, displayString=%s\n", compareStrictChecksums, compareCrawlerChecksums, displayString);

delete file1_sc_array;
delete file2_sc_array;

delete file1_cc_array;
delete file2_cc_array;

RS="</Document>";

}

{
	if ($0 ~ /StrictChecksum/ ) {
		sc=getStrictChecksum($0); 
		cc=getCrawlerChecksum($0); 
		
		s=buildDisplayString(displayString, $0);
		
		if (FILENAME==file1) {
		    file1_sc_array[sc]=s;
            file1_cc_array[cc]=s;
             if (debug)
                printf("%s: sc=%s, cc=%s, s=%s\n", file1, sc, cc, s);
		}

		if (FILENAME==file2) {
		    file2_sc_array[sc]=s;
            file2_cc_array[cc]=s;
             if (debug)
                printf("%s: sc=%s, cc=%s, s=%s\n", file2, sc, cc, s);
		}
	}
}

END {
        if (compareStrictChecksums==1) {
                compareChecksums("StrictChecksum", file1, file1_sc_array, file2, file2_sc_array);
        }

        if (compareCrawlerChecksums==1) {
                compareChecksums("CrawlerChecksum", file1, file1_cc_array, file2, file2_cc_array);
        }
}
