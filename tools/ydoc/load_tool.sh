TOOLS_DIR=$*

# Description:
#   Generate a Javadocs "options" file to then generate CW javadocs.
#   Once the "options" file has been generated, you can then generate
#   the javadocs as follows:
#
#   javadocs @options
#
#   Note: This script must be run from a CW appliance, as it needs to
#         access the compliled Java class files.
#
# Usage:
#   genoptions <cwversion> <sourcepath> <outpath>
#
#   Where:
#      cwversion   -  CW version, e.g. 66, 711, 712
#      sourcepath  -  Path to the uncompiled Java source files. This usually
#                     is the directory containing the "com" directory.
#      outpath     -  Where the generated documentation will appear,
#                     including the top-level index.html file.
#   Example:
#      genoptions 66 /cygdrive/d/svn/v66_fixes/src /cygdrive/c/tmp/docsout
#
function genoptions() {
    if [ "$1" = '-h' ]; then
        usage genoptions
        return
    fi
    (cd "$TOOLS_DIR/ydoc" && ./genoptions.sh $@)
}
