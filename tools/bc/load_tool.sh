TOOLS_DIR=$*

# Description:
#   Launch Beyond Compare (bcompare.exe) to compare 
#   two files or folders.
#
# Usage:
#   bc <file1|dir1> <file2|dir2>
#
function bc() {
    if [ "$1" = '-h' ]; then
        usage bc
        return
    fi
    "$ENV_BC_EXE" "$@"
}
