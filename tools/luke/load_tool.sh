TOOLS_DIR=$*

# Description:
#   Launch Luke for Lucene 3.5.0.
#   See http://code.google.com/p/luke/
#
# Usage:
#   luke350
#
function luke350() {
    if [ "$1" = '-h' ]; then
        usage luke350
        return
    fi
    java -jar "$(_cygpath -aw $TOOLS_DIR/luke/lukeall-3.5.0.jar)"
}
alias luke=luke350

# Description:
#   Launch Luke for Lucene 7.3.1.
#   https://github.com/DmitryKey/luke/releases/
#   Note: These newer versions are using JavaFX for 
#         the GUI and require Java 1.8.6 or newer.
# Usage:
#   luke731
#
function luke731() {
    if [ "$1" = '-h' ]; then
        usage luke731
        return
    fi
	local _lukejar="$TOOLS_DIR/luke/lukeall-7.3.1.jar"
	if [ ! -f "$_lukejar" ]; then
	    echo "Downloading $DOWNLOAD_LUKE_731 ..."
		(cd "$TOOLS_DIR/luke" && download_file "$DOWNLOAD_LUKE_731" lukeall-7.3.1.jar)	
	fi
	
	echo
	echo "################################" >&2
	echo "# WARNING:                     #" >&2
	echo "# Java 1.8.6 or newer required #" >&2
	echo "################################" >&2
    echo
	
	java -jar "$(_cygpath -aw "$_lukejar")"
}
