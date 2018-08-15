package com.jeremy.tools;

import java.net.*;
import java.io.*;
import org.apache.log4j.Logger;
 
/**
 * Utility to download a url.
 */
public class DownloadUtility {

	static Logger logger = Logger.getLogger(DownloadUtility.class);

	private static final int BUFFER_SIZE = 1048576;
    
    	public static void downloadurl(String strFileUrl, String strDestFile, String strDestDirectory) throws IOException {
		InputStream in = null;
		OutputStream out = null;

		try {
        		File fdestDir = new File(strDestDirectory);
        		if (!fdestDir.exists()) {
				logger.debug("Creating directory: " + fdestDir.toString() + "...");
			}
            		fdestDir.mkdir();
        		URL url = new URL(strFileUrl);
			in = url.openStream();
			//Path outPath = FileSystems.getDefault().getPath(strDestDirectory, strDestFile);
			File outPath = new File(strDestDirectory, strDestFile);
			logger.debug("Downloading url: " + url.toString() + ", to: " + outPath.toString() + "...");
			out = new FileOutputStream(outPath.toString());
        		byte[] buffer = new byte[BUFFER_SIZE];
			int bytes_read;
			while ((bytes_read = in.read(buffer)) != -1) {
				out.write(buffer, 0, bytes_read);
			}
			logger.debug("Download complete.");
		}
		finally {
			try { 
				if (in != null) in.close(); if (out != null) out.close(); 
			} catch (Exception e) {}
		}
    	}

    	public static class Test {
		public static void main(String args[]) throws IOException {
/*
** Remove references to Path class. We don't want to introduce a dependency on Java 1.7.

			Path p = null;
			if ((args.length != 1) && (args.length != 2) && (args.length != 3)) {
				System.err.println("Usage: java DownloadUtility$Test <url> [<destinationdir>] [<destfilename>]");
				System.exit(0);
			}
			if (args.length == 1) {
				// Extract filename from URL and use the current directory as the destination directory.
				String destdir = System.getProperty("user.dir");
				Path destfilename = new File(args[0]).toPath().getFileName();
				p = FileSystems.getDefault().getPath(destdir, destfilename.toString());
			}
			if (args.length == 2) {
				String s = args[1];
				if (s.matches("(.*)\\.(.*)")) {
					// Treat the second argument as the destination filename.
					// Use the current directory as the destination directory.
					String destdir = System.getProperty("user.dir");
					p = FileSystems.getDefault().getPath(destdir, s);
				} else {
					// Treat the second argument as the destination directory.
					// Extract the destination filename from the source url.
					String destdir = System.getProperty("user.dir") + File.separator + s;
					Path filename = new File(args[0]).toPath().getFileName();
					p = FileSystems.getDefault().getPath(destdir, filename.toString());
				}
			}
			if (args.length == 3) {
				// Use the second argument as the destination directory.
				// Use the third argument as the destination filename.
				String destdir = System.getProperty("user.dir") + File.separator + args[1];
				p = FileSystems.getDefault().getPath(destdir,args[2]);
			}
			//System.out.println("p=" + p.toString());
			downloadurl(args[0], p);
*/
		}
    	}
}
