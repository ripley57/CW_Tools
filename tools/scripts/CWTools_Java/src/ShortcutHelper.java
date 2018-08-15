package com.jeremy.tools;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.apache.log4j.Logger;

public class ShortcutHelper {
	static Logger logger = Logger.getLogger(ShortcutHelper.class);
		
	private String sPropFileName;
	
	private List<Shortcut> addShortcuts    = new ArrayList<Shortcut>();
	private List<Shortcut> removeShortcuts = new ArrayList<Shortcut>();
	private List<Shortcut> moveShortcuts   = new ArrayList<Shortcut>();
	
	public List<Shortcut> getAddShortcuts()    { return addShortcuts;    }
	public List<Shortcut> getRemoveShortcuts() { return removeShortcuts; }
	public List<Shortcut> getMoveShortcuts()   { return moveShortcuts;   }
	
	public ShortcutHelper(String sFilename) {
		logger.debug("ShortcutHelper::ShortcutHelper() entering ...");
		
		this.sPropFileName = sFilename;
		
		List<Property> props;
		Iterator<Property> iter;

		// Shortcuts to create.
		props = getProperties("^addshortcut.*");
		iter = props.listIterator();
		while (iter.hasNext()) {
			Property p = iter.next();
			addShortcuts.add(new AddShortcut(p.getKey(), p.getValue()));
		}
		
		// Shortcuts to remove.
		props = getProperties("^removeshortcut.*");
		iter = props.listIterator();
		while (iter.hasNext()) {
			Property p = iter.next();
			removeShortcuts.add(new RemoveShortcut(p.getKey(), p.getValue()));
		}
		
		// Shortcuts to move.
		props = getProperties("^moveshortcut.*");
		iter = props.listIterator();
		while (iter.hasNext()) {
			Property p = iter.next();
			moveShortcuts.add(new MoveShortcut(p.getKey(), p.getValue()));
		}
		
		logger.debug("ShortcutHelper::ShortcutHelper() exiting ...");
	}
	
	private List<Property> getProperties(String sPattern) {
		logger.debug("ShortcutHelper::getProperties(): Reading properties matching: " + sPattern + " ...");
		List<Property> props = new ArrayList<Property>();
		PropertyHelper phelper = new PropertyHelperFromResource(this.sPropFileName, sPattern);
		Iterator<Property> iter = phelper.iterator();
		while (iter.hasNext()) {
			Property p = iter.next();
			props.add(p);
		}
		logger.debug("ShortcutHelper::getProperties(): Finished reading properties matching: " + sPattern);
		return props;
	}
}