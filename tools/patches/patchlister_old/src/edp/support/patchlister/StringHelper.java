package edp.support.patchlister;

import java.io.*;
import java.nio.*;
import java.util.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class StringHelper
{
    public static String toHexString(byte[] argBytes) {
        StringBuilder hexbuf = new StringBuilder();
        for (int i = 0; i < argBytes.length; i++) {
            String hexst = Integer.toHexString(argBytes[i] & 0xff);
            if (hexst.length() < 2) { // for char < 0x10
                hexbuf.append("0");
            }
            hexbuf.append(hexst);
        }
        return hexbuf.toString();
    }

    public static String MD5(String s) {
        try {
            return toHexString(MessageDigest.getInstance("MD5").digest(s.getBytes("UTF-8")));
        } catch (NoSuchAlgorithmException e) {           
           throw new RuntimeException (e);           
        } catch (UnsupportedEncodingException e) {          
            throw new RuntimeException(e);   
        }
    }
    

}
