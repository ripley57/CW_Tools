TOOLS_DIR=$*

# Description:
#   Launch the MySQL graphical client myjgui
#
#   See http://myjgui.com/
#
# Usage:
#   myjgui
#
function myjgui() {
    if [ "$1" = '-h' ]; then
        usage myjgui
        return
    fi
    (cd "$TOOLS_DIR/myjgui" && ./myjgui.sh)
}
