TOOLS_DIR=$*

# Description:
#   See the result of setting or unsetting a bit flag.
#
# Usage:
#   bit clear|set flags flag
#
# Example:
#   bit clear 411 2
#
function bit() {
    if [ "$1" = '-h' ]; then
        usage bit
        return
    fi
    (cd "$TOOLS_DIR/Bit" && java -cp . Bit $*)
}
