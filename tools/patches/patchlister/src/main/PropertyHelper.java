package com.jeremy.tools;

import java.io.*;
import java.util.Properties;

import org.apache.log4j.*;
 
public class PropertyHelper {
	static Logger logger = Logger.getLogger(PropertyHelper.class);
    
	public String getProperty(String propname) {
		return getProperty(propname, "patchlister.properties");
	}

	// TODO;
	// Create getPropertyFromFile() and getPropertyFromResource().
	// Adding getPropertyFromFile() will allow the program to
	// read properties from a local file, rather than the file
	// inside the jar. This would be useful for testing, etc.
	// Perhaps use a property to invoke the appropriate one,
	// e.g. by utilizing a factory to create the appropriate
	// PropertyHelper.

	// First check if the property is already defined (perhaps by
	// an override on the command-line. If not, we fall through and
	// and read the property value from the specified property file.
	public String getProperty(String propname, String propfilename) {
		String propval = System.getProperty(propname);
		if (propval != null && propval.length() > 0) {
			return propval;
		}

		Properties prop = new Properties();
		InputStream input = null;
		String value = "";
		try {
			// NOTE: A property file inside a jar file
			// can only be read by using "getResource()".
			//input = new FileInputStream(propfilename);
			input = this.getClass().getClassLoader().getResourceAsStream(propfilename);
			prop.load(input);
			value = prop.getProperty(propname);
 
		} catch (IOException ex) {
			ex.printStackTrace();
		} finally {
			if (input != null) {
				try { input.close(); } catch (IOException e) {}
			}
		}
		return value;
	}
}
