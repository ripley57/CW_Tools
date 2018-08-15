package edp.support.patchlister;

import java.io.*;
import java.util.*;
import java.nio.file.*;
import java.nio.file.attribute.*;
import static java.nio.file.FileVisitResult.*;
import static java.nio.file.FileVisitOption.*;

import org.apache.log4j.Logger;

class DirVisitor extends SimpleFileVisitor<Path> {

	static Logger logger = Logger.getLogger(DirVisitor.class);
	
	Path topdir;
	List<File> dirs;

	DirVisitor(Path topdir, List<File> dirs) {
		this.topdir = topdir;
		this.dirs = dirs;
	}

    public FileVisitResult visitFile(Path file,	BasicFileAttributes attr) {
        return CONTINUE;
    }
	
    public FileVisitResult postVisitDirectory(Path dir, IOException exc) {
        //logger.info("DirVisitor::postVisitDirectory() " + dir);
		
		// If we are looking for directories at a certain depth
		// then we don't want to include the parent directory.
		if (!dir.equals(topdir)) {
			dirs.add(dir.toFile());
		}
		return CONTINUE;
    }
	
	// If there is some error accessing the file, let the 
	// user know. If you don't override this method and an 
	// error occurs, an IOException is thrown.
    public FileVisitResult visitFileFailed(Path file, IOException exc) {
        System.err.println(exc);
        return CONTINUE;
    }
}
