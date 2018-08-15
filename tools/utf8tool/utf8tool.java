import java.io.*;
import java.util.*;
import java.nio.charset.*;

/*
** Description:
**
** References:
** 	http://stackoverflow.com/questions/14374018/removing-4-byte-utf-characters-from-a-large-file
**	http://stackoverflow.com/questions/18571223/how-to-convert-java-string-into-byte
*/

public class utf8tool {
	
	static Boolean bDebug_v 	= false;
	static Boolean bDebug_vv	= false;
	static Boolean bDebug_vvv	= false;

	public static void usage() {
		System.out.println(	"\n" + 
							"usage: java -jar utf8tool.jar -i infile [-o outfile] [-p4] [-r4 [string]]\n" +
							"\n" +
							"where:\n" +
							"  -i infile\tInput file name.\n" +
							"  -o outfile\tOutput file name.\n" +
							"  -p4\t\tIndicate line numbers where a 4-byte char was found.\n" +
							"  -r4\t\tRemove 4-byte characters.\n" +
							"  -r4 [hex]\tReplace 4-byte characters with the specified hex.\n");
	}

    	public static void main(String[] args) throws Exception {
		String 	sInFile 	 = null;
		String 	sOutFile 	 = null;
		Boolean bPrint4b	 = false;
		Boolean	bRemove4b 	 = false;
		Boolean bReplace4b	 = false;
		String  sReplaceString	 = "";
		
		// Process input arguments.
		for (int i=0; i<args.length; i++) {
			if (args.length == 1 && (args[0].equals("-h") || args[0].equals("/?"))) {
				usage();
				System.exit(0);
			}
			if (args[i].equals("-v")) {
				bDebug_v = true;
			}
			if (args[i].equals("-vv")) {
				bDebug_v = true;
				bDebug_vv = true;
			}
			if (args[i].equals("-vvv")) {
				bDebug_v = true;
				bDebug_vv = true;
				bDebug_vvv = true;
			}
			if (args[i].equals("-i")) {
				// Input file name.
				if (args.length < i+2) {
					System.out.println("ERROR: No input file specified");
					System.exit(0);
				}
				sInFile = args[i+1];
				if (bDebug_vvv) System.out.println("-i: sInFile=" + sInFile);
			}
			if (args[i].equals("-o")) {
				// Output file name.
				if (args.length < i+2) {
					System.out.println("ERROR: No output file specified");
					System.exit(0);
				}
				sOutFile = args[i+1];
				if (bDebug_vvv) System.out.println("-o: sOutFile=" + sOutFile);
			}
				
			if (args[i].equals("-p4")) {
				// Indicate lines with 4-byte characters.
				bPrint4b = true;
				if (bDebug_vvv) System.out.println("-p4: bPrint4b=" + bPrint4b);
			}
			if (args[i].equals("-r4")) {
				bRemove4b = true;
				if (bDebug_vvv) System.out.println("-r4: bRemove4b=" + bRemove4b);
				if (args.length > i+1) {
					bReplace4b = true;
					sReplaceString = args[i+1];
					if (bDebug_vvv) System.out.println("-r4: sReplaceString=" + sReplaceString);
				}
			}
		}

		boolean bBadArgs = false;
		
		if (sInFile == null) {
			System.out.println("\nERROR: Bad args (no input file specified)");
			usage();
			System.exit(1);
		}

		if (bPrint4b == false && bRemove4b == false) {
			System.out.println("\nERROR: Bad args (must specify print or remove option)");
			bBadArgs = true;
		}
		
		if (sOutFile == null && bRemove4b == true) {
			System.out.println("\nERROR: Bad args (must specify output file for remove option)");
			bBadArgs = true;
		}
		
		if (sOutFile != null && bRemove4b == false) {
			System.out.println("\nERROR: Bad args (must specify remove option when specifying output file)");
			bBadArgs = true;
		}
		
		if (bBadArgs) {
			usage();
			System.exit(1);
		}
			
		remove4byteChars(sInFile, sOutFile, bPrint4b, bRemove4b, bReplace4b, sReplaceString);
    }

	static void remove4byteChars(String inFile, String outFile,
								 boolean bPrint4b, boolean bRemove4b, boolean bReplace4b, 
								 String sReplaceString) throws IOException 
	{
		boolean bEdit = (bRemove4b || bReplace4b);
				
		FileInputStream			isr = null;
		FileOutputStream		fos = null;
		
		try {
			try {
				isr = new FileInputStream(new File(inFile));
			}
			catch (FileNotFoundException e) {
				System.err.println("ERROR: File not found: " + inFile);
				return;
			}
			
			if (bEdit) {
				fos = new FileOutputStream(outFile);
			}
			
			long lineno = 1;
			long bytes_read_count = 0;
			long bytes_written_count = 0;
			
			int b;
			
			while ((b = isr.read()) != -1) {
				bytes_read_count++;
								
				if (b == 10 || b == 13)
					lineno++;

				if (bDebug_vvv) System.out.print("read b=" + String.format("%02x", b) );
					
				if ((b & 0b11111000) == 0b11110000) {	// Char is 4-byte UTF-8
					byte[] b4 = new byte[4];
					b4[0] = (byte)b; 
						
					// Skip the next 3 bytes.
					b4[1] = (byte)isr.read();
					b4[2] = (byte)isr.read();
					b4[3] = (byte)isr.read();
						
					if (bPrint4b)
						System.out.println("line " + lineno + ": 4-byte UTF-8 char: " + bytesToHex(b4));
	
					if (bRemove4b) {
						if (bReplace4b && sReplaceString != null && sReplaceString.length() > 0) {
							byte[] replace_b_array = hexStringToBytes(sReplaceString);
							DataInputStream replace_rdr = new DataInputStream(new ByteArrayInputStream(replace_b_array));
							if (bDebug_v) System.out.println("Adding replacement bytes: " + bytesToHex(replace_b_array));
							byte r;
							while (replace_rdr.available() > 0) {
								r = replace_rdr.readByte();
								if (fos != null) {
									fos.write(r);
									fos.flush();
									bytes_written_count++;
								}
							}
						}
					}
				}
				else {
					if (fos != null) {
						if (bDebug_vvv) System.out.println(" write b=" + String.format("%02x", b));
						fos.write(b);
						fos.flush();
						bytes_written_count++;
					}
				}
			}
			
			if (bDebug_vv) System.out.println("bytes read=" + bytes_read_count + ", bytes written=" + bytes_written_count);
			
		} finally {
			if (isr != null)
				isr.close();
			if (fos != null) {
				fos.flush();
				fos.close();
			}
		}
	}
	
	// From http://stackoverflow.com/questions/9655181/how-to-convert-a-byte-array-to-a-hex-string-in-java
	public static String bytesToHex(byte[] bytes) {
		char[] hexArray = "0123456789ABCDEF".toCharArray();
		char[] hexChars = new char[bytes.length * 2];
		for ( int j = 0; j < bytes.length; j++ ) {
			int v = bytes[j] & 0xFF;
			hexChars[j * 2] = hexArray[v >>> 4];
			hexChars[j * 2 + 1] = hexArray[v & 0x0F];
		}
		return new String(hexChars);
	}

	// From http://stackoverflow.com/questions/140131/convert-a-string-representation-of-a-hex-dump-to-a-byte-array-using-java
	public static byte[] hexStringToBytes(String str) 
	{
		if ((str.length() % 2) != 0)
			throw new IllegalArgumentException("Input string must contain an even number of characters");
		byte result[] = new byte[str.length()/2];
		char enc[] = str.toCharArray();
		for (int i = 0; i < enc.length; i += 2) {
			StringBuilder curr = new StringBuilder(2);
			curr.append(enc[i]).append(enc[i + 1]);
			result[i/2] = (byte)Integer.parseInt(curr.toString(), 16);
		}
		return result;
	}
}
