TOOLS_DIR=$*

# Description:
#   Extract all instances of the specified XML tag pair from an XML file.
#
# Usage:
#   xml_tag <tag> <file>
#
# Example:
#   Extract all <Message>...</Message> sections:
#     xml_tag Message recoverable_urn.xml
#
#   Note: You can also do the following:
#     cat recoverable_urn.xml | xml_tag Message
#
function xml_tag() {
    local _t=$1
    local _file=$2
    local _del_file=

    if [ -z "$1" -o "$1" = '-h' ]; then
        usage xml_tag
        return
    fi

    if [ -z "$_file" ]; then
        _del_file=1
        _file=$(_createstdinfile xml_tag)
    fi

    if [ -z "$_file" -o ! -f "$_file" ]; then 
        echo "No such file: $_file"
        return
    fi

    # The following sed command works as follows, using a <Messsage>...</Message> tag-pair
    # as an example:
    #
    # /'<Message/{h;d;}'    =>    Reset the hold buffer with just the next <Message> line.
    # '/<\/Message/!{H;d;}' =>    Append every line up to the </Message> line to the hold buffer.
    # '/<\/Message/{H;}'    =>    Append the </Message> line to the hold buffer.
    # "x;/./!d"             =>    Move the hold space buffer to the pattern space buffer and look
    #                             for any string. This will display the <Message>...</Message>.
    #  sed '$G'             =>    Ensure we have at least one line of results, for reading stdin.
    sed -e "/<$_t/{h;d;}" -e "/<\/$_t/!{H;d;}" -e "/<\/$_t/{H;}" -e "x;/./!d" $_file | sed '$G'

    [ ! -z $_del_file ] && rm -f $_file
}
 
# Description:
#   Extract all of the XML elements in the specified XML file that include
#   a specific text string somewhere between the opening and closing tags.
#
# Usage:
#   xml_tag_str <tag> <string> <file>
#
# Example:
#   Extract all the <Message>...</Message> sections that include '10024':
#     xml_tag_str Message 10024 recoverable_urn.xml
# 
#   Note: You can also do this:
#     cat recoverable_urn.xml | xml_tag_str Message 10024
#
function xml_tag_str() {
    local _t=$1
    local _s=$2
    local _file=$3
    local _del_file= 

    if [ $# -lt 2 -o "$1" = '-h' ]; then
        usage xml_tag_str
        return
    fi

    if [ -z "$_file" ]; then
        _del_file=1
        _file=$(_createstdinfile xml_tag_str)
    fi

    if [ -z "$_file" -o ! -f "$_file" ]; then 
        echo "No such file: $_file"
        return
    fi

    # The following sed command works as follows, using a <Messsage>...</Message> tag-pair
    # as an example:
    #
    # /'<Message/{h;d;}'    =>    Reset the hold buffer with just the next <Message> line.
    # '/<\/Message/!{H;d;}' =>    Append every line up to the </Message> line to the hold buffer.
    # '/<\/Message/{H;}'    =>    Append the </Message> line to the hold buffer.
    # "x;/$_s/!d"           =>    Move the hold space buffer to the pattern space buffer and look
    #                             for the search string. If we find it, display the complete
    #                             <Message>...</Message>.
    #  sed '$G'             =>    Ensure we have at least one line of results, for reading stdin.
    sed -e "/<$_t/{h;d;}" -e "/<\/$_t/!{H;d;}" -e "/<\/$_t/{H;}" -e "x;/$_s/!d" $_file | sed '$G'

    [ ! -z $_del_file ] && rm -f $_file
}

# Description:
#   Extract all of the XML elements in the specified XML file that do NOT
#   include a specific string somewhere between the opening and closing
#   tag pair.
#
# Usage:
#   xml_tag_str_not <string> <tag> <file>
#
# Example:
#   Extract all the <Message>...</Message> elements that do NOT include
#   the string '10024':
#     xml_tag_str_not Message 10024 recoverable_urn.xml 
#
#   Note: You can also do the following:
#     cat recoverable_urn.xml | xml_tag_str_not Message 10024
#
function xml_tag_str_not() {
    local _t=$1
    local _s=$2
    local _file=$3
    local _del_file=
    
    if [ $# -lt 2 -o "$1" = '-h' ]; then
        usage xml_tag_str_not 
        return
    fi
    
    if [ -z "$_file" ]; then
        _del_file=1
        _file=$(_createstdinfile xml_tag_str_not)
    fi

    if [ -z "$_file" -o ! -f "$_file" ]; then 
        echo "No such file: $_file"
        return
    fi

    # The following sed command works as follows, using a <Messsage>...</Message> tag-pair
    # as an example:
    #
    # /'<Message/{h;d;}'    =>    Reset the hold buffer with just the next <Message> line.
    # '/<\/Message/!{H;d;}' =>    Append every line up to the </Message> line to the hold buffer.
    # '/<\/Message/{H;}'    =>    Append the </Message> line to the hold buffer.
    # "x;/$_s/d"            =>    Move the hold space buffer to the pattern space buffer and look
    #                             for the search string. If we find it, do NOT display the complete
    #                             <Message>...</Message>.
    #  sed '$G'             =>    Ensure we have at least one line of results, for reading stdin.
    sed -e "/<$_t/{h;d;}" -e "/<\/$_t/!{H;d;}" -e "/<\/$_t/{H;}" -e "x;/$_s/d" $_file | sed '$G'

    [ ! -z $_del_file ] && rm -f $_file
}

# Description:
#   Extract all instances of a specific XML attribute from the specified
#   XML file.
#
# Usage:
#   xml_attrib <attribute> <file>
#
# Example:
#   Extract all DOCID="..." values:
#     xml_attrib DOCID recoverable_urn.xml
#
#  Note: You can also do this:
#     cat recoverable_urn.xml | xml_attrib DOCID
#   
function xml_attrib() {
    local _a=$1 
    local _file=$2
    local _del_file=

    if [ $# -lt 1 -o "$1" = '-h' ]; then
        usage xml_attrib 
        return
    fi

    if [ -z "$_file" ]; then
        _del_file=1
        _file=$(_createstdinfile xml_attrib)
    fi

    if [ -z "$_file" -o ! -f "$_file" ]; then 
        echo "No such file: $_file"
        return
    fi

    # sed '$G' => Ensure we have at least one line of results, for reading stdin.
    sed -n "s#.*$_a=\"\([^\"]*\)\".*#\1#Ip" $_file | sed '$G'
    
    [ ! -z $_del_file ] && rm -f $_file
}

# Description:
#   Extract all instances of a specific XML attribute from the specified
#   XML file. Extract the value part from the attrib_name=attrib_value
#   string and then display a comma-delimited list of all these values.
#
# Usage:
#   xml_attrib_delim <attribute> <file>
#
# Example:
#   Generate a comma-delimited list of all DOCID attribute values:
#     xml_attrib_delim DOCID recoverable_urn.xml
#
#  Note: You can also do this:
#     cat recoverable_urn.xml | xml_attrib_delim DOCID
# 
function xml_attrib_delim() {
    local _a=$1 
    local _file=$2
    local _del_file=

    if [ $# -lt 1 -o "$1" = '-h' ]; then
        usage xml_attrib_delim 
        return
    fi

    if [ -z "$_file" ]; then
        _del_file=1
        _file=$(_createstdinfile xml_attrib_delim)
    fi

    if [ -z "$_file" -o ! -f "$_file" ]; then 
        echo "No such file: $_file"
        return
    fi

    # sed '$G' => Ensure we have at least one line of results, for reading stdin.
    cat $_file | sed -n "s#.*$_a=\"\([^\"]*\)\".*#\1#Ip" | tr '\n' ',' | sed 's#.$##' | sed '$G'
 
    [ ! -z $_del_file ] && rm -f $_file
}
