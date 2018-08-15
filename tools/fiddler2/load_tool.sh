TOOLS_DIR=$*

# Description:
#   Launch Fiddler2
#
#   IMPORTANT
#   =========
#   You will not see any traffic if you use http://localhost/
#   Instead, use the IP address, i.e. http://a.b.c.d/
#
#   See also:
#   Why don't I see traffic sent to http://localhost or http://127.0.0.1?:
#   http://www.fiddler2.com/fiddler/help/hookup.asp#Q-LocalTraffic
#
# Usage:
#   fiddler
#
function fiddler() {
    if [ "$1" = '-h' ]; then
        usage fiddler
        return
    fi
    if [ ! -f "$TOOLS_DIR/fiddler2/Fiddler.exe" ]; then
       (cd "$TOOLS_DIR/fiddler2" && unzip fiddler.zip)
    fi
    chmod ugo+rx $TOOLS_DIR/fiddler2/Fiddler.exe
    $TOOLS_DIR/fiddler2/Fiddler.exe
}
