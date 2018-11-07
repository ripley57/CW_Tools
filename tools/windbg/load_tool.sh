TOOLS_DIR=$*

# Description:
#   Download the x86 and x64 versions of windbg from the Windows SDK 10.
#
#   This function will simply download the windbg exe installers to the 
#   current directory. No installation will be performed.
#
# Usage:
#   download_windbg
#
function download_windbg() {
	if [ "$1" = '-h' ]; then
		usage download_windbg
		return
	fi
	
	local download_x86="https://www.dropbox.com/s/ox28ffov8of7690/X86%20Debuggers%20And%20Tools-x86_en-us.msi?dl=1"
	local download_x64="https://www.dropbox.com/s/0c7o8qdp6qcgj68/X64%20Debuggers%20And%20Tools-x64_en-us.msi?dl=1"
	
	download_file "$download_x86" "X86_Debuggers_And_Tools-x86_en-us.msi"
	download_file "$download_x64" "X64_Debuggers_And_Tools-x64_en-us.msi"
	
	# Launch Windows Explorer, to show the downloads.
	e
}


# Description:
#	Show helpful windbg usage examples.
#
# Usage:
#	windbghelp
#
function windbghelp() {

    # Launch windbg commands web page.
    local _browser=$(_get_web_browser)
    "${_browser}" "http://windbg.info/doc/1-common-cmds.html" &

	cat <<EOI
	o Debugging a Windows service:
	https://support.microsoft.com/en-us/help/824344/how-to-debug-windows-services

	
    SETTING SYMBOL PATH WHILE IN WINDBG
    ===================================
    .symfix ; .sympath+ d:\cw\v811\exe\pst ; .reload

    DISPLAY STL STRING IN WINDBG
    ============================
    1) Copy sdbgext.dll to the windbg "winext" sub-directory.
    2) .load sdbgext.dll
    3) Determine address of variable, using "dv" (local variables) or "dt" (complex type such as "this").
    4) !stlwstring <address>[+<offset>]
    
    WINDBG NORMAL USAGE
    ===================
    windbg.exe" -y "d:\cw\v811\exe\pst" -srcpath "D:\src\esa-src\src\cpp" "D:\CW\V811\exe\pst\CWMsgToPst.exe"
    NOTE: We use "-srcpath" since this is NOT remote debugging.

    WINDBG REMOTE DEBUGGING USAGE USING NTSD.EXE
    ============================================
    1) Create a registry key called "debugger" under a registry key for the executable to debug, e.g.:
       HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\ExchangeCollection.exe
    2) Set the "debugger" child registry key to this:
       "C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\ntsd.exe" -server tcp:port=9001:9100
    3) Start the executable to debug. When you see ntsd.exe running, launch windbg.exe, e.g.:
       windbg.exe -remote tcp:server=localhost,port=9001 -y "d:\cw\v811\exe\pst" -lsrcpath "D:\src\esa-src\src\cpp" -c "bp esamapilib!CEsaPSTCollectionWriterThread::_store;g"
       NOTE: We use "-lsrcpath" since this is remote debugging.

    WINDBG COMMAND-LINE OPTIONS
    ===========================
    https://msdn.microsoft.com/en-us/library/windows/hardware/ff539174(v=vs.85).aspx

EOI
}

# Description:
#   Launch windbg
#
# Usage:
#   windbg
#
function windbg() {
    local _windbg_help="C:\\Program Files (x86)\\Windows Kits\\10\\Debuggers\\x86\\debugger.chm"
    if [ "$1" = '-h' ]; then
	cmd /c "$_windbg_help"
        return
    fi
    local _windbg_exe=$(cygpath -u "C:\\Program Files (x86)\\Windows Kits\\10\\Debuggers\\x86\\windbg.exe")
    "$_windbg_exe" "$@"
}

# Description:
#   Launch windbg64
#
# Usage:
#   windbg64
#
function windbg64() {
    local _windbg_help="C:\\Program Files (x86)\\Windows Kits\\10\\Debuggers\\x64\\debugger.chm"
    if [ "$1" = '-h' ]; then
	cmd /c "$_windbg_help"
        return
    fi
    local _windbg_exe=$(cygpath -u "C:\\Program Files (x86)\\Windows Kits\\10\\Debuggers\\x64\\windbg.exe")
    "$_windbg_exe" "$@"
}

# Description:
#   Launch symbol.bat to search for a specific symbol 
#   in all the pdb files in the current directory.
#
#   NOTE: The seach is case-sensitive. 
#
# Usage:
#	symbol <symbol>
#
# Example:
#	symbol _handler
#
function symbol() {
	if [ "$1" = '-h' -o $# -lt 1 ]; then
		usage symbol
		return
	fi
	
	cmd /c "$(cygpath -aw $TOOLS_DIR/windbg/symbol.bat)" "$1"
}
