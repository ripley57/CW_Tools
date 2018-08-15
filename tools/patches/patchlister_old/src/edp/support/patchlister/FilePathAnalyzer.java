package edp.support.patchlister;

import java.io.*;
import java.util.*;
import org.apache.log4j.*;

class FilePathAnalyzer extends MD5Analyzer
{
	static Logger logger = Logger.getLogger(FilePathAnalyzer.class);
		
	long m_numberTargetFilesFoundInPatches = 0;
		
	List<String> m_packageNames;

	FilePathAnalyzer(	List<File> md5PatchFilesDir, 
						List<File> md5FilesToAnalyze,
						File reportOutputFile,
						List<String> packageNames)
	{
		super(md5PatchFilesDir, md5FilesToAnalyze, null, reportOutputFile);
		
		m_packageNames = packageNames;
	}
	
	public void analyze() 
	{
		logger.debug("FilePathAnalyzer::analzye");
		
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
		
			if (fw != null) {
				fw.write("FilePathAnalyzer report generated on " + new Date() + "\n\n");
			}
			
			m_numberTargetFilesFoundInPatches = 0;
			
			// for each target MD5 file to analyze...
			for (MD5DirList targetMD5File : m_importedMD5FileListsToAnalyze) {
				logger.debug("\nAnalyzing file: " + targetMD5File.getDirName() + " ...");
		
				if (fw != null) {
					fw.write("Analyzing target MD5 file: " + targetMD5File.getDirName() + " ...\n");
				}
				
				// for each file path entry...		
				for (MD5Entry entry : targetMD5File.getEntries()) {
					m_numberTargetFilesExamined++;
				
					if (fw != null) {
						String s = String.format("\n%06d: Analyzing entry: %s\n", 
								m_numberTargetFilesExamined, entry.asString());
						//fw.write(s);
					}
				
					// look for file path in each patch...
					for (MD5DirList patch : m_importedMD5PatchFileLists) {
						if (patch.checkFilePath(entry, m_packageNames)==true) {
							if (fw != null) {
								String s = String.format("\n%06d: FOUND in PATCH: %s (%s)\n",
												m_numberTargetFilesExamined,
												patch.getDirName(),
												entry.asString());
								fw.write(s);
							}
							m_numberTargetFilesFoundInPatches++;
						}
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
	
	public void printReport() {
		String s;
		
		FileWriter fw = null;
		try {
			if (m_reportOutputFile != null) {
				fw = new FileWriter(m_reportOutputFile, true); 
			}
		
			s = "##################################################################\n";
			System.out.print(s);
			if (fw != null) fw.write("\n\n" + s);
		
			s = String.format("Files examined: %d\n", m_numberTargetFilesExamined);
			System.out.print(s);
			if (fw != null) fw.write(s);
		
			s = String.format("Files paths found in patches: %d\n", m_numberTargetFilesFoundInPatches);
			System.out.print(s);
			if (fw != null) fw.write(s);
		
			if (fw != null) {
				s = String.format("For full report see file %s\n", m_reportOutputFile.toString());
				System.out.print(s);
			}
			
			s = "##################################################################\n";
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
