TOOLS_DIR=$*

# Description:
#   Sets the Last Modified time of the specified file to now.
#
#   This script is useful if you have a set of files that you
#   want to sort by Last Modified date. Copying a number of
#   documents at once, into a target directory, can result in
#   many files having the exact same Last Modified time, due to
#   time resolution limitations of the file system (2 seconds
#   resolution for FAT and NTFS file systems). Run this command
#   against your group of files, with a sleep of say 4 seconds
#   before each call, in the sort order you want.
#
# Usage:
#   settimenow <filename>
#
function settimenow() {
    if [ "$1" = '-h' ]; then
        usage settimenow
        return
    fi
    $TOOLS_DIR/settimenow/settimenow.exe "$1"
}
