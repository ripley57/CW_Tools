TOOLS_DIR=$*

# Description:
#   Launch getmfctime.exe
#
#   Given file time in milliseconds, display the low and high 
#   values for setting PR_CLIENT_SUBMIT_TIME using mfcmapi.exe.
#
# Usage:
#   getmfctime time_in_milliseconds
#
# Example:
#   getmfctime.exe 1387715957029
#
#   Input value : 1387715957029
#
#   Low value   : 0xd3ec3550
#   High value  : 0x01ceff12
#
function getmfctime() {
    if [ "$1" = '-h' ]; then
        usage getmfctime
        return
    fi
    $TOOLS_DIR/getmfctime/getmfctime.exe $*
}
