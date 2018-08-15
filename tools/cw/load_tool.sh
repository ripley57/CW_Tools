TOOLS_DIR=$*

# Return CW version, e.g. "V712".
function cwver() {
	local _cwdir=$(cwdir)
	echo "$_cwdir" | sed -n 's/^.*\(V.*\)$/\1/p' | sed 's#/##'
}

# Determine the latest CW top-level directory.
function cwdir() {

    # If CW_HOME environment variable is defined then return that.
    # This enables us to use this function outside of an appliance.
    if [ x"$CW_HOME" != x ]; then
        _cwdir="$CW_HOME"
    else
        # Note: I found that I had to use tac, as tail resulted in a grep error when
        #       there was only one line of results returned by the find command.
        _cwdir=$(find /cygdrive/d/CW -maxdepth 1 -type d 2>/dev/null | grep -i 'v[0-9][0-9][0-9]*' | tail -1)
    fi

    echo $_cwdir
}

# Description: 
#   Determine the Tomcat version from the catalina.jar file.
#   If no input path to the catalina.jar file is specified,
#   determine the path to the CW catalina.jar file. 
#
#   FYI: Tomcat source downloads available here:
#   http://repo2.maven.org/maven2/org/apache/tomcat/tomcat-catalina/
#
# Usage:
#   tomcat_version [path-to-catalinar-jar]
#
# Example:
#   tomcat_version
#
function tomcat_version() {
    if [ "$1" = '-h' ]; then
        usage tomcat_version
        return
    fi

	local _catalina_jar="$(cygpath -aw "$1" 2>/dev/null)"
	
	if [ "x${_catalina_jar}" = "x" ]; then
		# No catalina.jar path specified, so determine path to CW catalinar.jar.
		local _cwdir=$(cwdir)
		_catalina_jar="$(cygpath -aw "${_cwdir}/tomcat/lib/catalina.jar")"
	fi
	
	local _tmp_dir="${TMP}/tomcat_version/"
	
	echo "Examining file $_catalina_jar ..."
	
	(	mkdir -p "$_tmp_dir" && cd "$_tmp_dir" && \
		jar xf "$_catalina_jar" org/apache/catalina/util/ServerInfo.properties && \
		grep server.number      org/apache/catalina/util/ServerInfo.properties	)
		
	echo
	echo "Tomcat source downloads available here:"
	echo "http://repo2.maven.org/maven2/org/apache/tomcat/tomcat-catalina/"
}

# Add useful directories to PATH.
_PATH_SAVED="$PATH"
function updatepath() {
    local _cwdir=$(cwdir)

    [ -z "$_cwdir" ] && return

    PATH="$PATH:$_cwdir/exe/"
    PATH="$PATH:$_cwdir/exe/filefilter/"
    PATH="$PATH:$_cwdir/exe/lef"
    PATH="$PATH:$_cwdir/exe/ocr"
    PATH="$PATH:$_cwdir/exe/pst/"
    PATH="$PATH:$_cwdir/3rdparty/Aid4Mail/"
    PATH="$PATH:$_cwdir/3rdparty/datanumen"
    PATH="$PATH:$_cwdir/3rdparty/apps/ant/bin/"

    PATH="$PATH:$_cwdir/../../Clear Packages/7zip/"
    PATH="$PATH:$_cwdir/../../pdftools/htmltools/"
    PATH="$PATH:$_cwdir/../../pdftools/PDF Meld/"

    export PATH
}
function _resetpath() {
    PATH="$_PATH_SAVED"
    export PATH
}
updatepath

# Description: 
#   Set CW_HOME to the specified directory, or to the 
#   current directory, if no directory was specified. 
#   This points us at a CW installation.
#
# Usage:
#   setcw [dir]
#
# Example:
#   cd /cygdrive/c/mystuff/CW/V66
#   setcw
#
function setcw() {
    local _cwdir="$1"

    if [ "$1" = '-h' ]; then
        usage setcw
        return
    fi

    if [ x"$_cwdir" != x ]; then
        CW_HOME="$_cwdir"
    else
        CW_HOME="$PWD"
    fi
}

# Description: 
#   Change to the most recent top-level CW directory.
#
# Usage:
#   cw
#
function cw() {
    local _cwdir=

    if [ "$1" = '-h' ]; then
        usage cw
        return
    fi

    _cwdir=$(cwdir)
    if [ -z "$_cwdir" ]; then
        printf "\nCould not find a top-level CW directory.\n"
        return
    fi

    cd $_cwdir
}

# Description:
#   Launch web browser with bash programming help.
#
# Usage:
#   bash [topic]
#
# Examples:
#   bash case
#   bash for
#
function bash() {
    # All bash topics I know about.
    local _topics="\
case#http://www.thegeekstuff.com/2010/07/bash-case-statement
for#http://www.thegeekstuff.com/2011/07/bash-for-loop-examples
if#http://www.thegeekstuff.com/2010/06/bash-if-statement-examples/
array#http://www.thegeekstuff.com/2010/06/bash-array-tutorial/
history#http://www.thegeekstuff.com/2011/08/bash-history-expansion/
string#http://www.thegeekstuff.com/2010/07/bash-string-manipulation/
while#http://www.thegeekstuff.com/2010/06/bash-for-while-until-loop-examples/
brackets#http://mywiki.wooledge.org/BashFAQ/031"

    if [ "$1" = '-h' ]; then
        usage bash
		echo
        echo "These are the bash topics I know about:"
        echo
        local _list_alias
        local _list_url
        echo "$_topics" | sed -n 's/\([^#]*\)#\(.*\)$/\1 \2/p' | while read _list_alias _list_url
        do
            printf "%-30s %s\n" "$_list_alias" "$_list_url"
        done
        return
    fi

    # Launch web page fpr a specific topic.
    local _browser=$(_get_web_browser)
    local _f=$(echo "$_topics" | grep "^$1#" | sed -n 's/\([^#]*\)#\(.*\)$/\2/p')
    if [ x"$_f" != x ]; then
        echo
        echo "Launching: $_browser $_f ..."
        echo
        "$_browser" "$_f"
    else
        echo
        echo "Sorry, I don't know about bash topic: $1"
    fi
}

# Description:
#   List the contents of a specific file.
#   Pass no argument to see all files.
#
# Usage:
#   list [filename]
#
# Example:
#   list
#   list esa.properties
#
function list() {
    local _cwdir=$(cwdir)
    if [ "$1" = '-h' ]; then
        usage list
        return
    fi

    if [ -z "$_cwdir" ]; then
        echo "Could not find cw_home!"
        return
    fi

    # All files I know about and their location.
    local _files="\
esa.properties#$_cwdir/scratch/esa/esa.properties
changes_esa.properties#$_cwdir/scratch/esa/changes_esa.properties
default.properties#$_cwdir/config/configs/default.properties
config.properties#$_cwdir/config/configs/esauser/config.properties
audit.txt#$_cwdir/scratch/support/esadb/audit.txt
server.xml#$_cwdir/tomcat/conf/server.xml
web.xml#$_cwdir/web/app/WEB-INF/web.xml
hosts#/cygdrive/c/windows/system32/drivers/etc/hosts
fileid#$TOOLS_DIR/stellent/Stellent-sccfi.h
debugcomps#List components currently enabled for debug in default.properties"

    if [ x"$1" = x ]; then
        echo "These are all the files I know about:"
        echo
        local _list_alias
        local _list_path
        echo "$_files" | sed -n 's/\([^#]*\)#\(.*\)$/\1 \2/p' | while read _list_alias _list_path
        do
            printf "%-30s %s\n" "$_list_alias" "$_list_path"
        done
    else
	    # Special file listing request handling...
		
        if [ "$1" = "debugcomps" ]; then
            # List components enabled for debug in the default.proeprties file.
			local def_props_file=$(echo "$_files" | grep "^default.properties#" | sed -n 's/\([^#]*\)#\(.*\)$/\2/p')
			echo "Looking for references to esa.common.jvm.debugparams ..."
			cat "$def_props_file" | grep 'esa.common.jvm.debugparams' | grep -v '^#' | sed -n 's/\([^=]*\)=.*$/\1/p'| grep -v -E 'esa.common.jvm.debugparams.core.vmSUN|esa.common.jvm.debugparams.core.vmBEA|esa.common.jvm.debugparams|esa.common.webapp.appserver.jvm.debugparams'
            return
		fi
		
		# Normal file listing request handling...
			
        # List a specific file and location.
        local _f=$(echo "$_files" | grep "^$1#" | sed -n 's/\([^#]*\)#\(.*\)$/\2/p')
        if [ x"$_f" != x ]; then
            echo
            echo "Listing: $_f ..."
            echo
            cat "$_f"
        else
            echo
            echo "Sorry, I don't know about file: $1"
        fi
    fi
}

# Description:
# 	List the Windows hosts file.
#
# Usage:
#	cwhosts
#
function cwhosts() { 
    if [ "$1" = '-h' ]; then
        usage cwhosts
        return
    fi
    list "hosts"
}

# Description:
#	List contents of the audit.txt file.
#
# Usage:
#	cwaudit
function cwaudit() {
    if [ "$1" = '-h' ]; then
        usage cwaudit
        return
    fi
	list "audit.txt"
}

# Description:
#	List components currently enabled for debugging.
#
#	esa.common.jvm.debugparams
#
#	Example values for Sun Java:
#	esa.common.jvm.debugparams=-Xint -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8000,suspend=y,server=y
#       (In this example, Eclipse would connect on localhost using port 8000).
#
# Usage:
#	cwdebugcomps
#
function cwdebugcomps() {
	if [ "$1" = '-h' ]; then
        usage cwdebugcomps
        return
    fi
    list "debugcomps"
}
alias debugcomps='cwdebugcomps'

# Description:
#	List contents of esa.properties.
#
# Usage:
#	cwesa
#
function cwesa() {
    if [ "$1" = '-h' ]; then
        usage cwesa
        return
    fi
	list "esa.properties"
}

# Description:
#	List contents of default.properties
#
# Usage:
#	cwdefault
#
function cwdefault() {
    if [ "$1" = '-h' ]; then
        usage cwdefault
        return
    fi
	list "default.properties"
}

# Description:
#	List contents of change_esa.properties
#
# Usage: 
#	cwchanges
#
function cwchangesprops() {
    if [ "$1" = '-h' ]; then
        usage cwchangesprops
        return
    fi
	list "changes_esa.properties" | grep -v safe | grep -v was
}
alias changes='cwchangesprops'

# Description:
#	List esa.properties and look for specified string.
#
# Usage:
#	cwp <string>
#
function cwp() {
    if [ "$1" = '-h' ]; then
        usage cwp
        return
    fi
	cwesa | grep -i "$1"
}

# Description:
#   Jump to the logs directory.
#
# Usage:
#   cwlogs
#
function cwlogs() {
    local _cwdir=$(cwdir)
	
    if [ "$1" = '-h' ]; then
        usage cwlogs
        return
    fi

    if [ -z "$_cwdir" ]; then
        echo "Could not find cw_home!"
        return
    fi
	
    cd $_cwdir/logs
}
alias logs='cwlogs'

# Description:
#	Jump to the scratch/support directory.
#
# Usage:
#	cwsupport
#
function cwsupport() {
    local _cwdir=$(cwdir)
	
    if [ "$1" = '-h' ]; then
        usage cwsupport
        return
    fi

    if [ -z "$_cwdir" ]; then
        echo "Could not find cw_home!"
        return
    fi
	
    cd $_cwdir/scratch/support
}
alias support='cwsupport'

# Description:
#	Jump to the scratch directory.
#
# Usage:
#	cwscratch
#
function cwscratch() {
    local _cwdir=$(cwdir)
	
    if [ "$1" = '-h' ]; then
        usage cwscratch
        return
    fi

    if [ -z "$_cwdir" ]; then
        echo "Could not find cw_home!"
        return
    fi
	
    cd $_cwdir/scratch/
}
alias scratch='cwscratch'

# Description:
#	Jump to the config/configs directory.
#
# Usage:
#	cwconfig
#
function cwconfig() {
    local _cwdir=$(cwdir)
	
    if [ "$1" = '-h' ]; then
        usage cwconfig
        return
    fi

    if [ -z "$_cwdir" ]; then
        echo "Could not find cw_home!"
        return
    fi
	
    cd $_cwdir/config/configs
}
alias config='cwconfig'

function _get_esadb_dirname() {
	local _esadb_dirname=$(list esa.properties | sed -n 's/esa.common.db.dbname=\(.*\)/\1/p')
	# Fall backup to default.
	[ ! -d "$_cwdir/data/$_esadb_dirname/case-logs" ] && _esadb_dirname=esadb
	echo "$_esadb_dirname"
}

# Description:
#   Jump to the web/app/WEB-INF/lib directory.
#
# Usage:
#   cwlib
#
function cwlib() {
    local _cwdir=$(cwdir)

    if [ "$1" = '-h' ]; then
        usage cwlib
        return
    fi

    if [ -z "$_cwdir" ]; then
        echo "Could not find cw_home!"
        return
    fi

    cd $_cwdir/web/app/WEB-INF/lib
}
alias lib='cwlib'

# Description:
#   Jump to the logs directory of the most recently modified Case.
#   This will usually jump you to the newest Case's logs directory. 
#
# Usage:
#   cwclogs
#
function cwclogs() {
    local _cwdir=$(cwdir)
	
    if [ "$1" = '-h' ]; then
        usage cwclogs
        return
    fi

    if [ -z "$_cwdir" ]; then
        echo "Could not find cw_home!"
        return
    fi

    local _esadb_dirname=$(_get_esadb_dirname)

    # Find all case directories, display last modified date as epoch seconds, so we can
    # sort them, then take the last one, which will be the most recently modified one.	
    local _dir=`find $_cwdir/data/$_esadb_dirname/case-logs -maxdepth 1 -type d -exec stat --format=%Y%n {} \; | \
	            sort | sed 's#^[0-9]\{10\}##' | grep -E -v '^\.$|/case-logs$' | tail -1` 
    cd "$_dir"
}
alias case_logs='cwclogs'
alias clogs='cwclogs'

# Description:
#   Tail newest server log.
#
# Usage:
#   cwtailserver
#
function cwtailserver() {
    if [ "$1" = '-h' ]; then
        usage cwtailserver
        return
    fi
    tailf server
} 
alias ts='cwlogs && cwtailserver'

# Description:
#   List the CW user accounts and their SID.
#
# Usage:
#   cwaccounts
#
function cwaccounts() {
    if [ "$1" = '-h' ]; then
        usage cwaccounts
        return
    fi
    cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/cw/cwaccounts.vbs)" 
}
alias account='cwaccounts'

# Description:
#   Install the bsh-to-bsf adapater (bsh-bsf-2.0b4.jar).
#   See http://www.beanshell.org/download.html
#
# Usage:
#   cwinstall_bshjar
#
function cwinstall_bshjar() {
    local _cwdir=$(cwdir)
    local _path="${_cwdir}/web/app/WEB-INF/lib/bsh-bsf-2.0b4.jar"

    if [ "$1" = '-h' ]; then
        usage cwinstall_bshjar
        return
    fi

    if [ ! -f "$_path" ]; then
        cp "$TOOLS_DIR/cw/bsh-bsf-2.0b4.jar" "$_path" && echo "Installed bsh-bsf-2.0b4.jar."
	return 0
    fi
    return 1
}

# Description:
#   Display CW product version (includes hotfix level).
#
# Usage:
#   cwbuildinfo
#
function cwbuildinfo() {
    if [ "$1" = '-h' ]; then
        usage cwbuildinfo
        return
    fi

    (cd "$TOOLS_DIR/cw" && _buildinfo_compile)
    (cd "$TOOLS_DIR/cw" && _buildinfo_run)
}

# Compile our Java program.
function _buildinfo_compile() {
    if [ ! -f buildinfo.class ] || [ -n "$(find . -name buildinfo.class -mmin +120)" ]; then
        local _cwdir=$(cwdir)
	if [ "x$_cwdir" != x ]; then
		#echo "Compiling buildinfo.java ..."
		local _cwdir_win=$(cygpath -w $_cwdir/web/app/WEB-INF/classes)
		javac -classpath "$_cwdir_win" buildinfo.java
	fi
    fi
}

# Run our Java program.
function _buildinfo_run() {
    local _cwdir=$(cwdir)
    if [ "x$_cwdir" != x ]; then
	local _cwdir_win=$(cygpath -w $_cwdir/web/app/WEB-INF/classes)
	java -classpath "$_cwdir_win;." buildinfo
    fi
}


# Description:
#    Enable debugging for a specific component by adding 
#    ${esa.common.jvm.debugparams} in default.properties.
#
# Usage:
#    cwdebugon <component-name>
#
# Example:
#    cwdebugon STELLENT
#
function cwdebugon() {
	local _comp=$1
	local _status

	if [ "$1" = '-h' ]; then
        	usage cwdebugon
        	return
    	fi
	
	if [ x"$_comp" = x ]; then
		echo "cwdebugon: Component name missing"
		return
	fi

	local _cwdir=$(cwdir)
	local _default_properties="${_cwdir}/config/configs/default.properties"

	_status=$(cwdebugstatus | grep -wi "$_comp")
	if echo "$_status" | grep -q 'ON' ; then
		echo "*** Debug is already ON for component $_comp"
	else
		sed -i "s/^[ \t]*esa\.asm\.component\.${_comp}\.jvm\.args=/esa\.asm\.component\.${_comp}\.jvm\.args=\${esa\.common\.jvm\.debugparams} /" "$_default_properties" && echo "Enabled debug for component $_comp"
		# Update list in registry of components enbabled for debug.
		bginfo debugcomps
	fi
}

# Description:
#    Disable debugging for a specific component by removing 
#    ${esa.common.jvm.debugparams} from default.properties.
#
# Usage:
#    cwdebugoff <component-name>
#
# Example:
#    cwdebugoff STELLENT
#
function cwdebugoff() {
	local _comp=$1
	local _status

	if [ "$1" = '-h' ]; then
        	usage cwdebugoff
        	return
    	fi
	
	if [ x"$_comp" = x ]; then
		echo "cwdebugoff: Component name missing"
		return
	fi

	local _cwdir=$(cwdir)
	local _default_properties="${_cwdir}/config/configs/default.properties"
	
	_status=$(cwdebugstatus | grep -wi "$_comp")
	if echo "$_status" | grep -q 'ON' ; then
		sed -i "s/^[ \t]*esa\.asm\.component\.${_comp}\.jvm\.args=\${esa\.common\.jvm\.debugparams\} /esa\.asm\.component\.${_comp}\.jvm\.args=/" "$_default_properties" && echo "Disabled debug for component $_comp"
		# Update list in registry of components enbabled for debug.
		bginfo debugcomps
	else
		echo "*** Debug is already off for component $_comp"
	fi
}

# Description:
#    List the debugging status of the components in default.properties.
#
# Usage:
#    cwdebugstatus
#
function cwdebugstatus() {
	local _propname
	local _compname
	local _status 
	local _line

	if [ "$1" = '-h' ]; then
        	usage cwdebugstatus
        	return
    	fi

	local _cwdir=$(cwdir)
	local _default_properties="${_cwdir}/config/configs/default.properties"
	
	sed 's#\\$##' "$_default_properties" | grep '^[ \t]*esa\.asm\.component\..*\.jvm\.args=' | while read _line
	do
		# Extract the leading property name from the line.
		_propname=${_line%=*}
	
		# Extract just the component name from the property name.
		#_compname=$(echo $_propname | sed -n 's/esa\.asm\.component\.\([^.]*\)\..*/\1/p')
		_compname=${_propname%.jvm.args*}
		_compname=${_compname#*esa.asm.component.}
		
		# Indicate if debug is enabled.
		_status="-"
		if echo "$_line" | grep -q '\.jvm\.args=[ ]*\${esa\.common\.jvm\.debugparams\}' ; then
			_status="ON"
		fi
	
		printf "%-10s %s\n" $_status $_compname
	done 
}
alias debugstatus='cwdebugstatus'
alias cwdebug='cwdebugstatus'

# Description:
#    List the components currently enabled for debugging.
#
# Usage:
#    cwdebugcompnames
#
function cwdebugcompnames() {
	if [ "$1" = '-h' ]; then
       	usage cwdebugcompnames
       	return
    fi
	cwdebugstatus | grep ON | sed 's/^ON[ ]*//' | tr '\n' ' '
}

# Description:
#    List the last changed value of the Muhimbi property.
#
# Usage:
#    muhimbi
#
function muhimbi() {
	if [ "$1" = '-h' ]; then
       	usage muhimbi
       	return
    fi
	changes | grep esa.imaging.muhimbi.service.enabled | tail -1
}
