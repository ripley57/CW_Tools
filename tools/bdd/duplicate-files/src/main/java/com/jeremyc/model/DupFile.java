package com.jeremyc.model;

public class DupFile extends DupNode {
	
	public DupFile(String name, String checksum) {
		super(name, checksum);
	}

	// Empty implementations
	public void addNode(DupNode n) {}
	public DupNode[] getNodes() { return new DupNode[0]; }

	public String toString() {
		return "DupFile: name=" + getName() + ",checksum=" + getChecksum();
	}

	@Override
        public boolean equals(Object obj) {
                if (this == obj)
                        return true;
                if (obj == null)
                        return false;
                if (getClass() != obj.getClass())
                        return false;
                DupFile f = (DupFile)obj;
                if (toString().equals(f.toString())) {
			return true;
		}
                return false;
        }
}
