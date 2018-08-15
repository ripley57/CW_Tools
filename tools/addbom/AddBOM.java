import java.io.*;
import java.util.*;
import java.nio.charset.*;

/*
**
** Description:
**
**     This program adds a BOM to a load file - if it can determine
**     the required byte order.
**
** Useful references:
**
** This code was taken from: 
** http://docs.oracle.com/javase/tutorial/i18n/text/stream.html
**
** List of different Java charset names:
** http://docs.oracle.com/javase/1.4.2/docs/api/java/nio/charset/Charset.html
**
** Java Unicode standard corresponds to UCS-2: 
** http://livedocs.adobe.com/coldfusion/8/htmldocs/help.html?content=i18n_07.html
**
** UCS-2 and Javascript: 
** http://mathiasbynens.be/notes/javascript-encoding
**
** BOMs:
** http://www.unicode.org/faq/utf_bom.html#bom4
**
** Writing bytes to a file:
** http://www.programcreek.com/2009/02/java-convert-a-file-to-byte-array-then-convert-byte-array-to-a-file/
**
** JeremyC 01/08/2013
*/

public class AddBOM {

	public enum BOM {
   		UTF32LE (	new byte[]{(byte)0xff, (byte)0xfe, (byte)0x00, (byte)0x00}, "UTF-32LE"		),
		UTF32BE (	new byte[]{(byte)0x00, (byte)0x00, (byte)0xfe, (byte)0xff}, "UTF-32BE"		),
		UTF16LE (	new byte[]{(byte)0xff, (byte)0xfe},							"UTF-16LE"		), 
		UTF16BE (	new byte[]{(byte)0xfe, (byte)0xff}, 						"UTF-16BE"		), 
		UTF8	(	new byte[]{(byte)0xef, (byte)0xbb, (byte)0xbf}, 			"UTF-8"			),
		ISO88591(	new byte[]{(byte)0x00},										"ISO-8859-1"	),
		NOBOM   (	new byte[]{(byte)0x00},										"No BOM"		);

		private byte[] bytes;
		private String encoding;

		private byte[] bytes() { return bytes; }
		private String encoding() { return encoding; }

		static BOM encodingToBOM(String encoding) {
			BOM bom = BOM.NOBOM;
			for (BOM b : BOM.values()) {
				if (encoding.equals(b.encoding())){
					bom = b;
					break;
				}
			}
			return bom;
		}

		BOM(byte[] bytes, String encoding) {
			this.bytes = bytes;
			this.encoding = encoding;
		}
	}

	/*
	** ISO-8859-1:
	**
	** $ od -x -c DEFAULT_iso88591.dat
	** 0000000 44fe 636f 4449 aefe 44fe 636f 7954 6570
	**         376   D   o   c   I   D 376 256 376   D   o   c   T   y   p   e
	** 0000020 0afe 30fe 372e 322e 3632 352e 3030 fe32
	**         376  \n 376   0   .   7   .   2   2   6   .   5   0   0   2 376
	** 0000040 feae 6946 656c 0afe
	**         256 376   F   i   l   e 376  \n
	** 0000050
	** 
	**
	** UTF-8:
	**
	** $ od -x -c DEFAULT_utf8.dat
	** 0000000 bec3 6f44 4963 c344 c2be c3ae 44be 636f
	**         303 276   D   o   c   I   D 303 276 302 256 303 276   D   o   c
	** 0000020 7954 6570 bec3 c30a 30be 372e 322e 3632
	**           T   y   p   e 303 276  \n 303 276   0   .   7   .   2   2   6
	** 0000040 352e 3030 c332 c2be c3ae 46be 6c69 c365
	**           .   5   0   0   2 303 276 302 256 303 276   F   i   l   e 303
	** 0000060 0abe
	**         276  \n
	** 0000062
	*/
	// TODO: Aadd UTF-32LE and UTF-32BE versions of the 254 text qualifier.
	public enum TEXTQUAL254 {
		TEXTQUALUTF16LE (	new byte[]{(byte)0xfe, (byte)0x00},	"UTF-16LE"		),
		TEXTQUALUTF16BE (	new byte[]{(byte)0x00, (byte)0xfe},	"UTF-16BE"		),
		TEXTQUALUTF8	(	new byte[]{(byte)0xc3, (byte)0xbe},	"UTF-8"			),
		TEXTQUALISO88591(	new byte[]{(byte)0xfe},				"ISO-8859-1"	),
		NOTEXTQUAL	(	new byte[]{(byte)0x00},					"No text qual"	);

		private byte[] bytes;
		private String encoding;

		private byte[] bytes() { return bytes; }
		private String encoding() { return encoding; }

		TEXTQUAL254(byte[] bytes, String encoding) {
			this.bytes = bytes;
			this.encoding = encoding;
		}
	}

	public static BOM convertTextQual254ToBOM(TEXTQUAL254 qual) {
		BOM bom = BOM.NOBOM;
		for (BOM b : BOM.values()) {
			if (qual.encoding().equals(b.encoding())){
				bom = b;
				break;
			}
		}
		return bom;
	}

	public static void usage() {
		System.out.println("                                                                    ");
        System.out.println("usage: java AddBOM -i inputfilename [-o outfilename] [-b [encoding]] [-w [encoding]]");
		System.out.println("                                                                    ");
		System.out.println("Where:                                                              ");
	  //System.out.println("  --list_encodings\tList the various encoding names.                ");
		System.out.println("  -i inputfilename\tInput file name.                                ");
		System.out.println("  -o outputfilename\tOutput file name.                              ");
		System.out.println("  -b [encoding]\t\tAdd BOM. Try to determine BOM if not specified.  ");
		System.out.println("  -w encoding\t\tRewrite the file in the specified encoding, without a BOM.");
		System.out.println("                                                                    ");
		System.out.println("The value of encoding can be any of the following:                  ");
		System.out.println("  UTF-16LE              (UTF-16 Little Endian)                      ");
		System.out.println("  UTF-16BE              (UTF-16 Big Endian)                         ");
	    System.out.println("  UTF-8                                                             ");
		System.out.println("                                                                    ");
		System.out.println("Examples:                                                           ");
	  //System.out.println("  List encodings:                                                   ");
	  //System.out.println("  java AddBOM --list_encodings                                      ");
	  //System.out.println("                                                                    ");
		System.out.println("  Automatically determine the BOM to add and add it:                ");
		System.out.println("  java AddBOM -i infile.DAT -o outfile.DAT -b                       ");
		System.out.println("                                                                    ");
		System.out.println("  Add the specified BOM:                                            ");
		System.out.println("  java AddBOM -i infile.DAT -o outfile.DAT -b UTF-16LE              ");
		System.out.println("                                                                    ");
		System.out.println("  Rewrite the input file to the specified encoding:                 ");
		System.out.println("  java AddBOM -i infile.DAT -o outfile.DAT -w UTF-16BE              ");
		System.out.println("                                                                    ");
	}

	private static class InvalidEncodingException extends Exception {  
    		public InvalidEncodingException() { } 
  	}

    public static void main(String[] args) throws Exception {
		String 	infilename = null;
		String 	outfilename = null;
		Boolean bAddBOM = false;
		Boolean bGuessBOM = false;
		Boolean bReWriteEncoding = false;
		String 	outEncoding = null;
		BOM 	outBOM = BOM.NOBOM;
		Boolean bDebug = false;

		for (int i=0; i<args.length; i++) {
			if (args.length == 1 && (args[0].equals("-h") || args[0].equals("/?"))) {
				usage();
				System.exit(0);
			}

			if (args.length == 1 && args[0].equals("--list_encodings")) {
				// Print encoding names
				printCharsetNames();
				System.exit(0);
			}

			if (args[i].equals("-v")) {
				bDebug = true;
			}

			if (args[i].equals("-i")) {
				// Input filename
				if (args.length < i+2) {
					System.out.println("ERROR: No input file specified");
					System.exit(0);
				}
				infilename = args[i+1];
				// Set default output filename
				outfilename = infilename + ".out";
				if (bDebug) System.out.println("-i: infilename=" + infilename + ", outfilename=" + outfilename);
			}

			if (args[i].equals("-o")) {
				// Output filename
				if (args.length < i+2) {
					System.out.println("ERROR: No output file specified");
					System.exit(0);
				}
				outfilename = args[i+1];
				if (bDebug) System.out.println("-o: outfilename=" + outfilename);
			}

			if (args[i].equals("-b")) {
				// Add BOM. 
				bAddBOM = true;
				if (args.length > i+1 && !args[i+1].startsWith("-")) {
					// BOM was specified.
					outBOM = BOM.encodingToBOM(validateEncoding(args[i+1]));
					if (bDebug) System.out.println("-b: BOM specified as " + outBOM.encoding);
				} else {
					// BOM was not specified. Try and guess it.
					bGuessBOM = true;
					if (bDebug) System.out.println("-b: No BOM specified. Will guess it later.");
				}
			}

			if (args[i].equals("-w")) {
				// Rewrite the input file to the specified encoding.
				bReWriteEncoding = true;
				if (args.length == i+1) {
					System.out.println("ERROR: -w: No encoding specified");
					System.exit(0);
				}
				outEncoding = validateEncoding(args[i+1]);
				if (bDebug) System.out.println("-w: Rewrite encoding specified as " + outEncoding);
			}
		}

		if (infilename == null) {
			System.out.println("ERROR: No input file specified");
			System.exit(1);
		}
		if (bReWriteEncoding == false && bAddBOM == false) {
			System.out.println("ERROR: You have not specified any action (-w or -b) to perform.");
			System.exit(1);
		}
		if (bReWriteEncoding == true && bAddBOM == true) {
			System.out.println("ERROR: You can only perform one action (-w or -b) at a time.");
			System.exit(1);
		}

		if (outfilename == null) {
			// Use default output file name
			outfilename = infilename + ".out";
		}

		// Let's do the main work now...

		// Re-encode the input file, but don't add a BOM.
		if (bReWriteEncoding) {
			BOM bom = guessBOM(infilename);
			if (bom == BOM.NOBOM) {
				// Could not determine current encoding. Assume ISO-8859-1.
				System.out.println("WARN: Could not determine current encoding. Assuming ISO-8559-1.");
				bom = BOM.ISO88591;
				//System.out.println("ERROR: Could not rewrite encoding. Could not determine current encoding.");
				//System.exit(1);
			}
			System.out.println("Current encoding determined as " + bom.encoding()); 
			System.out.println("Rewriting encoding as " + outEncoding + " ...");
			reWriteEncoding(infilename, outfilename, bom.encoding, outEncoding);
			System.out.println("Input  file: " + infilename);
			System.out.println("Output file: " + outfilename);
		}

		// Add a BOM.
		if (bAddBOM) {
			BOM b_present = getBOM(infilename);
			if (b_present != BOM.NOBOM) {
				System.out.println("ERROR: Cannot add BOM. File already contains a BOM: " + b_present.encoding());
				System.exit(1);
			}

			BOM b_guess = guessBOM(infilename);
			if (bGuessBOM) {
				if (b_guess == BOM.NOBOM) {
					System.out.println("ERROR: Could not guess BOM to add.");
					System.exit(1);
				}
				System.out.println("BOM to add determined as " + b_guess.encoding);
				outBOM = b_guess;
			} else {
				if (b_guess != outBOM) {
					System.out.println("WARNING: You are adding a BOM " + outBOM.encoding() + 
				  		   " but the file looks to be in encoding " + b_guess.encoding());
				}
			}
			System.out.println("Adding BOM " + outBOM.encoding + " ..."); 
			addBOM(infilename, outfilename, outBOM);
			System.out.println("Input  file: " + infilename);
			System.out.println("Output file: " + outfilename);
		}

		System.out.println("Finished!");
    	}

	// Check encoding string is valid.
	static String validateEncoding(String encoding) 
			throws InvalidEncodingException {
		if (encoding.equals("UTF-16LE") ||
		    encoding.equals("UTF-16BE") ||
		    encoding.equals("UTF-8")    ||
		    encoding.equals("ISO-8859-1")) {
			return encoding;
		}
		throw new InvalidEncodingException();
	}

	// Determine BOM of file.
	static BOM guessBOM(String filename) 
			throws FileNotFoundException, IOException {
		// Check if a BOM already exists
		BOM b = getBOM(filename);
		if (b == BOM.NOBOM) {
			// No BOM found. Try to determine the BOM.
			System.out.println("No BOM found. Trying to guess using text qualifier..."); 
			TEXTQUAL254 tq = getTextQual254(filename);
			b = convertTextQual254ToBOM(tq);
		}
		return b;
	}

	// Read BOM from file.
    	static BOM getBOM(String filename) 
			throws FileNotFoundException, IOException {
		// Read first 4 bytes.
		byte[] buffer = new byte[4];
		InputStream is = new FileInputStream(filename);
		is.read(buffer); 
		is.close();
		BOM bom = BOM.NOBOM;
		for (BOM b : BOM.values()) {
			byte[] bomToCheck = Arrays.copyOf(buffer, b.bytes.length);
			if (Arrays.equals(bomToCheck, b.bytes)) {
				bom = b;
				break;
			}
		}
		return bom;
    	}

	// Check if the common 254 decimal (376 octal) text qualifier exists at the start of
	// the file. Check each variation of the 254 text qualifier, based on the possible
	// encoding and byte order. Return value that indicates if 254 text qualifier was
	// found and what the byte order is. 
	static TEXTQUAL254 getTextQual254(String filename) 
			throws FileNotFoundException, IOException {
		// Read first 4 bytes.
		byte[] buffer = new byte[4];
		InputStream is = new FileInputStream(filename);
		is.read(buffer); 
		is.close();
		TEXTQUAL254 qual = TEXTQUAL254.NOTEXTQUAL;
		for (TEXTQUAL254 q : TEXTQUAL254.values()) {
			byte[] qualToCheck = Arrays.copyOf(buffer, q.bytes.length);
			if (Arrays.equals(qualToCheck, q.bytes)) {
				qual = q;
				break;
			}
		}
		return qual;
	}

	static void addBOM(String infilename, String outfilename, BOM bom) 
			throws FileNotFoundException, IOException {
		byte[] bom_bytes = bom.bytes();
		File infile = new File(infilename);
		FileInputStream fis = new FileInputStream(infile);
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		byte[] buf = new byte[1024];
		try {
			for (int readNum; (readNum = fis.read(buf)) != -1;) {
				bos.write(buf, 0, readNum); 
			}
		} catch (IOException ex) {
		}
		fis.close();
		byte[] bytes = bos.toByteArray();
		File outfile = new File(outfilename);
		FileOutputStream fos = new FileOutputStream(outfile);
		fos.write(bom_bytes);
		fos.write(bytes);
		fos.flush();
		fos.close();
	}

	// Rewrite file encoding without including a BOM.
	// TODO: Is there a better way to do this other than using a temporary string?
	static void reWriteEncoding(String infilename, String outfilename, String in_encoding, String out_encoding) 
			throws FileNotFoundException, IOException, InvalidEncodingException { 
        	String inputString = readInput(infilename, in_encoding);
        	writeOutput(inputString, outfilename, out_encoding);
	}
		
 	static String readInput(String infilename, String encoding) 
			throws FileNotFoundException, IOException, InvalidEncodingException {
		validateEncoding(encoding);
        	StringBuffer buffer = new StringBuffer();
        	FileInputStream fis = new FileInputStream(infilename);
        	//InputStreamReader isr = new InputStreamReader(fis, "UTF8");
        	//InputStreamReader isr = new InputStreamReader(fis, "ISO-8859-1");
        	//InputStreamReader isr = new InputStreamReader(fis, "UTF-16BE");
        	//InputStreamReader isr = new InputStreamReader(fis, "UTF-16LE");
        	InputStreamReader isr = new InputStreamReader(fis, encoding);
        	Reader in = new BufferedReader(isr);
        	int ch;
        	while ((ch = in.read()) > -1) {
            		buffer.append((char)ch);
        	}
        	in.close();
        	return buffer.toString();
    	}

	// Maps an encoding string to the corresponding encoding string that excludes a BOM.
	//private static final Map<String, String> mapEncodingToEncodingWithNoBOM = new HashMap<String, String>() {
	//	{
	//	put("UTF-16LE", "UnicodeLittleUnmarked");
	//	put("UTF-16BE", "UnicodeBigUnmarked");
	//	put("UTF-8",    "UTF-8");
	//	}
	//};
 
    	static void writeOutput(String inString, String outfilename, String encoding) 
			throws FileNotFoundException, IOException, InvalidEncodingException {
		validateEncoding(encoding);

		// Map output encoding to an encoding string that excludes a BOM.
		//String outencoding = mapEncodingToEncodingWithNoBOM.get(encoding);
		//System.out.println("Rewriting encoding using " + outencoding) + " ...";

       		FileOutputStream fos = new FileOutputStream(outfilename);
        	//Writer out = new OutputStreamWriter(fos, "UTF8");
        	//Writer out = new OutputStreamWriter(fos, "ISO-8859-1");
        	//Writer out = new OutputStreamWriter(fos, "UTF-16LE");
        	//Writer out = new OutputStreamWriter(fos, "UTF-16BE");
        	Writer out = new OutputStreamWriter(fos, encoding);
        	out.write(inString);
        	out.close();
    	}

	// Print list of Java encoding names.
	static void printCharsetNames() {
		Map charSets = Charset.availableCharsets();
		Iterator it = charSets.keySet().iterator();
		while(it.hasNext()) {
			String csName = (String)it.next();
			System.out.print(csName);
			Iterator aliases = ((Charset)charSets.get(csName)).aliases().iterator();
			if(aliases.hasNext())
		        System.out.print(": ");
			while(aliases.hasNext()) {
        			System.out.print(aliases.next());
        			if(aliases.hasNext())
         				System.out.print(", ");
      			}
      			System.out.println();
    		}
	}
}
