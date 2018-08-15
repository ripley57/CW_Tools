TOOLS_DIR=$*

# Description:
#   Useful Cygwin commands.
#
# Usage:
#   cygwinhelp
#
function cygwinhelp() {
    if [ "$1" = '-h' ]; then
        usage cygwinhelp
        return
    fi
	cat <<EOI

o List installed packages and versions:
cygcheck -c

o Get Cygwin setup-x86.exe:
https://cygwin.com/setup-x86.exe

o Cygwin Setup-x86.exe command-line options:
https://www.cygwin.com/faq.html#faq.setup.cli

o How to determine which Cygwin package a file (e.g. banner.exe) is in:
https://cygwin.com/cgi-bin2/package-grep.cgi?grep=banner.exe&arch=x86_64

o Full list of Cygwin packages:
https://cygwin.com/packages/package_list.html

EOI
}
