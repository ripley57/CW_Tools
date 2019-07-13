TOOLS_DIR=$*

# Description:
#    Present a menu of the installed java versions and allow
#    the user to select one. This will set JAVA_HOME and PATH,
#    in order to run Java from Cygwin.
#
# Usage:
#    javasetup [search]
#
# Where:
#    search  -  Search for installed java versions and persist the list.
#
function javasetup() {
    if [ "$1" = '-h' ]; then
        usage javasetup
        return
    fi

    if [ "$1" == "search" ]; then
        echo "Searching for JDK installations (THIS COULD TAKE SEVERAL MINUTES) ..."
        find /cygdrive/c/ -iname "javac.exe" > "${TMP}/.javasetup" 2>/dev/null
        if [ ! -f "${TMP}/.javasetup" ]; then
            echo "javasetup: ERROR: Error searching for Java JDK installations."
            return
        fi

        # Read the java installations list into an array.
        local _java_installs
        local _i
        IFS=$'\n' _java_installs=( `cat "${TMP}/.javasetup" | sort`)
	
        # Remove the trailing '/bin/javac.exe' and persist the java dirs.
        rm -f "${TMP}/.javasetup_list"
        local _java_dirs
        declare -a _java_dirs=( "${_java_installs[@]/\/bin\/javac.exe/}" )
        for _i in "${_java_dirs[@]}"; do
            echo $_i >> "${TMP}/.javasetup_list"
        done
	
        # Build a menu of the java dirs to pick from.
        rm -f "${TMP}/.javasetup_menu"
        let _n=1
        local _javadir
        while read _javadir; do
            echo "${_n}) $_javadir" >> "${TMP}/.javasetup_menu"
            let _n=_n+1
        done < "${TMP}/.javasetup_list"
    fi
		
    if [ ! -f "${TMP}/.javasetup_menu" ]; then
        echo "INFO: Please run the \"search\" option to search for installed Javas".
        return
    fi
    
    # Display the menu to allow the user to select a java version.
    local _ans
    local _dir
    while [ 1 ]
    do
        _ans=""
        _dir=""
        clearscreen
	
        if [ ! -z "$JAVA_HOME" ]; then
            echo 
            echo "JAVA_HOME is currently set to:"
            echo "$JAVA_HOME"
            echo
	fi
	
        # Display the menu of Javas to select from.
        echo
        cat "${TMP}/.javasetup_menu"
        echo
	
        # Ask the user to select a Java and configure the env.
        echo -n "Please select a Java installation: "
        read _ans
        if [[ "$_ans" =~ ^[0-9]+$ ]]; then 
            # Extract the Java dir.
            _dir=$(sed -n ${_ans}p "${TMP}/.javasetup_menu" | sed 's#^[0-9][^/]*##')
		
            # Configure new Java env.
            echo
            echo "Updating env to use: \"${_dir}\" ..."
            export JAVA_HOME="${_dir}"
            export PATH="${JAVA_HOME}/bin:$PATH"
            echo
            java -version
            echo
            echo "JAVA_HOME=$JAVA_HOME"
            return
        fi

        echo -n "Bad choice. Press Enter to select again: "
        read _dummy
    done
}

# Description:
#	Copy the build.bat script to the current directory.
#
# Usage:
#	build
#
function build() {
    if [ "$1" = '-h' ]; then
        usage build
        return
    fi
	
    if [ ! -e "./buildbat" ]; then
       cp "${TOOLS_DIR}/java/build.bat" . && echo "Copied build.bat to current directory."
       cp "${TOOLS_DIR}/java/run.bat" .
    fi
}

# Description:
#    Run jsonvalidator.jar to validate a json data file, 
#    optionally with validation against a json schema file.
#
#    NOTE:
#    If an input file does not exist, the tool will
#    treat the input as a json string to validate.
#
# Usage:
#    jsonvalidator <data.json> [<schema.json>]
#
function jsonvalidator() {
    if [ "$1" = '-h' ]; then
        usage jsonvalidator
        return
    fi
	
    if [ ! -f "${TOOLS_DIR}/java/jsonvalidator/jsonvalidator.jar" ]; then
       (cd "${TOOLS_DIR}/java/jsonvalidator" && ant package)
    fi
	
    java -jar "$(cygpath -aw "${TOOLS_DIR}/java/jsonvalidator/jsonvalidator.jar")" "$@"
}

# Description:
#    Check the SSL access to a remote server and optionally
#    dump the server certificate-chain to a local file, so
#    that you can manually add them to the appropriate 
#    Java keystore or Windows trustore.
#
# Usage:
#    sslpoke [dump] <host> <port>
#
# Example:
#    sslpoke dump github.com 443
#
function sslpoke() {
	if [ "$1" = '-h' ] || [ $# -ne 3 -a  $# -ne 2 ]; then
        	usage sslpoke
        	return
    	fi
	
	local _dump_certs=
	if [ "$1" = "dump" ]; then
		_dump_certs=-Ddump_certs
		shift
	fi
	
	java "$_dump_certs" -jar "$(cygpath -aw "${TOOLS_DIR}/java/SSLPoke/sslpoke.jar")" "$@"
}

# help-func javahelp ^stack dump$|^jstack$
#
# Description:
#   Display useful java commands.
#
# Usage:
#   javahelp
#
function javahelp() {
    if [ "$1" = '-h' ]; then
        usage javahelp
        return
    fi

    cat <<EOI

o Generate a jstack:
su slurp -c "/usr/java/default/bin/jstack -l \$(pgrep -f AgentRun)"

EOI
}

# Description:
#   Download and configure "groovy" command-line.
#
# Usage:
#   groovy
#
function groovy() {
    if [ "$1" = '-h' ]; then
        usage groovy
        return
    fi

    local groovy_download="https://bintray.com/artifact/download/groovy/maven/apache-groovy-binary-2.5.7.zip"
    local groovy_zip=$(basename "$groovy_download")
    local groovy_dir=groovy-2.5.7

    # Delete the existing zip download if the file size was zero bytes, as
    # this was probably a failed download due to lack of Internet connection.
    (cd "$TOOLS_DIR/java/groovy" && [ -f "$groovy_zip" ] && [ ! -s "$groovy_zip" ] && rm "$groovy_zip")
	
    # Download and extract Maven.
    if [ ! -d "$TOOLS_DIR/java/groovy/$groovy_dir" ]; then
        echo "Downloading $groovy_download ..."
        (cd "$TOOLS_DIR/java/groovy" && download_file "$groovy_download" "$groovy_zip")
        echo "Extracting $groovy_zip ..."
        (cd "$TOOLS_DIR/java/groovy" && unzip "$groovy_zip")
    fi
	
    # Setup Maven environment in Linux or Cygwin.
    if [ "$(uname)" = "Linux" ] || type cygpath >/dev/null 2>&1; then
	if [[ "$PATH" == *"groovy"* ]]; then
            : ;# echo "Path already includes Groovy"
	else
            export PATH=$groovy_dir/bin:$PATH 
        fi
    fi

    # Generate batch script to setup env in Windows cmd window.
    if type cygpath >/dev/null 2>&1; then
        if [ ! -f "$TOOLS_DIR/java/groovy/setenv.cmd" ]; then
            local groovy_bin="$(cygpath -aw "$TOOLS_DIR/java/groovy/$groovy_dir/bin")"
            cat <<EOI >"$TOOLS_DIR/java/groovy/setenv.cmd"
@echo off
set PATH=$groovy_bin;%PATH%
EOI
            echo "Script to setup Groovy environment in Windows cmd.exe:"
            echo
            echo \"$(cygpath -aw "$TOOLS_DIR/java/groovy/setenv.cmd")\"
            echo
        fi
    fi
		
    printf "\nLaunching CW_Tools groovy wrapper ...\n\n"
    # NOTE: The "groovy" command (on Linux) is currently (11-07-2019)
    #       displaying multiple "WARNING" lines when it is run, starting
    #       with this line (even with me using OpenJDK 8) :
    #       WARNING: An illegal reflective access operation has occurred
    #       For now, we'll simply ignore these WARNINGs.
    "$TOOLS_DIR/java/groovy/$groovy_dir/bin/groovy" $* 2>&1 | grep -v WARNING
}
