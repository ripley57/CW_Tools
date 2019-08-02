TOOLS_DIR=$*

# Description:
#   Load markdown help page.
#
# Usage:
#   markdown
#
function markdown() {
    if [ "$1" = '-h' ]; then
        usage markdown
        return
    fi
    local _browser=$(_get_web_browser)
    "$_browser" "https://www.markdownguide.org/basic-syntax/" &
}


# help-func githelp ^git$|^clone$|^annotate$
#
# Description:
#   Useful git commands and links.
#
# Usage:
#   githelp
#
function githelp() {
    if [ "$1" = '-h' ]; then
        usage githelp
        return
    fi

    cat "$TOOLS_DIR/git/GIT_CHEATSHEET.md"
}
