TOOLS_DIR=$*

# Description:
#   Download and launch Ant.
#
#   Note: Ant will fail if the Java env is not set up.
#         This function will not set up the Java env.
#         Set JAVA_HOME to set up the Java env.
#
# Usage:
#   ant [args]
#
function ant() {
    if [ "$1" = '-h' ]; then
        usage ant
        return
    fi
	
	local ant_download="https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.1-bin.zip"
	local ant_zip="apache-ant-1.10.1-bin.zip"
	local ant_dir="apache-ant-1.10.1/"

	# Delete the existing zip download if the file size was zero bytes, as
	# this was probably a failed download due to lack of Internet connection.
	(cd "$TOOLS_DIR/ant" && [ -f "$ant_zip" ] && [ ! -s "$ant_zip" ] && rm "$ant_zip")
	
	if [ ! -d "$TOOLS_DIR/ant/$ant_dir" ]; then
		echo "Downloading $ant_download ..."
		(cd "$TOOLS_DIR/ant" && download_file "$ant_download" "$ant_zip")
	
		echo "Extracting $ant_zip ..."
		(cd "$TOOLS_DIR/ant" && unzip "$ant_zip")
	fi
	
    	# Setup Ant environment in Linux or Cygwin.
    	if [ "$(uname)" = "Linux" ] || type cygpath >/dev/null 2>&1; then
		if [[ "$PATH" == *"apache-ant-"* ]]; then
			: ;# echo "Path already includes apache ant"
		else
			export ANT_HOME="$TOOLS_DIR/ant/$ant_dir"
			export PATH="$ANT_HOME/bin:$PATH"
		fi
	fi
	
    	# Generate batch script to setup env in Windows cmd window.
    	if type cygpath >/dev/null 2>&1; then
		if [ ! -f "$TOOLS_DIR/ant/setenv.cmd" ]; then
			local ant_home="$(cygpath -aw "$TOOLS_DIR/ant/$ant_dir")"
			local ant_path="$(cygpath -aw "$TOOLS_DIR/ant/$ant_dir/bin")"
			cat <<EOI >"$TOOLS_DIR/ant/setenv.cmd"
@echo off
set ANT_HOME=$ant_home
set PATH=$ant_path;%PATH%
EOI
			echo "Script to setup Ant environment on Windows:"
			echo
			echo \"$(cygpath -aw "$TOOLS_DIR/ant/setenv.cmd")\"
			echo
		fi
	fi
		
    	printf "\nLaunching CW_Tools ant wrapper ...\n"
	"$TOOLS_DIR/ant/$ant_dir/bin/ant" $*
}
