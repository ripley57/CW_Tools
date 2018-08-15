TOOLS_DIR=$*

# Description:
#   This function uses the dd command to strip the first
#   N number of bytes from the specified input file.
#   The outout file will be named <infile>.out
#
#   Example BOMs:
#   EF BB BF    - UTF-8
#   FF FE       - UTF-16, little-endian (UTF-16LE)
#   FE FF       - UTF-16, big-endian (UTF-16BE)
#   FF FE 00 00 - UTF-32, little-endian (UTF-32LE)
#   00 00 FE FF - UTF-32, big-endian (UTF-32BE)
#   (see http://www.unicode.org/faq/utf_bom.html#bom4)
#
#   NOTE: The order of these byte pairs will appear as swapped
#         when viewed on a PC when using the "od" command.
#
# Usage:
#   stripbom numbytes filename
#
function stripbom() {
    if [ "$1" = '-h' ]; then
        usage stripbom
        return
    fi
    dd bs=1 skip=$1 if="$2" of="$2.out"
}
