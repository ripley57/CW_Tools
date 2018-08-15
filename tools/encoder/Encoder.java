import java.io.*;
import java.util.*;
import java.nio.charset.*;

/*
** Description:
**   General encoder for changing the encoding of an input file,
**   and optionally adding a BOM. 
**
**   In order to change the encoding, the current encoding of the
**   input file needs to be determined. The input encoding can be
**   specified as an input argument. If the input encoding is not
**   specified then an attempt will be made to determine it, by
**   checking for existing well-known BOMs.
**
** JeremyC 23/8/2015.
**
** Useful references:
** http://docs.oracle.com/javase/tutorial/i18n/text/stream.html
** http://docs.oracle.com/javase/1.4.2/docs/api/java/nio/charset/Charset.html
** http://livedocs.adobe.com/coldfusion/8/htmldocs/help.html?content=i18n_07.html
** http://mathiasbynens.be/notes/javascript-encoding
** http://www.unicode.org/faq/utf_bom.html#bom4
** http://www.programcreek.com/2009/02/java-convert-a-file-to-byte-array-then-convert-byte-array-to-a-file/
*/

public class Encoder {
	
	static Boolean bDebug_v 	= false;
	static Boolean bDebug_vv	= false;
	static Boolean bDebug_vvv	= false;

	// Different BOMs.
	public enum BOM {
   		UTF32LE (	new byte[]{(byte)0xff, (byte)0xfe, (byte)0x00, (byte)0x00}, 	"UTF-32LE"	),
		UTF32BE (	new byte[]{(byte)0x00, (byte)0x00, (byte)0xfe, (byte)0xff}, 	"UTF-32BE"	),
		UTF16LE (	new byte[]{(byte)0xff, (byte)0xfe},				"UTF-16LE"	), 
		UTF16BE (	new byte[]{(byte)0xfe, (byte)0xff}, 				"UTF-16BE"	), 
		UTF8	(	new byte[]{(byte)0xef, (byte)0xbb, (byte)0xbf}, 		"UTF-8"		),
		ISO88591(	new byte[]{(byte)0x00},						"ISO-8859-1"	),
		NOBOM   (	new byte[]{(byte)0x00},						"No BOM"	);

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
	** Try and determine encoding by looking for well-known text qualifiers 
	** in different encodingss.
	**
	** ISO-8859-1:
	** $ od -x -c DEFAULT_iso88591.dat
	** 0000000 44fe 636f 4449 aefe 44fe 636f 7954 6570
	**         376   D   o   c   I   D 376 256 376   D   o   c   T   y   p   e
	** 0000020 0afe 30fe 372e 322e 3632 352e 3030 fe32
	**         376  \n 376   0   .   7   .   2   2   6   .   5   0   0   2 376
	** 0000040 feae 6946 656c 0afe
	**         256 376   F   i   l   e 376  \n
	** 0000050
	** 
	** UTF-8:
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
	**
	** TODO: Add UTF-32LE and UTF-32BE versions of the 254 text qualifier.
	*/
	public enum TEXTQUAL254 {
		TEXTQUALUTF16LE (	new byte[]{(byte)0xfe, (byte)0x00},	"UTF-16LE"	),
		TEXTQUALUTF16BE (	new byte[]{(byte)0x00, (byte)0xfe},	"UTF-16BE"	),
		TEXTQUALUTF8	(	new byte[]{(byte)0xc3, (byte)0xbe},	"UTF-8"		),
		TEXTQUALISO88591(	new byte[]{(byte)0xfe},			"ISO-8859-1"	),
		NOTEXTQUAL		(	new byte[]{(byte)0x00},		"No text qual"	);

		private byte[] bytes;
		private String encoding;

		private byte[] bytes() { return bytes; }
		private String encoding() { return encoding; }

		TEXTQUAL254(byte[] bytes, String encoding) {
			this.bytes = bytes;
			this.encoding = encoding;
		}
	}

	// Map text qualifier encoding to corresponding BOM.
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
		System.out.println("usage: java Encoder -i infile [-o outfile] [-ei in_encoding] [-eo out_encoding] [-b [encoding]] [--list_encodings] [-v[v]] [-d]");
		System.out.println("                                                                    ");
		System.out.println("Where:                                                              ");
		System.out.println("  -i infile\t\tInput file name.                                     ");
		System.out.println("  -o outfile\t\tOutput file name.                                   ");
		System.out.println("  -ei in_encoding\tInput file encoding.                             ");
		System.out.println("  -eo out_encoding\tOutput file encoding.                           ");
		System.out.println("  -b [encoding]\t\tAdd BOM. Determine encoding if not specified.    ");
		System.out.println("  --list_encodings\tList the various encoding names.                ");
		System.out.println("  -v[v][v]\t\tDisplay increasing amounts of debug output.           ");
		System.out.println("  -d\t\t\tDisplay current encoding only and then exit.              ");
		System.out.println("                                                                    ");
		System.out.println("Recognized BOM values:                                              ");
		System.out.println("  UTF-16LE              (UTF-16 Little Endian)                      ");
		System.out.println("  UTF-16BE              (UTF-16 Big Endian)                         ")
		System.out.println("  UTF-8                                                             ");
		System.out.println("                                                                    ");
		System.out.println("Examples:                                                           ");
		System.out.println("  Display current BOM and encoding:                                 ");
		System.out.println("  java -jar encoder.jar -i in.DAT                                   ");
		System.out.println("                                                                    ");
		System.out.println("  Try to determine the encoding and then add a corresponding BOM:   ");
		System.out.println("  java -jar encoder.jar -i in.DAT -o out.DAT -b                     ");
		System.out.println("                                                                    ");
		System.out.println("  Add the specified BOM:                                            ");
		System.out.println("  java -jar encoder.jar -i in.DAT -o out.DAT -b UTF-16LE            ");
		System.out.println("                                                                    ");
		System.out.println("  Change the encoding from UTF-8 to UTF-16LE:                       ");
		System.out.println("  java -jar encoder.jar -i in.DAT -o out.DAT -ei UTF-8 -eo UTF-16BE ");
		System.out.println("                                                                    ");
	}

	private static class InvalidEncodingException extends Exception {  
    		public InvalidEncodingException() { } 
  	}

    	public static void main(String[] args) throws Exception {
		String 	sInFile 	 = null;
		String 	sOutFile 	 = null;
		Boolean bAddBOM 	 = false;
		String  sInEncoding	 = null;
		String 	sOutEncoding 	 = null;
		Boolean bDisplayEncoding = false;
		BOM 	outBOM 		 = BOM.NOBOM;

		// Process input arguments.
		for (int i=0; i<args.length; i++) {
			if (args.length == 1 && (args[0].equals("-h") || args[0].equals("/?"))) {
				usage();
				System.exit(0);
			}
			if (args.length == 1 && args[0].equals("--list_encodings")) {
				// Print various sencoding names.
				printCharsetNames();
				System.exit(0);
			}
			if (args[i].equals("-v")) {
				bDebug_v = true;
			}
			if (args[i].equals("-vv")) {
				bDebug_vv = true;
				bDebug_v = true;
			}
			if (args[i].equals("-vvv")) {
				bDebug_vvv = true;
				bDebug_vv = true;
				bDebug_v = true;
			}
			if (args[i].equals("-d")) {
				bDisplayEncoding = true;
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
			if (args[i].equals("-ei")) {
				// Input file encoding.
				if (args.length < i+2) {
					System.out.println("ERROR: No input file encoding specified");
					System.exit(0);
				}
				sInEncoding = args[i+1];
				//sInEncoding = validateEncoding(args[i+1]);
				if (bDebug_vvv) System.out.println("-ei: sInEncoding=" + sInEncoding);
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
				
			if (args[i].equals("-eo")) {
				// Output file encoding.
				if (args.length < i+2) {
					System.out.println("ERROR: No output file encoding specified");
					System.exit(0);
				}
				sOutEncoding = args[i+1];
				//sOutEncoding = validateEncoding(args[i+1]);
				if (bDebug_vvv) System.out.println("-eo: sOutEncoding=" + sOutEncoding);
			}
			if (args[i].equals("-b")) {
				// Add BOM. 
				bAddBOM = true;
				if (args.length > i+1 && !args[i+1].startsWith("-")) {
					// BOM specified.
					outBOM = BOM.encodingToBOM(validateEncoding(args[i+1]));
					if (bDebug_vvv) System.out.println("-b: BOM specified=" + outBOM.encoding);
				}
			}
		}

		if (sInFile == null) {
			System.out.println("ERROR: No input file specified");
			System.exit(1);
		}
		
		// Attempt to determine the current encoding.
		BOM bomGuessed = guessBOM(sInFile);
		
		// Display details of the current encoding and BOM. 
		if (bDisplayEncoding == true || bDebug_vv == true || (sOutFile == null && sOutEncoding == null)) {
			BOM bom = getBOM(sInFile);
			if (bom != BOM.NOBOM) {
				System.out.println("BOM detected as " + bom.encoding());
			} else {
				System.out.println("No BOM detected.");
			}
			if (bomGuessed != BOM.NOBOM) {
				System.out.println("Input encoding determined as " + bomGuessed.encoding());
			}
		}
		
		if (bDisplayEncoding) {
			// Nothing else to do.
			System.exit(0);
		}
		
		if (sOutFile == null) {
			// Use default output file name.
			sOutFile = sInFile + ".out";
		}
			
		// Input encoding to use.
		if (sInEncoding != null) {
			// Input encoding specified. Compare determined encoding with specified encoding.
			if (bomGuessed != BOM.NOBOM && !bomGuessed.encoding().equals(sInEncoding)) {
				System.out.println("WARN: Input encoding determined to be " + bomGuessed.encoding() + " but specified as " + sInEncoding);
			}		
		} else {
			// No input encoding specified, so use determined encoding.
			if (bomGuessed == BOM.NOBOM) {
				System.out.println("ERROR: Could not determine input encoding.");
				System.exit(1);
			} 
			sInEncoding = bomGuessed.encoding();
		}
		
		// Output encoding to use.
		if (sOutEncoding == null) {
			sOutEncoding = sInEncoding;
		}

		// Add an optional BOM.
		if (bAddBOM) {
			// Check for existing BOM.
			BOM bom = getBOM(sInFile);
			if (bom != BOM.NOBOM) {
				System.out.println("WARN: File already contains a BOM of " + bom.encoding());
			}
			if (outBOM == BOM.NOBOM) {	
				// No BOM specified,so use output encoding.
				outBOM = BOM.encodingToBOM(sOutEncoding);
			} else {
				// BOM was specified. Check that it matches output encoding.
				if (!outBOM.encoding().equals(sOutEncoding)) {
					System.out.println("WARN: BOM encoding of " + outBOM.encoding() + " does not match output encoding of " + sOutEncoding);
				}
			}
		}
		
		if (bDebug_v) System.out.println("Converting " + sInFile + " from " + sInEncoding + " to " + sOutEncoding + " into file " + sOutFile + " ...");
		encode(sInFile, sInEncoding, sOutFile, sOutEncoding, outBOM);
		if (bDebug_vvv) System.out.println("Finished!");
    }

	// Check encoding string is valid, according to the limited list of values that we recognize.
	static String validateEncoding(String encoding) throws InvalidEncodingException {
		if (encoding.equals("UTF-16LE") ||
		    encoding.equals("UTF-16BE") ||
		    encoding.equals("UTF-8")    ||
		    encoding.equals("ISO-8859-1")) {
			return encoding;
		}
		throw new InvalidEncodingException();
	}

	// Determine BOM of file.
	static BOM guessBOM(String filename) throws FileNotFoundException, IOException {
		BOM b = getBOM(filename);
		if (b == BOM.NOBOM) {
			// No BOM found. Try to determine the BOM.
			if (bDebug_vvv) System.out.println("No BOM found. Trying to guess using text qualifier..."); 
			TEXTQUAL254 tq = getTextQual254(filename);
			b = convertTextQual254ToBOM(tq);
		}
		return b;
	}

	// Read BOM from file.
    	static BOM getBOM(String filename) throws FileNotFoundException, IOException {
		byte[] buffer = new byte[4];	// Read first 4 bytes.
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
	static TEXTQUAL254 getTextQual254(String filename) throws FileNotFoundException, IOException {
		byte[] buffer = new byte[4];	// Read first 4 bytes.
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

	static void encode(String inFile, String inEncoding, String outFile, String outEncoding, BOM bom) throws IOException {
		InputStreamReader isr = null;
		OutputStreamWriter osw = null;
		FileOutputStream fos = null;
		try {
			isr = new InputStreamReader(new FileInputStream(new File(inFile)), inEncoding);
			fos = new FileOutputStream(new File(outFile));
			
			if (bom != BOM.NOBOM) {
				// Add BOM.
				if (bDebug_vvv) System.out.println("Adding BOM " + bom.encoding() + " ...");
				byte[] bom_bytes = bom.bytes();
				fos.write(bom_bytes);
			}
			
			osw = new OutputStreamWriter(fos, outEncoding);
			
			char[] buffer = new char[4096];
			while (true) {
				int nRead = isr.read(buffer);
				if (nRead < 0)
					break;
				if (nRead > 0)
					osw.write(buffer, 0, nRead);
			}
		} finally {
			if (isr != null)
				isr.close();
			if (osw != null) {
				osw.flush();
				osw.close();
			}
		}
	}
		
	// Print list of Java encoding names.
	static void printCharsetNames() {
		Map charSets = Charset.availableCharsets();
		Iterator it = charSets.keySet().iterator();
		while(it.hasNext()) {
			String csName = (String)it.next();
			System.out.print(csName);
			Iterator aliases = ((Charset)charSets.get(csName)).aliases().iterator();
			if (aliases.hasNext()) {
		        System.out.print(": ");
			}
			while(aliases.hasNext()) {
        			System.out.print(aliases.next());
        			if(aliases.hasNext()) {
         				System.out.print(", ");
					}		
      			}
      			System.out.println();
    		}
	}
}
