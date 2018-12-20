# Tools to load.

if [ "$(uname)" != "Linux" ]
then
	WGET=wget
	NETCAT=netcat
else
	MP3=mp3
fi

function tools() {
    if [ "$ENV_INCLUDE_CW_TOOLS" = "yes" ]; then
        ENV_CW_TOOLS="cw lfitools dbtools patches notespeek fileid cwbcommands"
    fi

    cat <<EOI
gawk mfcmapi jd-gui jgit luke myjgui dependencywalker sysinternals mlcfg32 presavedir ydoc stripbom explorer openssl $WGET $NETCAT splitjoin 
pawk sawk fiddler2 notepad++ xmltools vim jetty gettimenow setlmtime listlmtimes filetimes settimenow getmfctime encoder hex filetools $ENV_CW_TOOLS 
$ENV_EXTRA_TOOLS download iexplorer snip wireshark Bit bc utf8tool image include git scripts ldap c# windbg shortcuts registry ldp $MP3 
pi addbom cygwin email java javascript uml fc ant 
EOI
}
