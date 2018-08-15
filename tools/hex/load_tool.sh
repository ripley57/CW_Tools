TOOLS_DIR=$*

# Description:
#   Launch HxD hex editor.
#
# Usage:
#   hex
#
function hex() {
    if [ "$1" = '-h' ]; then
        usage hex
        return
    fi
    $TOOLS_DIR/hex/HxD.exe $*
}
