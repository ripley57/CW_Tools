package edp.support.patchlister;

import java.io.*;
import java.util.*;
import org.apache.log4j.*;

public class PatchLister
{
	static Logger logger = Logger.getLogger(PatchLister.class);
	
	boolean bDebug = false;
	boolean bCreateMD5Files = false;
	boolean bIncludeIgnoredFiles = true;
	boolean bOverwriteExistingMD5Files = false;
	boolean bAnalyzeByMD5 = false;
	boolean bAnalyzeByFilePath = false;
	File	md5OutputDirectory = null;
	File	reportOutputFile = null;
		
	private static void usage() {
		System.err.println(	"\nUsage:                                                         \n" +
		                    "    java -jar patchlister.jar                                    \n" +
							"                                                                 \n" +
							"        [-version]                                               \n" +
							"                                                                 \n" +
							"        [-md5 <dir1|file1> <dir2|file2> ...]                     \n" +
							"                                                                 \n" +
							"        [-createmd5files [-noignoredfiles]]                      \n" +
							"        [-overwriteexistingmd5files]                             \n" +
                            "        [-d <dir1>] [-d <dir2>] [-d1 <dir3>] [-d1 <dir4>] ...    \n" + 
							"        [-md5outputdir <dir>]                                    \n" +       
							"                                                                 \n" +
							"        [-analyzebymd5 | -analyzebyfilepath]                     \n" +
                            "        [-md5patchfilesdir <dir>]                                \n" +
							"        [-targetmd5file <file>]                                  \n" +  
							"        [-refenvmd5file <file>]                                  \n" + 
							"        [-reportoutputfile <file>]                               \n" +
					        "        [-packagenames <name1>,<name2>,<name3>...]		          \n" +
							"                                                                 \n" +
							"Example 1:                                                       \n" +
							"   Generate MD5 file listings for the following directories:     \n" +
							"                                                                 \n" +
							"   c:/Installed_classes : Copy of class files to examine.        \n" +
							"   c:/All_Patches       : Sub-dir containing each private patch. \n" +
							"   c:/714Fix1_Ref_Env   : Copy of files from 714Fix1 product.    \n" +
							"                                                                 \n" +
							"   java -jar patchlister.jar -createmd5files -d1 c:/All_Patches  \n" +
							"          -d c:/Installed_classes -d c:/714Fix1_Ref_Env          \n" +
							"          -overwriteexistingmd5files -md5outputdir md5files      \n" +
							"                                                                 \n" +
							"Example 2:                                                       \n" +
							"    Analyze the Installed_classes.md5 file:                      \n" +
							"                                                                 \n" +
							"    First, move non-patch MD5 file lists from output directory:  \n" +
							"    mv md5files/Installed_classes.md5 .                          \n" +
							"    mv md5files/714Fix1_Ref_Env.md5 .                            \n" +
							"                                                                 \n" +
							"    Now perform the analysis of Installed_clases.md5:            \n" + 
							"    java -jar patchlister.jar -analyzebymd5 -md5patchfilesdir    \n" +
							"        md5files -targetmd5file Installed_classes.md5            \n" +
							"        -refenvmd5file 714Fix1_Ref_Env.md5                       \n" +
							"        -reportoutputfile report.log                             \n" +
							"                                                                 \n" + 
							"Example 3:                                                       \n" +
                            "    Simply calculate MD5 values for specified files or           \n" + 
							"    directories of files.							              \n" +
							"                                                                 \n" +
							"    java -jar patchlister.jar -md5 *.txt someotherfile.txt       \n" +
							"                                                                 \n");
		System.exit(1);
	}
	
	public void run(String args[]) {
		/*
		** Directories to scan and generate MD5 file listings for.
		*/
		List<MD5DirList> dirsGenMD5s = new ArrayList<MD5DirList>(5);
		
		/*
		** Parent directories that will be scanned 
		** for sub-dirs existing at a depth of 1.
		*/
		List<File> dirsDepth1 = new ArrayList<File>(5);
		
		/*
		** Target MD5 file to analyze. It should usually only
		** be a single file, but we'll use a list here for 
		** possible future uses.
		*/
		List<File> md5FilesToAnalyze = new ArrayList<File>(1);
		
		/*
		** Directories containing ".md5" patch files that we
		** need to load into this program for later analysis
		** of a target directory or target md5 file.
		*/
		List<File> md5PatchFilesDir = new ArrayList<File>(5);
		
		/*
		** Product base version MD5 file list. 
		** If a file is not in one of the patches that we know about,
		** then we need to check it against a product base version MD5
		** file list, otherwise it could be in a patch that we don't
		** know about.
		*/
		List<File> md5RefEnvFile = new ArrayList<File>(1);
		
		/*
		** Java package names for use with "-analyzebyfilepath".
		*/
		List<String> packageNames = new ArrayList<String>(3);
		
		/*
		** Process the command-line arguments.
		*/
		int i=0;
		String arg;
		while (i < args.length) {
			arg = args[i++];
			//logger.info("arg=" + arg);
			if (arg.equals("-h") || arg.equals("-help")) {
				usage();
			} 
			else
			if (arg.equals("-version") || arg.equals("-v")) {
				// Display program build information.
				System.out.println(Version.getVersionInfo());
				System.exit(0);
			}
			else
			if (arg.equals("-md5")) {
				if (i < args.length) {
					// Display MD5 values for any files or directories.
					String[] s = new String[args.length-i];
					System.arraycopy(args, i, s, 0, args.length-i);
					try {
						new GlobLister().listallglobs(s);
					} 
					catch (Exception e) {
						System.err.println("ERROR: Unknown error listing MD5 values: " + e);
						e.printStackTrace();
						System.exit(1); 
					}
					System.exit(0);
				}
				else {
					usage();
				}
			}
			else
			if (arg.equals("-debug")) {
				bDebug = true;
				// Set default log4j loglevel to DEBUG.
				Logger.getRootLogger().setLevel(Level.toLevel("DEBUG"));
			}
			else
			if (arg.equals("-d")) {
				if (i < args.length) {
					File dir = new File(args[i]);
					if (!dir.exists()) {
						System.err.println("ERROR: Directory not found: " + dir);
						System.exit(1); 
					}
					dirsGenMD5s.add(new MD5DirList(dir.toPath()));
					i++;
				}
				else {
					usage();
				}
			}
			else
			if (arg.equals("-d1")) {
				if (i < args.length) {
					File dir = new File(args[i]);
					if (!dir.exists()) {
						System.err.println("ERROR: Parent directory not found: " + dir);
						System.exit(1); 
					}
					dirsDepth1.add(dir);
					i++;
				}
				else {
					usage();
				}
			}
			else 
			if (arg.equals("-createmd5files")) {
				bCreateMD5Files = true;
			}
			else 
			if (arg.equals("-noignoredfiles")) {
				bIncludeIgnoredFiles = false;
			}
			else
			if (arg.equals("-overwriteexistingmd5files")) {
				bOverwriteExistingMD5Files = true;
			}
			else
			if (arg.equals("-targetmd5file")) {
				if (i < args.length) {
					File dir = new File(args[i]);
					if (!dir.exists()) {
						System.err.println("ERROR: Target MD5 file to analyze not found: " + dir);
						System.exit(1); 
					}
					md5FilesToAnalyze.add(dir);
					i++;
				}
				else {
					usage();
				}
			}
			else
			if (arg.equals("-md5patchfilesdir")) {
				if (i < args.length) {
					File dir = new File(args[i]);
					if (!dir.exists()) {
						System.err.println("ERROR: Target MD5 file to analyze not found: " + dir);
						System.exit(1); 
					}
					md5PatchFilesDir.add(dir);
					i++;
				}
				else {
					usage();
				}
			}
			else
			if (arg.equals("-analyzebymd5")) {
				/*
				** When we compare the target MD5 file list with the patch
				** and/or reference env MD5 file lists, we will be using the
				** MD5 values.
				*/
				bAnalyzeByMD5 = true;
			}
			else
			if (arg.equals("-analyzebyfilepath")) {
				/*
				** When we compare the target MD5 file list with the patch
				** and/or reference env MD5 file lists, we will be using the
				** file path values, and not the MD5 values.
				*/
				bAnalyzeByFilePath = true;
			}
			else
			if (arg.equals("-refenvmd5file")) {
				/*
				** In order to account for every file in a target MD5 file list
				** being examined, we need to determine one of the following:
				**
				** 1. Is the file one that has been overwritten by a private patch?
				** 2. Is the file a recognized base file from the product version being examined? 
				** 3. Anything else is an unaccounted for file, most possibly a patch that
				**    we don't know anything about.
				**
				** This option checks each file against the provided MD5 file list
				* of a recognized product base version. For now, the product version 
				** is not detected automatically, so the product base version MD5
				** file list needs to be provided here by the user.
				*/		
				if (i < args.length) {
					File f = new File(args[i]);
					if (!f.exists()) {
						System.err.println("ERROR: Reference product MD5 file not found: " + f);
						System.exit(1); 
					}
					md5RefEnvFile.add(f);
					i++;
				}
				else {
					usage();
				}
			}
			else
			if (arg.equals("-md5outputdir")) {
				/*
				** Output directory for geneated MD5 files.
				*/
				if (i < args.length) {
					File d = new File(args[i]);
					if (!d.exists()) {
						try {
							d.mkdir();
						} catch (Exception e) {
							System.err.println("ERROR: Could not create directory: " + d);
							e.printStackTrace();
							System.exit(1); 
						}
					}
					md5OutputDirectory = d;
					i++;
				}
				else {
					usage();
				}
			}
			else
			if (arg.equals("-reportoutputfile")) {
				/*
				** Output detailed report file.
				*/
				if (i < args.length) {
					File f = new File(args[i]);
					reportOutputFile = f;
					i++;
				}
				else {
					usage();
				}
			}
			else
			if (arg.equals("-packagenames")) {
				/*
				** The "-analyzebyfilepath" option enables a target MD5 file list
				** to be examine by file paths rather than by file MD5 values.
				** This is useful when comparing two MD5 file lists to look for
				** clashing files, for example, if a new CHF1 includes some files
				** and will therefore obliterate one or more private patch files.
				**
				** To be able to compare file paths, we need to know the prefixes
				** we should remove before comparison. For example, consider how
				** we could examine the following file paths:
				**
				** c:\Installation_to_examine\classes\com\symc\cm\bulkdata\BulkDataImpl.class
				** c:\Installation_to_examine\classes\symc\cm\impl\\Employee.class
				**
				** In this example, we would say that "com" and "symc" are packages
				** we want to consider, so use a value of -packagenames com,symc
				**
				** We now know that these are the file paths to examine, and we can
				** also safely remove the file path up to this point, for our file
				** path comparisons.
				*/
				if (i < args.length) {
					String pnames = args[i];
					for (String s : pnames.split(",")) {
							packageNames.add(s);
					}
					i++;
				}
				else {
					usage();
				}
				
			}
			else {
				System.err.println("ERROR: Unrecognized option: " + arg);
				usage();
			}
		}
		
		if (bCreateMD5Files==true) {
			createMD5Files(bIncludeIgnoredFiles, bOverwriteExistingMD5Files, dirsGenMD5s, dirsDepth1, md5OutputDirectory);
		} 
		else 
		if (bAnalyzeByMD5==true) {
			Analyzer a = new MD5Analyzer(md5PatchFilesDir, md5FilesToAnalyze, md5RefEnvFile, reportOutputFile);
			a.analyze();
			a.printReport();
		}
		else
		if (bAnalyzeByFilePath==true) {
			Analyzer a = new FilePathAnalyzer(md5PatchFilesDir, md5FilesToAnalyze, reportOutputFile, packageNames);
			a.analyze();
			a.printReport();
		}
		else 
			usage();
	}
			
	private void createMD5Files(boolean bIncludeIgnoredFiles, 
								boolean bOverwriteExistingMD5Files,
								List<MD5DirList> dirsGenMD5s, 
								List<File> dirsDepth1,
								File md5OutputDirectory) {
		
		// If the "-d1" input argument was specified (one or more times)
		// we need to scan each of these specified top-level directories 
		// for any sub-directories at a depth of 1. 
		// NOTE: We are not generating MD5 file listings yet; just gathering
		//       directory names
		List<File> dirsFoundAtDepth1 = new ArrayList<File>();
		for (File d : dirsDepth1) {
			try {
				new DirLister(d.toPath(), new DirVisitor(d.toPath(), dirsFoundAtDepth1)).list(2);
			}
			catch (Exception e)
			{
				System.err.println("ERROR: Problem scanning top-level directories. Exiting...");
				e.printStackTrace();
				System.exit(-1);
			}
		}
		// Add any sub-dirs found at depth of 1 to our list of directories to scan.
		for (File d : dirsFoundAtDepth1) {
			dirsGenMD5s.add(new MD5DirList(d.toPath()));
		}
		// Debugging. Print names of directories we are about to scan.
		if (bDebug) {
			logger.debug("Directories to be scanned:");
			for (MD5DirList d : dirsGenMD5s) {
				logger.debug(""+d.getPath());
			}
		}
		
		// Check that we have some directories to scan.
		if (dirsGenMD5s.size()==0) {
			System.err.println("ERROR: No directories to scan!");
			return;
		}
		
		// Generate MD5 file listing for each directory.
		logger.info("\nScanning directories...\n");
		for (MD5DirList d : dirsGenMD5s) {
			try {
				logger.info("Scanning directory " + d.getPath() + "...");
				new DirLister(d.getPath(), new MD5DirListerVisitor(d)).list();
			}
			catch (Exception e)
			{
				System.err.println("ERROR: Problem generating MD5 file listings. Exiting...");
				e.printStackTrace();
				System.exit(-1);
			}
		}
	 	// Debugging. Print MD5 values.
		if (bDebug) {
			for (MD5DirList d : dirsGenMD5s) {
				d.dumpMD5s();
			}
		}
		
		// Generate an MD5 listing file for each directory. 
		// For now these wil be created in the current dirctory.
		logger.info("\nGenerating MD5 file lists...\n");
		for (MD5DirList d : dirsGenMD5s) {
			if (d.getCount() > 0) {
				logger.info("Creating MD5 file list: " + d.getMD5FileName());
				d.createMD5File(bOverwriteExistingMD5Files, md5OutputDirectory);
			} else {
				logger.info("WARN: No suitable files found in " + d.getPath() + ", so skipping...");
			}
		}
	}
}