# Description:
#	Awk script to help identify documents that had a redaction that failed to save.
#	This script parses the access log.
#
# Example usage:
#	awk -f markup_errors.awk access.2015-04-24.log
#
# Example output:
#       awk -f markup_errors.awk access.2015-04-24.log
#      
#       FOUND BRAVA ERROR:
#       SESSIONID:              9c14a573%2Dd897%2D42f8%2Daa6e%2Dab2ebd2e9bb6
#       TIME OF ERROR:          24/Apr/2015:07:10:01 -0400
#       DOCUMENT ID:            2
#       CLIENT IP:              169.254.104.202
#       CLIENT USERNAME:        jeremy_c
#       CW USERNAME:            superuser
#      
#       FOUND BRAVA ERROR:
#       SESSIONID:              63358966%2D2d3b%2D4c9f%2Db20b%2D994ce90f6056
#       TIME OF ERROR:          24/Apr/2015:08:38:19 -0400
#       DOCUMENT ID:            2
#       CLIENT IP:              169.254.104.202
#       CLIENT USERNAME:        jeremy_c
#       CW USERNAME:            superuser
#
#
# JeremyC 24/4/2015

# From http://rosettacode.org/wiki/URL_decoding#AWK
function urldecode(str,		ret, len, i, L, M, R)
{
    len=length(str)
    for (i=1;i<=len;i++) {
      if ( substr(str,i,1) == "%") {
        L = substr(str,1,i-1) # chars to left of "%"
        M = substr(str,i+1,2) # 2 chars to right of "%"
        R = substr(str,i+3)   # chars to right of "%xx"
        str = sprintf("%s%c%s",L,hex2dec(M),R)
      }
    }

    return str;
}
function hex2dec(s,	num) {
    num = index("0123456789ABCDEF",toupper(substr(s,length(s)))) - 1
    sub(/.$/,"",s)
    return num + (length(s) ? 16*hex2dec(s) : 0)
}


function get_datetime(s,		ret)
{
	# Example:
	#
	# 10.12.189.12 - - [24/Apr/2015:08:34:12 -0400] "GET ...
	ret = s;
	sub(/^[^\[]+\[/,"",ret);
	sub(/\] .+$/,"",ret);
	return ret
}


function get_param(s, p,		ret, a1, a2, i, x)
{
	# Example:
	#
	# 10.12.189.12 - - [24/Apr/2015:08:34:12 -0400] "GET /esa/cwb/Markup/list?comparedocid=&docid=2&docversion=none& ...

	ret = "";
	regex = sprintf("^%s=", p);
	split(s, a1, "&");
	for (i in a1) {
		x = a1[i];
		if (match(x, regex)) {
			split(x, a2, "=");
			ret = a2[2];
			break;
		}
	}
	return ret;
}


function get_docid(s)
{
	return get_param(s, "docid");
}

function get_machineip(s)
{
	return get_param(s, "machineip");
}

function get_machineusername(s)
{
	return get_param(s, "machineusername");
}

function get_sessionid(s)
{
	return get_param(s, "sessionid");
}

function get_username(s)
{
	return get_param(s, "username");
}


BEGIN {}

/^.*GET \/esa\/cwb\/Markup\/list/	{

	# Example:
	# 
	# 10.12.189.12 - - [24/Apr/2015:08:34:12 -0400] "GET /esa/cwb/Markup/list?comparedocid=&docid=2&docversion=none&igcmethod=markuplist&
	#	   machineip=169%2E254%2E104%2E202&machineusername=jeremy%5Fc&readonly=true&sessionid=63358966%2D2d3b%2D4c9f%2Db20b%2D994ce90f6056&username=superuser& HTTP/1.1" 200 21
	#

	datetime=get_datetime($0);
	#docid=get_docid($0);
	docid=get_param($0,"docid");
	machineip=get_machineip($0);
	machineusername=get_machineusername($0);
	sessionid=get_sessionid($0);
	username=get_username($0);

	#printf("Markup/list: datetime=\"%s\", docid=\"%s\", machineip=\"%s\", machineusername=\"%s\", sessionid=\"%s\", username=\"%s\"\n",
	#	              datetime,        docid,        machineip,        machineusername,        sessionid,        username);

	MarkupList_sessions[sessionid]=$0;
}

/^.*POST \/esa\/cwb\/Markup\/update /	{

	# Example:
	#
	# 10.12.189.12 - - [24/Apr/2015:08:38:19 -0400] "POST /esa/cwb/Markup/update HTTP/1.1" 500 1163
	#

	datetime=get_datetime($0);s

	#printf("Markup/update: datetime=\"%s\"\n", datetime);
}

/^.*GET \/esa\/cwb\/Util\/getLastError/	{

	# Example:
	#
	# 10.12.189.12 - - [24/Apr/2015:08:38:19 -0400] "GET /esa/cwb/Util/getLastError?igcmethod=getlasterror&sessionid=63358966%2D2d3b%2D4c9f%2Db20b%2D994ce90f6056& HTTP/1.1" 200 83
	#

	datetime=get_datetime($0);
	sessionid=get_sessionid($0);

	#printf("getLastError: datetime=\"%s\", sessionid=\"%s\"\n", datetime, sessionid);

	# 
	# We have found a "getLastError" entry in the access log. 
	# These appear if we get an error trying to save a redaction ("POST /esa/cwb/Markup/update HTTP/1.1" 500).
	# Lets find the corresponding log entry for the earlier "GET /esa/cwb/Markup/list?" call for this same sessionid.
	# The "GET /esa/cwb/Markup/list?" log entry includes useful info, including username, document number, etc.
	# Display the details of the error, so that we can identify the affected document and cross-reference the
	# error with the error in the server log, to determine the case name, and verify the CW username.
	#

	markuplist_get=MarkupList_sessions[sessionid];
	if (markuplist_get != "") {
		printf("\nFOUND BRAVA ERROR:\n");
		printf("SESSIONID: 		%s\n", get_param(markuplist_get,"sessionid"));
		printf("TIME OF ERROR: 		%s\n", datetime);
		printf("DOCUMENT ID: 		%s\n", get_param(markuplist_get, "docid"));
		printf("CLIENT IP: 		%s\n", urldecode(get_param(markuplist_get, "machineip")));
		printf("CLIENT USERNAME: 	%s\n", urldecode(get_param(markuplist_get, "machineusername")));
		printf("CW USERNAME:		%s\n", urldecode(get_param(markuplist_get, "username")));
	}
	else {
		printf("WARNING: Could not find matching Markup/list GET details for getLastError on %s\n", datetime);
	}
}

END {
	# debug
	#for (i in MarkupList_sessions) {
	#	print MarkupList_sessions[i];
	#}
}
