package com.jeremy.tools;

import java.io.*;

public abstract class Shortcut {
	protected ScriptFileExecuter sfe = new ScriptFileExecuter();
	
	//private String jarScriptPath = "test.vbs";
	private String jarScriptPath = "shortcuts.vbs";
	private	String[] jarScriptPrefixArgs = {"cmd","/c","cscript","/nologo"};
	private String jarScriptSuffix = ".vbs";			//Windows complains if the vbs script has not suffix.
	
	public abstract void execute() throws FileNotFoundException, IOException;

	/*
	** Call shortcuts.vbs to launch a shortcut.
	**
	** Command-line example:
	**		cscript shortcuts.vbs 	/launch:yes /sourcedirspecial:Desktop /sourcedir2:folder1 /linkname:test.lnk 
	*/
	protected void launchShortcut(	String sArg1_SpecialDir, 
									String sArg2_OptionalSubDir, 
									String sArg3_ShortcutName)	throws FileNotFoundException, IOException 			
	{
		// Debugging.
		//System.out.println(toString());	
			
		String[] args = new String[1+3];
		args[0] = "/launch:yes";
		args[1] = "/sourcedirspecial:\"" 	+ sArg1_SpecialDir 			+ "\"";
		args[2] = "/sourcedir2:\"" 			+ sArg2_OptionalSubDir 		+ "\"";
		args[3] = "/linkname:\"" 			+ sArg3_ShortcutName 		+ "\"";
		
		sfe.executeScriptFromResource(jarScriptPath, jarScriptPrefixArgs, jarScriptSuffix, args);
	}
	
	/*
	** Call shortcuts.vbs to create a shortcut.
	**
	** Command-line example:
	**		cscript shortcuts.vbs 	/create:yes /destdirspecial:Desktop /destdir2:folder1 \
'   **								/linkname:test.lnk /description:"My link" /target:"C:\Windows\System32\services.msc"
	*/
	protected void addShortcut(	String sArg1_SpecialDir, 
								String sArg2_OptionalSubDir, 
								String sArg3_ShortcutName, 
								String sArg4_ShortcutTarget, 
								String sArg5_ShortcutDescription)	throws FileNotFoundException, IOException 			
	{
		// Debugging.
		//System.out.println(toString());
		
		// Testing withh test.vbs.
		//String[] args = new String[2];
		//args[0] = "hello";
		//args[1] = "hello world";
		
		String[] args = new String[1+5];
		args[0] = "/create:yes";
		args[1] = "/destdirspecial:\"" 	+ sArg1_SpecialDir 			+ "\"";
		args[2] = "/destdir2:\"" 		+ sArg2_OptionalSubDir 		+ "\"";
		args[3] = "/linkname:\"" 		+ sArg3_ShortcutName 		+ "\"";
		args[4] = "/target:\"" 			+ sArg4_ShortcutTarget		+ "\"";
		args[5] = "/description:\"" 	+ sArg5_ShortcutDescription + "\"";
		
		sfe.executeScriptFromResource(jarScriptPath, jarScriptPrefixArgs, jarScriptSuffix, args);
	}

	/*
	** Call shortcuts.vbs to remove a shortcut.
	**
	** Command-line example:
	**		cscript shortcuts.vbs /delete:yes /sourcedirspecial:Desktop /sourcedir2:folder1 /filename:test.lnk 
	*/
	protected void removeShortcut(	String sArg1_SpecialDir, 
									String sArg2_OptionalSubDir, 
									String sArg3_ShortcutName)	throws FileNotFoundException, IOException
	{
		// Debugging.
		//System.out.println(toString());
		
		// Testing with test.vbs.
		//String[] args = new String[2];
		//args[0] = "hello";
		//args[1] = "hello world";
		
		String[] args = new String[1+3];
		args[0] = "/delete:yes";
		args[1] = "/sourcedirspecial:\"" 	+ sArg1_SpecialDir 		+ "\"";
		args[2] = "/sourcedir2:\"" 			+ sArg2_OptionalSubDir 	+ "\"";
		args[3] = "/filename:\"" 			+ sArg3_ShortcutName 	+ "\"";
		
		sfe.executeScriptFromResource(jarScriptPath, jarScriptPrefixArgs, jarScriptSuffix, args);
	}
	
	/*
	** Call shortcuts.vbs to move a shortcut.
	**
	** Command-line example:
	**		cscript shortcuts.vbs /move:yes /sourcedirspecial:Desktop /sourcedir2:folder1 \
	**							 /filename:test.lnk /destdirspecial:Desktop /destdir2:folder2
	*/
	protected void moveShortcut(String sArg1_SpecialSourceDir, 
								String sArg2_OptionalSourceSubDir, 
								String sArg3_ShortcutName, 
								String sArg4_SpecialDestDir, 
								String sArg5_OptionalDestSubDir)	throws FileNotFoundException, IOException
	{
		// Debugging.
		//System.out.println(toString());
		
		// Testing with test.vbs.
		//String[] args = new String[2];
		//args[0] = "hello";
		//args[1] = "hello world";
		
		String[] args = new String[1+5];
		args[0] = "/move:yes";
		args[1] = "/sourcedirspecial:\"" 	+ sArg1_SpecialSourceDir 		+ "\"";
		args[2] = "/sourcedir2:\"" 			+ sArg2_OptionalSourceSubDir 	+ "\"";
		args[3] = "/filename:\"" 			+ sArg3_ShortcutName 			+ "\"";
		args[4] = "/destdirspecial:\"" 		+ sArg4_SpecialDestDir			+ "\"";
		args[5] = "/destdir2:\"" 			+ sArg5_OptionalDestSubDir	 	+ "\"";
		
		sfe.executeScriptFromResource(jarScriptPath, jarScriptPrefixArgs, jarScriptSuffix, args);
	}
}
