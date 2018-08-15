TOOLS_DIR=$*

# Description:
#   Directory containing various tools to help troubleshoot LFI issues.
#
# Usage:
#   lfitools
#
function lfitools() {
    usage lfitools
    cat <<EOI

Current tools in directory ${TOOLS_DIR}/lfitools:

EOI
    (cd "$TOOLS_DIR/lfitools" && ls -ltr)
}

# Description:
#   Indicate the BOM (byte-order-mark) of the input file.
#
#   Note: This function uses the cmp command, which might 
#         not be available on your system.
#
#      Common BOMs:
#                    Hexadecimal        Octal
#                    (hex order is      (octal order is
#                     reversed when      exactly that
#                     viewed using od    when viewed using
#                     on x86_64)         od on x86_64)
#
#      UTF-8      :  EF BB BF        :  357 273 277
#      UTF-16 LE  :  FF FE           :  377 376
#      UTF-16 BE  :  FE FF           :  376 377
#      UTF-32 LE  :  FF FE 00 00     :  377 376 000 000
#      UTF-32 BE  :  00 00 FE FF     :  000 000 376 377
#
#      http://www.unicode.org/faq/utf_bom.html#bom4
#
# Usage:
#   bom filename
#
function bom() {
    if [ "$1" = '-h' -o x"$1" = x ]; then
        usage bom
        return
    fi

    if ! which cmp >/dev/null 2>&1 
    then
       echo "No cmp command found! Sorry, cannot run the bom function."
       return
    fi

    _bom_create_samples
    cmp -s -n 3 "$1" "${TMP}/bom_utf8_sample"    && echo "Input file is UTF-8"     && _bom_dump_file "$1" && return
    cmp -s -n 2 "$1" "${TMP}/bom_utf16le_sample" && echo "Input file is UTF-16 LE" && _bom_dump_file "$1" && return 
    cmp -s -n 2 "$1" "${TMP}/bom_utf16be_sample" && echo "Input file is UTF-16 BE" && _bom_dump_file "$1" && return 
    cmp -s -n 4 "$1" "${TMP}/bom_utf32le_sample" && echo "Input file is UTF-32 LE" && _bom_dump_file "$1" && return
    cmp -s -n 4 "$1" "${TMP}/bom_utf32be_sample" && echo "Input file is UTF-32 BE" && _bom_dump_file "$1" && return
    echo "Could not determine BOM" && _bom_dump_file "$1" 
}

function _bom_dump_file() {
    cut -c 1-100 "$1" 
    od -c -x "$1" | head -2
}

function _bom_create_samples() {
    printf "\357\273\277"     > ${TMP}/bom_utf8_sample
    printf "\377\376"         > ${TMP}/bom_utf16le_sample
    printf "\376\377"         > ${TMP}/bom_utf16be_sample
    printf "\377\376\000\000" > ${TMP}/bom_utf32le_sample
    printf "\000\000\376\377" > ${TMP}/bom_utf32be_sample
}

# Description:
#   This function will replace the "174" LFI field delimiter 
#   (the trademark symbol), with the specified text string.
#
#   The "174" field delimiter is "c2ae" in hex ("302 256" octal):
#   $ head -1 Template1.dat
#   þDocIDþ®þFromþ®þSubjectþ®þCustodiansþ®þLocationsþ
#   $ od -x -c Template1.dat | head -2
#   0000000    bec3    6f44    4963    c344    c2be    c3ae    46be    6f72
#           303 276   D   o   c   I   D 303 276 302 256 303 276   F   r   o
#   (see http://www.fileformat.info/info/unicode/char/ae/index.htm)
#   (see also http://www.unicode.org/faq/utf_bom.html)
#
# Usage:
#   replace174delim string filename 
#
# Example:
#   replace174delim ',' Template1.dat > outfile
# 
function replace174delim() {
    if [ "$1" = '-h' ]; then
        usage replace174delim
        return
    fi
    local _new_delim="$1"
    sed "s/\o302\o256/${_new_delim}/g" "$2"
}

# Description:
#   This function will replace the "254" LFI text qualifier
#   (the funny 'p' symbol) with the specified text string.
#
#   The "254" text qualifier is "c3be" in hex ("303 276" octal):
#   $ head -1 Template1.dat
#   þDocIDþ®þFromþ®þSubjectþ®þCustodiansþ®þLocationsþ
#   $ od -x -c Template1.dat | head -2
#   0000000    bec3    6f44    4963    c344    c2be    c3ae    46be    6f72
#           303 276   D   o   c   I   D 303 276 302 256 303 276   F   r   o
#   (see http://www.fileformat.info/info/unicode/char/fe/index.htm)
#   (see also http://www.unicode.org/faq/utf_bom.html)
#
# Usage:
#   replace254txtqual string filename
#
# Example:
#   replace254txtqual '"' Template1.dat > outfile
#    
#
function replace254txtqual() {
    if [ "$1" = '-h' ]; then
        usage replace254txtqual
        return
    fi
    local _new_delim="$1"
    sed "s/\o303\o276/${_new_delim}/g" "$2"
}

# Description:
#   Launch lfgen.exe
#
# Usage:
#   lfgen
#
function lfgen() {
    if [ "$1" = '-h' ]; then
        $TOOLS_DIR/lfitools/lfgen.exe
        return
    fi
    $TOOLS_DIR/lfitools/lfgen.exe "$@"
}

# Description:
#   Launch lfcopy.exe
#
# Usage:
#   lfcopy
#
# Example:
#   lfcopy.exe native\capture.jpg 1 5 native/dir%06lu/capture%06lu.jpg
#
function lfcopy() {
    if [ "$1" = '-h' ]; then
        $TOOLS_DIR/lfitools/lfcopy.exe
        return
    fi
    $TOOLS_DIR/lfitools/lfcopy.exe "$@"
}
