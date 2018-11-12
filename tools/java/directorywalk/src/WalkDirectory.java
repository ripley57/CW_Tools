/*
** Description:
**		Demonstrates a flexible way to walk a directory tree.
**		
**		Note: This uses Java8 features.
**
** JeremyC 12-11-2018
*/

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import dirwalkdemo.DirVisitor;
import dirwalkdemo.StreamParallelExecutor;

public class WalkDirectory {
	
	public static void main(String[] args) throws IOException {
		File f = new File(args[0]);
		
		final List<Path> dirList = Collections.synchronizedList( new ArrayList<>());
		
		/*
		* Note: Here we are using a lambda expression to pass a definition
		*       of our DirVisitor interface. That interface only has one (abstract)
		*       method, hence we can pass an implementation as a lambda expression.
		*/
		new WalkDirectory().getDirs(f, ( dir ) ->
            {
				System.out.println("Visitor called with: " + dir);
                dirList.add( dir );
			}
		);
	}
		
	public void getDirs(File topdir, final DirVisitor visitor) throws IOException {
		/*
		* Use the streams feature of the Java8's "Files.walk()" to filter the directory list.
		* See https://docs.oracle.com/javase/8/docs/api/java/nio/file/Files.html
		* We will only consider directories names that begin with "TEST-".
		*/
  		List<Path> dirsFiltered = 
				Files.walk(topdir.toPath(), 1)
				.filter(p -> p.toFile().getName().split("-", 2).length == 2)
				.filter(p -> { 
				
					if (Files.isDirectory(p) == false)
						return false;
				
					try {
						String[] dirName = p.toFile().getName().split("-", 2);
						String p1 = dirName[0];
						if (p1.equals("TEST"))
							return true;
						System.out.println("Ignoring: " + p.toString());
						return false;
						
					}catch(Exception e) {
						return false;
					}
				}).collect(Collectors.toList());
				
		/*
		* Perform (serial) handling of each directory.
		*/
		System.out.println("\nHandling each directory in serial...");
		dirsFiltered
			.stream()
			.forEach(d ->
				handleDir(visitor, d));
				
		/*
		** Perfom (parallel) handling of each directory.
		*/
		System.out.println("\nHandling each directory in parallel...");
		StreamParallelExecutor.processParallel(
    		dirsFiltered.stream(), 
    		s -> {
    			s.forEach(d -> 
    				handleDir(visitor, d));
    			return null;
    		});
	}
	
	private void handleDir(final DirVisitor visitor, Path d)
	{
		visitor.visit(d);
	}
}