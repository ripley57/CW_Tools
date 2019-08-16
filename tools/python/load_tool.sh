TOOLS_DIR=$*

# Description:
#   Useful python commands and links.
#
# Usage:
#   pythonhelp
#
function pythonhelp() {
    if [ "$1" = '-h' ]; then
        usage pythonhelp
        return
    fi

    cat "$TOOLS_DIR/python/PYTHON_CHEATSHEET.md"
}
