package com.jeremy.tools;

import java.io.*;
import org.apache.log4j.Logger;

public class LaunchShortcut extends Shortcut {
	static Logger logger = Logger.getLogger(LaunchShortcut.class);
	
	private String sDescription;
	
	private String sArg1_SpecialDir;
	private String sArg2_OptionalSubDir;
	private String sArg3_ShortcutName;
	
	public LaunchShortcut(String description, String args) {
		this.sDescription = description;
		
		/*
		** Parse arguments to launch a shortcut.
		**
		** Example sArgs value:
		**
		**    "Desktop","My Shortcuts","services.lnk"
		*/
		String[] argsArray = args.split(",");
		if (argsArray.length != 3) {
			throw new IllegalArgumentException("Expected args count: 3, actual: " + argsArray.length + " [" + description + " : " + args + "]");
		}
		sArg1_SpecialDir			= argsArray[0];
		sArg2_OptionalSubDir		= argsArray[1];
		sArg3_ShortcutName 			= argsArray[2];
	}
	
	public String toString() {
		return this.sDescription + ": SpecialDir:" + this.sArg1_SpecialDir + ", OptionalSubDir:" + this.sArg2_OptionalSubDir + ",  ShortcutName:" + this.sArg3_ShortcutName;
	}
	
	public void execute() throws FileNotFoundException, IOException {
		super.launchShortcut(sArg1_SpecialDir, sArg2_OptionalSubDir, sArg3_ShortcutName);
	}
}