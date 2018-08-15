TOOLS_DIR=$*

# Description:
#    Create a copy of b.bat called b2.bat which uses the full 
#    file path to the installed Windows Perl, which is 
#    assumed to be in c:\perl\perl\bin\perl.exe. This b2.bat
#    script can then be called from Cygwin without invoking
#    the perl installed with Cygwin, which errors when calling
#    build.pl with the following error:
#    Can't locate object method "GetObject" via package "Win32::OLE"
#
# Usage:
#    createb2bat
#
function createb2bat() {
	if [ "$1" = '-h' ]; then
		usage createb2bat
		return
	fi
	
	local _cwdir=$(cwdir)
	if [ ! -f "$_cwdir/b2.bat" ]; then
		sed 's#perl#C:\\perl\\perl\\bin\\perl.exe#' "$_cwdir/b.bat" > "$_cwdir/b2.bat"
		chmod ugo+rwx "$_cwdir/b2.bat"
	else
		# Nothing to do
		return
	fi
} 


# Description:
#   Execute: b admin-client support run clusterbrowser
#
# Usage:
#   b_clusterbrowser
#
function b_clusterbrowser() {
    if [ "$1" = '-h' ]; then
        usage b_clusterbrowser
        return
    fi
    createb2bat
    local _cwdir=$(cwdir)
    cmd /c "$(cygpath -aw $TOOLS_DIR/cwbcommands/clusterbrowser.bat)" "$(cygpath -aw $_cwdir)"
}


# Description:
#   Execute: b admin-client monitor.thread getAllStackTraces
#
# Usage:
#   b_stackdump
#
function b_stackdump() {
    if [ "$1" = '-h' ]; then
        usage b_stackdump
        return
    fi
    createb2bat
    local _cwdir=$(cwdir)
    cmd /c "$(cygpath -aw $TOOLS_DIR/cwbcommands/stackdump.bat)" "$(cygpath -aw $_cwdir)"
}


# Description:
#   Display current property value being used by CW.
#
#   Note: This function is not quick, because it creates
#         a Beanshell script that it then runs.
#
# Usage:
#   getprop <property>
#
# Example:
#   getprop esa.netit.fileid.shortname.netit.Excel
#
function getprop() {
    local _propname="$1"

    if [ "$1" = '-h' ]; then
        usage getprop
        return
    fi

    echo "Generating Beanshell script..."
    cat >$TMP/getproperty.bsh <<EOI
import com.teneo.esa.common.util.Configuration;
buf = new StringBuffer();
buf.append("\n");
buf.append("CW property   : $_propname" + "=" + Configuration.getProperty("$_propname"));
buf.append("\n");
buf.append("Java System property : $_progname" + "=" + System.getProperties().getProperty("$_propname"));
buf;
EOI
    local _cwdir=$(cwdir)

    echo "Starting Beanshell service..."
    (cd "$_cwdir" && ${_cwdir}/b.bat admin-client shell addRemovableService bsfservice >/dev/null 2>&1)

    echo "Executing Beanshell script..."
    (cd "$_cwdir" && ${_cwdir}/b.bat admin-client bsfservice evalScript $(cygpath -w "$TMP/getproperty.bsh") | grep "${_propname}=")

    rm -f $TMP/getproperty.bsh
}


# Description:
#	List active local CW jvm components.
#
# Usage:
#	cwcomps
#
function cwcomps() {
    if [ "$1" = '-h' ]; then
        usage cwcomps
        return
    fi

    cwinstall_bshjar && echo "Restart the CW services." && return
    createb2bat
    local _cwdir=$(cwdir)
		
    echo "Starting Beanshell service..."
    (cd "$_cwdir" && ${_cwdir}/b2.bat admin-client shell addRemovableService bsfservice >/dev/null 2>&1)

    echo "Executing Beanshell script..."
    (cd "$_cwdir" && ${_cwdir}/b2.bat admin-client bsfservice evalScript $(cygpath -w "$TOOLS_DIR/cwbcommands/listcomps.bsh"))
}


# Description:
#   Restart all CW services.
#
# Usage:
#   cwrestart
#
function cwrestart() {
    if [ "$1" = '-h' ]; then
        usage cwrestart
        return
    fi
    createb2bat
    local _cwdir=$(cwdir)
    cmd /c "$(cygpath -aw $TOOLS_DIR/cwbcommands/cwstop.bat)" "$(cygpath -aw $_cwdir)"
    cmd /c "$(cygpath -aw $TOOLS_DIR/cwbcommands/cwstart.bat)" "$(cygpath -aw $_cwdir)"
}

# Description:
#   Stop all CW services.
#
# Usage:
#   cwstop
#
function cwstop() {
    if [ "$1" = '-h' ]; then
        usage cwstop
        return
    fi
    local _cwdir=$(cwdir)
    cmd /c "$(cygpath -aw $TOOLS_DIR/cwrestart/cwstop.bat)" "$(cygpath -aw $_cwdir)"
}

# Description:
#   Start all CW services.
#
# Usage:
#   cwstart
#
function cwstart() {
    if [ "$1" = '-h' ]; then
        usage cwstart
        return
    fi
    local _cwdir=$(cwdir)
    cmd /c "$(cygpath -aw $TOOLS_DIR/cwrestart/cwstart.bat)" "$(cygpath -aw $_cwdir)"
}

# Description:
#   Restart EsaApplicationService.
#
# Usage:
#   esarestart
#
function esarestart() {
    if [ "$1" = '-h' ]; then
        usage esarestart
        return
    fi
    local _cwdir=$(cwdir)
    cmd /c "$(cygpath -aw $TOOLS_DIR/cwrestart/esarestart.bat)" "$(cygpath -aw $_cwdir)"
}

# Description:
#   List status of services.
#
# Usage:
#   sclist [string]
#
# Example:
#   $ services ' ws'
#   RUNNING wscsvc
#   RUNNING WSearch
#
function sclist() {
    if [ "$1" = '-h' ]; then
        usage sclist
        return
    fi
    local grep_expr='.*'
    if [ x"$1" != x ];then
	grep_expr=$1
    fi
    sc.exe query | sed -n -e "/SERVICE_NAME:/{h;}" -ne "/STATE/{G;s#\n##;s#^.*: [0-9][0-9]*  ##;s# SERVICE_NAME:##;p}" | grep -i "$grep_expr"
}
alias services='sclist'
alias cwservices='sclist esa'
alias services.msc='cmd /c services.msc'

# Description:
#   List status of CW services.
#
# Usage:
#   cwsc
#
function cwsc() {
    if [ "$1" = '-h' ]; then
        usage cwsc
        return
    fi
    sclist | grep ' Esa'
}
