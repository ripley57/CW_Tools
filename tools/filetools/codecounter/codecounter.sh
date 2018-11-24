# Description:
#	Script to determine the file and line counts for 
#	all the non-binary files in the current directory.
#
# JeremyC 24-11-2018

# 1. Get the line counts for each file.
# Note: We are ignoring binary files (this method ain't too quick however).
find . -type f -exec sh -c 'file "$1" | grep -q text && wc -l "$1"' _ {} \; > "$TMP/codecounter_files.log"

echo $PWD

# 2. Run the output from above through awk to display the total counts.
SCRIPTDIR=$(dirname "$0")
/usr/bin/gawk -f "${SCRIPTDIR}/codecounter.awk" "$TMP/codecounter_files.log"
