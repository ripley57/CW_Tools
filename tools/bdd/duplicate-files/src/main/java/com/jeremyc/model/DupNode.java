package com.jeremyc.model;


public abstract class DupNode {

	private String name;
	private String checksum;

	public DupNode(String name) {
		this.name = name;
		this.checksum = null;
	}

	public DupNode(String name, String checksum) {
		this.name = name;
		this.checksum = checksum;
	}

	public String getName() {
		return name;
	}
	
	public String getChecksum() {
		return checksum;
	}

	public abstract void addNode(DupNode n);
	public abstract DupNode[] getNodes();

	public String toString() {
		return "DupNode: " + getName();
	}
}
