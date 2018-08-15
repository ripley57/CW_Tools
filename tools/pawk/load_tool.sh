TOOLS_DIR=$*

# Description:
#   Use Perl like awk, to display specific columns from a
#   delimited file. Useful when you have Perl, but not awk.
#
# Usage:
#   pawk [-d] coln coln coln ... [ -s fieldseparator ] [ -f filename ]
#
#   The default field separator is ',' (comma).
#   The debug -d option displays the command that was run.
#
# Examples:
#   $ cat data1
#   aaa,bbb,ccc,ddd,eee,ffff
#   $ pawk 3 1 -f data1
#   ccc,aaa
#
#   $ pawk 3  -f data1
#   ccc
#
function pawk() {
    if [ "$1" = '-h' ]; then
        usage pawk
        return
    fi

    local _debug=
    local _fname=
    local _sep=','
    local _textdelim=

    local _requested_fields=
    local _highest_requested_field=0
    while [ $# -ne 0 ]
    do
        case "$1" in
        -d)          _debug="yes"                               ; shift ;;
        -f) shift ;  _fname="$1"                                ; shift ;;
        -s) shift ;  _sep="$1"                                  ; shift ;;
        -t) shift ;  _textdelim="$1"                            ; shift ;;
        [0-9]*)      _requested_fields="$_requested_fields $1"  ;
                     if [ $1 -gt $_highest_requested_field ]
                     then
                        _highest_requested_field=$1
                     fi                                         ; shift ;; 
        *)           echo "Unknown arg: $1"                     ; shift ;;
        esac
    done

    if [ x"$_fname" = x ]; then
        echo "Error: You have not specified an input file"
        return
    fi

    if [ x"$_requested_fields" = x ]; then
        echo "Error: You have not specified any field numbers"
    fi

    local _requested_field_count=$(echo $_requested_fields | wc -w)
    #echo "_requested_field_count=$_requested_field_count"

    # Build first part of sed expression.
    local _perl_expr_part1="perl -F'${_sep}' -lane 'printf(\""
    local _first_field=yes
    for _i in $_requested_fields
    do 
        if [ $_first_field = no ]; then
           _perl_expr_part1="${_perl_expr_part1},"
        fi
        _perl_expr_part1="${_perl_expr_part1}%s"
       _first_field=no
    done
    #echo "_perl_expr_part1=$_perl_expr_part1"

    # Build second part of Perl expression.
    local _perl_expr_part2='\n", '
    _first_field=yes
    for _i in $_requested_fields
    do
       local _idx=$((_i - 1))
       if [ $_first_field = no ]; then
           _perl_expr_part2="${_perl_expr_part2},"
       fi 
       _perl_expr_part2="${_perl_expr_part2}@F[$_idx]"
       _first_field=no
    done
    _perl_expr_part2="${_perl_expr_part2});'"
    #echo "_perl_expr_part2=$_perl_expr_part2"

    local _cmd="${_perl_expr_part1}${_perl_expr_part2} $_fname"
    [ "$_debug" = "yes" ] && echo "_cmd=$_cmd"

    # Run the Perl command.
    eval $_cmd
}
