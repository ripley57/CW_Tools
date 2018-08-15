TOOLS_DIR=$*

# Return path to CW_Tools directory for Windows user.
function _cwtoolsdir()
{
    local _homedir="$(_windir)"
    local _toolsdir="${_homedir}/Cygwin/home/${USERNAME}/CW_Tools/"
    echo "${_toolsdir}"
}

# Return Windows user home directory.
function _windir()
{
    local _homedrive=$(echo "$HOMEDRIVE" | sed 's/://')
    local _homepath=$(echo "$HOMEPATH" | sed 's#\\#/#g')
    local _homedir="/cygdrive/${_homedrive}/${_homepath}"
    echo "${_homedir}"
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


# Description:
#	Copy the build.bat script to the current directory.
#
# Usage:
#	build
#
function build() {
    if [ "$1" = '-h' ]; then
        usage build
        return
    fi
	
    if [ ! -e "./buildbat" ]; then
       cp "${TOOLS_DIR}/java/build.bat" . && echo "Copied build.bat to current directory."
	   cp "${TOOLS_DIR}/scripts/Java/run.bat" .
    fi
}
