TOOLS_DIR=$*

function jdgui() {
	if [ "$(uname)" = "Linux" ]; then
		$TOOLS_DIR/jd-gui/jd-gui $*
	else
		$TOOLS_DIR/jd-gui/jd-gui.exe $(cygpath -aw "$*")
	fi
}

# Description:
#   Launch jd-gui to de-compile all Java class files under current directory.
#   The de-compiled class files will be saved in file src.zip in the current
#   directory.
#
# Usage:
#   jdall <class-file>
#
# Example:
#   jdall Boot.class
#
function jdall() {
    if [ "$1" = '-h' ]; then
        usage jdall
        return
    fi
    rm -f src.zip
    $TOOLS_DIR/jd-gui/jdall.exe $(cygpath -aw "$PWD") $(cygpath -aw "$TOOLS_DIR/jd-gui/jd-gui.exe") $(cygpath -aw "$*")
}

# Description:
#   Launch jd-gui to de-compile a single Java class file.
#   The de-compiled class file will be saved in the current directory.
#
# Usage:
#   jdone <class-file>
#
# Example:
#   jdone Boot.class
#
function jdone() {
    if [ "$1" = '-h' ]; then
        usage jdone
        return
    fi
    $TOOLS_DIR/jd-gui/jdone.exe $(cygpath -aw "$PWD") $(cygpath -aw "$TOOLS_DIR/jd-gui/jd-gui.exe") $(cygpath -aw "$*")
}

# Description:
#   De-compile all the CW source files into directory D:\src
#
# Usage:
#   src
#
function src() {
    if [ "$1" = '-h' ]; then
        usage src
        return
    fi
	# The call to sleep is required to wait for jdall.exe to release access to src.zip.
	(cw && cd web/app/WEB-INF/classes && jdall Boot.class && mkdir -p /cygdrive/d/src/ && sleep 1 && /usr/bin/unzip src.zip -d "/cygdrive/d/src/")
}

# Description:
#   cd to the web/app/WEB-INF/classes directory
#
# Usage:
#   classes
#
function classes() {
    if [ "$1" = '-h' ]; then
        usage classes
        return
    fi
    cw && cd web/app/WEB-INF/classes
}

# Description:
#   Extract jars files under the specified input directory 
#   and extract them into the specified output directory.
#
# Usage:
#   jars [<inputdir>] <outputdir>
#
function jars() {
    if [ "$1" = '-h' -o $# -gt 2 ]; then
        usage jars
        return
    fi

    local _outputdir
    local _inputdir

    [ $# -eq 1 ] && _inputdir="." && _outputdir=$1
    [ $# -eq 2 ] && _inputdir=$1  && _outputdir=$2
	
    echo "Copying jar files to ${_outputdir} ..."
    (	cd "$_inputdir" && \
       mkdir -p "$_outputdir" && \
       find . -iname "*.jar" -exec cp {} "$_outputdir"/ \;	)

    local  _abs_inputdir=$(cd "$_inputdir" && pwd)

    echo "Extracting jar files in d:/cwjars ..."
    local _jname
    local _dname
    cd "$_outputdir"
    for _jname in $(ls -1 *.jar)
    do
        _dname=${_jname%.jar}
        echo "Extracting $_jname ..."
        mkdir -p "$_dname" && (cd "$_dname" && jar xf ../"$_jname" && mv ../"$_jname" .)
    done

    echo "Finished extracting jars from $_abs_inputdir !"
}

# Description:
#   Extract all the cw jars files to directory d:/cwjars
#
# Usage:
#   cwjars
#
function cwjars() {
    if [ "$1" = '-h' ]; then
        usage cwjars
        return
    fi

	local _cwdir=$(cwdir)
	jars "$_cwdir/web/app/WEB-INF/lib" 	"/cygdrive/d/cwjars"
	jars "$_cwdir/tomcat/lib"		"/cygdrive/d/cwjars"
}
