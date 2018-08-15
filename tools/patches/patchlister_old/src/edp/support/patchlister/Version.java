package edp.support.patchlister;

import com.jeremy.tools.*;

public class Version
{
	public static String getVersionInfo() {
		// Read version string from the properties file.
		String version = new PropertyHelper().getProperty("patchlister.version");
		return version;
	}
}
	