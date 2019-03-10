import java.io.*;
import java.util.*;
import org.apache.log4j.Logger;
import com.jeremy.tools.*;

public class CWTools {
	static Logger logger = Logger.getLogger(CWTools.class);

	private static void usage() {
		System.err.println(	"\nUsage: java -jar cwtools.jar                 \n" +
					"             [-+cygwin] [-+cwtools]                    \n" +
					"             [-+cygwin_download]  [-+cygwin_install]	\n" +
					"             [-+cwtools_download] [-+cwtools_install]	\n" +
					"             [--dropbox] [--github]                    \n" +
					"             [--dry_run]                               \n" +
					"														\n" + 
					"Some useful property overrides: 					    \n" + 
					"    -Dlog4j.logger.CWTools=DEBUG    					\n" +
					"    -Dlog4j.logger.com.jeremy.tools=DEBUG    			\n" +
					"    -Dcwtools.processshortcuts=false					\n" + 	
					"    -Durl.cwtools=<cwtools_zip_url> 		  			\n" +
					"    -Durl.cygwin=<cygwin_zip_url>   					\n\n"	);
	}

	private enum Cygwin {
		GITHUB  ("url.github.cygwin","Cygwin_Light-master.zip","Cygwin_Light-master","Cygwin.zip"),
		DROPBOX ("url.dropbox.cygwin","Cygwin.zip","Cygwin_Light_08072018-master:Cygwin_Light_09062018-master:Cygwin_Light_04062018-master:Cygwin_Light_22042018-master:Cygwin_Light_03032018-master:Cygwin_Light_05032019-master:Cygwin_Light_10032019:Cygwin_Light-master","Cygwin.zip");

		private final String url_prop_name;
		private final String zip_name;
		private final String zip_dir_names;
		private final String zip_renamed_name;

		Cygwin(String s1, String s2, String s3, String s4) {
			this.url_prop_name 	= s1;
			this.zip_name  		= s2;
			this.zip_dir_names 	= s3;
			this.zip_renamed_name	= s4;
		}

		String getUrlPropName()	   	{	return url_prop_name;		}
		String getZipName()			{	return zip_name;			}
		String getZipRenamedName() 	{	return zip_renamed_name;	}
		
		// Return the unzipped folder name created.
		String getZipDirName()	{	
			// Return first folder name that exists (in the current directory).
			List<String> possible_folder_names = Arrays.asList(zip_dir_names.split(":"));
			for (String f : possible_folder_names) {
				if (FileHelper.fileExists(".", f)) {
					logger.info("Found Cygwin unzipped folder: " + f);
					return f;
				}
			}
			return null;
		}	

		String printString() { return this + ": url_prop_name=" + url_prop_name + ", zip_name=" + zip_name + 
					             ", zip_dir_names=" + zip_dir_names + ", zip_renamed_name=" + zip_renamed_name; }
	}

	private enum CW_Tools {
		GITHUB  ("url.github.cwtools","CW_Tools-master.zip","CW_Tools-master","CW_Tools.zip"),
		DROPBOX ("url.dropbox.cwtools","CW_Tools.zip","CW_Tools-master","CW_Tools.zip");

		private final String url_prop_name;
		private final String zip_name;
		private final String zip_dir_names;
		private final String zip_renamed_name;

		CW_Tools(String s1, String s2, String s3, String s4) {
			this.url_prop_name 	= s1;
			this.zip_name  		= s2;
			this.zip_dir_names	= s3;
			this.zip_renamed_name   = s4;
		}

		String getUrlPropName()		{	return url_prop_name;		}
		String getZipName()	  		{	return zip_name;			}
		String getZipRenamedName() 	{	return zip_renamed_name;	}
		
		// Return the unzipped folder name created.
		String getZipDirName()	{	
			// Return first folder name that exists (in the current directory).
			List<String> possible_folder_names = Arrays.asList(zip_dir_names.split(":"));
			for (String f : possible_folder_names) {
				if (FileHelper.fileExists(".", f)) {
					logger.info("Found Cygwin unzipped folder: " + f);
					return f;
				}
			}
			return null;
		}	
		
		String printString() { return this + ": url_prop_name=" + url_prop_name + ", zip_name=" + zip_name + 
						     ", zip_dir_names=" + zip_dir_names + ",zip_renamed_name=" + zip_renamed_name; }
	}

	public static void main(String args[]) {
		// The following function allows us to override Log4j properties
		// via the command-line. For example, the following can be used:
		// java -Dlog4j.logger.CWTools=INFO -jar cwtools.jar
		Log4jHelper.configureLog4jFromSystemProperties();

		/*
		** Download and install cygwin and cwtools by default.
		*/
		boolean bDownloadCygwin  = true;
		boolean bDownloadCWTools = true;
		boolean bInstallCygwin   = true;
		boolean bInstallCWTools  = true;

		/*
		** Don't run the actual commands, just give a preview.
		*/
		boolean bDryRun = false;
		
		/*
		** Download the Dropbox versions by default.
		*/
		Cygwin   cygwinzip  = Cygwin.DROPBOX;
		CW_Tools cwtoolszip = CW_Tools.DROPBOX;

		/*
		** Process command-line arguments to override the default behaviour.
		*/
		for (String s: args) {
			if (s.equals("+cygwin")) { bDownloadCygwin = true;	bInstallCygwin = true; }
            else if (s.equals("-cygwin")) { bDownloadCygwin = false; bInstallCygwin = false; }
			else if (s.equals("+cygwin_download")) { bDownloadCygwin = true; }
			else if (s.equals("-cygwin_download")) { bDownloadCygwin = false; }
			else if (s.equals("+cygwin_install")) {	bInstallCygwin = true; }
			else if (s.equals("-cygwin_install")) {	bInstallCygwin = false; }
            else if (s.equals("+cwtools")) { bDownloadCWTools = true; bInstallCWTools  = true; }
			else if (s.equals("-cwtools")) { bDownloadCWTools = false; bInstallCWTools = false; }
			else if (s.equals("+cwtools_download")) { bDownloadCWTools = true; }
			else if (s.equals("-cwtools_download")) { bDownloadCWTools = false;	}
			else if (s.equals("+cwtools_install")) { bInstallCWTools = true; }
			else if (s.equals("-cwtools_install")) { bInstallCWTools = false; }
			else if (s.equals("--github")) { cygwinzip = Cygwin.GITHUB; cwtoolszip = CW_Tools.GITHUB; }
			else if (s.equals("--dropbox")) { cygwinzip  = Cygwin.DROPBOX; cwtoolszip = CW_Tools.DROPBOX; }
			else if (s.equals("--dry_run")) { bDryRun = true; }
			else if (s.equals("-h") || s.equals("-help") || s.equals("/?")) { usage(); System.exit(0); }
			//else { System.err.println("\nInvalid argument: " + s); usage(); System.exit(1); }
		}

		if (bDryRun) logger.info("Running in --dry_run mode ...");

		/*
		** Don't download the zip files if they already exist.
		*/
		if (bDownloadCygwin && new File(cygwinzip.getZipRenamedName()).exists()) {
			logger.info("Skipping download of cygwin because zip found in current directory.");
			bDownloadCygwin = false;
		}
		if (bDownloadCWTools && new File(cwtoolszip.getZipRenamedName()).exists()) {
			logger.info("Skipping download of cwtools because zip found in current directory.");
			bDownloadCWTools = false;
		}

		logger.debug("DEBUG: download_cygwin  = " + bDownloadCygwin);
		logger.debug("DEBUG: download_cwtools = " + bDownloadCWTools);
		logger.debug("DEBUG: install_cygwin   = " + bInstallCygwin);
		logger.debug("DEBUG: install_cwtools  = " + bInstallCWTools);
		logger.debug("DEBUG: cygwin           = " + cygwinzip.printString());
		logger.debug("DEBUG: cwtools          = " + cwtoolszip.printString());

		// Do the actual work here.
		try {
			if (bDownloadCygwin)  downloadZip(cygwinzip.getUrlPropName(), cygwinzip.getZipRenamedName(), ".", bDryRun);
			if (bDownloadCWTools) downloadZip(cwtoolszip.getUrlPropName(), cwtoolszip.getZipRenamedName(), ".", bDryRun);
			if (bInstallCygwin)	  installCygwin(cygwinzip, bDryRun);
			if (bInstallCWTools)  installCWTools(cwtoolszip, bDryRun);
		}
		catch (Exception ex) {
			System.err.println("Error: unknown error: " + ex);
		}
		finally {
			tidy();
		}
		
		logger.info("Finished!");
	}

	private static void downloadZip(String sUrlPropName, String sRenamedZipName, String sDestDir, boolean bDryRun)
		throws Exception
	{
		String sUrl = new PropertyHelper("cwtools.properties").getProperty(sUrlPropName);
		logger.info("Downloading " + sUrl + " ...");
		if (!bDryRun) DownloadUtility.downloadurl(sUrl, sRenamedZipName, sDestDir);
	}

	private static void installCygwin(Cygwin cygwinzip, boolean bDryRun)
		throws IOException
	{
		logger.info("Installing Cygwin zip ...");
		
		/*
		** Unzip the cygwin zip into the current directory.
		*/
		File sZipFileName = new File(cygwinzip.getZipRenamedName(), ".");
		logger.info("Unzipping: " + sZipFileName + " ...");
		if (!bDryRun) UnzipUtility.unzipfile(sZipFileName);

		/* 
		** Rename the unzipped cygwin directory.
		*/
		logger.info("Renaming extracted directory to Cygwin ...");
		if (new File("Cygwin").exists()) {
			System.err.println("Error: Directory Cygwin already exists.");
			System.exit(1);
		}
		if (!bDryRun && !FileHelper.rename(cygwinzip.getZipDirName(),"Cygwin")) {
			System.err.println("Error: Could not rename Cygwin directory.");
			System.exit(1);
		}
	}

	private static void installCWTools(CW_Tools cwtoolszip, boolean bDryRun)
		throws IOException
	{
		logger.info("Installing CW Tools zip ...");
		
		/*
		** Unzip the cwtools zip into the current dirctory.
		*/
		File sZipFileName = new File(cwtoolszip.getZipRenamedName(), ".");
		logger.info("Unzipping: " + sZipFileName + " ...");
		if (!bDryRun) UnzipUtility.unzipfile(sZipFileName);

		/*
		** We've just installed cygwin, so we therefore want to unzip
		** the cwtools zip and move the unzipped directory into the
		** Bash skeleton user directory.
		*/
		File f_source = new File(cwtoolszip.getZipDirName());
		File f_target = new File("Cygwin/etc/skel/CW_Tools");
		if (!f_target.exists()) {
			logger.info("Moving CW_Tools to the skeleton directory ...");
			if (!bDryRun) f_source.renameTo(f_target);
		}

		/*
		** Create a Cygwin-run.bat script for launching Cygwin.
		*/
		if (!bDryRun) createCygwinBatchScript(new File("Cygwin/bin").getAbsolutePath());

		/*
		** Move the script to the Cygwin directory.
		*/
		File f_script_source = new File("Cygwin-run.bat");
		File f_script_target = new File("Cygwin/Cygwin-run.bat");
		logger.info("Moving Cygwin-run.bat to Cygwin/Cygwin-run.bat ...");
		if (!bDryRun) f_script_source.renameTo(f_script_target);
		
		/*
		** Create Desktop shortcut to launch Cygwin.
		*/
		if (!bDryRun && Boolean.parseBoolean(new PropertyHelper("cwtools.properties").getProperty("cwtools.addcygwinshortcut")))
			createdesktopshortcut();
		
		/*
		** Tidy existing shortcuts as described in shortcuts.properties.
		*/
		if (!bDryRun && Boolean.parseBoolean(new PropertyHelper("cwtools.properties").getProperty("cwtools.processshortcuts")))
			addremovemoveshortcuts();
		
		/*
		** Launch the Cygwin shortcut. 
		*/
		if (!bDryRun && Boolean.parseBoolean(new PropertyHelper("cwtools.properties").getProperty("cwtools.launchcygwinshortcut")))
			launchcygwinshortcut();
	}
	
	/*
	** Create Desktop shortcut to launch Cygwin.
	*/
	private static void createdesktopshortcut() throws java.io.FileNotFoundException, java.io.IOException
	{
		logger.info("Creating desktop shortcut to Cygwin ...");
		String args = "\"Desktop\",\"\",\"CW_Tools.lnk\",\"" + new File("Cygwin/Cygwin-run.bat").getAbsolutePath() + "\",\"Auto-generated Cygwin link\"";
		AddShortcut s = new AddShortcut("Cygwin shortcut", args);
		logger.debug("DEBUG: CWTools::createdesktopshortcut(): " + s.toString());
		s.execute();	
	}
	
	/*
	** Run the Desktop shortcut to Cygwin.
	** This should start the copying of the skeleton files.
	**
	** Note: We've updated the /etc/profile file in the Cygwin.zip to call
	**       our install.sh script once after the skeleton files have been copied. 
	**		 This therefore means that the entire installation is now automated:
	**			1) cwtools.bat calls java -jar cwtools.jar
	**			2) cwtools.jar (this Java file) creates a shortcut to Cygwin-run.bat.
	**			3) The shortcut is then executed (by this Java file). This initiates 
	**			   the copying of the skeleton files via the /etc/profile file.
	**			4) The /etc/profile file then calls our install.sh script which 
	**			   updates the ~/.bash_profile file. 
	** JeremyC 20/1/2017.
	*/
	private static void launchcygwinshortcut()	throws java.io.FileNotFoundException, java.io.IOException
	{
		logger.info("Launching Cygwin desktop shortcut ...");
		String args = "\"Desktop\",\"\",\"CW_Tools.lnk\"";
		LaunchShortcut s = new LaunchShortcut("Cygwin shortcut", args);
		logger.debug("DEBUG: CWTools::launchcygwinshortcut(): " + s.toString());
		s.execute();
	}

	/*
	** Remove files not needed that might confuse user what to do with them.
	*/
	private static void tidy() {
		logger.info("Tidying files ...");
		new File("Cygwin/setup-x86.exe").delete();
		new File("Cygwin/Cygwin-Terminal.ico").delete();
		new File("Cygwin/Cygwin.ico").delete();
		new File("Cygwin/Cygwin.bat").delete();
	}

	private static void createCygwinBatchScript(String cygwindir) {
		logger.info("Creating Cygwin batch script ...");
		
		String scriptname = "Cygwin-run.bat";
		logger.debug("DEBUG: CWTools::createCygwinBatchScript(): scriptname=" + scriptname + ", cygwindir=" + cygwindir);
		
		// Determine window size dimensions.
		String windowsize = new PropertyHelper("cwtools.properties").getProperty("cwtools.windowsize");
		String[] sizeargs = windowsize.split(",");
		String width  = sizeargs[0];
		String height = sizeargs[1];
		String buffer = sizeargs[2];	
		logger.debug("DEBUG: CWTools::createCygwinBatchScript(): width=" + width + ", height=" + height + ", buffer=" + buffer);
		
		try {
			PrintWriter writer = new PrintWriter(scriptname, "UTF-8");
			String content = String.format("@echo off							\n" +
							 "												 	\n" +
							 "REM Set window size.								\n" +				
							 "powershell -command \"&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.width=%s;$B.height=%s;$W.buffersize=$B;$C=$W.windowsize;$C.width=%s;$C.height=%s;$W.windowsize=$C} 2>$nul\"		     \n" + 
							 "												 	\n" +
							 "C: 							                    \n" +
							 "chdir " + cygwindir + 						   "\n" +
							 "		        									\n" +
							 "bash --login -i        							\n", width, buffer, width, height);
			//logger.debug("DEBUG: CWTools::createCygwinBatchScript(): content=" + content);
			writer.println(content);
			writer.close();
		}
		catch (Exception ex) {
			System.err.println("Error: Could not create cygwin batch script: " + ex);
		}
	}
	
	private static void addremovemoveshortcuts() {
		logger.info("Tidying shortcuts ...");
		List<Shortcut> shortcuts;
		Iterator<Shortcut> iter;
		try {
			ShortcutHelper sh = new ShortcutHelper("shortcuts.properties");
			
			// Add shortcuts.
			shortcuts = sh.getAddShortcuts();
			iter = shortcuts.listIterator();
			while (iter.hasNext()) {
				Shortcut s = iter.next();
				s.execute();
			}

			// Remove shortcuts.
			shortcuts = sh.getRemoveShortcuts();
			iter = shortcuts.listIterator();
			while (iter.hasNext()) {
				Shortcut s = iter.next();
				s.execute();
			}
		
			// Move shortcuts.
			shortcuts = sh.getMoveShortcuts();
			iter = shortcuts.listIterator();
			while (iter.hasNext()) {
				Shortcut s = iter.next();
				s.execute();
			}
		} catch (Exception e) {
			StringWriter sw = new StringWriter();
			e.printStackTrace(new PrintWriter(sw));
			System.out.println(sw.toString());
		}
	}
}
