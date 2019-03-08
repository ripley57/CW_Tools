#!/bin/sh
# Description:
#    Create a ~/.bash_profile file if one doesn't exist, 
#    and add the necessary code to load  cw_bash_profile.
#
# Usage:
#    sh ./install.sh

# Print code to insert into ~/.bash_profile
function profile_code() 
{
    cat <<EOI
##############################
##  START OF INSTALL INSERT ##
##############################

[ "\$OS" = Windows_NT ] && set -o igncr

# Prevent warning about /tmp not existing.
[ "\$OS" = Windows_NT ] && mkdir -p /tmp

# Return path to user's home directory.
function gethomedir()
{
    if [ "\$(uname)" = "Linux" ]; then
        echo "\$HOME"
    else
        local _homedrive=\$(echo "\$HOMEDRIVE" | sed 's/://')
        local _homepath=\$(echo "\$HOMEPATH" | sed 's#\\\#/#g')
        local _homedir="/cygdrive/\${_homedrive}/\${_homepath}"
        echo "\${_homedir}"
    fi
}

# Add CYGWIN_HOME/bin to front of path, so that we do not
# end up in a mess by unexpectedly calling windows commands
function set_bin_path()
{
   if [ "\$OS" = Windows_NT ]; then
      local _cygpath_exe=\$(which cygpath)
      local _cygwin_bin_dir=\$(dirname \$_cygpath_exe)
      PATH=\$_cygwin_bin_dir:\$PATH
      export PATH
   fi
}
set_bin_path

# Include CW tools.
ENV_INCLUDE_CW_TOOLS=yes

# OPTIONAL: Extra tools
#ENV_EXTRA_TOOLS="mp3 lxf"

# OPTIONAL: LXF Downloads
ENV_LXF_MEMBER_NUMBER=0001234567
ENV_LXF_MEMBER_SURNAME=XXXXXX

# OPTIONAL: Hotfix FTP directories
#V66_CMD='ftp://username:password@hostname'
#V711_CMD='ftp://username:password@hostname'
#V712_CMD='ftp://username:password@hostname'
#V713_CMD='ftp://username:password@hostname'
#V714_CMD='ftp://username:password@hostname'
#V715_CMD='ftp://username:password@hostname'

# Locations of the upload and download DB directories.
# Used when transferring large files in chunks via DB.
ENV_DB_UPLOAD_DIR=/cygdrive/c/users/jeremy.c/Dropbox/Public/tmp
ENV_DB_DOWNLOAD_DIR=/cygdrive/c/users/jcdc/Dropbox/Public/tmp

# Load cw_bash_profile and tools.
CW_BASH_PROFILE_PATH=~/CW_Tools/cw_bash_profile
export CW_BASH_PROFILE_PATH
. "\$CW_BASH_PROFILE_PATH"

# Load optional bash aliases.
[ -f ~/CW_Tools/aliases ] && . ~/CW_Tools/aliases
	
# OPTIONAL: Specify credentials for CW database.
#ENV_DB_USER=dbuser
#ENV_DB_PASSWORD=dbpassword
#ENV_DB_HOSTNAME=localhost

# OPTIONAL: Specify hostname and port for Subversion website.
#ENV_SVN_HOSTNAME_PORT=website:port

# OPTIONAL: Specify hostname for secondary source wbesite.
#ENV_SRC_HOSTNAME=srcwebsite

# OPTIONAL: Specify hostname:port and credentials for Jira website.
#JIRA_HOSTNAME_PORT=https://cw-jira.teneo-test.local
#ENV_JIRA_USERNAME=username
#ENV_JIRA_PASSWORD=password

# OPTIONAL: Specify hostname:port and credentials for Etrack website.
#ENV_ETRACK_HOSTNAME_PORT=
#ENV_ETRACK_USERNAME=username
#ENV_ETRACK_PASSWORD=password

# OPTIONAL: Specify default web browser.
ENV_WEB_BROWSER="/cygdrive/c/Program Files/Internet Explorer/iexplore.exe"

# OPTIONAL: Specify preferred text editor.
ENV_TEXT_EDITOR="\$TOOLS_DIR/notepad++/Notepad++.exe"

# OPTIONAL: Specify location of Beyond Compare (bcompare.exe)
ENV_BC_EXE="/cygdrive/c/Program Files/Beyond Compare 4/bcompare.exe"

# OPTIONAL: Pre-load any directory paths that you use often.
#presavedir 1 "/cygdrive/d/CW/V66/exe/filefilter" "stellent dir"

# Pre-load previously saved directory paths.
_homedir=\$(gethomedir)
if [ -f "\${_homedir}/.presave" ]; then
   echo "Loading \${_homedir}/.presave ..."
   . "\${_homedir}/.presave"
fi

# OPTIONAL: Pre-load all the CW cache directory paths.
#presavecachedirs

# Functions that might make sense to call at startup.
#find_set_mark

# Function intended to be called only once.
function callonce() {
	[ -f "\${HOME}/.callonce" ] && return
	setquickedit
	touch "\${HOME}/.callonce"
}
callonce

############################
##  END OF INSTALL INSERT ##
############################
EOI
}

function enable_syntax_highlighting() {
    if [ -f /usr/bin/vim ]; then
       cat >> ~/.vimrc <<EOI
syntax on
EOI
    fi
}

enable_syntax_highlighting

if [ ! -f "$HOME/.bash_profile" ]; then
    # .bash_profile does not exist, so create it. 
    profile_code > "$HOME/.bash_profile"
    echo
    echo "Created $HOME/.bash_profile for loading CW_Tools."
    echo
else
    # .bash_profile exists.
    cat "$HOME/.bash_profile" | grep -v '^#' | grep -q -i cw_bash_profile
    if [ $? -eq 0 ]; then
        echo
        echo "It looks like you already have your .bash_profile configured for CW_Tools, so I will do nothing."
        echo
    else
        # Add profile code to the END of the existing .bash_profile
        profile_code >> "$HOME/.bash_profile"
        echo
        echo "Your .bash_profile has been updated to load CW_Tools."
        echo 
    fi
fi
