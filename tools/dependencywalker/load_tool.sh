TOOLS_DIR=$*

# Description:
#   Launch Dependency Walker (depends.exe).
#
#   See http://www.dependencywalker.com/
#
# Usage:
#   depends
#
function depends() {
    if [ "$1" = '-h' ]; then
        usage depends
        return
    fi
    $TOOLS_DIR/dependencywalker/depends $*
}
