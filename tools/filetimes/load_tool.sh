TOOLS_DIR=$*

# Description:
#   Display the Last Modified, Date Created, and Last Accessed 
#   times of the specified file.
#
#   Note: The dir.exe command has options for listing the same
#   values (/t:w /t:c /t:a), but these do not include seconds.
#
# Usage:
#   filetimes <filename>
#
function filetimes() {
    if [ "$1" = '-h' ]; then
        usage filetimes
        return
    fi
    #cscript //nologo "$(cygpath -aw $TOOLS_DIR/filetimes/filetimes.vbs)" "$1"
    $TOOLS_DIR/filetimes/filetimes.exe $*
}
