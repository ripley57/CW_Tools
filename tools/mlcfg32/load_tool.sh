TOOLS_DIR=$*

# Description:
#   Launch MLCFG32.CPL
#
# Usage:
#   mlcfg32
#
function mlcfg32() {
    if [ "$1" = '-h' ]; then
        usage mlcfg32
        return
    fi
    cmd /c "$(cygpath -aw $TOOLS_DIR/mlcfg32/launchMail.bat)"
}
