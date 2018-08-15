TOOLS_DIR=$*

# Description:
#   Launch mfcmapi.exe
#
#   Find 32-bit executable here: https://mfcmapi.codeplex.com/releases/view/89760
#
# Usage:
#   mfcmapi
#
function mfcmapi() {
    if [ "$1" = '-h' ]; then
        usage mfcmapi
        return
    fi
    $TOOLS_DIR/mfcmapi/mfcmapi.exe $*
}
