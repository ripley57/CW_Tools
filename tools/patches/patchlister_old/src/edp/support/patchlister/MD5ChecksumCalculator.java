package edp.support.patchlister;

import java.io.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import org.apache.log4j.Logger;

public class MD5ChecksumCalculator {

    static Logger logger = Logger.getLogger(MD5ChecksumCalculator.class);
	
    public String createChecksum(File argFile) throws IOException, NoSuchAlgorithmException {
        InputStream is = null;
        try {
            is = new FileInputStream(argFile);
            return createChecksum(is);
        }
        finally {
            if(is != null) {
                is.close();
            }
        }        
    }   
	


    public String createChecksum(InputStream is) throws IOException, NoSuchAlgorithmException {
        byte[] buffer = new byte[1024];
        MessageDigest complete;
        try {
            complete = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            throw e;
        }
        complete.reset();
        int numRead = 0;
        do {
            try {
                numRead = is.read(buffer);
            } catch (IOException e1) {
                is.close();
            }
            if (numRead > 0) {
                complete.update(buffer, 0, numRead);
            }
        } while (numRead != -1);
        is.close();
        byte[] digestBytes = complete.digest();
        return StringHelper.toHexString(digestBytes);
    }
	
	public String createChecksum(String argStr) throws IOException, UnsupportedEncodingException, NoSuchAlgorithmException {
        byte[] inputStringInBytes = argStr.getBytes("UTF-8");
        return this.createChecksum(new ByteArrayInputStream(inputStringInBytes));
    }
	    
}