TOOLS_DIR=$*

# Description:
#   Given a value (argument one), calculate the values +/- the percentage
#   of the second value given (argument two).
#
# Usage:
#   percent 500 5
#
function percent() {
	if [ "$1" = '-h' ]; then
		usage percent
		return
	fi

	local  _pc=$(/usr/bin/bc <<<"$1*$2/100")
        local _min=$(/usr/bin/bc <<<"$1-$_pc")
        local _max=$(/usr/bin/bc <<<"$1+$_pc")

 	echo "In value: $1"
        echo "In percent: $2"
	echo "diff: $_pc"
        echo "min: $_min"
        echo "max: $_max"
}


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
