TOOLS_DIR=$*

# Description:
#   Set the "QuickEdit" command window settings in the registry to 1.
#
# Comments:
#   This sets the following registry values to 1:
#		HKEY_CURRENT_USER\Console\01 - Command Prompt\QuickEdit
#		HKEY_CURRENT_USER\Console\02 - Command Prompt\QuickEdit
#		HKEY_CURRENT_USER\Console\%SystemRoot%_system32_cmd.exe\QuickEdit
#		HKEY_CURRENT_USER\Console\QuickEdit
#
#   Launching a command window by right-clicking on the Windows start
#	button and selecting one of these:
#   	"Command Prompt"
#		"Command Prompt (Admin)"
#	Changing the "QuickEdit" value (in any of the different registry
#	locations) appears to have no affect on the "QuickEdit" setting
#   (under the command window "Properties" menu). These two options
#	appear to be linked to shortcut files "01 - Command Prompt.lnk"
#   and "02 - Command Prompt.lnk". Rename these files are you will get 
#   a "file not found" error when trying launch a command window. 
#   It therefore looks like the only way to change "QuickEdit" is 
#	in the UI, i.e. it does look like you can change the value 
#   programatically for these two ways of launching a command window.
#
#   Launching a command window by typing "cmd":
#	This uses the "QuickEdit" value under the following reg value:
#	HKEY_CURRENT_USER\Console\%SystemRoot%_system32_cmd.exe\QuickEdit
#   
#	Launching a command window using Cygin shortcut (Windows Server 2008):
#	TBD
#
# Usage:
#   setquickedit
#
function setquickedit() {
    if [ "$1" = '-h' ]; then
        usage setquickedit
        return
    fi
	
	# NOTE: Notice the way we are escaping the '%' characters.
	echo "Setting \"HKEY_CURRENT_USER\Console\%SystemRoot%_system32_cmd.exe\QuickEdit\" to 1 ..."
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:setdword /root:hkcu /key:"Console\^%SystemRoot^%_system32_cmd.exe" /name:QuickEdit /value:1
	
	echo "Setting \"HKEY_CURRENT_USER\Console\QuickEdit\" to 1 ..."
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:setdword /root:hkcu /key:"Console" /name:QuickEdit /value:1
	
	echo "Setting \"HKEY_CURRENT_USER\Console\01 - Command Prompt\QuickEdit\" to 1 ..."
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:setdword /root:hkcu /key:"Console\01 - Command Prompt" /name:QuickEdit /value:1
	
	echo "Setting \"HKEY_CURRENT_USER\Console\02 - Command Prompt\QuickEdit\" to 1 ..."
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:setdword /root:hkcu /key:"Console\02 - Command Prompt" /name:QuickEdit /value:1
}

# Description:
#   Set "QuickEdit" command window settings in the registry to 0.
#
# Usage:
#   unsetquickedit
#
function unsetquickedit() {
    if [ "$1" = '-h' ]; then
        usage unsetquickedit
        return
    fi
	
	# NOTE: Notice the way we are escaping the '%' characters.
	echo "Setting \"HKEY_CURRENT_USER\Console\%SystemRoot%_system32_cmd.exe\QuickEdit\" to 0 ..."
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:setdword /root:hkcu /key:"Console\^%SystemRoot^%_system32_cmd.exe" /name:QuickEdit /value:0
	
	echo "Setting \"HKEY_CURRENT_USER\Console\QuickEdit\" to 0 ..."
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:setdword /root:hkcu /key:"Console" /name:QuickEdit /value:0
	
	echo "Setting \"HKEY_CURRENT_USER\Console\01 - Command Prompt\QuickEdit\" to 0 ..."
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:setdword /root:hkcu /key:"Console\01 - Command Prompt" /name:QuickEdit /value:0
	
	echo "Setting \"HKEY_CURRENT_USER\Console\02 - Command Prompt\QuickEdit\" to 0 ..."
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:setdword /root:hkcu /key:"Console\02 - Command Prompt" /name:QuickEdit /value:0
}

# Description:
#   Display the "QuickEdit" command window values currently set in the registry.
#
# Usage:
#   getquickedit
#
function getquickedit() {
    if [ "$1" = '-h' ]; then
        usage getquickedit
        return
    fi
	

	# NOTE: Notice the way we are escaping the '%' characters.
	echo "HKEY_CURRENT_USER\Console\%SystemRoot%_system32_cmd.exe\QuickEdit:"
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:getdword /root:hkcu /key:"Console\^%SystemRoot^%_system32_cmd.exe" /name:QuickEdit
	
	echo "HKEY_CURRENT_USER\Console\QuickEdit:"
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:getdword /root:hkcu /key:"Console" /name:QuickEdit
	
	echo "HKEY_CURRENT_USER\Console\01 - Command Prompt\QuickEdit:"
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:getdword /root:hkcu /key:"Console\01 - Command Prompt" /name:QuickEdit
	
	echo "HKEY_CURRENT_USER\Console\02 - Command Prompt\QuickEdit:"
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/registry/registry.vbs)" /operation:getdword /root:hkcu /key:"Console\02 - Command Prompt" /name:QuickEdit
}


# Description:
#   Set the "QuickEdit" console registry value to 1 (enabled).
#
# Usage:
#   quickedit
#
function quickedit() {
	if [ "$1" = '-h'  ]; then
		usage quickedit
		return
	fi
	cmd /c cscript /nologo "$(cygpath -aw "$TOOLS_DIR/registry/quickedit.vbs")"
}
