TOOLS_DIR=$*

# Description:
#   Launch Windows Explorer in the specified directories.
#   If no directories are specified, assume the current 
#   directory.
#  
# Usage:
#   e dir1 dir2 dir3 ...
#   
# Examples:
#   e /cygdrive/c/tmp /cygdrive/c/tmp/work
#   e 
#
function e() {
    if [ "$1" = '-h' ]; then
        usage e
        return
    fi

    if [ x"$1" = x ]; then
        # Use current directory to create $@ array.
        set -- "$(pwd)"
    fi

    local _rtn=0
    local _d=
    for _d in "$@"
    do
        if [ ! -d "$_d" ]; then
            echo "Directory \"$_d\" does not exist, so skipping."
            _rtn=1
        else
	    if isLinux ; then
                xdg-open "$_d"
	    else
                explorer "$(cygpath -aw "$_d")"
	    fi
        fi
    done
    return $_rtn
}

function tmp() {
    cd /cygdrive/c/tmp
}

function work() {
    cd /cygdrive/c/tmp/work 2>/dev/null || cd ${HOME}/work 2>/dev/null
}

function testdata() {
    cd /cygdrive/c/tmp/Test_Data 2>/dev/null || cd ${HOME}/Test_Data 2>/dev/null
}

function etmp() {
    e /cygdrive/c/tmp
}

function ework() {
    e /cygdrive/c/tmp/work || e ${HOME}/work
}

function etestdata() {
    e /cygdrive/c/tmp/Test_Data || e ${HOME}/Test_Data
}

function edirs() {
    etmp
    ework
    etestdata
}
