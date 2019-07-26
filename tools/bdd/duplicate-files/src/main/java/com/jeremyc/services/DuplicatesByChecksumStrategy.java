package com.jeremyc.services;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.jeremyc.model.*;


public class DuplicatesByChecksumStrategy implements DuplicatesFinderStrategy {

	public Iterator<DupFileSet> findDuplicates(DirectorySet ds) {

		//  For now...
		List l =  new ArrayList<DupFileSet>();
		DupFileSet s = new DupFileSet();
		DupFile f = new DupFile("FILE1","findDuplicates() NOT YET IMPLEMENTED");
		s.add(f);
		l.add(s);
		return l.listIterator();
	}
}
