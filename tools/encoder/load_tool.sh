TOOLS_DIR=$*

# Description:
#   File encoder with optional BOM added.
#   This tool is intended to replace the AddBOM tool.
#
# Usage:
#   encoder -h
#
function encoder() {
    if [ "$(uname)" = "Linux" ]; then
       _jarpath=$TOOLS_DIR/encoder/encoder.jar
    else
       _jarpath=$(cygpath -w "$TOOLS_DIR/encoder/encoder.jar")
    fi

    if [ "$1" = '-h' ]; then
        (java -jar "$_jarpath" -h)
        return
    fi
	
    (java -jar "$_jarpath" $*)
}
