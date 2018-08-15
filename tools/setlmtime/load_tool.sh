TOOLS_DIR=$*

# Description:
#   Launch setlmtime.exe
#
#   Change the last modified time of a file.
#   Note: You can determine the milliseconds time value using
#         a tool such as http://www.epochconverter.com/
#
# Usage:
#   setlmtime <time_in_milliseconds> filename
#
# Example:
#   setlmtime 1400009613100 xxx
#   listlmtimes xxx
#   13/05/2014 19:33:33.100 UTC 1400009613100 C:\fullpath\xxx
#
function setlmtime() {
    if [ "$1" = '-h' ]; then
        usage setlmtime
        return
    fi
    $TOOLS_DIR/setlmtime/setlmtime.exe $*
}
