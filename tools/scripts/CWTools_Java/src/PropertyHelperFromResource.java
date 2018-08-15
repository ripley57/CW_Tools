package com.jeremy.tools;

import java.io.*;

public class PropertyHelperFromResource extends PropertyHelper {
	
	public PropertyHelperFromResource(String sFilename, String sPattern) {
		super(sFilename, sPattern);
	}
	
	public InputStream getInputStream(String sPropfilename) {
		// Note: This should work when reading a property file held inside the program jar file.
		return this.getClass().getClassLoader().getResourceAsStream(sPropfilename);
	}
}