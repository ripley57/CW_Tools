TOOLS_DIR=$*

# Description:
#   Test maximum encryption key length supported by the installed
#   Java version. If this command returns "128" then the Java does
#   not currently have the "Unlimited Strength Jurisdiction Policy Files"
#   installed in the Java Cryptography Extension (JCE). These policy
#   files are simply replacements for the files local_policy.jar and 
#   US_export_policy.jar which are by default not included due to export
#   restrictions in some countries.
#
# Usage:
#   maxkeylen
#
# Example usage:
#   maxkeylen
#   128
# 
function maxkeylen() {
    if [ "$1" = '-h' ]; then
        usage maxkeylen
        return
    fi

    (cd "$TOOLS_DIR/openssl" && _maxkeylen_compile)
    (cd "$TOOLS_DIR/openssl" && _maxkeylen_run)
}

# Compile the Java program.
function _maxkeylen_compile() {
    if [ ! -f MaxKeyLen.class ] || [ -n "$(find . -name MaxKeyLen.class -mmin +120)" ]
    then
	echo "Compiling MaxKeyLen.java ..."
	javac -classpath . MaxKeyLen.java
    fi
}

# Run the Java program.
function _maxkeylen_run() {
    java -classpath . MaxKeyLen
}

# Description:
#   Launch openssl.exe.
#
# Useful References:
#   Most used OpenSSL commands:
#     https://www.openssl.org/docs/manmaster/apps/s_client.html
#     https://www.openssl.org/docs/manmaster/apps/s_server.html    
#     https://www.openssl.org/docs/manmaster/apps/ciphers.html
#
#   Mapping cipher suite names from RFC to OpenSSL names:
#     https://testssl.sh/openssl-rfc.mappping.html
#
#   Common cipher suites and what they are used for:
#     https://en.wikipedia.org/wiki/Cipher_suite
#     http://www.thesprawl.org/research/tls-and-ssl-cipher-suites/
#
#   Protocols and cipher suites supported by Java versions: 
#     https://docs.oracle.com/javase/8/docs/technotes/guides/security/SunProviders.html#SunJSSEProvider
#     https://docs.oracle.com/javase/7/docs/technotes/guides/security/SunProviders.html#SunJSSEProvider
#     https://docs.oracle.com/javase/6/docs/technotes/guides/security/SunProviders.html#SunJSSEProvider
#
#   Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files:
#     http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html
#     http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html 
#     http://www.oracle.com/technetwork/java/javase/downloads/jce-6-download-429243.html
#
#   Tommcat Connector configuration:
#   (See "ciphers" setting. Note: CW does not use OpenSSL):
#     https://tomcat.apache.org/tomcat-7.0-doc/config/http.html
#
# Usage:
#   openssl <normals input arguments for openssl.exe>
#
# Example usage:
#
#   openssl s_client -showcerts -connect localhost:443
#   openssl s_client -showcerts -connect localhost:443 -CAfile ./root.txt -state -debug
#   openssl s_client -cipher ECDHE-RSA-AES128-GCM-SHA256 -connect localhost:443 
#   openssl s_client -connect example.com:443 [ -ssl3 | -tls1_2 | -tls1_1 ]
#   openssl s_server -accept 4443 -no_ssl3 -www -msg -cert cert.pem -key key.pem -cipher RC4-MD5:RC4-SHA:AES128-SHA
#   openssl ciphers -v -ssl2
#   openssl ciphers -v -ssl3
#   openssl ciphers -v -tls1
#   openssl x509 -text -in cert.pem
#
#   Convert file to base64:
#   openssl base64 -in TestPDF.pdf > TestPDF_base64.txt 
#   Decode base64:
#   openssl enc -base64 -d -in b64.txt > decoded.txt
#
function openssl() {
    if [ "$1" = '-h' ]; then
        usage openssl
        return
    fi
    export OPENSSL_CONF=$(cygpath -w $TOOLS_DIR/openssl/dummy.cnf)
	$TOOLS_DIR/openssl/OpenSSL-Win32_1_0_1e/bin/openssl.exe $*
}

# Description:
#   Launch openssl.exe version 0.9.8k (OpenSSL 0.9.8k 25 Mar 2009).
#
#   Note:
#   This version of OpenSSL pre-dates the fix for the SSL
#   renegotiation issue CVE-2009-3555. The fix for this issue
#   was for clients and servers to implement RFC5746. Since
#   OpenSSL version 0.9.8k cannot 'talk' RFC5746, and servers
#   configured to more stricly obey RFC5746 are likely to abort
#   at the initial connection handshake stage.
#   (See https://community.qualys.com/thread/2208)
#
# Usage:
#   openssl
#
function openssl_0_9_8k() {
    if [ "$1" = '-h' ]; then
        usage openssl_0_9_8k
        return
    fi
    export OPENSSL_CONF=$(cygpath -w $TOOLS_DIR/openssl/dummy.cnf)
    $TOOLS_DIR/openssl/OpenSSL-Win32_0_9_8k/bin/openssl.exe $*
}

# Description:
#   Launch openssl.exe version 1.0.1e (OpenSSL 1.0.1e 11 Feb 2013).
#
# Usage:
#   openssl
#
function openssl_1_0_1e() {
    if [ "$1" = '-h' ]; then
        usage openssl_1_0_1e
        return
    fi
    export OPENSSL_CONF=$(cygpath -w $TOOLS_DIR/openssl/dummy.cnf)
    $TOOLS_DIR/openssl/OpenSSL-Win32_1_0_1e/bin/openssl.exe $*
}

# Description:
#   Launch openssl.exe version 1.0.2h (OpenSSL 1.0.2h  3 May 2016).
#
# Usage:
#   openssl
#
function openssl_1_0_2h() {
    if [ "$1" = '-h' ]; then
        usage openssl_1_0_2h
        return
    fi
    export OPENSSL_CONF=$(cygpath -w $TOOLS_DIR/openssl/dummy.cnf)
    $TOOLS_DIR/openssl/OpenSSL-Win32_1_0_2h/bin/openssl.exe $*
}

# Description:
#   Launch openssl.exe version 1.0.2h with Kerberos (OpenSSL 1.0.2h  3 May 2016).
#
# Usage:
#   openssl
#
function openssl_1_0_2h_krb() {
    if [ "$1" = '-h' ]; then
        usage openssl_1_0_2h_krb
        return
    fi
    export OPENSSL_CONF=$(cygpath -w $TOOLS_DIR/openssl/dummy.cnf)
    $TOOLS_DIR/openssl/OpenSSL-Win32_1_0_2h_krb5/bin/openssl.exe $*
}
