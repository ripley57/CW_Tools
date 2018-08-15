TOOLS_DIR=$*

# Return passed files or get them from clipboard.
function _getfiles() {
    local _files=$*

    local _rtn_files=
    if [ ! -z "$_files" ]; then
        local _f;
        for _f in "$@"
        do
            _rtn_files="$_rtn_files $_f"
        done
    else
        local _clip=$(getclip)
        if [ x"$_clip" != x ]; then
            getclip > "$TMP/n.$$"
            echo   >> "$TMP/n.$$"
            local _f;
            while read _f; do
                _rtn_files="$_rtn_files $_f"
            done < "$TMP/n.$$"
            rm -f "$TMP/n.$$"
        fi
    fi
    echo $_rtn_files
}

# Download source file from http server.
function _g_get_file() {
    local _file_path="${ENV_SRC_HOSTNAME}/src/${1}/${2}"

    if [ x"$ENV_SRC_HOSTNAME" = x ]; then
        echo "You must define ENV_SRC_HOSTNAME !"
	return
    fi

    echo >&2
    echo "Download file $_file_path ..." >&2
    echo >&2
    wget -qO- "$_file_path"
} 

# Launch web browser at source file from http server.
function _gb_get_file() {
    local _file_path="${ENV_SRC_HOSTNAME}/src/${1}/${2}"

    if [ x"$ENV_SRC_HOSTNAME" = x ]; then
        echo "You must define ENV_SRC_HOSTNAME !"
	return
    fi

    local _browser=$(_get_web_browser)
    ${_browser} "$_file_path"
}

# Correct path so that we can use HTTP to get the java file.
function _g_correct_path() {
    local _f="$1"

    # Save file extension.
    local _extn=$(echo "$_f" | sed -n 's/.*\(\..*\)$/\1/p')

    # If extension was "class", then switch it to "java".
    [ "$_extn" = '.class' ] && _extn='.java'

    # Strip file extension.
    local _strip_extn="${_f%.*}"
    _f="$_strip_extn"

    # Convert x.y.z to x/y/z
    _f=$(echo $_f | sed 's#\.#/#g')

    # Construct base path.
    _f="/$_f"  ; # Add leading / in case there is none.
    case "$_f" in
    */com/*)
             local _strip_beg="${_f##*/com/}"
             _f="src/com/${_strip_beg}"
             ;;
    */app/*)
             local _strip_beg="${_f##*/app/}"
             _f="web/app/${_strip_beg}"
             ;;
    esac

    echo "${_f}${_extn}"
}

# Determine branch we need to use.
function _g_determine_branch() {
    local _str="$1"

    if [ -z "$_str" ]; then
        _str=$(cwdir)
    fi

    case "$_str" in
    *V66*)  _branch='V66_fixes'	 	;;
    *V711*) _branch='V711_Fixes'	;;
    *V712*) _branch='V712_Fixes'	;;
    *)      _branch='V712_Fixes'	;;
    esac

    #echo _branch=$_branch"
    echo $_branch
}

# Description:
#   Fetch 66 source file.
#
# Usage:
#   g66 filepath
#
# Example:
#   g66 com/teneo/esa/common/bitmap/BitMapBitType.java
#
function g66() {
    if [ "$1" = '-h' ]; then
        usage g66
        return
    fi
    local _branch=$(_g_determine_branch V66)
    local _f=$(_g_correct_path "$1")
    _g_get_file "$_branch" "$_f"
}

# Description:
#   Launch 66 source file in web browser.
#
# Usage:
#   gb66 filepath
#
# Example:
#   gb66 com/teneo/esa/common/bitmap/BitMapBitType.java
#
function gb66() {
    if [ "$1" = '-h' ]; then
        usage gb66
        return
    fi
    local _branch=$(_g_determine_branch V66)
    local _f=$(_g_correct_path "$1")
    _gb_get_file "$_branch" "$_f"
}

# Description:
#   Fetch 711 source file.
#
# Usage:
#   g711 filepath
#
# Example:
#   g711 com/teneo/esa/common/bitmap/BitMapBitType.java
#
function g711() {
    if [ "$1" = '-h' ]; then
        usage g711
        return
    fi
    local _branch=$(_g_determine_branch V711)
    local _f=$(_g_correct_path "$1")
    _g_get_file "$_branch" "$_f"
}

# Description:
#   Load 711 source file into web browser.
#
# Usage:
#   gb711 filepath
#
# Example:
#   gb711 com/teneo/esa/common/bitmap/BitMapBitType.java
#
function gb711() {
    if [ "$1" = '-h' ]; then
        usage gb711
        return
    fi
    local _branch=$(_g_determine_branch V711)
    local _f=$(_g_correct_path "$1")
    _gb_get_file "$_branch" "$_f"
}

# Description:
#   Fetch 712 source file.
#
# Usage:
#   g712 filepath
#
# Example:
#   g712 com/teneo/esa/common/bitmap/BitMapBitType.java
#
function g712() {
    if [ "$1" = '-h' ]; then
        usage g712
        return
    fi
    local _branch=$(_g_determine_branch V712)
    local _f=$(_g_correct_path "$1")
    _g_get_file "$_branch" "$_f"
}

# Description:
#   Load 712 source file into web browser.
#
# Usage:
#   gb712 filepath
#
# Example:
#   gb712 com/teneo/esa/common/bitmap/BitMapBitType.java
#
function gb712() {
    if [ "$1" = '-h' ]; then
        usage gb712
        return
    fi
    local _branch=$(_g_determine_branch V712)
    local _f=$(_g_correct_path "$1")
    _gb_get_file "$_branch" "$_f"
}

# Description:
#   Fetch specified file from SVN HTTP server.
#
# Usage:
#   g filepath
#
# Examples:
#   g com/teneo/esa/common/bitmap/BitMapBitType.class
#   g com.teneo.esa.common.bitmap.BitMapBitType.java
#   g /cygdrive/d/cw/v712/com/teneo/esa/common/bitmap/BitMapBitType.class
#
function g() {
    if [ "$1" = '-h' ]; then
        usage g
        return
    fi

    local _branch=$(_g_determine_branch "")

    local _f
    local _files=$(_getfiles $@)
    for _f in $_files
    do
        _f=$(_g_correct_path "$_f")
        _g_get_file "$_branch" "$_f"
    done
}

# Description:
#   Launch file from SVN HTTP server into web browser.
#
# Usage:
#   gb filepath
#
# Examples:
#   gb com/teneo/esa/common/bitmap/BitMapBitType.class
#   gb com.teneo.esa.common.bitmap.BitMapBitType.java
#   gb /cygdrive/d/cw/v712/com/teneo/esa/common/bitmap/BitMapBitType.class
#
function gb() {
    if [ "$1" = '-h' ]; then
        usage gb
        return
    fi

    local _branch=$(_g_determine_branch "")

    local _f
    local _files=$(_getfiles $@)
    for _f in $_files
    do
        _f=$(_g_correct_path "$_f")
        _gb_get_file "$_branch" "$_f"
    done
}
