 import java.io.FileInputStream;
 import java.util.*;
 import java.io.*;
 import javax.xml.transform.Transformer;
 import javax.xml.transform.TransformerFactory;
 import javax.xml.transform.sax.SAXSource;
 import javax.xml.transform.stream.StreamResult;
 import org.xml.sax.InputSource;
  
 public class cxsl
 {
	private static HashMap<String, String> hashMap_MimeTypesPresent = new HashMap();
 	private static HashMap<String, String> hashMap_MimeTypeToTestFileName = null;
	private static HashMap<String, String> hashMap_FileExtToTestFileName = null;
	 
	private static void usage() 
	{
		String s = "\nDescription\n"							+
				   "  Perform XML tranform that creates test input data\n"	+
				   "  based on the file mime type or the file extension.\n\n"	+ 
		           "Usage:\n" 								+
				   "  java cxsl <input xsl file> <input xml file>\n\n"		+
				   "Example:\n"							+
				   "  java cxsl transform.xml input.xml > out.xml";
		System.out.println(s);
	}
	
	public static void main(String[] args) throws Exception
	{
		if (args.length != 2) {
			usage();
			System.exit(1);
		}
		
		String inputXslFile = args[0];
		String inputXmlFile = args[1];
	 
		TransformerFactory localTransformerFactory = TransformerFactory.newInstance();
		Transformer localTransformer = localTransformerFactory.newTransformer(new SAXSource(new InputSource(new FileInputStream(inputXslFile))));
		localTransformer.transform(new SAXSource(new InputSource(new FileInputStream(inputXmlFile))), new StreamResult(System.out));

		System.out.println("\nIMPORTANT: You may need to update the access permissions of the generated output files.\n");
	}
	
	// Called from stylesheet.
	// Return path to the directory containing the test file, based on the file type.
	public static String getTestFileDir(String docid, String mimetype, String filetype, String fileextension)
	{
		String path = "unknown";
		if (filetype.equalsIgnoreCase("native"))
			path = "native";
		if (filetype.equalsIgnoreCase("text"))
			path = "text";
		return path;
	}
	
	// Called from stylesheet.
	// Return test file name, based on file type.
	public static String getFileName(String docid, String mimetype, String filetype, String filename, String fileextension)
	{
		// Populate our hashmap of mime types present.
		hashMap_MimeTypesPresent.put(mimetype, "dummy");
	
		Boolean bCopyFile = true;
		String sTestFileName = "unknown";
		if (filetype.equalsIgnoreCase("text")) {
			sTestFileName = "test_file_text.txt";
		} else 
		if (filetype.equalsIgnoreCase("native")) {
			sTestFileName = mapMimeTypeToTestFileName(mimetype);
			if (sTestFileName == null) {
				sTestFileName = mapFileExtToTestFileName(fileextension.toLowerCase());
				if (sTestFileName == null) {
					System.err.println("ERROR: getFileName: Could not determine test file name (docid=" + docid + ")");
					bCopyFile = false;
				}
			}
		}
		if (bCopyFile) {
			String sDestDirName = getTestFileDir(docid, mimetype, filetype, fileextension);
			copyTestFile(sTestFileName, "test_files", filename, sDestDirName);
		}
		return filename;
	}
   
	private static String mapMimeTypeToTestFileName(String sMimeType)
	{
		if (hashMap_MimeTypeToTestFileName == null) {
			hashMap_MimeTypeToTestFileName = new HashMap();
   			hashMap_MimeTypeToTestFileName.put("application/vnd.ms-excel","test_file_xls.xls");
			hashMap_MimeTypeToTestFileName.put("FI_JPEGFIF","test_file_jpeg.jpg");
			hashMap_MimeTypeToTestFileName.put("image/tiff","test_file_tiff.tif");
			hashMap_MimeTypeToTestFileName.put("NONE","test_file_text.txt");
			hashMap_MimeTypeToTestFileName.put("application/vnd.ms-powerpoint","test_file_ppt.pptx");
			hashMap_MimeTypeToTestFileName.put("image/jpeg","test_file_jpeg.jpg");
			hashMap_MimeTypeToTestFileName.put("text/plain","test_file_text.txt");
			hashMap_MimeTypeToTestFileName.put("FI_PNG","test_file_png.png");
			hashMap_MimeTypeToTestFileName.put("FI_BMP","test_file_bmp.bmp");
			hashMap_MimeTypeToTestFileName.put("image/gif","test_file_gif.gif");
			hashMap_MimeTypeToTestFileName.put("application/msword","test_file_word.docx");
			hashMap_MimeTypeToTestFileName.put("application/vnd.ms-outlook","test_file_msg.msg");
			hashMap_MimeTypeToTestFileName.put("text/html","test_file_html.htm");
			hashMap_MimeTypeToTestFileName.put("application/pdf","test_file_pdf.pdf");
			hashMap_MimeTypeToTestFileName.put("FI_PCX","test_file_pcx.pcx");
			hashMap_MimeTypeToTestFileName.put("FI_EXECUTABLE","test_file_exe.dll");
			hashMap_MimeTypeToTestFileName.put("message/rfc822","test_file_rfc822.txt");
			hashMap_MimeTypeToTestFileName.put("FI_MHTML","test_file_mhtml.mht");
			hashMap_MimeTypeToTestFileName.put("FI_VCARD","test_file_vcf.vcf");
			hashMap_MimeTypeToTestFileName.put("FI_WORDPERFECT61","test_file_wpd.wpd");
			hashMap_MimeTypeToTestFileName.put("rtf","test_file_rtf.rtf");
		}
		return hashMap_MimeTypeToTestFileName.get(sMimeType);
	}
	
	private static String mapFileExtToTestFileName(String sFileExt)
	{
		if (hashMap_FileExtToTestFileName == null) {
			hashMap_FileExtToTestFileName = new HashMap();
			hashMap_FileExtToTestFileName.put("wmv","test_file_wmv.wmv");
		}
		return hashMap_FileExtToTestFileName.get(sFileExt);
	}
   
	private static void copyTestFile(String sSourceFileName, String sSourceDirName, String sDestFileName, String sDestDirName) 
	{
		File source = new File(sSourceDirName,sSourceFileName);
		File dest   = new File(sDestDirName,sDestFileName);
		try {
			dest.mkdirs();
			copyFileUsingFileStreams(source, dest);
		} catch (Exception e) {
			System.err.println("ERROR: Could not copy file. source=" + source + ", to dest=" + dest);
		}
	}
	
	private static void copyFileUsingFileStreams(File source, File dest) throws IOException 
	{
		InputStream input = null;
		OutputStream output = null;
		try {
			input = new FileInputStream(source);
			output = new FileOutputStream(dest);
			byte[] buf = new byte[1024];
			int bytesRead;
			while ((bytesRead = input.read(buf)) > 0) {
				output.write(buf, 0, bytesRead);
			}
		} finally {
			input.close();
			output.close();
		}
   }
   
   	// Called from stylesheet.
	// For debugging. Print all mime types found in the input xml file.
	public static String printMimeTypesPresent() 
	{
		String s = "";
		Iterator itr =  hashMap_MimeTypesPresent.keySet().iterator(); 
		while (itr.hasNext()) {
			String key = (String)itr.next(); 
		    s += (String)key + "\n";
        }
		return s;
	}
}
