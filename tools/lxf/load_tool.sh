TOOLS_DIR=$*

_SESSION_COOKIE=lxf_cookie.txt
function _lxf_getsessioncookie() {
    local _member_number="$1"
    local _surname="$2"

    rm -f ./${_SESSION_COOKIE}  # Blow away any old cookie file.

    local _loginpath='http://www.linuxformat.com/subsarea'

    wget --tries=2 \
         --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" \
         --secure-protocol=auto --no-check-certificate \
         --keep-session-cookies --save-cookies ${_SESSION_COOKIE} \
         --post-data "Number=$_member_number&Surname=$_surname" \
         -qO- ${_loginpath} >/dev/null
}

function _getLXF() {
    local _url="$1"
    local _local_file_name="$2"

    wget --tries=2 \
         --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" \
         --limit-rate=200k --secure-protocol=auto --no-check-certificate \
         --keep-session-cookies --load-cookies ${_SESSION_COOKIE} \
         -qO "$_local_file_name" "$_url"

    #local _url_code="http://www.linuxformat.com/includes/download.php?PDF=LXF${_edition}.code.tgz"
    #wget --tries=2 \
    #     --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" \
    #     --limit-rate=200k --secure-protocol=auto --no-check-certificate \
    #     --keep-session-cookies --load-cookies ${_SESSION_COOKIE} \
    #     -qO "LXF${_edition}.code.tgz" "${_url_code}"
}

# Get range of LXF editions.
function _lxf_get_range() {
    local _min=$1
    local _max=$2
    local _url=
    local _local_file_name=

    if [ $_min -le 60 ]; then
        echo "Downloads for editions 60 below could not be found"
        return
    fi

    for ((i=${_max}; i>=${_min}; i--)) 
    do
        echo "Getting LXF edition $i..."
        if [ $i -gt 133 ]; then
            _url="http://www.linuxformat.com/includes/downloads.php?PDF=LXF${i}.complete.pdf"
	    _local_file_name="LXF${i}.pdf"
        else
            _url="http://www.linuxformat.com/includes/downloads.php?PDF=${i}-full.zip"
            _local_file_name="LXF${i}.zip"
        fi
	sleep 2
	_getLXF "$_url" "$_local_file_name"
    done
}

# Login to LXF site and get session cookie.
function _lxf_login() {
    echo "Getting session cookie..."
    _lxf_getsessioncookie "$ENV_LXF_MEMBER_NUMBER" "$ENV_LXF_MEMBER_SURNAME"
    sleep 1
    _lxf_getsessioncookie "$ENV_LXF_MEMBER_NUMBER" "$ENV_LXF_MEMBER_SURNAME"
}

# Test to fetch a single edition.
function _lxf_test() {
    _lxf_login
    sleep 1
    _getLXF 179
}

# Description: 
#   Get range of LXF editions.
#
# Usage
#   getAllLXF <min> <max>
#
# Example usage:
#   getAlLXF 169 179  
#
function getAllLXF() {
    if [ $# -ne 2 -o "$1" = '-h' ]; then
        usage getAllLXF
        return
    fi
    _lxf_login
    _lxf_get_range $1 $2
}
