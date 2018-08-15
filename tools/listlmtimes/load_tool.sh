TOOLS_DIR=$*

# Description:
#   Launch listlmtimes.exe
#
#   List last modified time of a single file 
#   or of all files in a directory.
#
# Usage:
#   listlmtimes
#
function listlmtimes() {
    if [ "$1" = '-h' ]; then
        usage listlmtimes
        return
    fi
    $TOOLS_DIR/listlmtimes/listlmtimes.exe $*
}
