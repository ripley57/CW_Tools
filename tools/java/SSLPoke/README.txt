SSLPoke
=======

The main point of this tool is too indicate the server cert chain that you need to add to your
local client-side Java cacerts file in order to prevent client-side connection errors such as 
"unable to find valid certification path to requested target"

Run the tool with -Ddump_certs to create a local certs.dat file containing the server cert chain, e.g.:
java -Ddump_certs SSLPoke edp-ad.edp.lab 636

To simply verify the connection (implicitly using the local Java cacerts file):
java SSLPoke edp-ad.edp.lab 636

If you want too see more debug info, remember you can use the Java built-in debug property:
java -Djavax.net.debug=ssl SSLPoke edp-ad.edp.lab 636



Example of the type of a client-side handshake failure that SSLPoke is useful for troubleshooting:

$JAVA_HOME/bin/java SSLPoke jira.example.com 443
sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
	at sun.security.validator.PKIXValidator.doBuild(PKIXValidator.java:387)
	at sun.security.validator.PKIXValidator.engineValidate(PKIXValidator.java:292)
	at sun.security.validator.Validator.validate(Validator.java:260)
	at sun.security.ssl.X509TrustManagerImpl.validate(X509TrustManagerImpl.java:324)
	at sun.security.ssl.X509TrustManagerImpl.checkTrusted(X509TrustManagerImpl.java:229)
	at sun.security.ssl.X509TrustManagerImpl.checkServerTrusted(X509TrustManagerImpl.java:124)
	at sun.security.ssl.ClientHandshaker.serverCertificate(ClientHandshaker.java:1351)
	at sun.security.ssl.ClientHandshaker.processMessage(ClientHandshaker.java:156)
	at sun.security.ssl.Handshaker.processLoop(Handshaker.java:925)
	at sun.security.ssl.Handshaker.process_record(Handshaker.java:860)
	at sun.security.ssl.SSLSocketImpl.readRecord(SSLSocketImpl.java:1043)
	at sun.security.ssl.SSLSocketImpl.performInitialHandshake(SSLSocketImpl.java:1343)
	at sun.security.ssl.SSLSocketImpl.writeRecord(SSLSocketImpl.java:728)
	at sun.security.ssl.AppOutputStream.write(AppOutputStream.java:123)
	at sun.security.ssl.AppOutputStream.write(AppOutputStream.java:138)
	at SSLPoke.main(SSLPoke.java:31)
Caused by: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
	at sun.security.provider.certpath.SunCertPathBuilder.build(SunCertPathBuilder.java:145)
	at sun.security.provider.certpath.SunCertPathBuilder.engineBuild(SunCertPathBuilder.java:131)
	at java.security.cert.CertPathBuilder.build(CertPathBuilder.java:280)
	at sun.security.validator.PKIXValidator.doBuild(PKIXValidator.java:382)
	... 15 more

	
JeremyC 12-07-2018

