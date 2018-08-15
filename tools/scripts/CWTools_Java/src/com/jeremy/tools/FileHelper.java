package com.jeremy.tools;

import java.io.*;
import org.apache.log4j.*;
 
public class FileHelper {
	static Logger logger = Logger.getLogger(FileHelper.class);
    
	public static String getCurrentDirectory() {
		return System.getProperty("user.dir");
	}

/*
** Comment this out to remove depedency on Path class which was introduced in Java 1.7.

	public static String getFileNameFromPath(String path) {
		return new File(path).toPath().getFileName().toString();
	}

	public static String getDirectoryNameFromPath(String path) {
		return new File(path).toPath().getRoot().toString();
	}
*/

	public static boolean fileExists(String dirname, String filename) {
		return new File(dirname, filename).exists();
	}


	public static boolean rename(String from, String to) {
		return new File(from).renameTo(new File(to));
	}

    	public static boolean setCurrentDirectory(String directory_name) {
        	boolean result = false;  // Boolean indicating whether directory was set
        	File    directory;       // Desired current working directory

        	directory = new File(directory_name).getAbsoluteFile();
		if (directory.exists()) {
            		result = (System.setProperty("user.dir", directory.getAbsolutePath()) != null);
        	}
        	return result;
    	}
}
