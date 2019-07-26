package com.jeremyc.services;

import java.util.Iterator;

import com.jeremyc.model.*;


public interface DuplicatesFinderStrategy {
	public Iterator<DupFileSet> findDuplicates(DirectorySet ds);
}
