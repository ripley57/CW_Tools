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

    if [ "$1" == "search" ; then
        echo "Searching for java installations..."
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
