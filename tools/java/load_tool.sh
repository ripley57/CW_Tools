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
#    search  -  Search for installed java versions and persist
#               the list.
#
function javasetup() {
    if [ "$1" = '-h' ]; then
        usage javasetup
        return
    fi

    if [ "$1" == "search" ]; then
        echo "Searching for java JDK installations..."
		find /cygdrive/c/ -iname "*javac.exe" > "${TMP}/.javasetup" 2>/dev/null
	
        if [ ! -f "${TMP}/.javasetup" ]; then
            echo "javasetup: Error searching for Java JDK installations."
            return
        fi

		# Read the java installations list into an array.
		local _java_installs
		local _i
        IFS=$'\n' _java_installs=( `cat "${TMP}/.javasetup" | sort`)
        for _i in "${_java_installs[@]}"; do
            echo $_i
        done
	fi
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
