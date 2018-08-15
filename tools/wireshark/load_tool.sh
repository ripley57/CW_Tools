TOOLS_DIR=$*

# Description:
#   tshark
#
# Examples:
#   tshark -D
#   tshark -f "tcp port 80" -i any 
#   tshark -f "tcp port 80" -i 2 -w cap.out
#   tshark -f "tcp port 80" -i 2 -R "http.request.method == GET"
#
function tshark() {
    if [ "$1" = '-h' ]; then
        usage tshark
        return
    fi

    # It is really tricky calling tshark.exe from here, i.e.
    # preserving the quoted capture filter (-f) and display
    # filter (-R) arguments, so let's not even bother trying
    # to wrap tshark.exe - especially since it is not even 
    # included in this tool set.
}
