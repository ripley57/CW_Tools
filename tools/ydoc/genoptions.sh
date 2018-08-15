#!/bin/sh
#
# Description:
#    Generate a Javadocs "@options" file to generate CW javadocs.
#
#    Once this file has been generated, you can then generate the
#    javadocs as follows from a Windows DOS prompt:
#
#        javadocs @options    
#
#    Note: This generation of javadocs requires both the compiled
#          (and unobfuscated) class files, and also the uncompiled 
#          java source files. See the "usage()" function below.
#
# For more info on yDoc: 
#    yWorks UML Doclet (formerly known as yDoc):	
#    http://www.yworks.com/en/products_ydoc.html	
#
#    yWorks UML Doclet 3.0_02 User's Guide:
#    http://www.yworks.com/products/yDoc/doc/usersguide.html

PROGNAME=`basename $0`

usage()
{
    cat <<EOI

Usage:
    $PROGNAME <cwversion> <sourcepath> <outpath>
	
    Where:
       cwversion   -  CW version, e.g. 66, 711, 712.                
       sourcepath  -  Path to the uncompiled Java source files. This usually
                      is the directory containing the "com" directory.
       outpath     -  Where the generated documentation will appear,
                      including the top-level index.html file.

    Example:
       $PROGNAME 66 /cygdrive/d/svn/v66_fixes/src /cygdrive/c/tmp/docs

EOI
}

[ $# -ne 3 ] && { usage; exit 1; }

DEBUG=0
log() 
{
   [ $DEBUG -eq 1 ] && eval "$*"
}
error()
{
    echo "$*"
    exit 99
}

CW_DIR="/cygdrive/d/cw/v$1"
[ -d "$CW_DIR" ] || error echo "No such CW directory: $CW_DIR"
log printf \"CW_DIR=%s\\n\" \"$CW_DIR\"

SOURCEPATH="$2"
[ -d "$SOURCEPATH" ] || error echo "No such sourcepath: $SOURCEPATH"
log printf \"SOURCEPATH=%s\\n\" \"$SOURCEPATH\"
SOURCEPATH=$(cygpath -w "$SOURCEPATH")

OUTPATH="$3"
OUTPATHPARENTDIR=${OUTPATH%/*}
[ -d "$OUTPATHPARENTDIR" ] || error echo "No such output directory: $OUTPATHPARENTDIR"
log printf \"OUTPATHPARENTDIR=%s\\n\" \"$OUTPATHPARENTDIR\"
OUTPATH=$(cygpath -w "$OUTPATH")

#
# Generate Javadocs "options" script.
#

CW_LIB_DIR=$(cygpath -w "$CW_DIR\web\app\WEB-INF\lib")
CW_CLASSES_DIR=$(cygpath -w "$CW_DIR\web\app\WEB-INF\classes")
CW_TOMCAT_DIR=$(cygpath -w "$CW_DIR\tomcat")
CW_3RDPARTY_DIR=$(cygpath -w "$CW_DIR\3rdparty")

function addjars() {
cat >>options <<EOI_ADDJARS
$CW_CLASSES_DIR;\
$CW_LIB_DIR\log4j.jar;\
$CW_LIB_DIR\hibernate3.jar;\
$CW_LIB_DIR\xstream.jar;\
$CW_LIB_DIR\lucene-core-2.4-esa.jar;\
$CW_LIB_DIR\lucene-analyzers-2.4.0.jar;\
$CW_LIB_DIR\lucene-wordnet-2.4-esa.jar;\
$CW_LIB_DIR\junit-3.8.1.jar;\
$CW_LIB_DIR\icu4j-4_0.jar;\
$CW_LIB_DIR\poi-scratchpad-3.5-beta5-20090219.jar;\
$CW_LIB_DIR\poi-contrib-3.5-beta5-20090219.jar;\
$CW_LIB_DIR\poi-3.5-beta5-20090219.jar;\
$CW_LIB_DIR\mysql-connector-java-5.0.6-bin.jar;\
$CW_LIB_DIR\commons-collections.jar;\
$CW_LIB_DIR\jcifs.jar;\
$CW_LIB_DIR\jakarta-regexp-1.5.jar;\
$CW_LIB_DIR\wstx-asl-3.2.9.jar;\
$CW_LIB_DIR\lucene-spellchecker-2.4-esa.jar;\
$CW_LIB_DIR\guava-r09.jar;\
$CW_LIB_DIR\mail.jar;\
$CW_LIB_DIR\annotations.jar;\
$CW_LIB_DIR\bsf.jar;\
$CW_LIB_DIR\commons-io-1.1.jar;\
$CW_LIB_DIR\es_core.jar;\
$CW_LIB_DIR\es_sharepoint2003.jar;\
$CW_LIB_DIR\es_sharepoint2007.jar;\
$CW_LIB_DIR\commons-httpclient-3.1.jar;\
$CW_LIB_DIR\CleanContent.jar;\
$CW_LIB_DIR\c3p0-0.9.1.2.jar;\
$CW_LIB_DIR\Tidy.jar;\
$CW_LIB_DIR\PDFBox-0.7.0.jar;\
$CW_LIB_DIR\Notes.jar;\
$CW_LIB_DIR\btrlp.jar;\
$CW_LIB_DIR\btutil.jar;\
$CW_LIB_DIR\itext-1.3.1.jar;\
$CW_LIB_DIR\jasperreports-3.0.0.jar;\
$CW_LIB_DIR\es_documentum.jar;\
$CW_LIB_DIR\geronimo-servlet_2.5_spec-1.2.jar;\
$CW_LIB_DIR\cxf-2.2.10.jar;\
$CW_LIB_DIR\commons-logging.jar;\
$CW_LIB_DIR\jakarta-oro.jar;\
$CW_LIB_DIR\commons-net-2.2.jar;\
$CW_LIB_DIR\jline-0.9.94.jar;\
$CW_LIB_DIR\ehcache.jar;\
$CW_LIB_DIR\json.jar;\
$CW_LIB_DIR\flexjson-1.7-cw.jar;\
$CW_LIB_DIR\jdom.jar;\
$CW_LIB_DIR\commons-fileupload-1.2.1.jar;\
$CW_LIB_DIR\struts.jar;\
$CW_LIB_DIR\jfreechart-0.9.21.jar;\
$CW_LIB_DIR\jcommon-0.9.6.jar;\
$CW_LIB_DIR\daisydiff.jar;\
$CW_LIB_DIR\Struts-Layout.jar;\
$CW_LIB_DIR\jsr311-api-1.0.jar;\
$CW_LIB_DIR\jsr305.jar;\
$CW_LIB_DIR\jackson-all-1.7.4.jar;\
$CW_TOMCAT_DIR\server\lib\catalina.jar;\
$CW_TOMCAT_DIR\common\lib\jsp-api.jar;\
$CW_TOMCAT_DIR\server\lib\catalina-optional.jar;\
$CW_3RDPARTY_DIR\apps\ant\lib\ant.jar;\
$CW_3RDPARTY_DIR\apps\ant\lib\ant-junit.jar;\
lib\jtestcase-3.0.0.jar;\
lib\jtestcase_4.0.0.jar;\
lib\mockito-all-1.9.5.jar
EOI_ADDJARS
}

# Backup old output file, if one exists.
[ -e options ] && mv options options.old

cat >options <<EOI
-d $OUTPATH
-source 1.5
-sourcepath $SOURCEPATH;$CW_CLASSES_DIR
-classpath 
EOI

# Rest of -classpath
addjars

cat >>options <<EOI
-version
-author
-breakiterator
-umlautogen
-generic
EOI

# Add first part of -docletpath
YWORKS_DIR=$(cygpath -w $PWD/yworks-uml-doclet-3.0_02-jdk1.5)
echo -n "-docletpath $YWORKS_DIR\lib\ydoc.jar;$YWORKS_DIR\resources;" >>options

# Rest of -docletpath
addjars

# Extract yWorks zip file, ready for the Javadocs command.
[ -d yworks-uml-doclet-3.0_02-jdk1.5 ] || unzip yworks-uml-doclet-3.0_02-jdk1.5.zip >/dev/null || error "Could not extract yWorks zip!"

cat >>options <<EOI
-doclet ydoc.doclets.YStandard
-tag y.precondition
-tag y.postcondition
-tag y.complexity
-tag param
-tag return
-tag see
-tag y.uml
-subpackages com.teneo.esa
EOI

# Ask for confirmation and then remove output target directory.
#if [ -d "$OUTPATH" ]; then
#    echo
#    echo "WARNING: Output directory $OUTPATH already exists."
#	echo
#	echo -n "Do you want to continue? ['y' or 'n']: "
#	read _answer
#	case "$_answer" in
#	n|N) echo "Exiting now..." ; exit 0 ;; 
#	esac
#fi

# Run Javadocs command.
#CMD="javadoc @options"
#log printf \"About to run: %s\\n\" \"$CMD\"
#eval "$CMD" 2>&1 | tee javadocs.log

printf "\nFinished generating Javadoc options file: $PWD/options\n"
