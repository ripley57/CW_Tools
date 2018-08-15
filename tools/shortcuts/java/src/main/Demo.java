import java.io.*;
import java.util.Iterator;
import java.util.List;
import org.apache.log4j.Logger;

import com.jeremy.tools.*;

public class Demo {
	static Logger logger = Logger.getLogger(ShortcutHelper.class);

	public static void main(String args[]) {
		ShortcutHelper sh = new ShortcutHelper("shortcuts.properties");
		
		List<Shortcut> shortcuts;
		Iterator<Shortcut> iter;
		
		try {
			// Add shortcuts.
			shortcuts = sh.getAddShortcuts();
			iter = shortcuts.listIterator();
			while (iter.hasNext()) {
				Shortcut s = iter.next();
				s.execute();
			}

			// Remove shortcuts.
			shortcuts = sh.getRemoveShortcuts();
			iter = shortcuts.listIterator();
			while (iter.hasNext()) {
				Shortcut s = iter.next();
				s.execute();
			}
		
			// Move shortcuts.
			shortcuts = sh.getMoveShortcuts();
			iter = shortcuts.listIterator();
			while (iter.hasNext()) {
				Shortcut s = iter.next();
				s.execute();
			}
		} catch (Exception e) {
			StringWriter sw = new StringWriter();
			e.printStackTrace(new PrintWriter(sw));
			System.out.println(sw.toString());
		}
	}
}
