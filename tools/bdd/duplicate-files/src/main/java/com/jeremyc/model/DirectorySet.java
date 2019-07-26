package com.jeremyc.model;

import java.util.List;
import java.util.ArrayList;

public class DirectorySet extends DupNode {
	
	private List<DupNode> nodes;

	public DirectorySet(String name) {
		super(name);
		nodes = new ArrayList<DupNode>();
	}

	public void addNode(DupNode n) {
		nodes.add(n);
	}

	public DupNode[] getNodes() { 
		return nodes.toArray(new DupNode[nodes.size()]);
	}

	public String toString() {
		return "DirectorySet: " + getName() + " (" + nodes.toString() + ")";
	}
}
