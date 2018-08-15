TOOLS_DIR=$*

# Description:
#    Cd to the MySQL directory containing the <hostname>.err file.
#
# Usage:
#    mysqlerr
#
function mysqlerr() {
    cd /cygdrive/d/MySQL/data && ls -ltr
}


# Test and save database username and password to ~/.bash_profile
function _test_and_save_db_username_password_hostname() {
    local _username="$1"
    local _password="$2"
    local _hostname="$3"

    if mysql.exe -h"$_hostname" -u"$_username" -p"$_password" -e "" 2>/dev/null ; then
        sed -i "s/#ENV_DB_USER=.*$/ENV_DB_USER=$_username/" ~/.bash_profile
        sed -i "s/#ENV_DB_PASSWORD=.*$/ENV_DB_PASSWORD=$_password/" ~/.bash_profile
        sed -i "s/#ENV_DB_HOSTNAME=.*$/ENV_DB_HOSTNAME=$_hostname/" ~/.bash_profile
    fi
}

# Ask for database username and password. Also determine database hostname.
function _get_db_username_password_hostname() {
    # Note: If you define and export these environment variables
    #       in your ~/.bash_profile then you won't have to enter
    #       these values each time you start this script. 
    if [ -z "$ENV_DB_USER" ]; then
        echo -n "Enter db user: "
        read ENV_DB_USER
    fi
    if [ -z "$ENV_DB_PASSWORD" ]; then
        echo -n "Enter db password: "
        read ENV_DB_PASSWORD
    fi

    # Determine database hostname.
    if [ -z "$ENV_DB_HOSTNAME" ]; then
        ENV_DB_HOSTNAME=$(list esa.properties | grep servername | tail -1 | sed -n 's/esa.common.db.servername=\(.*\)/\1/p')
    fi

    _test_and_save_db_username_password_hostname "$ENV_DB_USER" "$ENV_DB_PASSWORD" "$ENV_DB_HOSTNAME"
}

# Description:
#    Search each non-Case database for a specific string.
#
# Usage:
#    non_case_dbs_search <string>
#
# Example:
#    non_case_dbs_search "ATTRIBUTE_ID"
#
function non_case_dbs_search() {
    local _search_str="$1"

    if [ "$1" = '-h' ]; then
        usage non_case_dbs_search
        return
    fi
	
	# Get list of databases to search.
    local _dbs_list=$(non_case_dbs | sed 's#\r\n# #g')
	
    # Query each of the databases for the search string.
    local _db
    for _db in $(echo $_dbs_list)
    do
        echo "Searching $_db for \"$_search_str\" ..."
        _db_search "$_db" "$_search_str"
    done
}
	
# Description:
#    Search each database of a Case for a specific string.
#
# Usage:
#    case_dbs_search <case name> <string>
#
# Example:
#    case_dbs_search "my test case" "ATTRIBUTE_ID"
#
function case_dbs_search() {
    local _case_name="$1"
    local _search_str="$2"

    if [ $# -ne 2 -o "$1" = '-h' ]; then
        usage case_dbs_search
        return
    fi

    # Get list of all databases of Cases that match the Case name.
    local _cases_list=$(case_dbs "$_case_name")

    # Return an error if multiple (or zero) matching Cases were found.
    local _case_count=$(echo "$_cases_list" | grep 'esadb.*_lds_case_[^_]*$' | wc -l)
    if [ "$_case_count" -gt 1 ]; then
        echo "Too many matching Cases ($_case_count)."
        echo "Re-run this function using the full case name."
        return
    elif [ "$_case_count" -eq 0 ]; then
        echo "No matching cases were found."
        return
    fi

    # Query each of the Case's databases for the search string.
    local _db
    for _db in $(echo "$_cases_list" | grep esadb_)
    do
        echo
        echo "Searching $_db for \"$_search_str\" ..."
        _db_search "$_db" "$_search_str"
    done
}

# Description:
#    Given a string (e.g. property name or value), search all 
#    the tables of the specified database for the string.
#
# Usage:
#    _db_search <case_db> <string>
#
# Example:
#    _db_search esadb_lds_case_294781183 esa.case.processing.rediscoverLEFFiles
#
function _db_search() {
    if [ $# -ne 2 -o "$1" = '-h' ]; then
        usage _db_search
        return
    fi

    local _db_name="$1"
    local _str="$2"
    local _rtn
    local _table

    _get_db_username_password_hostname

    for _table in `mysql -N -B -e "SHOW TABLES" $_db_name`
    do
        local _rtn
        _rtn=`mysql -N -B -e "DESC $_db_name.$_table" 2>/dev/null | grep -i "$_str"`
        if [ x"$_rtn" != x ]; then
            echo "TABLE: $_table"
            echo "$_rtn"
        fi
        _rtn=`mysql -N -B -e "SELECT * FROM $_db_name.$_table" 2>/dev/null | grep -i "$_str"`
        if [ x"$_rtn" != x ]; then
            echo "TABLE: $_table" 
            echo "$_rtn"
        fi
    done
}

# Description:
#    List the non-Case databases.
#
# Usage:
#    non_case_dbs
#
# Example:
#    non_case_dbs
#
function non_case_dbs() {
    if [ "$1" = '-h' ]; then
        usage non_case_dbs
        return
    fi
	
	_get_db_username_password_hostname

    mysql -N -B -e "SHOW DATABASES"  | grep -E -v '(esadb.*_lds_index|esadb.*_lds_email_locator|esadb.*_lds_case_temp|esadb.*_lds_case_group|esadb.*_lds_case_appliance|esadb.*_lds_case_[^0-9])'
}
	
# Description:
#    List the Case databases.
#    If a string is specified then only cases containing that
#    string in the name (case-insensitive) will be listed.
#
# Usage:
#    case_dbs [name]
#
# Example:
#    case_dbs my test 1
#
function case_dbs() {
    local _case_name_str="$*"

    if [ "$1" = '-h' ]; then
        usage case_dbs
        return
    fi

    _get_db_username_password_hostname

    local _case_db
    local _case_name
    local _case_id
    local _is_template
    local printed_header=0

    echo "Reading Case details from database ..."

    for _case_db in `mysql -e "SHOW DATABASES" | grep -E 'esadb.*_lds_case_[0-9]{9}|esadb.*_lds_case_[a-zA-Z0-9\$]{10}|esadb.*_lds_case_[0-9]{8}'`
    do
        # Extract database esadb prefix.
        local _esadb_prefix=$(echo $_case_db | sed -n 's/\(.*\)_lds_case_.*/\1/p')

        _case_name=`mysql -N -B -e "SELECT NAME FROM $_case_db.t_case"`
        _case_id=`mysql -N -B -e "SELECT ID FROM $_case_db.t_case"`
        _is_template=`mysql -N -B -e "SELECT bin(ISTEMPLATE) FROM $_case_db.t_case"`

        # Indicate if case template.
        local _template_indicator=""
        [ "$_is_template" = "1" ] && _template_indicator=" [CASE TEMPLATE]";

        # Display the Case name.
        printf "\n\n%40s\t%s" "$_case_name" "$_template_indicator"
        printf "\n%40s" "$_case_id"
        printf "\n%60s" "$_case_db"

	# Dont go any further for a case template.
	[ "$_is_template" = "1" ] && continue;

        # Display related child databases.
        local _child_case_db
        for _child_case_db in `mysql -N -B -e "SELECT CHILD_DS_DB_NAME from $_case_db.t_ds_meta_data_child_dbs"`
        do
            printf "\n%60s" "$_esadb_prefix$_child_case_db"
        done
    done > "$TMP/.case_dbs"

    # If we were passed a case name string, display all database names.
    if [ -f "$TMP/.case_dbs" ]; then
        if [ x"$_case_name_str" != x ]; then
            # Later versions of grep have a 'secret' way to override the "--" group
            # separator string (by using --group-separator=""). To be safe, we will
            # instead use sed.
            echo
            sed -n "/$_case_name_str/,/^$/p" "$TMP/.case_dbs" | sed 's/^--//'
            echo
        else
            cat "$TMP/.case_dbs"
        fi
    fi
}

# Description:
#    Wrapper around mysql.exe that supplies the username and password.
#
# Usage:
#        mysql [--opts="opts"] <dbname> -e "<query>"
#
# Example:
#        mysql esadb_lds_case_ack1nby4hl -e "show tables"
#        mysql --opts="-N -B" esadb_lds_case_ack1nby4hl -e "show tables"
#
function mysql() {
    if [ "$1" = '-h' ]; then
        usage mysql
        return
    fi
	
	# Optional mysql command-line options.
	local _mysqlopts=""
	if grep -q '^--opts=' <<< $1 ; then
		_mysqlopts=$(sed 's/^--opts=//' <<< $1)
		shift
	fi
	
    _get_db_username_password_hostname

    #mysql.exe -h$ENV_DB_HOSTNAME -u$ENV_DB_USER -p$ENV_DB_PASSWORD "$@"
	MYSQL_PWD="$ENV_DB_PASSWORD" mysql.exe $_mysqlopts -h$ENV_DB_HOSTNAME -u$ENV_DB_USER "$@"
}


# JeremyC 27/11/2016. There are two versions of the function. Let's comment-output
#                     this version and see if it causes any issues. If it doesn't, 
#                     then we'll remove this version at some point.
## Description:
##    Create a copy of b.bat called b2.bat which uses the full 
##    file path to the installed Windows Perl, which is 
##    assumed to be in c:\perl\perl\bin\perl.exe. This b2.bat
##    script can then be called from Cygwin without invoking
##    the perl installed with Cygwin, which errors when calling
##    build.pl with the following error:
##    Can't locate object method "GetObject" via package "Win32::OLE"
##
## Usage:
##    createb2bat
##
#function createb2bat() {
#	if [ "$1" = '-h' ]; then
#		usage createb2bat
#		return
#	fi
#	
#	local _cwdir=$(cwdir)
#	if [ ! -f "$_cwdir/b2.bat" ]; then
#		sed 's#perl#C:\\perl\\bin\\perl.exe#' "$_cwdir/b.bat" > "$_cwdir/b2.bat"
#	else
#		# Nothing to do
#		return
#	fi
#} 

# Description:
#    Display the names of all the datastores of a case
#	 by parsing the output from the case browser support
#	 feature.
#
# Usage:
#    casedatastores <casename>
#
function casedatastores() {
    if [ "$1" = '-h' ]; then
		usage casedatastores
		return
	fi
	local _casename=$*
	if [ x"$_casename" = x ]; then
		echo "ERROR: casedatastores: No case name specified" >&2
		return
	fi
	createb2bat
	local _cwdir=$(cwdir)
	local _line
	(cd "$_cwdir" && ${_cwdir}/b2.bat admin-client support run caseBrowser ESACASE="$_casename" COUNTS=NONE DATASTORES=1) | gawk.exe '/.*datastore[ \t]+:/ { sub(/^.*: /,"",$0); print; } '
}

# Description:
#	Display name of CASE datastore for a specific case.
#
# Usage:
#	CASE_ds <casename>
#
function CASE_ds() {
    if [ "$1" = '-h' ]; then
		usage CASE_ds
		return
	fi
	local _casename=$*
	if [ x"$_casename" = x ]; then
		echo "ERROR: CASE_ds: No case name specified" >&2
		return
	fi
	casedatastores "$_casename" | grep _lds_case_ | grep -v -E 'group|appliance|temp'
	
}

# Description:
#	List the case-level propertiesof a case.
#
# Usage:
#	caseprops <casename>
#
function caseprops() {
	if [ "$1" = '-h' ]; then
		usage caseprops
		return
	fi
	
	local _casename=$*
	if [ x"$_casename" = x ]; then
		echo "ERROR: caseprops: No case name specified" >&2
		return
	fi

	_get_db_username_password_hostname
	
	local _case_ds=$(CASE_ds "$_casename")
	if [ x"$_case_ds" = x ]; then
		echo "ERROR: caseprops: Could not determine CASE datastore. Check case name: \"$_casename\"" >&2
		return
	fi
	mysql -B "$_case_ds" -e "select name,value from t_genericproperty" | grep 'case\$'
}

# Description:
#	List case names.
#
# Usage:
#	cases
#
function cases() {
	if [ "$1" = '-h' ]; then
		usage cases
		return
	fi
		createb2bat
	local _cwdir=$(cwdir)
	local _line
	(cd "$_cwdir" && ${_cwdir}/b2.bat admin-client support run clusterbrowser) | gawk.exe '/.*case:/ { sub(/^.*case:/,"case:",$0); print; } '
}

# Description:
#   View and update the MySQL logging setting "general_log".
#   Without any arguments, display the current settings, and
#   the log file location ("general_log_file").
#	
# Usage:
#   mysqllog [on|off]
#
function mysqllog() {
	if [ "$1" = '-h' ]; then
		usage mysqllog
		return
	fi

	# Path to the MySQL log file.
	local _general_log_file="$(mysql --opts="-B -N" -e "show variables like 'general_log_file'" | sed 's/^general_log_file[ \t]*//')"

	# Convert to Cygwin/Linux path.
	local _general_log_file_path_unix="$(cygpath -au "$_general_log_file")"

	if [ $# -eq 0 ]; then
	    # Display "general_log" and "general_log_file" values.
	    mysql -e "show variables like '%general_log%'"
	    echo
	    echo "Path to log file:" 
	    echo "$_general_log_file_path_unix"
	    echo
	    echo "Press any key to tail the file:"
	    local _dummy
	    read  _dummy
	    tail -f "$_general_log_file_path_unix"
	fi

	if [ $1 = "on" -o $1 = "ON" ]; then
	    echo "Set general_log to ON"
	    echo "====================="
	    echo "Enter MySQL root password:"
	    mysql.exe -uroot -p -e "set global general_log = 'ON';"
	    mysql -e "show variables like '%general_log%'"
	    echo 
	    echo "Path to log file:" 
	    echo "$_general_log_file_path_unix"
	    echo
	    echo "Press any key to tail the file:"
	    local _dummy
	    read  _dummy
	    tail -f "$_general_log_file_path_unix"
	fi

	if [ $1 = "off" -o $1 = "OFF" ]; then
	    echo "Set genral_log to OFF"
	    echo "====================="
	    echo "Enter MySQL root password:"
	    mysql.exe -uroot -p -e "set global general_log = 'OFF';"
	    mysql -e "show variables like '%general_log%'"
	fi
}
