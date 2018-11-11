TOOLS_DIR=$*

# Description:
#   Download and launch UMLET (https://www.umlet.com/).
#
# Usage:
#   uml
#
function uml() {
	if [ "$1" = '-h' ]; then
        	usage uml
        	return
	fi
	
		set DOCSEARCH_ANT_DOWNLOAD_ZIP_URL=https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.1-bin.zip
	set DOCSEARCH_ANT_DOWNLOAD_ZIP_FILENAME=apache-ant-1.10.1-bin.zip
	
	local ant_download="https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.1-bin.zip"
	local ant_zip="umlet.zip"
	local umlet_exe="$TOOLS_DIR/uml/Umlet/Umlet.exe"

	# Delete the existing zip download if the file size was zero bytes, as
	# this was probably a failed download due to lack of Internet connection.
	(cd "$TOOLS_DIR/uml" && [ -f "$umlet_zip" ] && [ ! -s "$umlet_zip" ] && rm "$umlet_zip")
	
	# Download.
	if [ ! -f "$TOOLS_DIR/uml/$umlet_zip" ]; then
		echo "Downloading $umlet_download ..."
		(cd "$TOOLS_DIR/uml" && download_file "$umlet_download" "$umlet_zip")
	fi
	
	# Extract.
	if [ ! -f "$umlet_exe" ]; then
		echo "Extracting $umlet_zip ..."
		(cd "$TOOLS_DIR/uml" && unzip "$umlet_zip" && chmod ugo+rx "$umlet_exe")
	fi

	# Launch.
	"$umlet_exe" &
}
