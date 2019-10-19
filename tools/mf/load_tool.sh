TOOLS_DIR=$*

# Description:
#   Launch MF ED 32-bit command prompt.
#
# Usage:
#   es32
#
function es32() {
	if [ "$1" = '-h' ]; then
		usage es32
		return
	fi
	cygstart cmd /c "$(cygpath -w "$TOOLS_DIR/mf/es32.bat")"
}


# Description:
#   Launch MF ED 64-bit command prompt.
#
# Usage:
#   es64
#
function es64() {
	if [ "$1" = '-h' ]; then
		usage es64
		return
	fi
	cygstart cmd /c "$(cygpath -w "$TOOLS_DIR/mf/es64.bat")"
}
