TOOLS_DIR=$*

# Description:
#   Launch vim.exe
#
#   File vim73_46w32.zip was downloaded from http://www.vim.org/download.php#pc
#
# Usage:
#   vi [file]
#
function vi() {
    if [ "$1" = '-h' ]; then
        usage vi
        return
    fi
    cygstart cmd.exe /c $(cygpath -w "$TOOLS_DIR/vim/vim.exe") $(cygpath -w "$*")
}

if [ -f /usr/bin/vim ]; then
# Description:
#   Launch multiple files in vim horizontally.
#
# Usage:
#   vimh file1 file2
#
function vimh() {
    if [ "$1" = '-h' ]; then
        usage vimh
        return
    fi
    /usr/bin/vim -o $*
}
# Description:
#   Launch multiple files in vim vertically.
#
# Usage:
#   vimv file1 file2
#
function vimv() {
    if [ "$1" = '-h' ]; then
        usage vimv
        return
    fi
    /usr/bin/vim -O $*
}
fi

# Use the real vi instead, if present.
which vi >/dev/null 2>&1 && unset vi

