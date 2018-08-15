package edp.support.patchlister;

import java.io.*;
import java.util.*;
import java.nio.file.*;
import java.nio.file.attribute.*;
import static java.nio.file.FileVisitResult.*;
import static java.nio.file.FileVisitOption.*;

import org.apache.log4j.Logger;

/*
** Visitor for reading ".md5" files from a directory.
*/

class MD5FileDirVisitor extends SimpleFileVisitor<Path> {

	static Logger logger = Logger.getLogger(MD5FileDirVisitor.class);
	
	List<MD5DirList> importedMD5PatchFiles = new ArrayList<MD5DirList>(5);
	
	PathMatcher md5_file_matcher = FileSystems.getDefault().getPathMatcher("glob:**.md5");
	
	MD5FileDirVisitor(List<MD5DirList> importedMD5PatchFiles) {
		this.importedMD5PatchFiles = importedMD5PatchFiles;
	}

    public FileVisitResult visitFile(Path file,	BasicFileAttributes attr) {
        if (attr.isSymbolicLink()) {
            //System.out.format("Symbolic link: %s ", file);
        } else if (attr.isRegularFile()) {
				//logger.info("MD5FileDirVisitor::visitFile: file=" + file);
				if (md5_file_matcher.matches(file)) {
					MD5DirList d = new MD5DirList(file);
					d.importMD5File(file);
					importedMD5PatchFiles.add(d);
				}
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
