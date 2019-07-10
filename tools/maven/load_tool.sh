TOOLS_DIR=$*

# Description:
#   Download and configure Maven.
#
# Usage:
#   mvn
#
function mvn() {
    if [ "$1" = '-h' ]; then
        usage mvn
        return
    fi

    local mvn_download="https://mirrors.ukfast.co.uk/sites/ftp.apache.org/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.zip"
    local mvn_zip=$(basename "$mvn_download")
    local mvn_dir=${mvn_zip%-bin.zip}

    # Delete the existing zip download if the file size was zero bytes, as
    # this was probably a failed download due to lack of Internet connection.
    (cd "$TOOLS_DIR/maven" && [ -f "$mvn_zip" ] && [ ! -s "$mvn_zip" ] && rm "$mvn_zip")
	
    # Download and extract Maven.
    if [ ! -d "$TOOLS_DIR/maven/$mvn_dir" ]; then
        echo "Downloading $mvn_download ..."
        (cd "$TOOLS_DIR/maven" && download_file "$mvn_download" "$mvn_zip")
        echo "Extracting $mvn_zip ..."
        (cd "$TOOLS_DIR/maven" && unzip "$mvn_zip")
    fi
	
    # Setup Maven environment in Linux or Cygwin.
    if [ "$(uname)" = "Linux" ] || type cygpath >/dev/null 2>&1; then
	if [[ "$PATH" == *"maven"* ]]; then
            : ;# echo "Path already includes Maven"
	else
            export M2_HOME="$TOOLS_DIR/maven/$mvn_dir"
            export M2=$M2_HOME/bin
            export MAVEN_OPTS="-Xms256m -Xmx512m"
            export PATH=$M2:$PATH 
        fi
    fi

    # Generate batch script to setup env in Windows cmd window.
    if type cygpath >/dev/null 2>&1; then
        if [ ! -f "$TOOLS_DIR/maven/setenv.cmd" ]; then
            local m2_home="$(cygpath -aw "$TOOLS_DIR/maven/$mvn_dir")"
            local m2="$(cygpath -aw "$m2_home/bin")"
            cat <<EOI >"$TOOLS_DIR/maven/setenv.cmd"
@echo off
set M2_HOME=$m2_home
set M2=$m2
set PATH=$m2;%PATH%
EOI
            echo "Script to setup Maven environment in Windows cmd.exe:"
            echo
            echo \"$(cygpath -aw "$TOOLS_DIR/maven/setenv.cmd")\"
            echo
        fi
    fi
		
    printf "\nLaunching CW_Tools mvn wrapper ...\n"
    "$TOOLS_DIR/maven/$mvn_dir/bin/mvn" $*
}
