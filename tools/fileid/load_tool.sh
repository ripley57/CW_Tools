TOOLS_DIR=$*

# Description:
#   Launch fileid.exe, or use the "-list" option to display a web
#   page showing the Stellent file ids (i.e. html page of sccfi.h).
#
#   Note: fileid.exe does have -i and -o options, but the
#         the -i option seems to always return an error.
#         Because of this, we will use the stdin approach.
#
# Usage:
#   fileid <filename>
#   fileid -list
#
function fileid() {
    if [ "$1" = '-h' ]; then
        usage fileid
        return
    fi
	
    if [ "$1" = '-list' ]; then
        local _browser=$(_get_web_browser)
        "${_browser}" "https://searchcode.com/codesearch/view/258102/" &
        return
    fi

    # Construct full path.
    local _file="$*"
    local _file_path_linux=$(cygpath -au "$_file")
    local _file_path_windows=$(cygpath -aw "$_file")
		
    if [ ! -f "$_file_path_linux" ]; then
        echo "Error: No such file: $_file_path_windows"
        return
    fi

    # Call fileid.exe and pass the windows file path on stdin.
    local _cwdir=$(cwdir)
    $_cwdir/exe/filefilter/fileid.exe <<EOI
"$_file_path_windows"
EOI
}

# Description:
#	Launch fileid.exe using csv input file format, to display the fileid for
#	all files in the current directory. 
#
# Usage:
#	fileids
#
function fileids() {
	if [ "$1" = '-h' ]; then
		usage fileids
		return
	fi
	
	local _cwdir=$(cwdir)
	cmd /c "$(cygpath -aw $TOOLS_DIR/fileid/fileids.bat)" "$(cygpath -aw $_cwdir)"
}
