package com.jeremyc.model;

/**
 * The Class DupFileSet to group each set of identical files.
 * <p>
 * When we get to display the duplicate files we've found, we need to
 * display all identical files together as a group. That's the purpose
 * of this class.
 *
 * @author JeremyC
 */

import java.util.List;
import java.util.ArrayList;

public class DupFileSet {

	private List<DupFile> duplicateFiles;

	public DupFileSet() {
		duplicateFiles = new ArrayList<DupFile>();
	}

	public void add(DupFile f) {
		duplicateFiles.add(f);
	}

	public int size() {
		return duplicateFiles.size();
	}

	@Override
	public String toString() {

                StringBuilder builder = new StringBuilder("DupFileSet: [ ");
                for (DupFile f : duplicateFiles)
                {
                        builder.append(f.toString());
                        builder.append(", ");
                }
                return builder.append(" ] ").toString();
	}

        @Override
	public boolean equals(Object obj) {
        	if (this == obj)
             		return true;
        	if (obj == null)
             		return false;
        	if (getClass() != obj.getClass())
             		return false;
		DupFileSet s = (DupFileSet)obj;   
		if (size() != s.size())
			return false; 
		for (DupFile f : duplicateFiles) {
			if (s.exists(f) == false)
				return false;
		}
                return true;
	}

	public boolean exists(DupFile f1) {
		for (DupFile f2 : duplicateFiles) {
			if (f1 == f2) {
				return true;
			}
		}
		return false;
	}
}
