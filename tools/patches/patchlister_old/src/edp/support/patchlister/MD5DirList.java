package edp.support.patchlister;

import java.io.*;
import java.util.*;
import java.nio.file.*;

import org.apache.log4j.Logger;

public class MD5DirList {
	
	static Logger logger = Logger.getLogger(MD5DirList.class);
		
	Path dir;
	String name;
	
	List<MD5Entry> entries = new ArrayList<MD5Entry>(100);
	
	// Ignored files
	List<File> ignored = new ArrayList<File>(10);
	
	MD5ChecksumCalculator md5calculator = new MD5ChecksumCalculator();
	
	PathMatcher class_file_matcher = FileSystems.getDefault().getPathMatcher("glob:**.class");

	MD5DirList(Path dir) {
				
		this.dir = dir;
		
		// Remove trailing ".md5" from file name, if present.
		this.name = dir.toFile().getName().replace(".md5","");

	}
	
	Path getDir() { return dir; }
	String getDirName() { return dir.toFile().getName(); }
	List<MD5Entry> getEntries() { return entries; }
	long getCount() { return entries.size(); }
	String getMD5FileName() { return ""+name+".md5"; }
	
	int m_numberPatchFilesFound = 0;
	int getNumberPatchFilesFound() { return m_numberPatchFilesFound; }
	int getNumberPatchFiles() { return entries.size(); }
	boolean isPatchInstalled() { return getNumberPatchFilesFound() >= getNumberPatchFiles(); }
	String getPatchInstalledStatusString() {
			if (isPatchInstalled()) {
				return "INSTALLED";
			}
			else
			if (getNumberPatchFilesFound() > 0 ) {
				return "PARTIALLY INSTALLED";
			}
			else {
				return "NOT INSTALLED";
			}
	}
	String getPatchInstalledStatusSymbol() {
			if (isPatchInstalled()) {
				return "*";
			}
			else
			if (getNumberPatchFilesFound() > 0 ) {
				return ".";
			}
			else {
				return " ";
			}
	}
	
	/*
	** Look for a file by file path rather than by MD5 value.
	*/
	boolean checkFilePath(MD5Entry entry, List<String> packageNames) {
		boolean bFoundIt = false;
		for (MD5Entry e : entries) {
			if (entry.matchesFilePath(e, packageNames)) {
				m_numberPatchFilesFound++;
				bFoundIt = true;
				break;
			}
		}
		return bFoundIt;
	}
	
	/*
	** Look for a file by file MD5 value.
	*/
	boolean check(MD5Entry entry) {
		boolean bFoundIt = false;
		for (MD5Entry e : entries) {
			if (entry.matchesMD5(e)) {
				m_numberPatchFilesFound++;
				bFoundIt = true;
				break;
			}
		}
		return bFoundIt;
	}
	
	void dumpMD5s() {
		logger.info("\nDUMPING: "+dir+":");
		if (getCount() == 0) {
			logger.info("WARNING: No class files found in directory!");
		} else {
			for (MD5Entry e : this.entries) {
				logger.info(""+ e.asString());
			}
		}
	}
	
	boolean createMD5File() {
		return createMD5File(false, null);
	}
	
	boolean createMD5File(boolean bOverwriteExistingFile, File outputDirectory) {
			boolean ret = true;	// Success
				
			File file = null;
			if (outputDirectory != null) {
				file = new File(outputDirectory + System.getProperty("file.separator") + getMD5FileName());
			} else {
				file = new File(getMD5FileName());
			}

			try {
				if (file.exists() && bOverwriteExistingFile==false) { 
						logger.warn("WARN: Skipping MD5 file creation. File already exists: " + file);
						return false;
				}
			
				FileWriter fw = new FileWriter(file, false);	
				
				// Lets add a comment line that mentions the directory name for these
				// hash values. We make comment lines any lines at the start of the md5
				// file listing that begin with '#'.
				fw.write("# Dirctory: " + getDirName() + "\n");
				fw.write("# This file was generated " + new Date() + "\n\n");
		
				for (MD5Entry e : this.entries) {	
					fw.write(e.asString()+"\n");
				}
				
				// Lets write all the ignored files as comments 
				// at the bottom of the MD5 file listing.
				if (this.ignored.size() > 0) {
					fw.write("\n# IGNORED FILES:\n");
					for (File i : this.ignored) {
						fw.write("# " + i + "\n");
					}
				}
				
				fw.close();
			
			} catch (IOException e) {
				logger.error("ERROR: Problem creating MD5 file: " + file);
			} finally {
				
			}
			return ret;
	}
	
	void importMD5File(Path file) {
		logger.debug("Loading MD5 filelist: " + file + " ...");
		
		BufferedReader br = null;
		try {
			String line;;
			br = new BufferedReader(new FileReader(file.toFile()));
			while ((line = br.readLine()) != null) {
				if (line.startsWith("#")) {
					// Skip comment lines.
					continue;
				}
				if (line.length()==0) {
					// Skip empty lines.
					continue;
				}
				
				// Parse line into: <MD5><space><filepath>
				int space = line.indexOf(' ');
				if (space == -1) {
					logger.error("ERROR: Invalid MD5 file entry: \n" + line + "\nIn file: " + file);
					break;
				}
				
				// Add an MD5Entry.
				String md5 = line.substring(0,space);
				String f = line.substring(space+1);
				entries.add(new MD5Entry(md5, new File(f)));			
			}
			
			logger.debug("Read " + entries.size() + " entries.");
			
		} catch (IOException e) {
			logger.error("ERROR: Problem reading MD5 file: " + file);
			e.printStackTrace();
		} finally {
			try {
			if (br != null) br.close();
			} catch (IOException e) {
			}
		}
	}
		
	void visitFile(Path file) {
		//logger.info("MD5DirList::visitFile: " + file);
				
		if (!class_file_matcher.matches(file)) {
			//logger.info("MD5DirList::visitFile: IGNORING: " + file);
			ignored.add(file.toFile());
			return;
		}
		
		try {
			File f = file.toFile();
			String md5 =  md5calculator.createChecksum(f);
			
			//System.out.format("%s : %s\n", md5, f);
			
			entries.add(new MD5Entry(md5, f));
		}
		catch (Exception e) {
		}
	}
	
	public Path getPath() {
		return dir;
	}
}

