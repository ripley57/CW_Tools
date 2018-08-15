TOOLS_DIR=$*

# Description:
#   Launch gawk.exe
#
#   gawk.exe executable from: http://gnuwin32.sourceforge.net/packages/gawk.htm
#
#   $ cat test.csv | gawk.exe -F',' '{print $1}'
#   "Beg_Doc"
#   "00000001"
#
# Usage:
#   gawk
#
function gawk() {
    if [ "$1" = '-h' ]; then
        usage gawk
        return
    fi
    $TOOLS_DIR/gawk/gawk.exe "$@"
}
