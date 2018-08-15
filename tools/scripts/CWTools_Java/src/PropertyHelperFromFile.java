package com.jeremy.tools;

import java.io.*;

public class PropertyHelperFromFile extends PropertyHelper {
	
	public PropertyHelperFromFile(String sFilename, String sPattern) {
		super(sFilename, sPattern);
	}
	
	public InputStream getInputStream(String sPropfilename) throws FileNotFoundException {
		// Note: This should work with any property file on the classpath, 
		// excluding a property file held inside the program jar file.
		return new FileInputStream(sPropfilename);
	}
}
