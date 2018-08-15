TOOLS_DIR=$*

# Description:
#   Launch Windows snipping tool.
#
# Usage:
#   snip
#
function snip() {
    if [ "$1" = '-h' ]; then
        usage snip
        return
    fi
    # Note: The following command does not work. It looks like
    #       cygwin cannot launch Windows shortcut (.lnk) files.
    #       It's probably because they are some sort of special
    #       binary file and that destination target cannot be
    #       resvoled.
    #cmd /c "$(cygpath -w $TOOLS_DIR/snip/launchSnip.bat)"

    echo "Note: For some reason Cygwin cannot launch Windows shortcut (lnk) files."
    echo "      You will find the location of the shortcut to Windows snip tool here:"
    echo
    cat $TOOLS_DIR/snip/launchSnip.bat
    echo
}
