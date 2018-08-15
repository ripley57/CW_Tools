TOOLS_DIR=$*

# Description:
# Common OpenLDAP commands.
#
# Download of OpenLDAP for Windows:
# http://www.userbooster.de/en/download/openldap-for-windows.aspx
#
# Usage:
#   openldaphelp
#
function openldaphelp() {
    if [ "$1" = '-h' ]; then
        usage openldaphelp
        return
    fi
	
	cat <<EOI
How to determine slapd process:
C:\OpenLDAP\run\slapd.pid

How to clear the OpenLDAP database:
o Stop the OpenLDAP service (services.msc).
o Delete the contents of the "C:\OpenLDAP\data" directory.
o Start the OpenLDAP service. This will create new database files.

NOTE: 
ldap* commands require OpenLDAP to be running. 
slap* commands should be run when OpenLDAP is stopped.  

slappasswd
==========
Use slappasswd to generate a new password and then manually paste
it into the slapd.conf file.

slapadd
=======
o How to import an LDIF file into OpenLDAP:
C:\OpenLDAP>slapadd.exe -v -l c:\demo1.ldif

slapcat
======= 
o How to dump the database contents as an LDIF file:
C:\OpenLDAP>slapcat.exe -b "dc=maxcrc,dc=com" -l c:\dump.ldif
	
ldapsearch
==========
o Search filter syntax: 
https://www.ietf.org/rfc/rfc2254.txt (see also page 91 of OpenLDAP book).
o Example 1. Using simple bind (-x), i.e. with no SASL. 
C:\OpenLDAP>ClientTools\ldapsearch.exe -x -D "cn=Manager,dc=maxcrc,dc=com" -w pwd -b "dc=maxcrc,dc=com" "(&(objectclass=inetOrgPerson)(|(mail=carter*)))"
o Example 2. More complex search filter and print result in LDIF format (-LL).
C:\OpenLDAP>ClientTools\ldapsearch.exe -x -LL -D "cn=Manager,dc=maxcrc,dc=com" -w pwd -b "dc=maxcrc,dc=com" "(&(objectclass=inetOrgPerson)(|(mail=carter*)(cn=Jerry*)))"
o Example 3. With hostname and port number.
C:\OpenLDAP>ClientTools\ldapsearch.exe -H "ldap://localhost:389" -x -LL -D "cn=Manager,dc=maxcrc,dc=com" -w pwd -b "dc=maxcrc,dc=com" "(&(objectclass=inetOrgPerson)(|(mail=carter*)(cn=Jerry*)))"
	
EOI
}
