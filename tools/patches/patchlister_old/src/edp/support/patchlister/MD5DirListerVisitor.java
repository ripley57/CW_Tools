package edp.support.patchlister;

import java.nio.file.*;
import java.nio.file.attribute.*;
import static java.nio.file.FileVisitResult.*;
import static java.nio.file.FileVisitOption.*;
import java.io.*;

import org.apache.log4j.Logger;

class MD5DirListerVisitor extends SimpleFileVisitor<Path> {

	static Logger logger = Logger.getLogger(MD5DirListerVisitor.class);
	
	MD5DirList dir;

	MD5DirListerVisitor(MD5DirList dir) {
		this.dir = dir;
	}

    public FileVisitResult visitFile(Path file,	BasicFileAttributes attr) {
        if (attr.isSymbolicLink()) {
            //System.out.format("Symbolic link: %s ", file);
        } else if (attr.isRegularFile()) {
			//logger.info("MD5DirListerVisitor::visitFile: " + file);
			dir.visitFile(file);
        } else {
            //System.out.format("Other: %s ", file);
        }
        //System.out.println("(" + attr.size() + "bytes)");
        return CONTINUE;
    }
	
    public FileVisitResult postVisitDirectory(Path dir, IOException exc) {
        //System.out.format("Directory: %s%n", dir);
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
