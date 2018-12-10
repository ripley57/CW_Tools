/*
 * Description:
 *
 * Implement a simple class for getting and setting an application's runtime properties.
*/

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map.Entry;
import java.util.Properties;

public final class Config {

	private static Properties GLOBAL_PROPS;
	private static final String PROPERTIES_FILE = "config/app.properties";

	private static final String REMOVED = "@removed@";

	private static final String PROPERTY_HOME = "app.home";
	private static final String PROPERTY_HOME_VALUE;

	public  static final String PROP_BACKUPDIR="app.backupdir";
    	private static final String PROP_BACKUPDIR_VALUE="backups";
	
    	static
	{
		PROPERTY_HOME_VALUE = System.getProperty(PROPERTY_HOME);
		
		GLOBAL_PROPS = new Properties();

		// Defaults.
        	GLOBAL_PROPS.setProperty(PROP_BACKUPDIR, PROP_BACKUPDIR_VALUE);
		
		readPropertiesFile(GLOBAL_PROPS, new File(PROPERTY_HOME_VALUE, PROPERTIES_FILE));
	}
	
	private static void dumpGlobalProps() {
		System.out.println("\nGLOBAL_PROPS:");
		for (Entry<?, ?> e : GLOBAL_PROPS.entrySet()) {
                String p = (String)e.getKey();
                String v = (String)e.getValue();
                System.out.println(String.format("%s=%s", p, v));
        }
	}
	
	public static void main(String[] args) {
		dumpGlobalProps();
		
		// Update an existing property.
		setProperty("testname", "testval_updated");
		
		// Add two new properties.
		setProperty("testname_new", "testval_new");
		setProperty("testname_new2", "testval_new2");
		setProperty("testarray1", "a,b,c,d,e");
		
		// Delete first new property.
		setProperty("testname_new2", "");
		
		dumpGlobalProps();
		
		System.out.println("\n");
		String[] testarray1 = getCommaSeparatedListProperty("testarray1", "");
		for (int i=0 ; i<testarray1.length; i++) {
			System.out.println(String.format("testarray1[%d]=%s", i, testarray1[i]));
		}
	}
	
	private static void readPropertiesFile(final Properties outProps, File inPropsFile) {
		try {
			FileInputStream fin = new FileInputStream(inPropsFile);
            		Properties props = new Properties();
            		props.load(fin);
            		for (Entry<?, ?> e : props.entrySet()) {
                		String p = (String)e.getKey();
                		String v = (String)e.getValue();
                		if (!v.equals(REMOVED))
                    			outProps.put(p, v);
            		}
		} catch (IOException ioe) {
            		throw new RuntimeException("Error reading properties file: " + inPropsFile);
		}
    	}
	
	public static String getProperty(String propName) {
        	return GLOBAL_PROPS.getProperty(propName);
    	}
	
	public static String getProperty(String propName, String defValue) {
        	return GLOBAL_PROPS.getProperty(propName, defValue);
    	}

    	public static boolean getBooleanProperty(String propName, boolean defValue) {
        	return convertToBoolean(getProperty(propName), defValue);
    	}

   	 public static boolean convertToBoolean(String str, boolean defValue) {
        	if (str.equals(""))
            		return defValue;
        	else
            		return "true".equalsIgnoreCase(str);
    	}

    	public static String[] getCommaSeparatedListProperty(String propName, String defVal)
    	{
        	String valsStr = getProperty(propName, defVal);
		
        	if(valsStr == null || valsStr.equals("")) {
            		return new String[] {};
        	}
		
		List<String> valsList = Arrays.asList(valsStr.split(","));
		String[] valsArr = new String[valsList.size()];
		valsArr = valsList.toArray(valsArr);
		return valsArr;
    	}

    	public static int[] getCommaSeparatedIntListProperty(String propName, String defVal) {
        	String[] valsStr = getCommaSeparatedListProperty(propName, defVal);
        	int[] valsArr = new int[valsStr.length];
        	int i = 0;
        	for (String s : valsStr) {
            		int value = Integer.parseInt(s.trim());
            		valsArr[i++] = value;
        	}
        	return valsArr;
    	}

    	private static String setProperty(String propName, String propVal) {
        	if (propVal == null || propVal.equals("") || REMOVED.equals(propVal))
            		return removeProp(propName);
       		 return (String)GLOBAL_PROPS.setProperty(propName, propVal);
    	}
	
	private static String removeProp(String propName) {
        	return (String)GLOBAL_PROPS.remove(propName);
    	}
}
