TOOLS_DIR=$*

# Description:
#   Download and launch ant.
#
#	Note: Launching ant will fail if Java is not set up
#         correctly, but that is not the responsbility 
#         of this function.
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
	
	# Setup Ant env in Cygwin.
	if [[ "$PATH" == *"apache-ant-"* ]]; then
		: ;# echo "Path already includes apache ant"
	else
		export ANT_HOME="$TOOLS_DIR/ant/$ant_dir"
		export PATH="$ANT_HOME/bin:$PATH"
	fi
	
	# Generate batch script to setup Ant env in Windows.
	if [ ! -f "$TOOLS_DIR/ant/setenv.cmd" ]; then
		local ant_home="$(cygpath -aw "$TOOLS_DIR/ant/$ant_dir")"
		local ant_path="$(cygpath -aw "$TOOLS_DIR/ant/$ant_dir/bin")"
		cat <<EOI >"$TOOLS_DIR/ant/setenv.cmd"
set ANT_HOME="$ant_home"
set PATH="$ant_home";%PATH%
EOI
	fi
	
	echo "Script to setup Ant environment on Windows:"
	echo
	echo \"$(cygpath -aw "$TOOLS_DIR/ant/setenv.cmd")\"
	echo
		
	echo
	echo "Launching Ant in Cygwin ..."
	echo
	"$TOOLS_DIR/ant/$ant_dir/bin/ant" $*
}
