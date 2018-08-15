TOOLS_DIR=$*

# Description:
#   Launch cdllogvw.exe tool to view HTM file left in
#   Temporary Internet Files folder from a failed ActiveX
#   installation attempt. You don't need this tool to view
#   these HTM files, but the tools makes locating them a
#   doddle.
#
#   Downloaded from: 
#   http://download.microsoft.com/download/6/8/3/683DB9FE-8D61-4A3C-B7B8-3169FF70AE9F/cdllogvw.exe
#
#   See also the following log files for troubleshooting 
#   ActiveX plugin failure on a client user PC:
#
#   C:\Windows\inf\setupapi.app.log
#   C:\Windows\inf\setupapi.dev.log
#
# Usage:
#   cdllogvw
#
function cdllogvw() {
    if [ "$1" = '-h' ]; then
        usage cdllogvw
        return
    fi
    $TOOLS_DIR/iexplorer/cdllogvw.exe
}

# Description:
#   Launch 32-bit Internet Explorer
#
# Usage:
#   ie32
#
function ie32() {
    if [ "$1" = '-h' ]; then
        usage ie32
        return
    fi
    /cygdrive/c/Program\ Files\ \(x86\)/Internet\ Explorer/iexplore.exe
}

# Description:
#   Launch 64-bit Internet Explorer
#
# Usage:
#   ie64
#
function ie64() {
    if [ "$1" = '-h' ]; then
        usage ie64
        return
    fi
    /cygdrive/c/Program\ Files/Internet\ Explorer/iexplore.exe
}
