package com.jeremyc.services;

import java.util.Iterator;

import com.jeremyc.model.*;


public class DuplicatesService {

	// TODO: Dependency injection here, e.g. using the Spring framework?
	private DuplicatesFinderStrategy dfs = new DuplicatesByChecksumStrategy();

	public void setDuplicatesFinderStategy(DuplicatesFinderStrategy dfs) {
		this.dfs = dfs;
	}

	public Iterator<DupFileSet> findDuplicates(DirectorySet dirSet) {
		return dfs.findDuplicates(dirSet);
	}
}
