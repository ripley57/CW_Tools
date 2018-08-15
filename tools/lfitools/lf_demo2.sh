# This script generates demo LFI email data with attachments. 
# 
# Run this script from Cygwin.
#
# Usage:
#   . lf_demo2.sh <startbatesnum> <endbatesnum> <samplesfilesdir> <outputdir>
#
# Example usage to generate a load file import consisting of 5 email records, 
# each with two attachments.
#   . lf_demo2.sh 1 5 test_files output

if [ $# -ne 4 ]; then
cat <<EOI

    lf_demo2.sh

    Description:
      Generate test data for LFI.

    Usage:
      . lf_demo2.sh <startbatesnum> <endbatesnum> <samplefilesdir> <outputdir>

    Example:
      . lf_demo2.sh 1 5 test_files output

EOI
    return 2>/dev/null || exit 99
fi

_BEGNUM=$1
_ENDNUM=$2
_SAMPLESDIR=$(cd $3 && pwd)
_OUTDIR=$4

mkdir -p $_OUTDIR || (echo "ERROR: Could not create directory $_OUTDIR" && return 1)

_SAVEDPWD=$PWD
cd $_OUTDIR

cat >loadfile.dat <<EOI
"DOCID","PARENTID","DOCTYPE","SENTDATE","LAST_MODIFIED","FROM","TO","SUBJECT","FILENAME_EXT","NATIVE_PATH","TEXT_PATH"
EOI

# Generate load file.
lfgen $_BEGNUM $_ENDNUM \"%08lu\",\"%08lu\",\"Message\",\"2008-12-15T13:54:13.313-0500\",\"\",\"fred@fred.com\",\"bert@bert.com\",\"Test_email_%08lu\",\"\",\"native\\%08lu.msg\",\"text\\%08lu.txt\" \"%08lu\",\"%08lu\",\"File\",\"\",\"2008-12-15T13:54:13.313-0500\",\"\",\"\",\"\",\"attachment1.docx\",\"native\\attachment_%08lu.docx\",\"\" \"%08lu\",\"%08lu\",\"File\",\"\",\"2008-12-15T13:54:13.313-0500\",\"\",\"\",\"\",\"attachment2.docx\",\"native\\attachment_%08lu.docx\",\"\" >> loadfile.dat

# Generate text and native files.
mkdir -p text native
lfcopy $(cygpath -w "$_SAMPLESDIR/test_file_text.txt") $_BEGNUM $_ENDNUM text/%08lu.txt
lfcopy $(cygpath -w "$_SAMPLESDIR/test_file_msg.msg")  $_BEGNUM $_ENDNUM native/%08lu.msg
let _ENDNUM+=1
lfcopy $(cygpath -w "$_SAMPLESDIR/test_file_attachment.docx") $_BEGNUM $_ENDNUM native/attachment_%08lu.docx

cd $_SAVEDPWD

echo
echo "Finished!"
echo
echo "NOTE: If you have any discovery or processing issues, it could be due to permissions."
echo "      You may therefore need to reset all the file permissions using Windows Explorer."
echo
