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
	
	local umlet_download="https://www.dropbox.com/s/.../umlet.zip?dl=1"
	local umlet_zip="umlet.zip"
	local umlet_exe="$TOOLS_DIR/uml/umlet-standalone-14.3.0/Umlet/Umlet.exe"

	# Delete the existing zip download if the file size was zero bytes, as
	# this was probably a failed download due to lack of Internet connection.
	(cd "$TOOLS_DIR/uml" && [ -f "$umlet_zip" ] && [ ! -s "$umlet_zip" ] && rm "$umlet_zip")
	
	# Download.
	if [ ! -f "$TOOLS_DIR/uml/$umlet_zip" ]; then
      	      (cd "$TOOLS_DIR/uml" && download_file "$umlet_download" "$umlet_zip")
	fi
		
	# Extract.
	if [ ! -f "$umlet_exe" ]; then
              (cd "$TOOLS_DIR/uml" && unzip "umlet.zip" && chmod ugo+rx "$umlet_exe")
	fi
	
	# Launch.
    	"$umlet_exe" &
}
