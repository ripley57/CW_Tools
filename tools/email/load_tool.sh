TOOLS_DIR=$*

# Description:
#   Launch smtp4dev
#
# Usage:
#   smtp4dev
#
function smtp4dev() {
    if [ "$1" = '-h' ]; then
        usage smtp4dev
        return
    fi
    $TOOLS_DIR/email/smtp4dev.exe
}
