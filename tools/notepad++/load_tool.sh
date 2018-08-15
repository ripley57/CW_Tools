TOOLS_DIR=$*

# Description:
#   Launch Notepad++
#
#   Comment: 
#   I removed the contents of the following large directories:
#   3.4M    ./plugins
#   3.3M    ./user.manual
#
#   Documentation:
#   http://npp-community.tuxfamily.org/documentation/notepad-document
#
#   http://notepad-plus-plus.org/download/
#
# Usage:
#   notepad++ [file]
#
function notepad++() {
    if [ "$1" = '-h' ]; then
        usage notepad++
        return
    fi
    $TOOLS_DIR/notepad++/Notepad++.exe $*
}
