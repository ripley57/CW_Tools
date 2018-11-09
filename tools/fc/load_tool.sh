TOOLS_DIR=$*

# Description:
#   Download and launch FreeCommander Portable (https://freecommander.com/en/downloads/).
#
#   FreeCommander is more powerful than Windows Explorer. For example, 
#   it can sort folders and files TOGETHER by their last modified date.
#
#   FreeCommander command-line options:
#   https://freecommander.com/fchelpxe/en/Commandlineparameters.html
#
# Usage:
#   fc [dirpath]
#
function fc() {
	if [ "$1" = '-h' ]; then
		usage fc
		return
	fi
	
	local fc_download="https://www.dropbox.com/s/ri5asskq94l9vq0/FreeCommanderPortable.zip?dl=1"
	local fc_zip="FreeCommanderPortable.zip"
	local fc_exe="$TOOLS_DIR/fc/FreeCommanderPortable/FreeCommander.exe"
	
	# Use optional directory path specified by user, or default to current directory.
	local dirpath=${1:-"$(cygpath -w "$PWD")"}
  
	# Delete the existing zip download if the file size was zero bytes, as
	# this was probably a failed download due to lack of Internet connection.
	(cd "$TOOLS_DIR/fc" && [ -f "$fc_zip" ] && [ ! -s "$fc_zip" ] && rm "$fc_zip")
	
	# Download.
	if [ ! -f "$TOOLS_DIR/fc/$fc_zip" ]; then
		echo "Downloading $fc_download ..."
        (cd "$TOOLS_DIR/fc" && download_file "$fc_download" "$fc_zip")
	fi
		
	# Extract.
	if [ ! -f "$fc_exe" ]; then
		echo "Extracting $fc_zip ..."
        (cd "$TOOLS_DIR/fc" && unzip "$fc_zip" -d "FreeCommanderPortable")
		
		# Without this a lot of the UI icons are missing!
		(cd "$TOOLS_DIR/fc/FreeCommanderPortable" && find . -type f -exec chmod ugo+rwx {} \;)
	fi
	
	# Configure sorting of folders and files together by last modified date.
	# "Tools" > "Settings..." > "View" > "File/folder list" > "Sorting" (tab) > "Folders like files"
	# Note: We only do this when we can see a FreeCommander.ini file, because it looks 
	#		like the file is only created after the first time the program is launched.
	(cd "$TOOLS_DIR/fc/FreeCommanderPortable/Settings/" && [ -f FreeCommander.ini ] && /usr/bin/sed -i 's/SortDirLikeFiles=0/SortDirLikeFiles=1/' FreeCommander.ini)

	# Launch.
	cmd /c "$(cygpath -w "$TOOLS_DIR/fc/FreeCommanderPortable/FreeCommander.exe")" "$(cygpath -w "$dirpath")"
}
