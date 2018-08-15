package com.jeremy.tools;

import java.io.*;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.*;
 
public class PropertyHelper implements Iterable<Property> {
	static Logger logger = Logger.getLogger(PropertyHelper.class);
		
	private String sPropsFilename = null;
	private String sPropsPattern = ".*";
	private List<Property>	props = new ArrayList<Property>();
	    
	public PropertyHelper(String filename) {
		this.sPropsFilename = filename;
	}
	
	public PropertyHelper(String filename, String pattern) {
		this.sPropsFilename = filename;
		this.sPropsPattern = pattern;
	}
	
	public Iterator<Property> iterator() {
		props.clear();	// This function may be called multiple times.
		readPropsFile(this.sPropsFilename, this.sPropsPattern);
		return props.listIterator();
	}
	
	// Read all the properties that match the pattern from the properties file.
	private void readPropsFile(String sFilename, String sPattern) {
		Pattern p = Pattern.compile(sPattern);
		Properties prop = new Properties();
		InputStream input = null;

		try {
			input = getInputStream(sFilename);
			prop.load(input);
			Enumeration<?> e = prop.propertyNames();
			while (e.hasMoreElements()) {
				String key = (String)e.nextElement();
				Matcher m = p.matcher(key);				
				if (m.find()) {
					String value = prop.getProperty(key);	
					props.add(new Property(key, value));
				}
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		} finally {
			if (input != null) {
				try { input.close(); } catch (IOException e) {}
			}
		}
	}
	
	// A property file inside a jar file can only be read by using "getResource()".
	// Override this method using a new class if you want to use FileInputStream().	
	protected InputStream getInputStream(String sPropfilename) throws FileNotFoundException {
		return this.getClass().getClassLoader().getResourceAsStream(sPropfilename);
	}
	
	// Return the value of a single specified property.
	public String getProperty(String propname) {
		return getProperty(propname, this.sPropsFilename);
	}

	// Return the value of a single specified property.
	public String getProperty(String propname, String propfilename) {
		
		// First check if the property is already defined (perhaps by
		// an override on the command-line. If not, we fall through and
		// and read the property value from the specified property file.
		String propval = System.getProperty(propname);
		if (propval != null && propval.length() > 0) {
			return propval;
		}
		
		// Read the property from property file.
		Properties prop = new Properties();
		InputStream input = null;
		String value = "";
		try {
			input = input = getInputStream(propfilename);
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
