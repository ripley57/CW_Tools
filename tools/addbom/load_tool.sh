TOOLS_DIR=$*

# Description:
#   Add a byte order mark (BOM) to an input file. 
#   Can also convert the file to a specified encoding.
#
# Usage:
#   addbom
#
function addbom() {
    if [ "$(uname)" = "Linux" ]; then
       _jarpath=$TOOLS_DIR/addbom/addbom.jar
    else
       _jarpath=$(cygpath -w "$TOOLS_DIR/addbom/addbom.jar")
    fi

    if [ "$1" = '-h' ]; then
        (java -jar "$_jarpath" -h)
        return
    fi
	
    (java -jar "$_jarpath" $*)
}
