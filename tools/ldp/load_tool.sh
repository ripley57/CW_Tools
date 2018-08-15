TOOLS_DIR=$*

# Description:
#   Launch ldp.exe
#
# Usage:
#   ldp.exe
#
function ldp() {
    if [ "$1" = '-h' ]; then
        usage ldp
        return
    fi
    $TOOLS_DIR/ldp/ldp.exe
}
