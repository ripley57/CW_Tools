TOOLS_DIR=$*

# Downloads paths all in one place, so they are easy to change.
DOWNLOAD_ECLIPSE_JUNO="https://www.dropbox.com/s/cejfgqrz0izhunx/eclipse_juno_cw_debug.zip?dl=1"
DOWNLOAD_ECLIPSE_LUNA="https://www.dropbox.com/s/bh3msa5ojxungw3/eclipse_luna_cw_debug.zip?dl=1"
DOWNLOAD_ECLIPSE=$DOWNLOAD_ECLIPSE_JUNO
# For testing using non-http downloads.
#DOWNLOAD_ECLIPSE="//localhost/downloads_share/eclipse_juno_cw_debug.zip"
DOWNLOAD_EXTJS3="https://www.dropbox.com/s/iv5k2p3jl34wsxz/ext-3.4.0.zip?dl=1"
DOWNLOAD_EXTJS4="https://www.dropbox.com/s/bm4pk6azqq9a0uw/ext-4.2.0.zip?dl=1"
DOWNLOAD_GITWIN="https://github.com/git-for-windows/git/releases/download/v2.18.0.windows.1/PortableGit-2.18.0-64-bit.7z.exe"
DOWNLOAD_GITBASH="https://github.com/git-for-windows/git/releases/download/v2.18.0.windows.1/Git-2.18.0-64-bit.exe"
DOWNLOAD_FIREFOX="https://www.dropbox.com/s/b4i799xymi2qlm7/FirefoxPortable.zip?dl=1"

# Pre-downloaded and installed Node.js working environment, because the
# install_nodejs command annoyingly take several minutes to complete.
DOWNLOAD_NODEJS_PREINSTALLED="https://www.dropbox.com/s/67os8bo2bcs39j8/node_preinstalled.zip?dl=1"

# Luke downloads.
DOWNLOAD_LUKE_731="https://www.dropbox.com/s/le3ky5fzxpc60hb/lukeall-7.3.1.jar?dl=1"


# Description:
#   Download Windows Git client.
#
# Usage:
#   download_git [gitwin|gitbash]
#
function download_git() {
    if [ "$1" = '-h' ]; then
        usage download_git
        return
    fi

    local _git_download=$DOWNLOAD_GITWIN
    case "$1" in
    gitwin)  _git_download=$DOWNLOAD_GITWIN  ;;
    gitbash) _git_download=$DOWNLOAD_GITBASH ;;
    esac

    download_file "$_git_download" "git-installer.exe"
}

# Description:
#   cd to the Windows downloads directory.
#
# Usage:
#   downloads
#
function downloads() {
    if [ "$1" = '-h' ]; then
        usage downloads
        return
    fi
	
    local _downloads_dir="$(cygpath -u "${HOMEDRIVE}${HOMEPATH}\\downloads")"
    cd "$_downloads_dir"
}

# Description:
#	cd to the Windows Desktop directory.
#
# Usage:
#	desktop
#
function desktop() {
    if [ "$1" = '-h' ]; then
        usage desktop
        return
    fi
	
    local _desktop_dir="$(cygpath -u "${HOMEDRIVE}${HOMEPATH}\desktop")"
    cd "$_desktop_dir"
}

# Description:
#	Add Eclipse shortcut to desktop.
#
# Usage:
#	addeclipseshortcut <path-to-exclipse.exe>
#
# Example:
#	addeclipseshortcut /cygdrive/c/eclipse/eclipse.exe
#
function addeclipseshortcut() {
    if [ "$1" = '-h' -o $# -ne 1 ]; then
        usage addeclipseshortcut
        return
    fi
	
	local _eclipseexepath="$(cygpath -aw "$1")"
	
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" \
				   "/create:yes" \
				   "/destdirspecial:Desktop" \
				   "/destdir2:""""" \
				   "/linkname:eclipse.lnk" \
				   "/description:""My shortcut to eclipse""" \
				   "/target:""$_eclipseexepath"""
}

function _getworkspacezip() {
	local _cwver="$1"
	
	cat <<EOI | grep "^$_cwver#" | sed 's/^.*#//'
V712#https://www.dropbox.com/s/6s9b6ybsxdpyqpt/workspaceV712.zip?dl=1
V713#https://www.dropbox.com/s/c8rzmicok7o0cks/workspace713.zip?dl=1
V714#https://www.dropbox.com/s/ex3zwzj8gu3kh1y/workspaceV714.zip?dl=1
V715#https://www.dropbox.com/s/e94c5zhmrurxseo/workspaceV715.zip?dl=1
V80#https://www.dropbox.com/s/wd2ycobbzp8ty93/workspaceV80.zip?dl=1
V81#https://www.dropbox.com/s/vw0e1i0l20zg5rj/workspaceV81.zip?dl=1
V811#https://www.dropbox.com/s/cp57tza9ziomrzk/workspaceV811.zip?dl=1
V811R1#https://www.dropbox.com/s/1x63ieylihzmgga/workspaceV811R1.zip?dl=1
V82#https://www.dropbox.com/s/h8o8jces4gewovj/workspaceV82.zip?dl=1
V83#https://www.dropbox.com/s/osfy0hwugxcx9u2/workspaceV83.zip?dl=1
V90#https://www.dropbox.com/s/zu64ivi82ul6w2a/workspaceV90.zip?dl=1
EOI
}

# Description:
#   Download and install Eclipse, including the workspace
#   required for the installed version of CW.
#
# Usage:
#   install_eclipse [juno|luna]
#
function install_eclipse() {
    if [ "$1" = '-h' ]; then
        usage install_eclipse
        return
    fi

	local _eclipse_download=$DOWNLOAD_ECLIPSE
	case "$1" in
	juno) _eclipse_download=$DOWNLOAD_ECLIPSE_JUNO ;;
	luna) _eclipse_download=$DOWNLOAD_ECLIPSE_LUNA ;;
	esac

    # Change to D or C drive.
    local _pwd=$(PWD)
    cd /cygdrive/d/ 2>/dev/null && touch xyzxyzxyz 2>/dev/null && rm xyzxyzxyz 2>/dev/null
	if [ $? -ne 0 ]; then
		cd /cygdrive/c/ 2>/dev/null && touch xyzxyzxyz 2>/dev/null && rm xyzxyzxyz 2>/dev/null
        if [ $? -ne 0 ]; then
			cd /cygdrive/c/eclipse 2>/dev/null
			if [ $? -ne 0 ]; then
				echo "ERROR: Could not change to D or C directory. Aborting..."
				return
			fi
		fi
	fi
  
    # Install eclipse.
	if [ -d eclipse ]
	then
		echo "Eclipse already installed."
	else
		if [ -f eclipse.zip ]
		then
			echo "Found existing eclipse zip."
		else
			echo "Downloading eclipse zip $_eclipse_download ..."
			download_eclipse "$_eclipse_download"
			if [ ! -f eclipse.zip ]
			then
				echo "ERROR: Could not download eclipse zip file. Aborting..."
				cd "$_pwd"
				return
			fi
		fi
		echo "Unzipping eclipse installation zip ..."
		unzip -q eclipse.zip 
		if [ $? -ne 0 ]
		then
			echo "ERROR: Problem unzipping eclipse.zip. Aborting..."
			cd "$_pwd"
			return
		fi
		# Set permissions.
		find eclipse -type f -exec chmod +x {} \;
	fi
	
	# Create shortcut on Desktop.
	echo "Installing Eclipse shortcut on desktop..."
	local _eclipsedir=$(cd eclipse && pwd)
	addeclipseshortcut "$_eclipsedir/eclipse.exe"
	
	# Install workspace zip for the target CW version.
    local _cwver=$(cwver)
    if [ x"$_cwver" = x ]
    then
    	echo "WARNING: Could not determine CW version, so not installing Eclipse workspace."
		cd "$_pwd"
		return
    fi
	local _workspace_zip=$(_getworkspacezip "$_cwver")
	local _workspace_zip_filename="$(basename "$_workspace_zip" | sed 's/\?dl=.*$//')"
	if [ -f "$_workspace_zip_filename" ]
	then
		echo "Using existing workspace zip ${_workspace_zip_filename}"
	else
		echo "Downloading workspace zip $_workspace_zip ..."
		wget -O "$_workspace_zip_filename" "$_workspace_zip"
		if [ ! -f "$_workspace_zip_filename" ]
		then
			echo "ERROR: Could not download workspace zip. Aborting..."
			cd "$_pwd"
			return
		fi
	fi
    # Install the workspace zip. 
    local _workspace_target_dir1="$(cygpath -u "C:\\users\\$USERNAME")"
	_install_eclipse_workspace "${_workspace_target_dir1}" "${_workspace_zip_filename}"
	# Also install to second possible location.
	local _winhomedir=$(_windir)
	local _workspace_target_dir2="${_winhomedir}"
	_install_eclipse_workspace "${_workspace_target_dir2}" "${_workspace_zip_filename}"

    echo "Finished installing Eclipse and workspace"
    cd "$_pwd"
}

function _install_eclipse_workspace()
{
	local _workspace_target_dir=$1
	local _workspace_zip_filename=$2
	
	echo "Installing workspace ${_workspace_zip_filename} to ${_workspace_target_dir}/workspace/ ..."
	rm -fr "${_workspace_target_dir}/workspace"
    unzip -q "${_workspace_zip_filename}" -d "${_workspace_target_dir}"
    if [ ! -d "${_workspace_target_dir}/workspace" ]
	then
		echo "ERROR: Could not install workspace zip ${_workspace_zip_filename}. Aborting..."
		cd "$_pwd"
		return
    fi
}

# Description:
#   Download a file.
#   Use wget if the file path begins with "http:".
#   Otherwise use scp (which also works with Windows shares beginning "//").
#
# Usage:
#   download_file <filepath> <localfilename> [-verbose]
#
# Examples:
#   download_file "//localhost/downloads_share/eclipse_juno_cw_debug.zip" "eclipse_juno_cw_debug.zip"
#   download_file "https://www.dropbox.com/s/cejfgqrz0izhunx/eclipse_juno_cw_debug.zip?dl=1" "eclipse_juno_cw_debug.zip"
#
function download_file() {
    if [ "$1" = '-h' ]; then
        usage download_file
        return
    fi
	
	local _filepath="$1"
	local _localfilename="$2"
	local _verbose="$3"

	[[ ! -z $_verbose ]] && echo "Downloading file $_filepath ..."
	
	if echo "$_filepath" | grep -qi "^https:" ; then
	    wget -O "$_localfilename" "$_filepath"
	else
		scp "$_filepath" "$_localfilename"
	fi
}

# Description:
#   Download Eclipse zip.
#
# Useful downloads:
#   https://wiki.eclipse.org/Older_Versions_Of_Eclipse
#
# Usage:
#   download_eclipse <url>
#
function download_eclipse() {
    if [ "$1" = '-h' ]; then
        usage download_eclipse
        return
    fi
	download_file "$1" "eclipse.zip"
}

# Description:
#	Download ExtJS v4 zip.
#
# Usage:
#	download_extjs4
#
function download_extjs4() {
    if [ "$1" = '-h' ]; then
        usage download_extjs4
        return
    fi
    download_file "$DOWNLOAD_EXTJS4" "ext-4.2.0.zip"
}

# Description:
#	Download ExtJS v3 zip.
#
# Usage:
#	download_extjs3
#
function download_extjs3() {
    if [ "$1" = '-h' ]; then
        usage download_extjs3
        return
    fi
    download_file "$DOWNLOAD_EXTJS3" "ext-3.4.0.zip"
}

# Description:
#	Verify that downloaded file is of the expected type.
#	This is useful because if a DB link is invalid, the
#	downloaded file usually ends up as an html file rather 
#	than, for example, a zip file.
#
# Usage:
#	verifydownload <expectedfiletype> <filepath>
#
# Example:
#	verifydownload "ZIP" "/cygdrive/d/tmp/FirefoxPortable.zip"
#
function _verify_download() {
	if [ "$1" = '-h' ]; then
        usage _verify_download
        return
    fi
	
	if [ ! -f "$2" ]; then
		echo "ERROR: _verify_download: No such file: $2"
		return 1	# failure
	fi
	
	if [ ! -s "$2" ]; then
		# File exists but is 0 bytes. This can happen if there is no Internet connection.
		echo "ERROR: File downloaded is 0 bytes! Check Internet connection. (File downloaded: $2)"
		return 1	# failure
	fi
	
	case "$1" in
	"ZIP")
		if ! $(file "$2" | grep -q 'Zip archive data')
		then
			echo "ERROR: Downloaded file is not a ZIP as expected: $2"
			return 1	# failure
		fi
		return 0	# success
		;;
	esac
	
	return 1	# failure
}

# Description:
#   Create desktop shortcut to FirefoxPortable.exe
#
# Usage:
#   Create firefox shortcut.
#
function _create_firefox_shortcut() {
    if [ "$1" = '-h' -o $# -ne 1 ]; then
        usage _create_firefox_shortcut
        return
    fi
	local _firefox_exe_path="$(cygpath -aw "$1")"
	cmd /c cscript /nologo "$(cygpath -aw $TOOLS_DIR/shortcuts/shortcuts.vbs)" \
				   "/create:yes" \
				   "/destdirspecial:Desktop" \
				   "/destdir2:""""" \
				   "/linkname:FirefoxPortable.lnk" \
				   "/description:""My shortcut to Portable Firefox""" \
				   "/target:""$_firefox_exe_path"""
}

# Description:
#	Extract portable Firefox zip.
#
# Usage:
#	_extract_firefox_zip
#
function _extract_firefox_zip() {
	echo "Extracting $1 ..."
	if unzip -q "$1" ; then
		return 0	# success
	fi
	return 1		# failure
}

# Description:
#   Download and extract portable Firefox zip to the current directory.
#
# Usage:
#   _download_firefox_zip
#
function _download_firefox_zip() {
	local zipfile="FirefoxPortable.zip"
    if [ "$1" = '-h' ]; then
        usage _download_firefox_zip
        return
    fi
	
	if [ ! -f "$zipfile" ];	then
		echo "Downloading $zipfile..."
		wget -O FirefoxPortable.zip $DOWNLOAD_FIREFOX
		[ -f "$zipfile" ] && return 0	# success
	else
		echo "Already downloaded $zipfile"
	fi
	return 1	# failure
}

# Description:
#   Launch portable Firefox. Download and install if needed.
#
# Usage:
#   firefox [args]
#
function firefox() {
	local firefox_zip="$TOOLS_DIR/download/FirefoxPortable.zip"
	local firefox_exe="$TOOLS_DIR/download/FirefoxPortable/FirefoxPortable.exe"

	if [ "$1" = '-h' ]; then
        usage firefox
        return
    fi

	# Delete the existing zip download if the file size was zero bytes, as
	# this was probably a failed download due to lack of Internet connection.
	[ -f "$firefox_zip" ] && [ ! -s "$firefox_zip" ] && rm "$firefox_zip"
	
	# Download Firefox zip.
	if [ ! -f "$firefox_zip" ]; then
		(cd "$TOOLS_DIR/download" && _download_firefox_zip)
		if ! _verify_download "ZIP" "$firefox_zip" ; then
			return 1	# failure
		fi
	fi
		
	# Extract Firefox zip. Ensure sufficient file permissions. Create desktop shortcut.
	if [ ! -f "$firefox_exe" ]; then
	   (cd "$TOOLS_DIR/download" && _extract_firefox_zip "$firefox_zip" && \
		chmod -R +x "$TOOLS_DIR/download/FirefoxPortable" && _create_firefox_shortcut "$firefox_exe")
	fi
	
	cmd /c $(cygpath -aw "$firefox_exe") $* &
}


# Description:
#   Download netcat exe.
#
#   NOTE: To build nc.exe, run "nmake" to invoke the makefile.
#
# Usage:
#   download_nc [destination_path]
#
function download_nc() {
    if [ "$1" = '-h' ]; then
        usage download_nc
        return
    fi
    local destination_path=""
    if [ "$1" != "" ]; then
	destination_path="-O "$1""
    fi
    wget "$destination_path" https://dl.dropboxusercontent.com/u/22161481/nc.exe.safe
}

# Prefix used when splitting large file for upload.
function _get_upload_prefix() {
	local _file="$1"
	local _prefix=${_file%.*}_
	echo $_prefix
}

# Filename created after file chunks have been re-joined.
function _get_rejoined_filename() {
	local _file=$(_get_upload_prefix "$1")
	local _rejoined_filename=${_file%_*}
	echo $_rejoined_filename
}

# File marker to signal completion of upload of all file chunks.
function _get_upload_completion_marker_filename() {
	local _file="$1"
	local _upload_or_download_dir="$2"
	local _prefix=$(_get_upload_prefix "$_file")
	local _marker="${_upload_or_download_dir}/UPLOAD_COMPLETE_${_prefix}"
	echo $_marker
} 

# File marker to signal upload completion of a single file chunk.
function _get_upload_chunk_ready_marker_filename() {
	local _file="$1"
	local _upload_or_download_dir="$2"
	local _prefix=$(_get_upload_prefix "$_file")
	local _marker="${_upload_or_download_dir}/UPLOAD_CHUNK_READY_${_prefix}"
	echo $_marker
}

# Default directory to upload file chunks to.
function _get_default_upload_dir() {
	echo "$ENV_DB_UPLOAD_DIR"
}

# Default directory to download file chunks from.
function _get_default_download_dir() {
	echo "$ENV_DB_DOWNLOAD_DIR"
}

function _display_time_elapsed() {
	local _start_sec=$1
	local _now_sec=$(date +%s)

	local _elapsed_sec;
	local _mins;
	local _hours;
	local _mins2;
	
	let _elapsed_sec=$_now_sec-$_start_sec
	let _mins=$_elapsed_sec/60
	let _hours=$_mins/60
	let _mins2=$_mins%60
	
	if [[ $_hours -eq 0 ]]
	then
		printf "%s: Time elapsed: %2d mins\n" "$(date)" "$_mins2"
	else
		printf "%s: Time elapsed: %2d hours %2d mins\n" "$(date)" "$_hours" "$_mins2"
	fi
}

# Description:
#   Upload a file in chunks.
#   This function is used with the dbdownload function.
#
# Usage:
#   dbupload -file <file> [-splitsize <size>] [-uploaddir <dir>] [-sleep <secs>] 
#
# Example:
#   dbupload -file largefile.zip
#
function dbupload() {
	local _uploaddir="$(_get_default_upload_dir)"
	local _file=
	local _splitsize=250	# Default split size in MB.
	local _sleep=30
	
	if [ "$1" = '-h' ]; then
        usage dbupload
        return
    fi
	
	# Processing input arguments.
	while true; do
	case $1 in
	-splitsize)	shift && _splitsize="$1" 	;;
	-uploaddir)	shift && _uploaddir="$1" 	;;
	-sleep)		shift && _sleep="$1" 		;;
	-file) 		shift && _file="$1" 		;;
	esac
	shift || break
	done
	
	# Check required arguments.
	[ "$_file" = "" ]		&& echo "ERROR: dbupload: file argument is required!"		&& return
	[ "$_uploaddir" = "" ]	&& echo "ERROR: dbupload: uploaddir argument is required!" 	&& return
	[ ! -d "$_uploaddir" ] 	&& echo "ERROR: dbupload: upload directory does not exist!" && return
	
	local _start_sec=$(date +%s)
		
	# 1. Split the input file into chunks, if no chunks already exist. This enables
	#    us to rerun the dbupload function to complete a previously-started upload.
	local _prefix=$(_get_upload_prefix "$_file")
	local _count=$(ls -1 "$_prefix"* 2>/dev/null | wc -l)
	if [ $_count -eq 0 ]; then
		echo "Splitting ${_file} into ${_splitsize}MB chunks in the current directory ..."
		splitfile $_splitsize "$_file" "$_prefix"
		_count=$(ls -1 "$_prefix"* 2>/dev/null | wc -l)
	else
		echo "File chunks already exist, so skipping split of ${_file}"
	fi
	
 	# 2. Move each chunk to the upload directory.
	#    Wait for each chunk to be accepted by the other end.
	#	 (The other end will leave a marker file named after 
	#    the chunk, for example "FirefoxPortable_aa_ACCEPTED").
	local _i; let _i=1 
	local _chunk=
	for _chunk in $(ls -1 "$_prefix"* | sort); do
		# Move next chunk to the upload directory.
		echo "Uploading chunk $_chunk ($_i of $_count) ..."
		cp "$_chunk" "$_uploaddir"
		#mv "$_chunk" "$_uploaddir"
		
		# Create a "chunk ready" marker. This file will also contain the name of the chunk.
		local _chunk_ready_marker=$(_get_upload_chunk_ready_marker_filename "$_file" "$_uploaddir" )
		echo "$_chunk" > "${_chunk_ready_marker}"
	
		# Wait for other end to accept the chunk (by deleting the "chunk ready" marker.)
		while true; do
			#echo "Waiting for removal of ${_chunk_ready_marker} ..."
			if [ ! -f "${_chunk_ready_marker}" ]; then
				#echo "Other end has downloaded chunk $_chunk"
				# Remove the chunk from the upload directory.
				sleep 15
				rm "${_uploaddir}/${_chunk}" 
				let _i=_i+1
				break
			fi
			sleep $_sleep
		done
		_display_time_elapsed $_start_sec
	done

	# 3. Create an upload completion marker file and wait for other 
	#    end to acknowledge it (by deleting the marker file).
	local _upload_completion_marker_filename=$(_get_upload_completion_marker_filename "$_file" "$_uploaddir")
	touch "${_upload_completion_marker_filename}"
	#echo "Created upload completion marker ${_upload_completion_marker_filename}"
	# Wait for other end to delete the upload completion marker.
	while true; do
		#echo "Waiting for removal of ${_upload_completion_marker_filename} ..."
		if [ ! -f "$_upload_completion_marker_filename" ]; then
			echo "Other end has completed downloading."
			break
		fi
		sleep $_sleep
	done	
	_display_time_elapsed $_start_sec
}

# Description:
#   Download a file in chunks to the current directory.
#   This function is used with the dbupload function.
#
#   Note: The "-downloaddir" argument is the DB location 
#         used for the transferring of each file chunk.
#         The final downloaded file will be created in 
#         the current directory.
#
# Usage:
#   dbdownload -file <file> [-downloaddir dir] [-sleep secs] 
#
# Example:
#   dbdownload -file largefile.zip -downloaddir /cygdrive/c/users/jcdc/Dropbox/Public/tmp
#
function dbdownload() {
	local _downloaddir="$(_get_default_download_dir)"
	local _file=
	local _sleep=30
	local _prefix=
	local _complete_marker=

	if [ "$1" = '-h' ]; then
        usage dbdownload
        return
    fi
	
	# Process input arguments.
	while true; do
	case $1 in
	-downloaddir)	shift && _downloaddir="$1" 	;;
	-sleep) 		shift && _sleep="$1" 		;;
	-file) 			shift && _file="$1"			;;
	esac
	shift || break
	done

    # Check required arguments.
	[ "$_file" = "" ]			&& echo "ERROR: dbdownload: file argument is required!" 		&& return
	[ "$_downloaddir"  = "" ] 	&& echo "ERROR: dbdownload: downloaddir argument is required!" 	&& return
	[ ! -d "$_downloaddir"  ] 	&& echo "ERROR: dbdownload: download directory does not exist!" && return
	
	printf "\n********************************************************************\n"
	printf   "WARNING: Ensure you have free disk space 2x the size of upload file!\n"
	printf   "********************************************************************\n\n"

	local _start_time_secs=$(date +%s)
	
	local _upload_completion_marker_filename=$(_get_upload_completion_marker_filename "$_file" "$_downloaddir")
	local _chunk_ready_marker=$(_get_upload_chunk_ready_marker_filename "$_file" "$_downloaddir")
	local _i; let _i=1
	while true; do
		if [ -f "${_upload_completion_marker_filename}" ]; then
			# Download of all chunks completed.
			rm  "${_upload_completion_marker_filename}"
			_display_time_elapsed $_start_time_secs
			break
		fi
		#echo "Waiting for ${_chunk_ready_marker} ..."
		if [ -f "${_chunk_ready_marker}" ]; then
			_display_time_elapsed $_start_time_secs
			local _chunk=$(<${_chunk_ready_marker})
			# Wait for the chunk to appear.
			while true; do
				if [ -f "${_downloaddir}/${_chunk}" ]; then
					printf "%s: Download chunk %s (%s)\n" "$(date)" "$_chunk" "$_i"
					# Copy the downloaded chunk to the current directory.
					cp "${_downloaddir}/${_chunk}" .
					sleep 15
					# Signal to the upload end that we have downloaded the chunk.
					rm "${_chunk_ready_marker}"
					let _i=_i+1
					break
				else
					sleep $_sleep
				fi
			done
		fi
		sleep $_sleep
	done
	# Join all the downloaded chunks in the current directory.
	local _prefix=$(_get_upload_prefix "$_file")
	echo "Re-joining downloaded chunks..."
	joinfiles ${_prefix}
	# Rename rejoined file to name of the originally uploaded file.
	local _rejoined_filename=$(_get_rejoined_filename "$_file")
	mv "${_rejoined_filename}" "${_file}"
	# Remove chunks from current directory.
	#rm "${_prefix}"*
	echo "Download complete of file ${_file}"
	ls -ltr
	_display_time_elapsed $_start_time_secs
}
