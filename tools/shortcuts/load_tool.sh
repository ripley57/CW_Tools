TOOLS_DIR=$*

# Description:
#   Add selection of useful shortcuts to the desktop.
#
# Usage:
#   addusefulshortcuts
#
# Example:
#   addusefulshortcuts
#
function addusefulshortcuts() {
    if [ "$1" = '-h' ]; then
        usage addusefulshortcuts
        return
    fi
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" /addusefulshortcuts:yes
}

# Description:
#   Remove selection of useful shortcuts from the desktop.
#
# Usage:
#   removeusefulshortcuts
#
# Example:
#   removeusefulshortcuts
#
function removeusefulshortcuts() {
    if [ "$1" = '-h' ]; then
        usage removeusefulshortcuts
        return
    fi
    cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" /removeusefulshortcuts:yes
}

# Description:
#	Add windbg shortcut to desktop.
#
# Usage:
#	addwindbgshortcut
#
# Example:
#	addwindbgshortcut
#
function addwindbgshortcut() {
    if [ "$1" = '-h' ]; then
        usage addwindbgshortcut
        return
    fi
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" \
				   "/create:yes" \
				   "/destdirspecial:Desktop" \
				   "/destdir2:""My Shortcuts""" \
				   "/linkname:windbgx86.lnk" \
				   "/description:""My link to windbg x86""" \
				   "/target:""C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\windbg.exe"""
}

# Description:
#	Remove windbg shortcut from desktop.
#
# Usage:
#	removewindbgshortcut
#
# Example:
#	removewindbgshortcut
#
function removewindbgshortcut() {
    if [ "$1" = '-h' ]; then
        usage removewindbgshortcut
        return
    fi
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" \
					"/delete:yes" \
					"/sourcedirspecial:Desktop" \
					"/sourcedir2:""My Shortcuts""" \
					"/filename:windbgx86.lnk"
}

# Description:
#	Add shortcut to Desktop.
#
# Usage:
#	addshortcut <shortcutfilename> <description> <targetpath>
#
# Example:
#	addshortcut "windbg.lnk" "My link to windbg x86" "C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\windbg.exe"
#
function addshortcut() {
    if [ "$1" = '-h' -o $# -ne 3 ]; then
        usage addshortcut
        return
    fi
	
	local _shortcutfilename="$1"	;# Example: "windbg.lnk"
	local _description="$2"			;# Example: "My link to windbg x86"
	local _target="$3"				;# Example: "C:\Program Files (x86)\Windows Kits\10\Debuggers\x86\windbg.exe"
	
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" \
				   "/create:yes" \
				   "/destdirspecial:Desktop" \
				   "/destdir2:""""" \
				   "/linkname:""$_shortcutfilename""" \
				   "/description:""$_description""" \
				   "/target:""$_target"""
}

# Description:
#	Remove shortcut from Desktop.
#
# Usgae:
#	removeshortcut <shotcutfilename>
#
# Example:
#	removeshortcut "windbg.lnk"
#
function removeshortcut() {
    if [ "$1" = '-h' -o $# -ne 1 ]; then
        usage removeshortcut
        return
    fi
	
	local _shortcutfilename="$1"
	
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" \
					"/delete:yes" \
					"/sourcedirspecial:Desktop" \
					"/sourcedir2:""""" \
					"/filename:""$_shortcutfilename"""
}

# Description:
#	Launch desktop shortcut.
#
# Usage:
#	launchdesktopshortcut <subdir> <linkname>
#
# Example:
#	launchdesktopshortcut "My Shortcuts" "CW_Tools.lnk"
#
function launchdesktopshortcut()
{
	if [ "$1" = '-h' -o $# -ne 2 ]; then
		usage launchdesktopshortcut
		return
	fi
	
	local _subdir="$1"
	local _linkname="$2"
	
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" \
					"/launch:yes" \
					"/sourcedirspecial:Desktop" \
					"/sourcedir2:""$_subdir""" \
					"/linkname:""$_linkname"""
}

# Description:
#	Launch CW Tools shortcut on desktop.
#
# Usage:
#	launchcwshortcut
#
function launchcwshortcut()
{
	launchdesktopshortcut \"\" "CW_Tools.lnk"
}

# Description:
#	Launch allusersdesktop shortcut.
#
# Usage:
#	launchallusersdesktopshortcut <subdir> <linkname>
#
# Example:
#	launchallusersdesktopshortcut "My Shortcuts" "CWTools.lnk"
#
function launchallusersdesktopshortcut()
{
	if [ "$1" = '-h' -o $# -ne 2 ]; then
		usage launchallusersdesktopshortcut
		return
	fi
	
	local _subdir="$1"
	local _linkname="$2"
	
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" \
					"/launch:yes" \
					"/sourcedirspecial:AllUsersDesktop" \
					"/sourcedir2:""$_subdir""" \
					"/linkname:""$_linkname"""
}

# Description:
#	Move shortcuts from the Desktop to a "Moved shortcuts" folder.
#
# Usage:
#	cwshortcutstidy
#
function cwshortcutstidy() {
	if [ "$1" = '-h' ]; then
		usage cwshortcutstidy
		return
	fi
	
	echo "Tidying Desktop shortcuts ...."
	
	# Note: We check for the shortcuts in both the "Desktop" and "AllUsersDesktop" special folders.
	# 		The "AllUsersDesktop" special folder usually corresponds to "C:\Users\Public\Desktop\".
	
	# MagicDisc.lnk
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop /filename:MagicDisc.lnk /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop /filename:MagicDisc.lnk /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# Notepad++.lnk
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop /filename:Notepad++.lnk /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop /filename:Notepad++.lnk /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# TreeSize Free.lnk
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop "/filename:""TreeSize Free.lnk""" /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop "/filename:""TreeSize Free.lnk""" /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# WinSCP.lnk
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop /filename:WinSCP.lnk /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop /filename:WinSCP.lnk /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# Wireshark.lnk
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop /filename:Wireshark.lnk /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop /filename:Wireshark.lnk /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# Lotus Notes 8.5.lnk
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop "/filename:""Lotus Notes 8.5.lnk""" /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop "/filename:""Lotus Notes 8.5.lnk""" /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# FileZilla Client.lnk
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop "/filename:""FileZilla Client.lnk""" /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop "/filename:""FileZilla Client.lnk""" /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# cwpostinstall.lnk
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop /filename:cwpostinstall.lnk /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop /filename:cwpostinstall.lnk /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# Adobe Reader X.lnk
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop "/filename:""Adobe Reader X.lnk""" /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop "/filename:""Adobe Reader X.lnk""" /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# 7-Zip File Manager.lnk
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop "/filename:""7-Zip File Manager.lnk""" /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop "/filename:""7-Zip File Manager.lnk""" /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# putty.exe
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop /filename:putty.exe /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop /filename:putty.exe /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	
	# Applications
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:AllUsersDesktop /filename:Applications.lnk /destdirspecial:AllUsersDesktop "/destdir2:""Moved shortcuts""" 2>/dev/null
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)"  /move:yes /sourcedirspecial:Desktop /filename:Applications.lnk /destdirspecial:Desktop "/destdir2:""Moved shortcuts""" 2>/dev/null
}
