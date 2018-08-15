package com.jeremy.tools;

/*
import java.nio.file.*;
*/
import java.io.*;
import java.util.zip.*;
import org.apache.log4j.Logger;
 
/**
 * Utility to extract a zip file to destination directory.
 */
public class UnzipUtility {
	static Logger logger = Logger.getLogger(UnzipUtility.class);

	private static final int BUFFER_SIZE = 1048576; 

	public static boolean unzipfile(File path) throws IOException {
		return unzipfile(path.toString(), FileHelper.getCurrentDirectory());
	}

/*
	public static boolean unzipfile(Path path) throws IOException {
		return unzipfile(path.toString(), FileHelper.getCurrentDirectory());
	}
*/

	public static boolean unzipfile(String zipFilePath, String destDirectory) throws IOException {
		if (!new File(zipFilePath).exists()) {
			logger.error("Error: No such file: " + zipFilePath);
			return false;
		}
        	File destDir = new File(destDirectory);
        	if (!destDir.exists()) {
			logger.debug("Creating directory: " + destDir.toString() + "...");
           	 	destDir.mkdir();
        	}
		logger.debug("Unzipping file: " + zipFilePath + ", to: " + destDirectory + "...");
        	ZipInputStream zipIn = new ZipInputStream(new FileInputStream(zipFilePath));
        	ZipEntry entry = zipIn.getNextEntry();
        	// iterates over entries in the zip file
       	 	while (entry != null) {
            		String filePath = destDirectory + File.separator + entry.getName();
            		if (!entry.isDirectory()) {
                		// if the entry is a file, extracts it
                		extractFile(zipIn, filePath);
            		} else {
                		// if the entry is a directory, make the directory
               		 	File dir = new File(filePath);
                		dir.mkdir();
   		        }
            		zipIn.closeEntry();
            		entry = zipIn.getNextEntry();
        	}
        	zipIn.close();
		logger.debug("Unzipping complete.");
		return true;
    	}
    
	private static void extractFile(ZipInputStream zipIn, String filePath) throws IOException {
        	BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(filePath));
        	byte[] bytesIn = new byte[BUFFER_SIZE];
        	int read = 0;
       		 while ((read = zipIn.read(bytesIn)) != -1) {
            		bos.write(bytesIn, 0, read);
        	}
        	bos.close();
    	}

    	public static class Test {
		public static void main(String args[]) throws IOException {
/*
			if ((args.length != 1) && (args.length !=2)) {
				System.err.println("Usage: java UnzipUtility$Test <zipfile> [<destinationdir>]");
				System.exit(0);
			}
			String srcfile = args[0];
			String destdir = System.getProperty("user.dir");
			if (args.length == 2) {
				destdir = args[1];
			}
			File fsrcfile = new File(srcfile);
			if (!fsrcfile.exists()) {
				System.err.println("Error: file does not exist: " + fsrcfile);
				System.exit(1);
			}
			String type = Files.probeContentType(fsrcfile.toPath());
			if (!type.equals("application/zip")) {
				System.err.println("Error: file mime type is not application/zip: " + fsrcfile);
				System.exit(1);
			}
			File fdestdir = new File(destdir);
			if (!fdestdir.exists()) {
				System.err.println("Error: destination directory does not exit: " + fdestdir);
				System.exit(1);
			}
			if (!fdestdir.isDirectory()) {
				System.err.println("Error: destination directory is not valid: " + fdestdir);
				System.exit(1);
			}
    			unzipfile(srcfile, destdir);
*/
		}
    	}
}
