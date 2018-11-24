TOOLS_DIR=$*

# Description:
#	Count the files and lines in the text-based
#	files in the current directory.
#
# Usage:
#	codecounter
#
function codecounter() {
	if [ "$1" = '-h' ]; then
        usage codecounter
        return
    fi
	
	sh "${TOOLS_DIR}/filetools/codecounter/codecounter.sh"
}


# Description:
#   Perl tail command.
#
# Usage:
#   ptail <filename>
#
function ptail() {
    if [ "$1" = '-h' ]; then
        usage ptail
        return
    fi

    echo perl -e "\"open(FH,'<','$1');seek FH,-2000,2;for (;;) {while (<FH>) {chomp \$_;print \$_.qq~\\r\\n~;}sleep 1;seek FH,0,1;};\""
         perl -e "open(FH,'<','$1');seek FH,-2000,2;for (;;) {while (<FH>) {chomp \$_;print \$_.qq~\\r\\n~;}sleep 1;seek FH,0,1;};"
}


# Description:
#   Find files (or directories) with the specified string in the name.
#
# Usage:
#   fl <string>
#
# Example:
#   fl prop
#
function fl() {
    if [ "$1" = '-h' ]; then
        usage fl
        return
    fi

    find . -iname "*$1*"
}

# Description:
#   Find files with the specified string in the name.
#
# Usage:
#   f <string>
#
# Example:
#   f prop
#
function f(){
	if [ "$1" = '-h' ]; then
        usage f
        return
    fi

    find . -type f -iname "*$1*"
}

# Description:
#   Find files with the specified string in the name
#   and sort the results, with most recently modified
#   file at the top
#
# Usage:
#   flr <string>
#
# Example:
#   flr prop
#
function flr() {
    if [ "$1" = '-h' ]; then
        usage flr
        return
    fi

    find . -iname "*$1*" -type f -printf '%T@ %12s %Td %Tb %TH:%TM:%Ts %TY %p \n' | sort -k 1nr | sed 's/^.\{21\}//'
}


# Description:
#   Find files with the specified string in the name
#   and sort the results, with the large file at the
#   top.
#
# Usage:
#   fls <string>
#
# Example:
#   fls prop
#
function fls() {
    if [ "$1" = '-h' ]; then
        usage fls
        return
    fi

    find . -iname "*$1*" -type f -printf '%15s %Td %Tb %TH:%TM:%Ts %TY %p \n' | sort -k 1nr
}


# Description:
#   Find files containing the specified string.
#
# Usage:
#   fe <string>
#
# Example:
#   fe '\[#10024\]'
#
function fe() {
    if [ "$1" = '-h' ]; then
        usage fe
        return
    fi

    find . -type f -print0 | xargs -0 grep -i "$1"
}


# Description:
#   List names of files containing the specified string.
#
# Usage:
#   fel <string>
#
# Example:
#   fel '\[#10024\]'
#
function fel() {
    if [ "$1" = '-h' ]; then
        usage fel
        return
    fi

    find . -type f -print0 | xargs -0 grep -il "$1" | sort | uniq -c
}


# Functions for indicating recently updated files.
MARKER=$TMP/.cw_bash_profile_marker
MARKER2=$TMP/.cw_bash_profile_marker2

# Description:
#   Create a temporary file with a datestamp of the current date and time. 
#   This 'marker' file is used by the accompanying function "newer",
#   to indicate any files updated since the marker file was updated. 
#
#   The idea is to mark(), perform some GUI operation, then run 
#   newer(). If newer() lists any files, then these are likely
#   to have been updated due to the GUI operation you just performed.
#
#   The -t option to find_newer will print the date and time when 
#   mark() was last called.
#
# Usage:
#   mark
#   <perform some GUI operation>
#   newer [-t]
#
function mark() { 
    if [ "$1" = '-h' ]; then
        usage mark
        return
    fi
    date > $MARKER ; 
}


# Description:
#   Use this function to list files that have been modified
#   within a certain period of time. Use this together with
#   the "mark" and "create_marker" functions.
#
# Usage:
#    newer [<marker-file-path> | <time-period>]
#
# Examples:
#   Example of using the mark and newer functions together:
#     mark
#     <perform some operation>
#     newer
#
#   List files newer than date in marker file associated with marker named "MY-MARKER":
#     newer /cygdrive/c/tmp/marker_file
#
#   List files newer than 3 minutes:
#     newer 3m
#
#   List files newer than 4 hours:
#     newer 4h
#
#   List files newer than 5 days:
#     newer 5d
#
#   List files newer than 7 weekds:
#     newer 7w
#
function newer() { 
    if [ "$1" = '-h' ]; then
        usage newer
        return
    fi

    local _period=$(echo "$1" | grep -E '^[0-9]+[mhdw]{1,1}$')
    if [ x"$_period" != x ]; then
       # Replace period characters with numeric expression.
       local _period_calc=$(echo $_period | sed -e 's/d/ * 24 * 60 * 60/' -e 's/w/ * 7 * 24 * 60 * 60/' -e 's/h/ * 60 * 60/' -e 's/m/ * 60/')

       # Calculate period in seconds.
       local _period_secs=$(($_period_calc))
 
       # Determine the current time, take away the specified mins
       # (after converting this to seconds) and then create a marker
       # file for this earlier time. Then use the find command to
       # list the files newer than this time.

       # Current time in seconds (UTC)
       local _time_now_secs=$(date -u +%s)

       # Calculate time X minutes ago.
       local _time_earlier_secs=$(($_time_now_secs - $_period_secs))

       # Convert earlier time to string.
       local _time_earlier_string=$(date -d@$_time_earlier_secs)

       # debug
       echo "time_now_string=$(date -d@$_time_now_secs)"
       echo "time_earlier_string=$_time_earlier_string"

       # Set marker file to the earlier time.
       touch -d "$_time_earlier_string" $MARKER2

       # Find the files.
       find . -type f -newer $MARKER2 -print
    else
       # Find files newer than a marker file created
	   # previously using the create_marker function.
	   if [ x"$1" != x ] && [ -f "$1" ]; then
	       # Use the specified marker file.
		   #echo "Using specified marker file: $1"
		   find . -type f -newer "$1" -print0
	   else
		   # Use the default MARKER file.
           find . -type f -newer $MARKER -print0
	   fi
    fi
}


# Description:
#   Create a marker file with the specified marker name postfix.
#   Then cache the marker file path in our general variable cache.
#
# Usage:
#   create_marker <marker-name>
#
# Example:
#   create_marker "CHANGES-SINCE-13THAPRIL"
#
function create_marker() {
    if [ "$1" = '-h' ]; then
        usage create_marker
        return
    fi
	local _marker_name="$1"
	if [ x"$_marker_name" = "x" ]; then
	    echo "ERROR: create_marker: No marker name specified!" >&2
		echo ""
		return
	fi

	local _marker_file_path="$TMP/.create_marker___$_marker_name"
	date > "$_marker_file_path"

	# Cache the marker file path for future retrieval.
	cache "$_marker_name" "$_marker_file_path" 1>/dev/null

	echo $_marker_file_path
}


# Description:
#   List the files in the specified directory that have been updated
#   or are new when compared to the specified pre-cached marker name.
#   It is assumed that marker file was previously created using the
#   create_marker() function.
#
# Usage:
#   files_updated_since_marker <marker-name>
#
# Example:
#   files_updated_since_marker "MY-MARKER-13THAPRIL"
#
function files_updated_since_marker() {
    if [ "$1" = '-h' ]; then
        usage files_updated_since_marker
        return
    fi

	local _marker_name="$1"

	# Use the marker name to fetch the marker file path from our variable cache.
	local _marker_file_path=$(cache "$_marker_name")
	if [ x"$_marker_file_path" = "x" ]; then
	    echo "ERROR: find_updated_files: Could not find marker: $_marker_name" >&2
		return
	fi

	local _date=$(<"$_marker_file_path")
	echo "Searching $PWD for files newer than \"$_date\" ..." >&2
	newer "$_marker_file_path"
}


# Description:
#   Create a marker file for identifing CW notes made since this date.
#   Note: This should only be called once!
#   Note: Markers are cached, so use cache_list to see the cache entry.
#
# Usage:
#   cwupdates_configure
#
function cwupdates_configure()
{
    if [ "$1" = '-h' ]; then
        usage cwupdates_configure
        return
    fi
    create_marker "CWUPDATES-MARKER-13042018"
}


# Description:
#   Capture updates to my CW directories.
#
# Usage:
#   getcwupdates
#
function getcwupdates() {
    if [ "$1" = '-h' ]; then
        usage getcwupdates
        return
    fi
	
	local _marker_name="CWUPDATES-MARKER-13042018"
	local _dir
	
	_dir="/cygdrive/c/mystuff_Clearwell"
    if [ -d "$_dir" ]; then
		local _target_file=mystuff_CW.tar.gz
		local _files_list_path="$TMP/.getcwupdates__${_target_file}"
		echo "Getting updated files from directory $_dir ..."
	    #(cd "$_dir" && files_updated_since_marker "$_marker_name" | xargs -0 tar cvzf $HOME/mystuff_CW.tar.gz -C "$_dir" && echo "Created backup: $HOME/mystuff_CW.tar.gz")
		(cd "$_dir" && files_updated_since_marker "$_marker_name" > ${_files_list_path} && tar cvzf $HOME/${_target_file} -T ${_files_list_path} && echo "Created backup: $HOME/${_target_file}")
	else 
		echo "ERROR: getcwupdates: No such directory: $_dir"
	fi
	
    _dir="/cygdrive/c/mystuff"
    if [ -d "$_dir" ] ; then
		local _target_file=mystuff.tar.gz
		local _files_list_path="$TMP/.getcwupdates__${_target_file}"
		echo "Getting updated files from directory $_dir ..."
        #(cd "$_dir"&& files_updated_since_marker "$_marker_name" | xargs -0 tar cvzf $HOME/mystuff.tar.gz -C "$_dir" && echo "Created backup: $HOME/mystuff.tar.gz")
		(cd "$_dir"&& files_updated_since_marker "$_marker_name" > ${_files_list_path} && tar cvzf $HOME/${_target_file} -T ${_files_list_path} && echo "Created backup: $HOME/${_target_file}")
	else
		echo "ERROR: getcwupdates: No such directory: $_dir"
	fi
}


# Description:
#   This function, given two files, will list the text lines
#   that are only in the first file.
#
#   Note: See join_demos directory if you need to compare 
#         specific columns in two files and return either
#         matching or non-matching lines.
#
# Usage:
#   comm_first <file1> <file2>
#
function comm_first() {
    local _f1=$1
    local _f2=$2

    if [ $# -ne 2 -o "$1" = '-h' ]; then
        usage comm_first
        return
    fi

    if [ ! -f "$_f1" ]; then 
        echo "No such file: $_f1"
        return
    fi

    if [ ! -f "$_f2" ]; then 
        echo "No such file: $_f2"
        return
    fi

    # sed '$G' => Ensure we have at least one line of results, for reading stdin.
    comm -23 "$_f1" "$_f2" | sed '$G'
}


# Description:
#   This function, given two files, will list the text lines
#   that are only in the second file.
#
#   Note: See join_demos directory if you need to compare 
#         specific columns in two files and return either
#         matching or non-matching lines.
#
# Usage:
#   comm_second <file1> <file2>
#
function comm_second() {
    local _f1=$1
    local _f2=$2

    if [ $# -ne 2 -o "$1" = '-h' ]; then
        usage comm_second
        return
    fi

    if [ ! -f "$_f1" ]; then 
        echo "No such file: $_f1"
        return
    fi

    if [ ! -f "$_f2" ]; then 
        echo "No such file: $_f2"
        return
    fi

    # sed '$G' => Ensure we have at least one line of results, for reading stdin.
    comm -13 "$_f1" "$_f2" | sed '$G'
}


# Description:
#   This function, given two files, will list the text lines
#   that are common to both files.
#
#   Note: See join_demos directory if you need to compare 
#         specific columns in two files and return either
#         matching or non-matching lines.
#
# Usage:
#   comm_both <file1> <file2>
# 
function comm_both() {
    local _f1=$1
    local _f2=$2

    if [ $# -ne 2 -o "$1" = '-h' ]; then
        usage comm_both
        return
    fi

    if [ ! -f "$_f1" ]; then 
        echo "No such file: $_f1"
        return
    fi

    if [ ! -f "$_f2" ]; then 
        echo "No such file: $_f2"
        return
    fi

    # sed '$G' => Ensure we have at least one line of results, for reading stdin.
    comm -12 "$_f1" "$_f2" | sed '$G'
}


# Description:
#   This function, given two files, will combine the lines
#   from each file, using the specified optional delimiter.
#
#   Note: See join_demos directory if you need to compare 
#         specific columns in two files and return either
#         matching or non-matching lines.
#
# Usage:
#   comm_combine <file1> <file2> [delimiter]
#
# Examples:
#   comm_combine file_a file_b
#   comb_combine file_a file_b '#'
#
function comm_combine()
{
    if [ $# -lt 2 -o "$1" = '-h' ]; then
        usage comm_combine
        return
    fi
    local _delim=' '
    [ x"$3" = x ] || _delim="$3"
    paste $1 $2 -d"$_delim"
}


# Return the name of the most recently modified file
# with a filename that includes the specified string.
function _lastf() {
    local _file=`ls -1tr | grep "^$1" | tail -1`
	if [ x"$_file" = x ]; then
	   _file=`ls -1tr | grep "$1" | tail -1`
	fi
    echo "$_file"
}


# Description:
#   tail the most recent file that has a filename that contains the 
#   specified string. A blank string will match all filenames, so
#   this will result in the most recent file being tail'ed.
#
# Usage:
#   tailf [string]
#
# Example:
#   tailf indexstat
#
function tailf() {
    if [ "$1" = '-h' ]; then
        usage tailf
        return
    fi
    local _file=$(_lastf "$1")
    if [ "x$_file" != x ]
    then
       printf "\ntail -f $_file ...\n\n"
       tail -f "$_file"
    else
       echo "tailf: No file names match \"$1\""
    fi
}
function t() {
	tailf $*
}


# Description:
#   Wait for a file name to appear in the current directory and then tail it.
#   The complete file name is not required; part of the file name is enough.
#   We want to wait for the next new occurrence of the file, so we must ignore
#   any old file names that match the name.
#
# Usage:
#   wtailf [string]
#
# Example:
#   wtailf validator
#
function wtailf() {
    if [ "$1" = '-h' ]; then
        usage wtailf
        return
    fi
    local _last_existing_file=$(ls -1tr | grep "$1" | tail -1)
	while [ 1 ]; do
        local _most_recent_file=$(ls -1tr | grep "$1" | tail -1)
		if [ "$_most_recent_file" != "$_last_existing_file" ]; then
		    echo "NEW FILE DETECTED: $_most_recent_file"
			local dummy
		    read -s -r -p "Press any key to tail the file..." -n 1 dummy
		    tailf "$_most_recent_file"
		fi
    done
}


# Description:
#   "less" the most recent file that has a 
#    filename that contains the specified string. 
#
# Usage:
#   lf [string]
#
# Example:
#   lf indexstat
#
function lf() {
    if [ "$1" = '-h' ]; then
        usage lf
        return
    fi
    local _file=$(_lastf "$1")
    if [ "x$_file" != x ]
    then
       /usr/bin/less "$_file"
    else
       echo "lf: No file names match \"$1\""
    fi
}


# Description:
#   List the contents of the specified file, starting
#   from the last line that contains the specified string.
#
# Usage:
#   last <filename> <string>
#
# Example:
#   last server.2012-09-09.log '= Clear'
#
function last() {
    local _file=$1
    local _str=$2

    if [ "$1" = '-h' ]; then
        usage last
        return
    fi

    tac "$_file" | sed -n "1,/$_str/p" | tac
}


# Description:
#   "less" the most recent file that has a filename 
#   that contains the specified string and also 
#   display line numbers.
#
# Usage:
#   lfn [string]
#
# Example:
#   lfn indexer
#
function lfn() {
    if [ "$1" = '-h' ]; then
        usage lfn
        return
    fi
    local _file=$(_lastf "$1")
    if [ "x$_file" != x ]
    then
       cat -n "$_file" | /usr/bin/less
    else
       echo "lfn: No file names match \"$1\""
    fi
}


# Description:
#   List the contents of the server log, starting
#   from the last boot. If the server log filename
#   is not specified, then use the most recent one.
#
# Usage:
#   lastb [serverlog]
#
function lastb() {
    local _serverlog=$1

    if [ "$1" = '-h' ]; then
        usage lastb
        return
    fi

	# Go to logs directory.
	logs
	
    if [ "x$_serverlog" = x ]; then
       # Determine most recent server log.
       _serverlog=$(_lastf 'server')
    fi
    if [ x"$_serverlog" = x ]; then
       echo "ERROR: lastb: No server log" 1>2&
       return
    fi

    last "$_serverlog" '= Clearw' | putclip
}


function _md5deep() {
    local _dir="$1"
    find "$_dir" -type f -exec md5sum {} \; | sed -n "s/^\([0-9a-f]*\) [ \t]*${_dir}\//\1\t/p"
}

# Description:
#   Diff md5sums of the files in two source directories.
#   Similar to md5deep (available in many Linux distributions).
#
# Usage:
#   md5diff dir1 dir2
#
function md5diff() {
    if [ $# -ne 2 -o "$1" = '-h' ]; then
        usage md5diff
        return
    fi
    
    local _dir1="$1"
    local _dir2="$2"

    if [ ! -d "$_dir1" ]; then
        echo "ERROR: No such directory: $_dir1"
	return
    fi   
    if [ ! -d "$_dir2" ]; then
        echo "ERROR: No such directory: $_dir2"
	return
    fi

    diff <(sort -t\t -k2 <(_md5deep "$_dir1")) <(sort -t\t -k2  <(_md5deep "$_dir2"))
}

# Description:
#   Analyse a Java stack dump and print the line numbers
#   of the start of the largest individual thread stacks.
#   These are usually the most relevant stacks to examine.
#
# Usage:
#   stacks <filename>
#
# Example:
#   stack dump.log
#
function stacks() {
    if [ "$1" = '-h' ]; then
        usage stacks
        return
    fi

    /bin/gawk.exe -f $TOOLS_DIR/filetools/stacks.awk $@
}


# Description:
#    Wait for a file to appear in the current dirctory or in a
#    a sub-directory of the current directory. When the file 
#    exists, copy it to $TMP and print a message on the screen.
#
# Usage:
#    wf <filename>
#
# Example:
#    wf summary.html
#
function wf() {
    local _file="$1"

    if [ $# -ne 1 -o "$1" = '-h' ]; then
        usage wf
        return
    fi

    echo "Waiting for file $_file to appear ..."
    while [ 1 ] 
    do
        # Note how we ignore the .cw_bash_profile directory, 
        # in case we are running this from the $HOME directory.
        local _found=`find . -path './.cw_bash_profile' -prune -o -name "$_file" -print`
        if [ x"$_found" != x ]; then
            echo "wf: FOUND $_found !!!"
            cp "$_found" "$TMP"/
            echo "Copied $_file to $TMP/"
            return
        fi
        sleep 1
    done 
}


# Description:
#    Watch the current directory. Every few seconds (3 seconds by default)
#    list the contents of the current directory and any subdirectories. 
#    Send this output to the screen and to the log file $TMP/wd.log. The 
#    name of the logfile can be changed and so can the number of seconds 
#    between each directing listing.
#
#    Use the stopwd() function to stop this function.
#
# Usage:
#    wd [<logfilename>] [-t <seconds>]
#
# Examples:
#    wd
#    wd -t 1
#
function wd() {
    local _logfile="$TMP/wd.log"
    local _delay=3

    if [ "$1" = '-h' ]; then
        usage wd
        return
    fi

    while [ ! -z "$1" ]
    do
        case "$1" in
        -t)
           shift
           if [ ! -z "$1" ]; then
               _delay="$1"
           fi
        ;;
        *) 
           _logfile="$1"
        ;;
        esac
        shift
    done
    
    rm -f "$_logfile"
    rm -f "$TMP/.stopwd"

    echo "Logging to $_logfile ..."
    echo "Watching directory $PWD ..." > $_logfile

    while [ ! -f "$TMP/.stopwd" ]
    do
        echo              >> "$_logfile"
        echo -n "DATE: "  >> "$_logfile"
        date              >> "$_logfile"
        echo
        find . -type f -print | tee -a "$_logfile"
        sleep $_delay
    done

    echo "wd: Finished logging to $_logfile"

    rm -f "$TMP/.stopwd"

}

# Description:
#   Stop watching the current directory.
#   This function stops the wd() function.
#
# Usage:
#   stopwd
#
function stopwd() {
    if [ "$1" = '-h' ]; then
        usage stopwd
        return
    fi
    touch "$TMP/.stopwd"
}

# Description:
#   Continuously list the files in the current directory.
#
# Usage:
#    w [-t <seconds>]
#
# Examples:
#    w
#    w -t 10
#
function w() {
    local _delay=1

    if [ "$1" = '-h' ]; then
        usage w
        return
    fi

    while [ ! -z "$1" ]
    do
        case "$1" in
        -t)
           shift
           if [ ! -z "$1" ]; then
               _delay="$1"
           fi
        ;;
        esac
        shift
    done

    while [ 1 ]
    do
	echo
	echo
	find . -type f -print
        sleep $_delay
    done
}

# Description:
#   List files bigger than the specified size.
#
# Usage:
#   bigger <size[kb|mb]>
#
# Examples:
#   bigger 4mb
#
function bigger() {
	if [ $# -ne 1 -o "$1" = '-h' ]; then
        usage bigger
        return
    fi

    local _size=$(echo "$1" | grep -i -E '^[0-9]+(kb|mb|gb|k|m|g)$')
	if [ x"$_size" != x ]; then
       # Convert size description to size calculation in bytes.
       local _size_calc_kb=$(echo $_size | sed -e 's/g[b]*/ * 1024 * 1024/I' -e 's/m[b]*/ * 1024/I' -e 's/k[b]*/ * 1/I')

       # Calculate period in seconds.
       local _size_kb=$(($_size_calc_kb))

       find . -size +${_size_kb}k -exec ls -lh {} \;
	else
	   echo "Bad input: $1"
	fi
}
