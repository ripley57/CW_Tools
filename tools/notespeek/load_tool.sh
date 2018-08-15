TOOLS_DIR=$*

# Description:
#   Launch notespeek tool for viewing NSF files. 
#   This utility is very similar to mfcmapi.exe
#
#   IMPORTANT: The notespeek tool will only work
#              on an appliance where the Notes 
#              client software is installed.
#
# Usage:
#   notespeek
#
function notespeek() {
    if [ "$1" = '-h' ]; then
        usage notespeek
        return
    fi
    $TOOLS_DIR/notespeek/notespk.exe $*
}
