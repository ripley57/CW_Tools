package com.jeremy.tools;

import java.io.*;

public class AddShortcut extends Shortcut {
	private String sDescription;
	
	private String sArg1_SpecialDir;
	private String sArg2_OptionalSubDir;
	private String sArg3_ShortcutName;
	private String sArg4_ShortcutTarget;
	private String sArg5_ShortcutDescription;
	
	public AddShortcut(String description, String args) {
		this.sDescription = description;
		
		/*
		** Parse arguments to add a shortcut.
		**
		** Example sArgs value:
		**
		**    "Desktop","My Shortcuts","services.lnk","C:\Windows\System32\services.msc","My link to services"
		**
		** This example creates a shortcut file "services.lnk" in the Desktop sub-directory "My Shortcuts". The
		** shortcut points to "C:\Windows\System32\services.msc" and has a description of "My link to services".
		*/
		String[] argsArray = args.split(",");
		if (argsArray.length != 5) {
			throw new IllegalArgumentException(description + " : " + args);
		}
		sArg1_SpecialDir			= argsArray[0];
		sArg2_OptionalSubDir		= argsArray[1];
		sArg3_ShortcutName 			= argsArray[2];
		sArg4_ShortcutTarget 		= argsArray[3];
		sArg5_ShortcutDescription 	= argsArray[4];
	}
	
	public String toString() {
		return this.sDescription + ": SpecialDir:" + this.sArg1_SpecialDir + ", OptionalSubDir:" + this.sArg2_OptionalSubDir + ",  ShortcutName:" + this.sArg3_ShortcutName + ", ShortcutTarget:" + this.sArg4_ShortcutTarget + ", ShortcutDescription:" + this.sArg5_ShortcutDescription;
	}
	
	public void execute() throws FileNotFoundException, IOException {
		super.addShortcut(sArg1_SpecialDir, sArg2_OptionalSubDir, sArg3_ShortcutName, sArg4_ShortcutTarget, sArg5_ShortcutDescription);
	}
}