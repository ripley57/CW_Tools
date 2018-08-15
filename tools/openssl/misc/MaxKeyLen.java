/*
**
** Description:
**     Displays the maximum key length for the specified transformation 
**     according to the installed JCE jurisdiction policy files.
**
** Usage:
**		java MaxKeyLen
**
** Example:
**		D:\>javac MaxKeyLen.java
**		D:\>java MaxKeyLen
**		128
**
** References:
**     http://opensourceforgeeks.blogspot.co.uk/2014/09/how-to-install-java-cryptography.html
**	   http://stackoverflow.com/questions/24129441/cipher-getmaxallowedkeylengthaes-returns-128-what-does-that-mean-if-i-want:
*/
public class MaxKeyLen {
    public static void main(String[] args) {
		try {
			int maxKeyLength = javax.crypto.Cipher.getMaxAllowedKeyLength("AES");
			System.out.println("" + maxKeyLength);
		} catch (Exception e) {
			System.err.println(e);
		}
    }
}