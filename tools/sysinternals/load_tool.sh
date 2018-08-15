TOOLS_DIR=$*

# Description:
#   Display the parent process id given process id.
#
# Usage:
#   ppid <pid>
#
function ppid() {
    if [ "$1" = '-h' ]; then
        usage ppid
        return
    fi
    cmd /c "wmic process where (processid=$1) get parentprocessid"
}


# Description:
#   Launch Sysinternals regjump.exe.
#
#   By default load the application debugging registry key:
#   	HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options
#
# Usage:
#   reg [<args>]
#
# ExampleS:
#   reg HKU
#   reg HKCU
#   reg HKLM
#   reg 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'
#
function reg() {
    local _regkey

    # Default regkey to open.
    _regkey='HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'

    if [ "$1" = '-h' ]; then
        usage reg
        return
    fi

    if [ $# -gt 0 ]; then
        _regkey="$1"

    fi

    # This is tricky because regjump.exe needs to be run as administrator (you will
    # see an error otherwise). To get around this, we create a temporary shortcut 
    # file, and set the "run as admin" bit flag. We then run regjump.exe via that.
    echo "Launching regjump.exe via a temporary shortcut..."
    cmd /c powershell -executionpolicy RemoteSigned "$(cygpath -aw "$TOOLS_DIR/sysinternals/runasadmin.ps1")" -programfilepath "$(cygpath -aw "$TOOLS_DIR/sysinternals/regjump.exe")" -shortcutfilepath "$(cygpath -aw "$TOOLS_DIR/sysinternals/temp.lnk")" "\"/accepteula $_regkey\""
}


# Description:
#   Launch Sysinternals handle.exe
#
#   The primary purpose of handle.exe is to identify in-use files 
#   and directories. Because of this, running handle without any
#   arguments lists all the File owned by those processes. 
#
#   See http://technet.microsoft.com/en-gb/sysinternals
#
# Usage:
#   handle
#
function handle() {
    if [ "$1" = '-h' ]; then
        usage handle
        return
    fi
    $TOOLS_DIR/sysinternals/handle.exe /accepteula
}

# Description:
#   Launch Sysinternals Tcpview
#
#   See http://technet.microsoft.com/en-gb/sysinternals
#
# Usage:
#   tcpview
#
function tcpview() {
    if [ "$1" = '-h' ]; then
        usage tcpview
        return
    fi
    $TOOLS_DIR/sysinternals/Tcpview.exe /accepteula
}

# Description:
#   Launch Sysinternals Process Explorer
#
#   See http://technet.microsoft.com/en-gb/sysinternals
#
# Usage:
#   procexp
#
function procexp() {
    if [ "$1" = '-h' ]; then
        usage procexp
        return
    fi
    $TOOLS_DIR/sysinternals/procexp.exe /accepteula
}

# Description:
#   Launch Sysinternals Process Monitor.
#   See https://technet.microsoft.com/en-us/sysinternals/processmonitor.aspx
#
# Usage:
#   procmon
#
function procmon() {
    if [ "$1" = '-h' ]; then
        usage procmon
        return
    fi
    $TOOLS_DIR/sysinternals/procmon.exe /accepteula /noconnect
}

# Description:
#   Launch Sysinternals Strings.exe command.
#
#   See http://technet.microsoft.com/en-gb/sysinternals
#
# Usage:
#   strings
#
function strings() {
    if [ "$1" = '-h' ]; then
        usage strings
        return
    fi
    $TOOLS_DIR/sysinternals/strings.exe /accepteula
}

# Description:
#   Wrapper functions around Sysinternals bginfo.exe.
#
#   bginfo                  -  Launch the bginfo.exe GUI.
#   bginfo install          -  Create bginfo.exe shortcut.
#   bginfo remove           -  Remove bginfo.exe shortcut.
#   bginfo gettext          -  Display additional bginfo text.
#   bginfo settext <text>   -  Update additional bginfo text.  
#
# Usage:
#   bginfo [install|remove|gettext|settext <text>]
#
function bginfo() {
    if [ "$1" = '-h' ]; then
        usage bginfo
        return
    fi
	
	local _bginfo_exe=$TOOLS_DIR/sysinternals/bginfo.exe
	local _registry_vbs_script=$TOOLS_DIR/registry/registry.vbs
	local _shorcuts_vbs_script=$TOOLS_DIR/shortcuts/shortcuts.vbs
	local _bginfo_shortcut_filename="cwtools_bginfo.lnk"
	local _bginfo_shortcut_description="My link to bginfo"
	local _bginfo_shortcut_target="$(cygpath -aw $TOOLS_DIR/sysinternals/bginfo.exe)"
	local _bginfo_cfg_file="$(cygpath -aw $TOOLS_DIR/sysinternals/bginfo/cwtools_bginfo_cfg.bgi)"
	
	if [ $# -eq 0 ]; then
		$_bginfo_exe /nolicprompt "$_bginfo_cfg_file"
		return
	fi
	
	case "$1" in
	silent)
		# Silently launch bginfo, i.e. do not display the GUI.
		$_bginfo_exe /nolicprompt "$_bginfo_cfg_file" /timer:0 /silent
		;;
	install)
		# Create our "cwtools_biginfo" shortcut here:
		# C:\Users\<user name>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
		# Note: We don't need to determine the username, since we are using the "Startup"
		# special folder (see https://ss64.com/vb/special.html).
		cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" \
				   "/create:yes" \
				   "/destdirspecial:Startup" \
				   "/destdir2:""""" \
				   "/linkname:""$_bginfo_shortcut_filename""" \
				   "/description:""$_bginfo_shortcut_description""" \
				   "/target:""$_bginfo_shortcut_target""" \
				   "/arguments:""$_bginfo_cfg_file /timer:0 /silent"""
		# Copy our vbs script to c:\temp. We do this because this is the easiest/only way to
		# have the script in a known location that our pre-configured bginfo config can find.
		mkdir -p /cygdrive/c/temp
		cp -f $TOOLS_DIR/sysinternals/bginfo/bginfo_vbscript1.vbs /cygdrive/c/temp/
		# Force immediate update to the desktop.
		bginfo silent
		;;
	remove)
		# Remove our "cwtools_bginfo" shortcut.
		cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" \
				   "/delete:yes" \
				   "/sourcedirspecial:Startup" \
				   "/sourcedir2:""""" \
				   "/filename:""$_bginfo_shortcut_filename"""
		;;
	settext)
		# Set the new bginfo additional bgtext text value in the registry.
		cmd /c cscript /nologo "$(cygpath -aw "$_registry_vbs_script")" /operation:setstring /root:hkcu /key:"Software\CW_Tools" /name:BGInfo_Text /value:"$2"
		# Call bginfo silently, to update the desktop.
		bginfo silent
		;;
	gettext)
		# Display the current additional bginfo text value stored in the registry.
		cmd /c cscript /nologo "$(cygpath -aw "$_registry_vbs_script")" /operation:getstring /root:hkcu /key:"Software\CW_Tools" /name:BGInfo_Text
		;;
	debugcomps)
		# Get the list of components currently enabled for debug.
		local _debugcomps="$(cwdebugcompnames)"
		if [ x"$_debugcomps" = x ]; then
			_debugcomps="NONE"
		fi
		# Save in the registry so that our vbs script can get the string.
		cmd /c cscript /nologo "$(cygpath -aw "$_registry_vbs_script")" /operation:setstring /root:hkcu /key:"Software\CW_Tools" /name:BGInfo_Debugcomps /value:"$_debugcomps"
		# Now calls the vbs script from bginfo.
		bginfo silent	
		;;
	esac
}
