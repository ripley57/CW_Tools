TOOLS_DIR=$*

# Description:
#   Tool to print and remove 4-byte utf8 characters from a file.
#
#   The purpose of this tool is to avoid the MySQL exception...
#
#   "Incorrect string value: '\xF2\xAD...'
#
#   ...when inserting text into a table defined by MySQL as 
#   having the "utf8" charset. 
#
#   MySQL's utf8 charset does not handle 4-byte characters. 
#   See here for more info: 
#   https://dev.mysql.com/doc/refman/5.5/en/charset-unicode.html
#
# Usage:
#   utf8tool -h
#
function utf8tool() {
    if [ "$(uname)" = "Linux" ]; then
       _jarpath="$TOOLS_DIR/utf8tool/utf8tool.jar"
    else
       _jarpath=$(cygpath -w "$TOOLS_DIR/utf8tool/utf8tool.jar")
    fi
    if [ "$1" = '-h' ]; then
        (java -jar "$_jarpath" -h)
    else
        (java -jar "$_jarpath" $*)
    fi
}
