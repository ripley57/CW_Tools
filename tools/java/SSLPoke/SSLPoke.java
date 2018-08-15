/*
** Code from here:
** 	http://jexp.ru/index.php/Java_Tutorial/Security/SSL_Socket
**	https://confluence.atlassian.com/kb/unable-to-connect-to-ssl-services-due-to-pkix-path-building-failed-779355358.html
**
** JeremyC 11-07-2018
*/

import java.io.InputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.ObjectOutputStream;
import java.io.PrintStream;
import java.io.StringWriter;
import java.security.cert.CertPath;
import java.security.cert.CertificateFactory;
import java.security.cert.CertificateEncodingException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.security.KeyStore;
import java.util.ArrayList;
import java.util.Base64.Encoder;

import java.util.List;
import javax.net.ssl.SSLHandshakeException;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;
import javax.xml.bind.DatatypeConverter;
 
public class SSLPoke
{
   public static void main(String[] paramArrayOfString)
   {
     if (paramArrayOfString.length != 2) {
		System.out.print("                                                                               \n" +
				"SSLPoke:                                                                       \n" +
				"   Utility to debug Java connections to SSL servers.                           \n" +
				"                                                                               \n" +
				"*** IMPORTANT ***                                                              \n" +
				"Be sure to use the same path to java.exe that the client-side product          \n" +
				"uses that you are trying to replicate here. This is to ensure that you         \n" +
				"use the same Java trust-store file \"jre\\lib\\security\\cacerts\".            \n" +
				"                                                                               \n" +
				"Usage:                                                                         \n" +
				"   java " + SSLPoke.class.getName() + " <host> <port>                          \n" +
				"                                                                               \n" +
				"   To capture the server cert chain to file \"server-certs.pem\":              \n" +
				"   java -Ddump_certs " + SSLPoke.class.getName() + " <host> <port>             \n" +
				"                                                                               \n" +
				"   NOTE:                                                                       \n" +
				"   o Because the certs were sent from the server and contain no private key,   \n" +
				"     it should be safe to decode them using a tool such as                     \n" +
				"     https://www.sslshopper.com/certificate-decoder.html                       \n" +
				"   o Alternatively, you can examine the contents of \"server-cert-chain.log\"  \n" +
				"                                                                               \n" +
				"   To see (Sun/Oracle) Java built-in SSL debugging:                            \n" +
				"   java -Djavax.net.debug=ssl " + SSLPoke.class.getName() + " <host> <port>    \n" +
				"                                                                               \n" +
				"Example usage:                                                                 \n" +
				"   Testing the LDAPS connection to ldaps://edp-ad.edp.lab:636 ...              \n" +
				"   java " + SSLPoke.class.getName() + " edp-ad.edp.lab 636                     \n" +
				"                                                                               \n" +
				"   Capture the server cert chain:                                              \n" +
				"   java -Ddump_certs" + SSLPoke.class.getName() + " edp-ad.edp.lab 636         \n" +
				"   This generates files \"server-certs.pem\" and \"server-cert-chain.log\"     \n" +
				"                                                                               \n" +
				"Example of adding a cert pem file into the local Java cacerts file:            \n" +
				"   C:\\jdk-8u144-windows-x64\\bin\\keytool.exe -import -trustcacerts -alias    \n" +
				"   server-root-ca-cert -file D:\\root.pem                                      \n" +
				"   -keystore C:\\jdk-8u144-windows-x64\\jre\\lib\\security\\cacerts -storepass changeit\n" +
				"                                                                               \n");
		System.exit(1);
     }
	 
     try {
		SSLSocketFactory localSSLSocketFactory;
		String dump_certs = System.getProperty("dump_certs", null);
		if (dump_certs != null) {
			/*
			** We want to dump the server cert(s) being returned by the server.
			** We're not concerned about reporting any client-side validation
			** error due to the server cert chain. To do this, and ignore any
			** validation error, we need to create our own TrustManager that
			** is very forgiving about the server cert chain.
			*/
			SSLContext context = SSLContext.getInstance("TLSv1.2");
			KeyManagerFactory keyManagerFactory = createAndInitKeyManagerFactory();
			context.init(keyManagerFactory.getKeyManagers(), new TrustManager[] { createRelaxedTrustManager() }, null);
			localSSLSocketFactory = (SSLSocketFactory)context.getSocketFactory();
		} else {
			/*
			** Use the default socket factory. If the server cert chain is
			** not valid then this will report a client-side exception.
			*/
			localSSLSocketFactory = (SSLSocketFactory)SSLSocketFactory.getDefault();
		}
		SSLSocket localSSLSocket = (SSLSocket)localSSLSocketFactory.createSocket(paramArrayOfString[0], Integer.parseInt(paramArrayOfString[1]));
	   
		if (dump_certs != null) {
			/*
			** Just dump the server cert chain and exit.
			*/
			FileOutputStream f = new FileOutputStream("server-certs.pem");
			localSSLSocket.startHandshake();
			SSLSession session = localSSLSocket.getSession();
			java.security.cert.Certificate[] servercerts = session.getPeerCertificates();
			List mylist = new ArrayList();
			for (int i = 0; i < servercerts.length; i++) {
				f.write(certToString((X509Certificate)servercerts[i]).getBytes());
				mylist.add(servercerts[i]);
			}
			f.flush();
			f.close();
			System.out.println("Server certs dumped to \"server-certs.pem\"");
			
			FileOutputStream f2 = new FileOutputStream("server-cert-chain.log");
			CertificateFactory cf = CertificateFactory.getInstance("X.509");
			CertPath cp = cf.generateCertPath(mylist);
			f2.write(cp.toString().getBytes());
			f2.flush();
			f2.close();
			System.out.println("Server cert chain info in \"server-cert-chain.log\"");

			System.exit(0);
	   }

	   /*
	   ** See if the client connection to the server works or not.
	   */
       InputStream localInputStream = localSSLSocket.getInputStream();
       OutputStream localOutputStream = localSSLSocket.getOutputStream();
       localOutputStream.write(1);
       while (localInputStream.available() > 0) {
         System.out.print(localInputStream.read());
       }
       System.out.println("Successfully connected");
       System.exit(0);
     }
     catch (SSLHandshakeException localSSLHandshakeException) {
       if (localSSLHandshakeException.getCause() != null)
         localSSLHandshakeException.getCause().printStackTrace();
       else
         localSSLHandshakeException.printStackTrace();
     }
     catch (Exception localException) {
       localException.printStackTrace();
     }
     System.exit(1);
   }
   
   // From https://stackoverflow.com/questions/3313020/write-x509-certificate-into-pem-formatted-string-in-java
   private static String certToString(X509Certificate cert) {
		StringWriter sw = new StringWriter();
		try {
			sw.write("-----BEGIN CERTIFICATE-----\n");
			sw.write(DatatypeConverter.printBase64Binary(cert.getEncoded()).replaceAll("(.{64})", "$1\n"));
			sw.write("\n-----END CERTIFICATE-----\n");
		} catch (CertificateEncodingException e) {
			e.printStackTrace();
		}
		return sw.toString();
	}
	
	// return the client-side Java cacerts trust store.
	private static KeyStore localTrustStore() throws Exception
	{
		KeyStore clientKeyStore = KeyStore.getInstance("JKS");
		
		// Here we could point to any trust store, but, for now, let's comment-out
		// the following code and use the default trust store, which will be the
		// cacerts file in the Java installation directory, e.g.:
		// C:/jdk-8u144-windows-x64/jre/lib/security/cacerts
		//InputStream readStream = new FileInputStream("C:/jdk-8u144-windows-x64/jre/lib/security/cacerts");
		//clientKeyStore.load(readStream, "changeit".toCharArray());
		//readStream.close();
		
		clientKeyStore.load(new FileInputStream(
            System.getProperties()
                  .getProperty("java.home") + File.separator
                + "lib" + File.separator + "security" + File.separator
                + "cacerts"), "changeit".toCharArray());
		
		return clientKeyStore;
	}
	
	private static KeyManagerFactory createAndInitKeyManagerFactory() throws Exception {
		KeyStore clientKeyStore = localTrustStore();
		KeyManagerFactory keyManagerFactory = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
		keyManagerFactory.init(clientKeyStore, "changeit".toCharArray());
		return keyManagerFactory;
	}
	
	private static TrustManager createRelaxedTrustManager() throws Exception {
		TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
		tmf.init(localTrustStore());
		
		// Get hold of the default trust manager
		X509TrustManager defaultTm = null;
		for (TrustManager tm : tmf.getTrustManagers()) {
			if (tm instanceof X509TrustManager) {
				defaultTm = (X509TrustManager) tm;
				break;
			}
		}
		final X509TrustManager finalDefaultTM = defaultTm;
	
		// Create our own trust manager.
		X509TrustManager customTm = new X509TrustManager() {
			@Override
			public X509Certificate[] getAcceptedIssuers() {
				return finalDefaultTM.getAcceptedIssuers();
			}

			@Override
			public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
				// We do no checking at all here.
				// We could dump the server cert chain here. but we do that somewhere else.
				
				// Set this to true to verify that this code is being invoked.
				// We can throw an exception here to indicate we don't trust
				// the server cert. We don't want to do that though, so that
				// we can dump the server cert chain, later.
				boolean testing = false;
				if (testing) throw new CertificateException("Testing Testing!");
			}
			
			@Override
			public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {
			}
		};
		return customTm;
	}
};
