TOOLS_DIR=$*

# Description:
#   Launch wget.exe
#
#   wget executable from: http://gnuwin32.sourceforge.net/packages/wget.htm
#   or from https://eternallybored.org/misc/wget/
#
# Usage:
#   wget
#
function wget() {
    if [ "$1" = '-h' ]; then
        usage wget
        return
    fi
	
	[ ! -f $TOOLS_DIR/wget/run_chmod.txt ] && (cd "$TOOLS_DIR/wget" && chmod +x *.exe *.dll && date > run_chmod.txt)
	
    $TOOLS_DIR/wget/wget.exe --no-check-certificate $* 2>/dev/null | dos2unix
}

# Description:
#    curl.exe for Windows can be downloaded from here:
#    http://curl.haxx.se/
#
#    See also:
#    http://www.oracle.com/webfolder/technetwork/tutorials/obe/cloud/13_2/messagingservice/files/installing_curl_command_line_tool_on_windows.html
#
# Usage:
#    curlhelp
#
function curlhelp() {
	usage curlhelp
}
