# Description:
#
#    Installed Fixes and Hotfixes (ESAs) leave a jar file
#    behind in the directory /cygdrive/d/cw/v??/patches/.
#    This jar file includes a copy of the source files that 
#    were updated. The jar file also includes a patch.properties 
#    file, and this file includes a line indicating the build
#    date of the Fix or Hotfix. This script cd's to the "patches"
#    directory, extracts the patch.properties file for each
#    installed Fix and Hotfix into a temporary directory,
#    and then displays the order in which the Fix and Hotfixes
#    should be installed based on their build dates, i.e. they
#    should be installed in their build date order.
#
# Example usage and output:
#
#    $ sh patch_build_order.sh 66
#      Patch Name     Build Date
#      ----------     ----------
#        V66_Fix2  :  Mon Dec 12 18:30:08 PST 2011
#       ESA-23034  :  Wed Dec 21 16:44:08 PST 2011
#       ESA-23159  :  Thu Jan 05 12:03:27 PST 2012
#       ESA-23313  :  Wed Jan 11 00:37:59 PST 2012
#       ESA-23277  :  Wed Jan 11 19:55:46 PST 2012
#
# JeremyC 27/04/2012

PROGNAME=`basename $0`

usage()
{
    cat <<EOI

This script will examine the Fixes and Hotfixes (ESAs) installed
on the appliance and list the order that they should be installed
based on the build date in each patch's patch.properties file.

Example usage:
    sh $PROGNAME 66

EOI
}

[ $# -ne 1 ] && { usage; exit 1; }
CW_DIR="/cygdrive/d/cw/v$1/patches"

DEBUG=0
log() 
{
   [ $DEBUG -eq 1 ] && eval "$*"
}
error()
{
    eval "$*"
    cleanup
    exit 99
}
# Testing
#val="hello world"
#log printf \"test=%s\\n\" \"$val\"

cd $CW_DIR 2>/dev/null || error echo "Bad directory: $CW_DIR"

# Create temporary working directory.
TMP_DIR="$TMP/$PROGNAME.$$"
mkdir -p "$TMP_DIR"

cleanup()
{
    rm -fr "$TMP_DIR"
}

# Extract fields from the patch's patch.properties file.
parse_prop_file()
{
    _jar_full_path="$1"
    if [ ! -e "$_jar_full_path" ]
    then 
       error printf \"No such jar file: %s\\n\" \"$_jar_full_path\"
    fi

    _prop_file="scratch/patch/patch.properties"
    _prop_file_full_path="$(cygpath -aw "$TMP_DIR/$_prop_file")"
    rm -f "$_prop_file_full_path"  
    (cd "$TMP_DIR" && jar xf "$_jar_full_path" "$_prop_file")
    if [ ! -e "$_prop_file_full_path" ]
    then 
       error printf \"No such property file: %s\\n\" \"$_prop_file_full_path\"
    fi
    
    PROP_BUILD_DATE=`head -2 "$_prop_file_full_path" | tail -1 | sed 's/^#//'`
    [ x"$PROP_BUILD_DATE" = x ] && error echo "Error: could not parse build date"   
    log printf \"PROP_BUILD_DATE=%s\\n\" \"$PROP_BUILD_DATE\"

    PROP_BUILD_DATE_EPOCH=`date +%s -d"$PROP_BUILD_DATE"`
    [ x"$PROP_BUILD_DATE_EPOCH" = x ] && error echo "Error: could not determine build date epoch"   
    log printf \"PROP_BUILD_DATE_EPOCH=%s\\n\" \"$PROP_BUILD_DATE_EPOCH\"

    PROP_PATCH_NAME=`grep '^patchName=' $_prop_file_full_path | sed 's#^patchName=\(.*\)#\1#'`
    [ x"$PROP_PATCH_NAME" = x ] && error echo "Error: could not parse patchname" 
    log printf \"PROP_PATCH_NAME=%s\\n\" \"$PROP_PATCH_NAME\" 
}

cat <<EOI

    Below are the build dates of Fix and Hotfixes installed on this appliance,
    listed in the order that they should be installed (oldest at the top):

EOI
printed_header=0
for jar_file in `find . -name "ESA-*.jar" -o -name "V*_Fix*.jar"`
do
    if [ $printed_header -eq 0 ]
    then
        printf "%s %15s     %s\n" "1111111111" "Patch Name" "Build Date" 
        printf "%s %15s     %s\n" "1111111112" "----------" "----------" 
        printed_header=1
    fi  

    jar_full_path="$(cygpath -aw "$jar_file")"
    parse_prop_file "$jar_full_path" 

    # Note how we print the build date as an epoch numerical value at the start
    # of each output line. This enables us to easily sort the output by build date.
    # We later strip off the epoch build date from the final display, since we don't
    # need it any more.
    printf "%s %15s  :  %s\n" "$PROP_BUILD_DATE_EPOCH" "$PROP_PATCH_NAME" "$PROP_BUILD_DATE"  

done | sort -k2nr | sed 's#^[0-9]\{10\}##' 

cleanup

cat <<EOI


    Below is the apparent Fix and Hotfix installation order on this appliance
    (oldest at the top). This order is based on the modification time of the 
    Fix and Hotfix directories in the $CW_DIR directory.
    (Note: This method isn't reliable if someone has been messing inside these 
    directories post-install):

EOI
echo "      Install Date    Patch"
echo "      ------------    -----"
(cd $CW_DIR && ls -ltr | egrep '(ESA-|_Fix)' | sed 's#\(.*\) \(.*\) \(.*\) \(.*\) \(.*\) \(.*\) \(.*\) \(.*\) \(.*\)#      \6 \7 \8    \9#')

# END
