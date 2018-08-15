package edp.support.patchlister;

import java.nio.file.*;
import java.nio.file.attribute.*;
import java.io.*;
import java.util.*;

import org.apache.log4j.Logger;

class GlobLister {
	static Logger logger = Logger.getLogger(GlobLister.class);
	
	MD5ChecksumCalculator md5calculator = new MD5ChecksumCalculator();

	private void printMD5(File f) {
		try {
			String md5 =  md5calculator.createChecksum(f);
			System.out.println((new MD5Entry(md5, f)).asString());
		} 
		catch (Exception e) {
			System.err.println("ERROR: Error calculating MD5 for file: " + f);
			e.printStackTrace();
		}
	}
	
	public void listallglobs(String[] globs) throws IOException {
		for (String g : globs) {
			File f = new File(g);
			if (f.exists() && f.isDirectory()) {
				// Walk directory recursively, by passing glob pattern "**".
				logger.debug("listallglobs: Walk directory: " + g);
				listglob("**", g);
			}
			else 
			if (f.exists() && f.isFile()) {
					// Print MD5 directly. No need to walk a directory.
					logger.debug("listallglobs: Print file MD5: " + g);
					printMD5(f);
			}
			else {
				// Look for presence of glob syntax "**". If we see this,
				// then split file path string at the first occurrence.
				int i = g.indexOf("**");
				if (i >= 0) {
					String prefix = g.substring(0,i);
					String pstfix = g.substring(i);
					logger.debug("listallglobs: prefix=" + prefix + ", pstfix=" + pstfix);
				
					if (prefix.equals(""))
						prefix = ".";
			
					logger.debug("listallglobs: Walk directory: " + prefix + ", using glob: " + pstfix);
					listglob(pstfix, prefix);
				}
				else {
					logger.debug("listallglobs: Walk directory: " + g);
					listglob(g, "." /*Paths.get(".").toAbsolutePath().toString()*/);
				}
			}
		}
	}
		
	// Globs and PathMatcher:
	// https://docs.oracle.com/javase/tutorial/essential/io/find.html
	// https://docs.oracle.com/javase/7/docs/api/java/nio/file/FileSystem.html#getPathMatcher(java.lang.String)
	//
	// Path:
	// https://docs.oracle.com/javase/7/docs/api/java/nio/file/Path.html
	// https://docs.oracle.com/javase/tutorial/essential/io/pathOps.html
	//
	// Glob examples (that work here):
	//   **/*.java
	//   src/*.java
	//   src/**/*.java
	//   src/**/*.{java,class}
	
	public void listglob(String glob, String location) throws IOException {
		logger.debug("GlobLister::listglob: glob=glob:" + glob + ", location=" + location);
		
		final PathMatcher pathMatcher = FileSystems.getDefault().getPathMatcher("glob:" + glob);
		
		Files.walkFileTree(Paths.get(location), new SimpleFileVisitor<Path>() {
			@Override
			public FileVisitResult visitFile(Path path,	BasicFileAttributes attrs) throws IOException {
				if (pathMatcher.matches(path)) {
					printMD5(path.toFile());
				}
				return FileVisitResult.CONTINUE;
			}

			@Override
			public FileVisitResult visitFileFailed(Path file, IOException exc) throws IOException {
				return FileVisitResult.CONTINUE;
			}
		});
		
	}
}