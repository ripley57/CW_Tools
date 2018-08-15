import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLHandshakeException;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

public class Example {
    private static class UrlAndFingerprint {
        public final String url, fingerprint;
        public UrlAndFingerprint(String url, String fingerprint) {
            this.url = url;
            this.fingerprint = fingerprint;
        }
    }

    public static void main(String[] args) {
        UrlAndFingerprint[] examples = new UrlAndFingerprint[] {
            new UrlAndFingerprint("https://www.example.com/", "25:09:FB:22:F7:67:1A:EA:2D:0A:28:AE:80:51:6F:39:0D:E0:CA:21".replaceAll(":", "")),
            new UrlAndFingerprint("https://expired.badssl.com/", "40:4B:BD:2F:1F:4C:C2:FD:EE:F1:3A:AB:DD:52:3E:F6:1F:1C:71:F3".replaceAll(":", "")),
            new UrlAndFingerprint("https://wrong.host.badssl.com/", "69:4C:62:94:2E:B1:F7:6A:C2:02:AC:6C:7C:AA:6F:26:CB:AE:41:80".replaceAll(":", "")),
            new UrlAndFingerprint("https://self-signed.badssl.com/", "07:9B:32:59:D0:7C:4D:E2:A1:CE:0E:F4:A5:B5:59:9D:3B:2D:62:EA".replaceAll(":", "")),
            new UrlAndFingerprint("https://untrusted-root.badssl.com/", "40:28:A5:C4:43:AB:92:E3:DE:A7:43:1C:59:16:80:32:34:5D:8F:C8".replaceAll(":", ""))
        };

        for (UrlAndFingerprint example: examples) {
            try {
                runDemo(example.url, example.fingerprint);
            } catch (NoSuchAlgorithmException e) {
                System.err.println(e);
            } catch (KeyStoreException e) {
                System.err.println(e);
            } catch (KeyManagementException e) {
                System.err.println(e);
            } catch (MalformedURLException e) {
                System.err.println(e);
            } catch (SSLHandshakeException e) {
                System.err.println(e);
            } catch (IOException e) {
                System.err.println(e);
            }
        }
    }

    private static void runDemo(String url, String fingerprint) throws NoSuchAlgorithmException, KeyStoreException, KeyManagementException, MalformedURLException, IOException {
        System.out.printf("%s: ", url);
        SSLContext context = buildContext(fingerprint);
        URL urlObj = new URL(url);
        HttpsURLConnection conn = (HttpsURLConnection) urlObj.openConnection();
        conn.setSSLSocketFactory(context.getSocketFactory());
        conn.setRequestMethod("HEAD");
        System.out.printf("%d\n", conn.getResponseCode());
    }

    private static SSLContext buildContext(String fingerprint) throws NoSuchAlgorithmException, KeyStoreException, KeyManagementException {
        TrustManagerFactory factory;
        factory = TrustManagerFactory.getInstance("X509");
        factory.init((KeyStore) null);
        TrustManager[] trustManagers = factory.getTrustManagers();
        for (int i = 0; i < trustManagers.length; i++) {
            if (trustManagers[i] instanceof X509TrustManager) {
                trustManagers[i] = new IgnoreExpirationTrustManager((X509TrustManager) trustManagers[i], fingerprint);
            }
        }
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, trustManagers, null);
        return sslContext;
    }
}
