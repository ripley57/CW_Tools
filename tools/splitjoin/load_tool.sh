TOOLS_DIR=$*

# Description:
#   Join binary file chunks created by the "splitfile" command.
#
# Usage:
#   joinfiles <prefix>
#
# Example:
#   The following will join the files named yDocV66_aa, yDocV66_ab, etc:
#
#   joinfiles yDocV66_
#
function joinfiles() {
    local _prefix="$1"

    if [ "$1" = '-h' -o x = "x$_prefix" ]; then
        usage joinfiles
        return
    fi

    local _output_file=$(echo $_prefix | sed -n 's/\(.*\)_.*$/\1/p')
    local _input_filelist=$(ls -1 | grep "$_prefix" | sort | tr '\n' ' ')

    echo "Combining $_input_filelist into $_output_file ..."
    cat $_input_filelist > $_output_file
}


# Description:
#   Split a file into binary chunks
#
#   See also the "joinfiles" comand.
#
# Usage:
#   splitfile <chunk size in MB> <input file> <prefix>
#
# Example:
#   The following will split the file yDocV66.zip into 4MB chunks named
#   yDocV66_aa, yDocV66_ab, etc:
#
#   splitfile 4 yDocV66.zip yDocV66_
#
function splitfile() {
    local _chunk_size_mb="$1"
    local _inputfile="$2"
    local _prefix="$3"

    if [ "$1" = '-h' -o x = "x$_chunk_size_mb" ]; then
        usage splitfile
        return
    fi

    local _chunk_size_bytes=$(expr ${_chunk_size_mb} \* 1024 \* 1024)
    split -b $_chunk_size_bytes "$_inputfile" "$_prefix"
}
