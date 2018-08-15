TOOLS_DIR=$*

# Description:
#   Use patchlister.jar tool to print MD5 values of files.
#
# Usage:
#   md5 *.txt
#   md5 somedir/**/*.txt
#
function md5() {
    if [ "$1" = '-h' ]; then
        usage md5
        return
    fi

    java -jar "$(_cygpath -aw $TOOLS_DIR/patches/patchlister/patchlister.jar)" -md5 $@
}

# Description:
#   Change to patches directory and list contents.
#
# Usage:
#   patches
#
function patches() {
    local _cwdir=$(cwdir)
    if [ -z "$_cwdir" ]; then
        printf "\nCould not find a top-level CW directory.\n"
        return
    fi

    (cd $_cwdir/patches && ls -ltr)
}

function _extract_jar_to_tmpdir() {
   local _esa_jar_path="$1"

   local _esa_name="$(basename $_esa_jar_path)"
   local _tmp_dir="${TMP}/jar_tmp_dir/$_esa_name"

   if [ ! -d "$_tmp_dir" ]
   then
      mkdir -p "$_tmp_dir"
      (cd "$_tmp_dir" && jar xf "$(cygpath -w $_esa_jar_path)")
   fi

   echo "$_tmp_dir"
}

function _display_file_contents() {
   local _esa_jar_path="$1"
   local _file_path="$2"

   # Generate unique div id.
   # I opted for this method because for some reason I could
   # not get a simple global variable to increment correctly.
   local _file_id=$(date +%s%N)

   cat << EOI
<div style="font-family: courier; font-size: 12px;">
<a href="#$_file_id"><u onmousedown="if(document.getElementById('file_${_file_id}').style.display == 'none'){ document.getElementById('file_${_file_id}').style.display = 'block'; }else{ document.getElementById('file_${_file_id}').style.display = 'none'; }">$_file_path</u></a><br>
<div id="file_${_file_id}" style="display:none; background-color: #d7d7d7"><pre>
EOI

   local _tmp_dir=$(_extract_jar_to_tmpdir "$_esa_jar_path")
   cat "$_tmp_dir/$_file_path"

cat << EOI
</pre></div></div>
EOI
}

function _display_file_path_only() {
   local _file_path="$1"

   cat << EOI
<div style="font-family: courier; font-size: 12px;">$_file_path</div>
EOI
}

function _display_patch_file() {
   local _esa_jar_path="$1"
   local _file_path="$2"

   # Extract file extension and decide if we want to see the file contents.
   local _ext=${_file_path##*\.}
   case "$_ext" in
   properties) _display_file_contents  "$_esa_jar_path" "$_file_path"
               ;;
   MF)         _display_file_contents  "$_esa_jar_path" "$_file_path"
               ;;
   *)          _display_file_path_only "$_file_path"
               ;;
   esac
}

function _display_patches() {

    local _patch_dir=$(cwdir)/patches
    local _build_info=$(buildinfo)

    cat << EOI
<html>
<head><title>Patch Listing</title></head>
<body>
<h1>$_build_info</h1>
EOI

    # Build list of patches to display.
    #
    # Note: We only want to list the 1-off patch details
    # for patches installed after the last rollup Fixpack.
    # To do this, notice how we list the directory by date.
    #
    local _esa_dir_path
    local _esa_patch_list
    local _cumhotfix_list
    local _ver_last_cumhotfix=0
    local _ver_new_cumhotfix
    local _esa_name
    for _esa_dir_path in `ls -1tr "$_patch_dir"`
    do
        _esa_name=$(basename "$_esa_dir_path")

        pattern_fixpack='^V[0-9]+_Fix[0-9]+$'
        pattern_oneoff='^ESA-[0-9-]+$'
	pattern_cumhotfix='^V[0-9]+_CHF[0-9]+$'

        if [[ "$_esa_name" =~ $pattern_fixpack ]]
        then
            # Old style (pre-715) rollup Fixpack. 
			_esa_patch_list="$_esa_patch_list $_esa_name"
        elif [[ "$_esa_name" =~ $pattern_oneoff ]]
	then
            	# Old stype (pre-715) one-off ESA patch.
            	_esa_patch_list="$_esa_patch_list $_esa_name"
		elif [[ "$_esa_name" =~ $pattern_cumhotfix ]]
		then
			# New style (715+) cumulative hotfix.
			_ver_new_cumhotfix=$(echo "$_esa_name" | sed -n 's/V\([0-9][0-9]*\)_CHF[0-9][0-9]*/\1/p')
			if [[ $_ver_new_cumhotfix -gt $_ver_last_cumhotfix ]]
			then
				# Product upgrade detected. Ignore earlier 
				# cumulative hotfixes.
				_cumhotfix_list="$_esa_name"
			else
				_cumhotfix_list="$_cumhotfix_list $_esa_name"
			fi
			_ver_last_cumhotfix=$_ver_new_cumhotfix
			# At least one new style cumulative hotfix is installed, 
			# so we not want to consider any old style fixpacks or
			# one-offs.
			_esa_patch_list="$_cumhotfix_list"
        	fi
    	done

    	# List patches directory.
    	cat << EOI
<div style="font-family: courier; font-size: 12px;">
<pre>
EOI
    ls -ltr "$_patch_dir"
    cat << EOI
</pre>
</div>
EOI

    # List contents of each patch jar file.
    local _esa_jar_path
    for _esa_name in $_esa_patch_list
    do
        _esa_dir_path="$_patch_dir/$_esa_name"
        _esa_jar_path="$_esa_dir_path/$_esa_name".jar

        echo "Examining ${_esa_name}.jar ..." >&2

        cat << EOI
<br/>
<h2>$_esa_name</h2>
EOI
        # Process each file in the patch.
        local _tmp_dir=$(_extract_jar_to_tmpdir "$_esa_jar_path")
        jar tvf $(cygpath -w "$_esa_jar_path") | dos2unix | grep -v '/$' | cut -c 37- | \
	while read _line
        do
           _display_patch_file "$_esa_jar_path" "$_line"
        done
        rm -fr "$_tmp_dir"

        cat << EOI
<br/>
EOI
    done

    # Footer.
    cat << EOI
<br/>
<br/>
Generated by genpatcheshtml on $(date)
</body>
</html>
EOI
}


# Description:
#   List patch contents by listing the contents of the jar files under
#   cw_home/patches. Only list patches corresponding to the last rollup
#   Fixpack. This function generates an HTML page and copies it to the
#   Windows desktop.
#
# Usage:
#   genpatcheshtml
#
function genpatcheshtml() {
    if [ "$1" = '-h' ]; then
        usage genpatcheshtml
        return
    fi

    rm -f "${TMP}/patchlist.html"
    _display_patches > "${TMP}/patchlist.html"
    cp "${TMP}/patchlist.html" "/cygdrive/c/Documents and Settings/All Users/Desktop/Patch Listing.html"
    local _browser=$(_get_web_browser)
    "${_browser}" file://$(cygpath -m "${TMP}/patchlist.html") &
}


# List all of the cw ftp urls, or grep for just one of them.
function _getftpurls() {
	local _cwver="$1"

	# Note: we need to remove any surrounding single quotes, because 
	#       otherwise they get escaped with another single quote, which
	#	then causes problem later when the ftp url value is used.
	if [ "x$_cwver" != "x" ]; then
		grep -E '^V[0-9]+_CMD' ~/.bash_profile | grep "${_cwver}_CMD=" | sed 's/^[^=]*=//' | tr -d \'
	else
		grep -E '^V[0-9]+_CMD' ~/.bash_profile | tr -d \'
	fi
}

# Parse zip names from ftp patches listing.
function _parseZipNames() {
    local _s
    local _zipNames=""

    while read _s ; do
        local _zip=$(echo $_s |  sed -n 's/^.*\(ESA-.*\.zip\).*$/\1/p')
        if [ x"$_zip" != x ]; then
            _zipNames="$_zipNames $_zip"
        fi
    done
    echo $_zipNames
}

# Parse ESA names from ftp patches listing.
function _parseEsaNames() {
    local _s
    local _esaNames=""

    while read _s ; do
        local _esas=$(echo $_s |  sed -n 's/^.*ESA\(-.*\).zip.*$/\1/p')
        if [ x"$_esas" != x ]; then
            let '_oneoff_count = _oneoff_count + 1'
            IFS='-' read -a _array <<< "$_esas"
            for _element in "${_array[@]}" ; do
                if [ x"$_element" != x ]; then
                    _esaNames="$_esaNames $_element"
                fi
            done
        fi
    done
    echo $_esaNames
}

# Parse ESA names from listing of appliance patches directory.
function _parseInstalledEsaNames() {
    local _s
    local _esaNames=""

    while read _s ; do
        local _esas=$(echo $_s |  sed -n 's/^.*ESA\(-.*\)/\1/p')
        if [ x"$_esas" != x ]; then
            IFS='-' read -a _array <<< "$_esas"
            for _element in "${_array[@]}" ; do
                if [ x"$_element" != x ]; then
                    _esaNames="$_esaNames $_element"
                fi
            done
        fi
    done
    echo $_esaNames
}

# Return list of ESA zips that need to be installed.
function _getZipNamesToInstall() {
	local _missing_esas=$1
	local _available_zips=$2
	local _zipsToInstall=""
	local _esa
	local _zip

	for _esa in $_missing_esas
	do
		_zip=$(echo $_available_zips | tr ' ' '\n' | grep $_esa)
		if [ "x$_zip" != x ]; then
			_zipsToInstall="$_zipsToInstall $_zip"
		fi
	done
	echo $_zipsToInstall | tr ' ' '\n' | sort | uniq 
}

# Download file and direct to stdout.
function _download_patch_zip() {
    local _file_path="$1"

    echo >&2
    echo "Download file $_file_path ..." >&2
    echo >&2
    wget "$_file_path"
}

# Description:
#   List patches that are available but missing from the appliance.
#
# Usage:
#   listmissingpatches
#
function listmissingpatches() {
	if [ "$1" = '-h' ]; then
		usage listmissingpatches
		return
	fi

	# Determine current CW version.
	local _cwver=$(cwver)
	if [ "x$_cwver" = x ]; then
		echo "ERROR: Could not determine current CW version"
		return
	fi

	# Get ftp url for current CW version.
	local _ftpurl=$(_getftpurls $_cwver)
	if [ "x$_ftpurl" = x ]; then
		echo "ERROR: Could not determine patches ftp url"
		return
	fi

	# Get listing of available patches for curent CW version.
	_getHotfixesPage $_ftpurl >${TMP}/patches_available.tmp
	if [[ ! -s ${TMP}/patches_available.tmp ]]; then
		echo "WARNING: No patches available for version $_cwver"
		echo
		echo "You might want to check this..."
		echo
		echo "FTP LOCATION"
		echo "============"
		echo $_ftpurl
		return
	fi

	# Get available one-off zip names.
	local _available_zips=$(cat ${TMP}/patches_available.tmp | _parseZipNames)
	if [ "x$_available_zips" = x ]; then
		echo "ERROR: Could not determine available patch zips"
		echo
		echo "FTP LOCATION"
		echo "============"
		echo $_ftpurl
		return
	fi

	# Get available one-off ESA names.
	local _available_esas=$(cat ${TMP}/patches_available.tmp | _parseEsaNames)
	if [ "x$_available_esas" = x ]; then
		echo "ERROR: Could not determine available ESA list"
		echo
		echo "FTP LOCATION"
		echo "============"
		echo $_ftpurl
		return
	fi

	# Get currently installed one-off ESA names.
	patches > ${TMP}/patches_installed.tmp
	local _installed_esas=$(cat ${TMP}/patches_installed.tmp | _parseInstalledEsaNames)

	# Get list of missing ESA names.
	echo $_available_esas | tr ' ' '\n' | sort -n > ${TMP}/patches_available_sorted.tmp
	echo $_installed_esas | tr ' ' '\n' | sort -n > ${TMP}/patches_installed_sorted.tmp
	local _missing_esas=$(comm_first ${TMP}/patches_available_sorted.tmp ${TMP}/patches_installed_sorted.tmp | grep -v '^$')

	# Get list of ESA zip files to install.
	local _zips_to_install=""
	if [ "x$_missing_esas" != x ]; then
		_zips_to_install=$(_getZipNamesToInstall "$_missing_esas" "$_available_zips")
	fi

	echo
	echo "MISSING PATCHES TO BE INSTALLED"
	echo "==============================="
	if [ "x$_zips_to_install" = "x" ]; then
		echo "No new patches to install."
	else
		echo "$_zips_to_install"
	fi
	echo
	echo "FTP LOCATION"
	echo "============"
	echo $_ftpurl
	echo

        local _browser=$(_get_web_browser)
        "${_browser}" "$_ftpurl/current/Hotfixes" &

	if [ "x$_zips_to_install" != x ]; then
		if _yorn 'Do you want to download the missing zips? (yes|no) :' -eq 0 ; then
			echo
			echo "Downloading zips..."
			echo
			local _zip=""
			local _zip_url=""
			for _zip in $_zips_to_install; do
				_zip_url="$_ftpurl/current/Hotfixes/$_zip"
				_download_patch_zip "$_zip_url"
			done
		fi
	fi
}


# Generate an HTML page of CW Hotfix links.
# Print start of html.
function _header() {
cat <<EOI
<html>
<head>
<title>CW Hotfixes</title>
<style type="text/css">
a:link      {color:rgb(25,25,25);}
a:visited   {color:rgb(25,25,25);}
a:focus     {color:rgb(25,25,25);}
a:hover     {color:rgb(25,25,25);background:#c0c0c0;}
a:active    {color:rgb(25,25,25);}
</style>
</head>
<body bgcolor="#acacac">
EOI
}

# Generate an HTML page of CW Hotfix links.
# Print end of html.
function _footer() {
local _date="$(date)"
cat <<EOI
<br>
<p>Generated by genhotfixhtml on $_date</p>
</body>
</html>
EOI
}

# Log into Etrack and create a session cook. We should only need to do this once.
_ETRACK_SESSION_COOKIE=genhotfixhtml_etrack_cookie.txt
function _getetracksessioncookie() {
    local _username="$1"
    local _password="$2"

    rm -f ./${_ETRACK_SESSION_COOKIE}  # Blow away any old cookie file.

    wget --secure-protocol=auto --no-check-certificate \
         --keep-session-cookies --save-cookies ${_ETRACK_SESSION_COOKIE} \
         --post-data "rememberval=1&username=$_username&password=$_password&database=etrack&rememberme=1&submit2=Login" \
         -qO- "$ENV_ETRACK_HOSTNAME_PORT/Etrack/newindex.php" >/dev/null
}
   

# Log into Jira and create a session cookie. We should only need to do this once.
_JIRA_SESSION_COOKIE=genhotfixhtml_cookie.txt
function _getjirasessioncookie() {
    local _username="$1"
    local _password="$2"

    rm -f ./${_JIRA_SESSION_COOKIE}  # Blow away any old cookie file.

    wget --secure-protocol=auto --no-check-certificate \
         --keep-session-cookies --save-cookies ${_JIRA_SESSION_COOKIE} \
         --post-data "os_username=$_username&os_password=$_password" \
         -qO- ${JIRA_HOSTNAME_PORT}/login.jsp >/dev/null
}

# Fetch an Etrack entry and extract the Abstract description.
# Example url: https://engtools.com/Etrack/printer_friendly.php?sid=etrack&incident=3664362
function _getEtrackTitle() {
    local _url="$1"
    local _title

#echo "*** _getEtrackTitle: _url=$_url" >&2

    _title=`wget --secure-protocol=auto --no-check-certificate \
                 --keep-session-cookies --load-cookies ${_ETRACK_SESSION_COOKIE} \
                 -qO- "$_url" | grep -A1 ';Abstract:' | sed -n "s#.*<b class='h4'>\([^<]*\)<.*#\1#p"`

#echo "*** _getEtrackTitle: _title=$_title" >&2

    echo "$_title"
}

# Fetch a Jira entry and extract the <title></title> value. 
# If the Jira is a placeholder for an Etrack, insert the Etrack 
# number at the front of the title, for example:
# ET-3641067 - [ESA-40127] Check-in JIRA for ETrack-3641067 - Syman eDiscovery Platform JIRA 
# Example Jira url: http://jira-new.cw-test.com:8092/browse/ESA-26152
function _getJiraTitle() {
    local _url="$1"
    local _jira_title=
    local _etrack_number=

    #_jira_title=`wget --secure-protocol=auto --no-check-certificate \
    #             --keep-session-cookies --load-cookies ${_JIRA_SESSION_COOKIE} \
    #             -qO- "$_url" | sed -n 's#.*<title>\(.*\)</title>.*#\1#p'`

    rm -f ${TMP}/getJiraTitle.tmp

    wget --secure-protocol=auto --no-check-certificate \
         --keep-session-cookies --load-cookies ${_JIRA_SESSION_COOKIE} \
         -qO- "$_url" > ${TMP}/getJiraTitle.tmp

    _jira_title=$(sed -n 's#.*<title>\(.*\)</title>.*#\1#p' "${TMP}/getJiraTitle.tmp" | sed 's/ - Syman eDiscovery Platform JIRA//')
    _etrack_number=$(_getEtrackNumber "${TMP}/getJiraTitle.tmp")

#echo "*** _getJiraTitle: _etrack_number=$_etrack_number" >&2

    if [ "x$_etrack_number" != "x" ]; then
        echo "$_etrack_number $_jira_title"
    else
        echo "$_jira_title"
    fi
}

# Determine if Jira page is a placeholder for an Etrack.
function _getEtrackNumber()
{
    local _page_contents="$1"
    local _etrack_number=""

    # Look for a recognizable Etrack URL and then extract the Etrack number.
    _etrack_number=$(sed -n 's#^.*https://engtools.com.*incident=\([0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\".*$#\1#p' "$_page_contents")

    if [ "x$_etrack_number" != "x" ]; then
        _etrack_number="ET-$_etrack_number"
    fi

#echo "*** _getEtrackNumber: _etrack_number=$_etrack_number" >&2

    echo "$_etrack_number"
}

# Get listing of ftp directory.
function _getHotfixesPage() {
    local _ftp_url="$1"

    if [ x"$_ftp_url" = x ]; then
        echo "Error: You must pass an FTP username and password string!"
	return
    fi

    # We use "wget --no-remove-listing" to get a listing of the FTP directory.
    # This generates .listing and index.html.N files in the current directory,
    # so we save the current working directory, generate our .listing files, extract 
    # the useful information, and then return to the saved working directory.
    _PWD_SAVED="$PWD"
    cd $TMP

    rm -f .listing
    `wget -q --no-remove-listing ${_ftp_url}/current/Hotfixes/`
    [ -f ".listing" ] && cat .listing

    rm -f .listing
    rm -f index.html.*
    cd "$_PWD_SAVED"
}

# Helper function to indicate if we should fetch each Jira title.
function _gettitle() {
    return 0
}

# Parse listing of FTP directory and generate HTML links.
function _parseHotfixesPage() {
    local _hfdir="$1"
    local _s
    local _array
    local _element
    local _oneoff_count
    local _etrack_number
    local _etrack_title

    let '_oneoff_count = 0'

    while read _s ; do
        # Fetch ESA-xxxx descriptions and create HTTP links.
        local _esas=$(echo $_s |  sed -n 's/^.*ESA\(-.*\).zip.*$/\1/p')
        if [ x"$_esas" != x ]; then
            let '_oneoff_count = _oneoff_count + 1'
            IFS='-' read -a _array <<< "$_esas"
            for _element in "${_array[@]}" ; do
                if [ x"$_element" != x ]; then
                    local _title=
		    if $(_gettitle); then
		       # Make several attempts to get title.
		       local _i
                       for ((i=0;i<3;i++)) ; do
                          _title="$(_getJiraTitle ${JIRA_HOSTNAME_PORT}/browse/ESA-$_element)"
			  [ x"$_title" != x ] && break
	               done
#echo "*** _parseHotfixesPage: _title=$_title" >&2
                       _etrack_number=$(echo "$_title" | grep -o '^ET-[0-9][0-9]*' | sed 's/ET-//')
                       if [ "x$_etrack_number" != "x" ]; then
                          # This is an Etrack placeholer. Get the Etrack title.
	                  local _etrack_url="https://engtools.com/Etrack/printer_friendly.php?sid=etrack&incident=$_etrack_number"
                          _etrack_title=$(_getEtrackTitle "$_etrack_url")
                          if [ "x$_etrack_title" != "x" ]; then
                              echo "<a href=\"$_etrack_url\" target=\"_NEW\">$_etrack_number: $_etrack_title</a>&nbsp;&nbsp;<b><a href=\"${JIRA_HOSTNAME_PORT}/browse/ESA-$_element\" target=\"_NEW\">[Etrack placeholder: ESA-$_element]</a></b><br>"
                          else
                              echo "<a href=\"$_etrack_url\" target=\"_NEW\">$_etrack_number: TITLE UNKNOWN &nbsp;<a href=\"${JIRA_HOSTNAME_PORT}/browse/ESA-$_element\" target=\"_NEW\">(ESA-$_element)</a><br>"
                          fi
                       else
                          # This is a regular Jira, i.e. not an Etrack placeholder.
                          if [ "x$_title" != "x" ]; then
                              echo "<a href=\"${JIRA_HOSTNAME_PORT}/browse/ESA-$_element\" target=\"_NEW\">$_title</a><br>"
                          else
                              echo "<a href=\"${JIRA_HOSTNAME_PORT}/browse/ESA-$_element\" target=\"_NEW\">ESA-$_element</a><br>"
                          fi
                       fi
                   fi
               fi
           done
        fi

        # Create HTTP link to vNNN_fixN.txt readme.
        local _readme_txt=$(echo $_s | sed -n 's/^.*\(v[0-9][0-9]*_fix[0-9][0-9]*.txt\).*$/\1/p')
        if [ x"$_readme_txt" != x ]; then
            echo "<a href=\"$_hfdir/current/Hotfixes/$_readme_txt\" target=\"_NEW\">$_readme_txt</a><br>"
        fi

        # Create HTTP link to pdf readme.
        local _readme_pdf=$(echo $_s | sed -n 's/^.*\(Syman .*.pdf\).*$/\1/p')
        if [ x"$_readme_pdf" != x ]; then
            # Replace space with %20
            local _readme_pdf_href=$(echo $_readme_pdf | sed 's/ /%20/g')
            echo "<a href=\"$_hfdir/current/Hotfixes/$_readme_pdf_href\" target=\"_NEW\">$_readme_pdf</a><br>"
        fi

        # Create HTTP link to vNNN_fixN.zip.
        local _hotfix_zip=$(echo $_s | sed -n 's/^.*\(v[0-9][0-9]*_.*.zip\).*$/\1/p')
        if [ x"$_hotfix_zip" != x ]; then
            echo "<a href=\"$_hfdir/current/Hotfixes/$_hotfix_zip\" target=\"_NEW\">$_hotfix_zip</a><br>"
        fi    
    done

    # Display count of one-offs
    echo "Total count of one-offs: $_oneoff_count<br>"
}

# Description:
#   Parse listings of the CW Hotfix directories and generate
#   a single HTML page with links to Hotfix readmes and ESAs.
#
#   Note: You need to define the following FTP username/password
#         environment variables somewhere for this function to work:
#         V66_CMD, V711_CMD, V712_CMD, etc
#
#   Example:
#         V66_CMD='ftp://username:password@ftp.hostname.com/'
#
# Usage:
#   genhotfixhtml
#
# Example:
#   genhotfixhtml > hotfixes.html
#
function genhotfixhtml() {
    if [ "$1" = '-h' ]; then
        usage genhotfixhtml
        return
    fi

    _header

    # If we are to display Jira titles then we first need to log into Jira and Etrack.
    if _gettitle ; then
        if [ x"$ENV_JIRA_USERNAME" = x ] || [ x"$ENV_JIRA_PASSWORD" = x ]; then
            echo "You must define ENV_JIRA_USERNAME and ENV_JIRA_PASSWORD!"
            return
        fi
        _getjirasessioncookie "$ENV_JIRA_USERNAME" "$ENV_JIRA_PASSWORD"
        _getetracksessioncookie "$ENV_ETRACK_USERNAME" "$ENV_ETRACK_PASSWORD"
    fi

    # Get all the patch ftp urls.
    local _ftpurls=$(_getftpurls)
    if [ "x$_ftpurls" = x ]; then
	echo "ERROR: Could not determine patch ftp urls"
    	return
    fi

    # Print a section of patches for each CW version.
    local _url
    for _u in $_ftpurls
    do
	local _ver=$(echo $_u | sed -n 's/\(V[0-9][0-9]*\)_CMD.*/\1/p')
	local _url=$(_getftpurls $_ver)

    	printf "<br><br><h3><a href=\"$_url\">$_ver</a></h3>\n"
    	printf "<a href=\"$_url/current/Hotfixes\" target=\"_NEW\">$_ver/current/Hotfixes</a><br>\n"
    	printf "<a href=\"$_url/nativeViewerInstaller\" target=\"_NEW\">$_ver/nativeViewerInstaller</a><br><br>\n"
    	_getHotfixesPage "$_url" | _parseHotfixesPage "$_url"
    done 

    _footer
}

# Function to test retrieving an Etrack Abstract description.
function test_etrack() {
	local _url='https://engtools.com/Etrack/printer_friendly.php?sid=etrack&incident=3664362'
        _getetracksessioncookie "$ENV_ETRACK_USERNAME" "$ENV_ETRACK_PASSWORD"
        local _title=$(_getEtrackTitle "$_url")
	echo "test_etrack: _title=$_title"
}

# Function to test retrieving a Jira that is a placeholder for an Etrack.
function test_etrack_placeholder() {
        #local _url='https://cw-jira.teneo-test.local/browse/ESA-40127'
        local _url='https://cw-jira.teneo-test.local/browse/ESA-39299'
	_getjirasessioncookie "$ENV_JIRA_USERNAME" "$ENV_JIRA_PASSWORD"
	local _title=$(_getJiraTitle "$_url")
	echo "test_etrack_placeholder: _title=$_title"
}

# END
