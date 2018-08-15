package edp.support.patchlister;

import java.nio.file.*;
import java.io.*;
import java.util.*;

class DirLister {
	Path dir;
	FileVisitor v;
	
	DirLister(Path dir, FileVisitor v) {
		this.dir = dir;
		this.v = v;
	}
	
	@SuppressWarnings("unchecked") 
	public void list() throws IOException {
		Files.walkFileTree(this.dir, this.v);
	}

	@SuppressWarnings("unchecked") 
	public void list(int depth) throws IOException {
		// Below syntax for default opts argument taken from :
		// https://docs.oracle.com/javase/7/docs/api/java/nio/file/Files.html
		Files.walkFileTree(this.dir, EnumSet.noneOf(FileVisitOption.class), depth, this.v);
	}
}