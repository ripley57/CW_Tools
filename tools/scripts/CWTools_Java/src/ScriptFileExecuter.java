/*
** Description:
**		Class to launch a Windows script from a Java program, including 
**		a script contained inside a Jar file.
*/

package com.jeremy.tools;

import java.io.*;
import java.util.*;
import org.apache.log4j.Logger;

public class ScriptFileExecuter {
	static Logger logger = Logger.getLogger(ScriptFileExecuter.class);

	public void executeScriptFromResource(String scriptPath, String[] scriptPrefixArgs, String scriptSuffix, String[] args) 
			throws FileNotFoundException, IOException {
				
		File tempScriptFile = copyFileToTempFile(getInputStreamFromResource(scriptPath), scriptSuffix);
		executeScriptFile(tempScriptFile, scriptPrefixArgs, args);
		try {tempScriptFile.delete();} catch (Exception e) {}
	}

	public void executeScriptFromFile(String scriptPath, String[] scriptPrefixArgs, String scriptSuffix, String[] args) 
			throws FileNotFoundException, IOException  {
		
		File tempScriptFile = copyFileToTempFile(getInputStreamFromFile(scriptPath), scriptSuffix);
		executeScriptFile(tempScriptFile, scriptPrefixArgs, args);
		try {tempScriptFile.delete();} catch (Exception e) {}
	}
	
	private InputStream getInputStreamFromResource(String file) 
			throws FileNotFoundException {
		InputStream input = this.getClass().getClassLoader().getResourceAsStream(file);
		if (input == null)
			throw new FileNotFoundException(file);
		return input;
	}
	
	public InputStream getInputStreamFromFile(String file) 
			throws FileNotFoundException {
		InputStream input = new FileInputStream(file);
		if (input == null)
			throw new FileNotFoundException(file);
		return input;
	}
	
	private File copyFileToTempFile(InputStream input, String suffix) 
			throws IOException {
		File tempFile = File.createTempFile("temp", Long.toString(System.nanoTime()) + suffix);
		OutputStream output = null;
		try {
			output = new FileOutputStream(tempFile);
			byte[] buf = new byte[1024];
			int bytesRead;
			while ((bytesRead = input.read(buf)) > 0) {
				output.write(buf, 0, bytesRead);
			}
		} finally {
			output.close();
			input.close();
		}
		return tempFile;
	}
	
	private void executeScriptFile(File script, String[] scriptPrefixArgs, String[] args) 
		throws IOException
	{
		String[] argsScript = new String[1];
		argsScript[0] = script.toString();
		
		ArrayList<String> temp = new ArrayList<String>();
		temp.addAll(Arrays.asList(scriptPrefixArgs));
		temp.addAll(Arrays.asList(argsScript));
		temp.addAll(Arrays.asList(args));
		String[] concatedArgs = temp.toArray(new String[1+args.length]);
		
		logger.debug(Arrays.toString(concatedArgs));
		
		Process p = Runtime.getRuntime().exec(concatedArgs);
		BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
		String line = null;
		while ((line = in.readLine()) != null) {
			System.out.println(line);
		}
	}
}