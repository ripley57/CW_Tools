TOOLS_DIR=$*

# Description:
#   Launch nc.exe
#
#   See http://www.securityfocus.com/tools/139
#
# Usage:
#   Server: nc -L -p 10000
#   Client: nc localhost 10000	
#
function nc() {
    if [ "$1" = '-h' ]; then
        usage nc
        return
    fi

    # Download nc.exe if not already present.
    # NOTE: nc.exe has been removed from CW_Tools
    #       because virus scanners do not like it.
    if [ ! -f "$TOOLS_DIR/netcat/nc.exe" ]; then
	echo "Downloading nc.exe ..."
	download_nc "$(cygpath -aw "$TOOLS_DIR/netcat/nc.exe")"
    fi

    $TOOLS_DIR/netcat/nc.exe $*
}
