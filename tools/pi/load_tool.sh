TOOLS_DIR=$*

# Remember the last IP and URL values.
ACE_URL=
# Initialise the IP with any previously cached value.
ACE_IP=$(cache "ACE_IP")
# Description:
#   Extract acestream links from a specified web url. Create 
#   a history.txt file and upload it to the Pi Plexus program.
#
#   This function will determine, from the format of each 
#   input argument, whether it is an IP address or a web url.
#
#   The passed url and ip arguments are cached, so that 
#   re-scraping and uploading any changes to the links can 
#   be achieved by simply typing the function name "ace".
#
#   The Pi ip value is cached under the user's home directory,
#   as this is not expected to change very often. In contrast,
#   the url of the web page to scrape is only cached in the
#   Cygwin session.
#
# Usage:
#   ace [-e] [ip] [url] [nosop] [noace]
#
# Where:
#   -e      Launch IE.
#   ip      IP address of the Pi.
#   url     Web page to scrape.
#   nosop   Do not scrape sopcast urls.
#   noace   Do not scrape ace urls.
#
# Examples:
#   ace -e                                                 Launch IE.
#   ace 192.168.1.5 https://streaming.com/30709.html       Scrape URL and upload history.txt to Pi.	
#   ace https://104.28.2.7/30709.html                      Scrape URL and upload history.txt to Pi, if IP known.
#   ace 192.168.1.2                                        Scrape URL if known, and upload history.txt to Pi.
#   ace                                                    Scrape URL if known, and upload history.txt to Pi, if IP known.
# 
function ace() {
    if [ "$1" = '-h' ]; then
        usage ace
        return
    fi
	
    local _ip=
    local _url=
    local _launch_ie=false
    local _sop=true
    local _ace=true
    while (( $# > 0 )); do
        local _arg=$1
        if [[ $_arg =~ [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ ]]; then
            _ip=$_arg
            # Remember ip.
            ACE_IP=$_arg
        elif [[ $_arg =~ ^https?://.* ]]; then
            _url=$_arg
            # Remember url.
            ACE_URL=$_arg
        elif [[ $_arg =~ \-e ]]; then
            _launch_ie=true
        elif [[ $_arg = nosop ]]; then
            _sop=false
        elif [[ $_arg = noace ]]; then
            _ace=false
        fi
        shift
    done

    # Launch web browser if requested.
    if [[ $_launch_ie =~ true ]] || [[ -z $ACE_URL ]]; then
        local _browser=$(_get_web_browser)
        "${_browser}" "https://streaming.com/foot" &
        return
    fi

    if [[ ! -z $ACE_URL ]]; then
        # Always re-scrape if URL is known.
        _acestream_extractlinks $ACE_URL sop=$_sop ace=$_ace
    fi

    if [[ ! -z $_ip ]]; then
        # Pi IP was specified, so cache it for next time.
        # Note: Unlike the url value, which is likely to change often,
        #       the Pi IP will not change often, so we cache the value 
        #       in a flat file, using the "cache" function.
        cache "ACE_IP" $_ip
    fi

    if [[ ! -z $ACE_IP ]]; then
        # Pi IP is known, so upload history.txt file, if present.
        if [ -f history.txt ]; then
            _acestream_uploadlinks $ACE_IP
        fi
    fi
}

# Extract acestream links and generate a plexus history.txt file.
function _acestream_extractlinks() {
    local _url=$1

    local _extract_sop=false
    local _extract_ace=false
	while (( $# > 0 )); do
	    local _arg=$1
		if   [[ $_arg =~ sop=.* ]]; then
		    _extract_sop=$(echo $_arg | grep -o -P '(?<=sop=).*')
		elif [[ $_arg =~ ace=.* ]]; then
		    _extract_ace=$(echo $_arg | grep -o -P '(?<=ace=).*')
		fi
        shift
    done

    rm -f history.txt
    let c=0 
    if [[ $_extract_ace = "true" ]]; then
	    echo "Extracting ACE links from ${_url} ..."
        for f in $(wget -qO- ${_url} | grep -o -P '"acestream://[^"]*"' | sed 's/"//g')
        do
            let c=c+1
            cat >>history.txt <<EOI
ACE_LINK_${c}|${f}|1|/storage/.kodi/addons/program.plexus/resources/art/acestream-menu-item.png
EOI
        done
    fi
	if [[ $_extract_sop = "true" ]]; then
	    echo "Extracting SOP links from ${_url} ..."
        for f in $(wget -qO- ${_url} | grep -o -P '"sop://[^"]*"' | sed 's/"//g')
        do
            let c=c+1
            cat >>history.txt <<EOI
SOP_LINK_${c}|${f}|2|/storage/.kodi/addons/program.plexus/resources/art/sopcast_logo.jpg
EOI
        done
	fi
	if [ -f history.txt ]; then
	    echo "${c} links extracted."
	else
	    echo "No links extracted!"
	fi
}

# Copy the new history.txt file to the plexus program directory.
function _acestream_uploadlinks() {
    local _ipaddr=$1
    echo "Uploading history.txt to Pi @ ${_ipaddr} ..."
    scp ./history.txt root@${_ipaddr}:/storage/.kodi/userdata/addon_data/program.plexus/
}
