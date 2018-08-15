package edp.support.patchlister;

import java.io.*;
import java.util.*;
import org.apache.log4j.*;

class MD5Analyzer implements Analyzer
{
	static Logger logger = Logger.getLogger(MD5Analyzer.class);
	
	/*
	** For report.
	*/
	long m_numberTargetFilesExamined = 0L;
	long m_numberTargetFilesFoundInPatches = 0L;
	long m_numberTargetFilesUnaccountedFor = 0L;
	long m_numberTargetFilesFoundInRefEnv = 0L;
	List<String> NOT_FOUND_files = new ArrayList<String>(20);
	
	List<File> m_md5PatchFilesDirs;
	List<File> m_md5TargetFilesToAnalyze;
	List<File> m_md5RefEnvFiles;
	File m_reportOutputFile;
	
	List<MD5DirList> m_importedMD5PatchFileLists = new ArrayList<MD5DirList>(10);
	List<MD5DirList> m_importedMD5FileListsToAnalyze = new ArrayList<MD5DirList>(1);
	List<MD5DirList> m_importedMD5RefEnvFiles = new ArrayList<MD5DirList>(1);
	
	MD5Analyzer(List<File> md5PatchFilesDirs, 
				List<File> md5TargetFilesToAnalyze, 
				List<File> md5RefEnvFiles,
				File reportOutputFile)
	{
		m_md5PatchFilesDirs = md5PatchFilesDirs;
		m_md5TargetFilesToAnalyze = md5TargetFilesToAnalyze;
		m_md5RefEnvFiles = md5RefEnvFiles;
		m_reportOutputFile = reportOutputFile;
		
		loadMD5FilesFromDirectory(m_md5PatchFilesDirs, m_importedMD5PatchFileLists);
		loadMD5Files(m_md5TargetFilesToAnalyze, m_importedMD5FileListsToAnalyze);
		
		// Optional.
		if (md5RefEnvFiles != null)
			loadMD5Files(m_md5RefEnvFiles, m_importedMD5RefEnvFiles);
	}
	
	long getCountMD5PatchFiles() { return m_importedMD5PatchFileLists.size(); }
	long getCountMD5TargetFiles() { return m_importedMD5FileListsToAnalyze.size(); }
	
	private void loadMD5FilesFromDirectory(List<File> dirs, List<MD5DirList> importedMD5Files)
	{
		for (File d : dirs) {
			try {
				new DirLister(d.toPath(), new MD5FileDirVisitor(importedMD5Files)).list();
			}
			catch (Exception e)
			{
				System.err.println("ERROR: Problem loading MD5 patch files. Exiting...");
				e.printStackTrace();
				System.exit(-1);
			}
		}
		
		// Debugging. 
		//for (MD5DirList d : importedMD5Files) {
		//	d.dumpMD5s();
		//}
	}
	
	private void loadMD5Files(List<File> md5Files, List<MD5DirList> importedMD5Files)
	{
		for (File f : md5Files) {
			MD5DirList d = new MD5DirList(f.toPath());
			d.importMD5File(f.toPath());
			importedMD5Files.add(d);
		}
		
		// Debugging. 
		//for (MD5DirList d : importedMD5Files) {
		//	d.dumpMD5s();
		//}
	}
	
	public void analyze()
	{
		logger.debug("MD5Analyzer::analzye");
		
		if (getCountMD5PatchFiles()==0) {
			System.err.println("ERROR: No MD5 patch files found!");
			return;
		}	
		
		if (getCountMD5TargetFiles()==0) {
			System.err.println("ERROR: No MD5 target file found!");
			return;
		}
		
		FileWriter fw = null;
		
		try {
			if (m_reportOutputFile != null) {
				fw = new FileWriter(m_reportOutputFile, false); 
			}
		
			if (fw != null)
				fw.write("MD5Analyzer report generated on " + new Date() + "\n\n");
		
			// for each target MD5 file to analyze...
			for (MD5DirList targetMD5File : m_importedMD5FileListsToAnalyze) {
				logger.debug("\nAnalyzing file: " + targetMD5File.getDirName() + " ...");
		
				if (fw != null)
					fw.write("Analyzing target MD5 file: " + targetMD5File.getDirName() + " ...\n");
		
				// for each MD5 entry...		
				for (MD5Entry entry : targetMD5File.getEntries()) {
					m_numberTargetFilesExamined++;
					boolean bFoundIt = false;
				
					if (fw != null) {
						String s = String.format("\n%06d: Analyzing entry: %s\n", 
								m_numberTargetFilesExamined, entry.asString());
						fw.write(s);
					}
				
					// look for each MD5 entry in each patch...
					int foundCount = 0;
					for (MD5DirList patch : m_importedMD5PatchFileLists) {
						if(patch.check(entry)==true) {
							bFoundIt = true;
							if (fw != null) {
								String s = String.format("\n%06d: FOUND in PATCH: %s (%s)\n",
									m_numberTargetFilesExamined,
									patch.getDirName(),
									entry.asString());
								fw.write(s);
							}
							foundCount++;
						}
					}
				
					/*
					** If we didn't find the file in one of the patches,
					** then let's now check any product refrence MD5 files
					** specified by the user. These are optional.
					*/
					if ((bFoundIt==false) && (m_importedMD5RefEnvFiles.size() > 0)) {
						for (MD5DirList ref : m_importedMD5RefEnvFiles) {
							if (ref.check(entry)==true) {
								logger.debug("MD5Analyzer:analyze: Found entry in ref env file: " + entry.getMD5());
							
								if (fw != null) {
									fw.write("FOUND entry in ref file: " + ref.getDirName() + "\n");
								}
							
								m_numberTargetFilesFoundInRefEnv++;
								bFoundIt = true;
								break;
							}
						}
					}
					
					if (bFoundIt==false) {
						fw.write("NOT FOUND entry: " + entry.asString() + "\n");
						NOT_FOUND_files.add(entry.asString());
					}

				}
			}
		
			if (fw != null) {
				fw.close();
			}
		} catch (Exception e) {
			System.err.println("ERROR: Unexpected error analyzing.");
			e.printStackTrace();
		}
	}
	
	public void printReport() 
	{
		String s;
		
		FileWriter fw = null;
		try {
			if (m_reportOutputFile != null) {
				fw = new FileWriter(m_reportOutputFile, true); 
			}
		
			s = "\n####################################################################################\n";
			System.out.print(s);
			if (fw != null) fw.write("\n\n" + s);
			
			// Let's assume there is just one target MD5 being analyzed.
			s = String.format("Analysis report for %s:\n\n", m_md5TargetFilesToAnalyze.get(0));
			System.out.print(s);
			if (fw != null) fw.write("\n\n" + s);
		
			s = String.format("Number of patches searched: %d\n", m_importedMD5PatchFileLists.size());
			System.out.print(s);
			if (fw != null) fw.write(s);
		
			s = "Patches:\n";
			System.out.print(s);
			if (fw != null) fw.write(s);
		
			m_numberTargetFilesFoundInPatches = 0L;
			for (MD5DirList patch : m_importedMD5PatchFileLists) {
				m_numberTargetFilesFoundInPatches += patch.getNumberPatchFilesFound();
				s = String.format("%s MD5 filelist: %-37s: (%02d/%02d): %s\n",
								patch.getPatchInstalledStatusSymbol(),
								patch.getMD5FileName(),
								patch.getNumberPatchFilesFound(),
								patch.getNumberPatchFiles(),
								patch.getPatchInstalledStatusString());
				System.out.print(s);
				if (fw != null) fw.write(s);
			}
		
			s = String.format("Files examined: %d\n", m_numberTargetFilesExamined);
			System.out.print(s);
			if (fw != null) fw.write(s);
		
			s = String.format("Files found in patches: %d\n", m_numberTargetFilesFoundInPatches);
			System.out.print(s);
			if (fw != null) fw.write(s);
		
			if (m_importedMD5RefEnvFiles.size() > 0) {
				/*
				** User specified one of more product reference files, so let's
				** display the results here, including any unnaccounted for
				** files (i.e. files we don't know baout).
				*/
				s = String.format("Files found in product reference MD5 file %s: %d\n",
					/* We will assume there is only one ref MD5 file.*/
					m_importedMD5RefEnvFiles.get(0).getMD5FileName(), m_numberTargetFilesFoundInRefEnv);
				System.out.print(s);
				if (fw != null) fw.write(s);
					
				// I'm not sure why at the moment, but I've seen this calculated 'unaccounted for' value
				// not match the 'NOT FOUND' count in the report.log file. Instead, for now, let's just
				// dump the list of 'NOT FOUND' entries that we recorded during the analysis.
				/*
				s = String.format("*** Files unaccounted for: %d\n", 
					(m_numberTargetFilesExamined - m_numberTargetFilesFoundInPatches - m_numberTargetFilesFoundInRefEnv));
				System.out.print(s);
				if (fw != null) fw.write(s);
				*/
				s = String.format("**** Files not identified by MD5: %d\n", NOT_FOUND_files.size());
				System.out.print(s);
				if (fw != null) fw.write(s);
				for (String ss : NOT_FOUND_files) {
					s = String.format("%s\n", ss);
					System.out.print(s);
					if (fw != null) fw.write(s);
				}
			}
			
			if (fw != null) {
				s = String.format("For full report see file %s\n", m_reportOutputFile.toString());
				System.out.print(s);
			}

			s = "####################################################################################\n";
			System.out.print(s);
			if (fw != null) fw.write(s);
		
			if (fw != null) {
				fw.close();
			}
		} catch (Exception e) {
			System.err.println("ERROR: Unexpected error generating report.");
			e.printStackTrace();
		}
	}
}
