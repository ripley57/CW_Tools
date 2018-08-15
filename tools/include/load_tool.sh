TOOLS_DIR=$*

# Description:
#   List the include files in this directory.
#   These files are useful for various Windows errors.
#
# Usage:
#   includes
#
function includes() {
    if [ "$1" = '-h' ]; then
        usage includes
        return
    fi

    cd "$TOOLS_DIR/include" && ls -l
}
