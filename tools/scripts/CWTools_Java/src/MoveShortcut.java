package com.jeremy.tools;

import java.io.*;

public class MoveShortcut extends Shortcut {
	private String sDescription;
	
	private String sArg1_SpecialSourceDir;
	private String sArg2_OptionalSourceSubDir;
	private String sArg3_ShortcutName;
	private String sArg4_SpecialDestDir;
	private String sArg5_OptionalDestSubDir;
		
	public MoveShortcut(String description, String args) {
		this.sDescription = description;
				
		/*
		** Parse arguments to move a shortcut.
		**
		** Example sArgs value:
		**
		**    "Desktop","folder1","test.lnk","Desktop","folder2"
		**
		** This example moves a shortcut file "test.lnk" from the Desktop sub-directory "folder1"
		** to the Desktop sub-directory "folder2".
		*/
		String[] argsArray = args.split(",");
		if (argsArray.length != 5) {
			throw new IllegalArgumentException("Expected args count: 5, actual: " + argsArray.length + " [" + description + " : " + args + "]");
		}
		sArg1_SpecialSourceDir		= argsArray[0];
		sArg2_OptionalSourceSubDir	= argsArray[1];
		sArg3_ShortcutName 			= argsArray[2];
		sArg4_SpecialDestDir 		= argsArray[3];
		sArg5_OptionalDestSubDir 	= argsArray[4];
	}
	
	public String toString() {
		return this.sDescription + ": SpecialSourceDir:" + this.sArg1_SpecialSourceDir + ", OptionalSourceSubDir:" + this.sArg2_OptionalSourceSubDir + ",  ShortcutName:" + this.sArg3_ShortcutName + ", SpecialDestDir:" + this.sArg4_SpecialDestDir + ", OptionalDestSubDir:" + this.sArg5_OptionalDestSubDir;
	}
	
	public void execute() throws FileNotFoundException, IOException {
		super.moveShortcut(sArg1_SpecialSourceDir, sArg2_OptionalSourceSubDir, sArg3_ShortcutName, sArg4_SpecialDestDir, sArg5_OptionalDestSubDir);
	}
}
