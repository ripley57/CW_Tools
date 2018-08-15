TOOLS_DIR=$*

# Description:
#   Launch gettimenow.exe
#
#   This program determines the current system time
#   and displays the low and high DWORD values you
#   can use with mfcmapi.exe to change the sent time
#   PR_CLIENT_SUBMIT_TIME. This program also displays
#   a version of the time truncated to seconds.
#
# Usage:
#   gettimenow.exe
#
function gettimenow() {
    if [ "$1" = '-h' ]; then
        usage gettimenow
        return
    fi
    $TOOLS_DIR/gettimenow/gettimenow.exe $*
}
