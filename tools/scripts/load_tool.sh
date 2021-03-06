TOOLS_DIR=$*

# Description:
#   Launch cmd.exe suitable for building VC++ 2010 programns on the command-line.
#
# Usage:
#   vc++
#
function vc++()
{
    if [ "$1" = '-h' ]; then
        usage vc++
        return
    fi
	cmd /c start cmd /k "C:\Program^ Files^ ^(x86^)\Microsoft^ Visual^ Studio^ 10.0\VC\vcvarsall.bat" x86
}


# Description:
#   Cd to user CW_Tools directory.
#
# Usage:
#   cwtools
#
function cwtools() {
    if [ "$1" = '-h' ]; then
        usage cwtools
        return
    fi

    local _dir="$(_cwtoolsdir)"
    echo "cd $_dir ..."
    cd "$_dir"
}

# Description:
#   Cd to user Windows home directory.
#
function windir() {
    if [ "$1" = '-h' ]; then
        usage windir
        return
    fi
    
    local _dir="$(_windir)"
    echo "cd $_dir ..."
    cd "$_dir"
}


# Description:
#   Install useful Windows batch scripts.
#
# Usage:
#   installwindowsscripts
#
function installwindowsscripts() {
    if [ "$1" = '-h' ]; then
        usage installwindowsscripts
        return
    fi

    local _dir="$(_windir)"

    # Script to Cd to CW_Tools directory.
    cp "${TOOLS_DIR}/scripts/windows/cwtools.bat" "${_dir}/cwtools.bat"

}
