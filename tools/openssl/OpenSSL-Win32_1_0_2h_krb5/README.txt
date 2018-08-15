ME: This is my attempt to build openssl.exe with kerberos support. The build was successful, but I haven't tested the client yet.

Building OpenSSL-1_0_2h with Kerberos support:

o MIT Kerberos download for Windows (pre-built, but includes "custom" option to install SDK, i.e. include and lib files):
http://web.mit.edu/kerberos/dist/
http://web.mit.edu/kerberos/dist/#kfw-4.1

o Launch VC++ shortcut from desktop (“C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"" x86”).

o perl Configure VC-WIN32 no-asm --with-krb5-dir=C:/MIT/Kerberos --with-krb5-flavor=MIT --prefix=C:/OpenSSL-Build
(see here for options: https://github.com/ChatSecure/OpenSSL/blob/master/Configure)	

o ms\do_ms

o nmake -f ms\ntdll.mak

o nmake -f ms\ntdll.mak install 
This will populate directory C:/OpenSSL-Build.

(All command-line options: https://github.com/ChatSecure/OpenSSL/blob/master/Configure).

JeremyC 26/12/2016.