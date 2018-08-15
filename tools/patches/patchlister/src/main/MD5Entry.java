package edp.support.patchlister;

import java.io.*;
import java.util.*;

import org.apache.log4j.Logger;

public class MD5Entry {
		
	static Logger logger = Logger.getLogger(MD5DirListerVisitor.class);
		
	String md5;
	File f;
			
	MD5Entry(String md5, File f) {
		this.md5 = md5;
		this.f = f;
	}
	
	String getMD5() { return this.md5; }
	File getFile() { return this.f; }
	
	String asString() { return this.md5+" "+f; }
	
	boolean matchesMD5(MD5Entry e) {
		return e.getMD5().equals(this.md5);
	}
	
	boolean matchesFilePath(MD5Entry e, List<String> packageNames) {
		String s1 = e.getFile().toString();
		String s2 = this.getFile().toString();
			
		// Look for package name in either of two formats: "/com/" or "\com\".			
		for (String p : packageNames) {		
			// Look for Format 1.
			int ps1_Idx1 = s1.indexOf("\\"+p+"\\");	
			int ps2_Idx1 = s2.indexOf("\\"+p+"\\"); 
			
			// Look for Format 2.
			int ps1_Idx2 = s1.indexOf("/"+p+"/");
			int ps2_Idx2 = s2.indexOf("/"+p+"/");
				
			if (ps1_Idx1 != -1 && ps2_Idx1 != -1) {		// Format 1 match.
				// Strip prefixes.
				String ss1 = s1.substring(ps1_Idx1);
				String ss2 = s2.substring(ps2_Idx1);
				//logger.info("Will compare: s1=" + ss1 + ", s2=" + ss2);
				if (ss1.equals(ss2)) 
					return true;	// Match.
			}
			
			if (ps1_Idx2 != -1 && ps2_Idx2 != -1) {		// Format 2 match.
				// Strip prefixes.
				String ss1 = s1.substring(ps1_Idx2);
				String ss2 = s1.substring(ps2_Idx2);
				//logger.info("Will compare: s1=" + ss1 + ", s2=" + ss2);
				if (ss1.equals(ss2))
					return true;	// Match.
			}
		}

		return false;	// No match.
	}
}