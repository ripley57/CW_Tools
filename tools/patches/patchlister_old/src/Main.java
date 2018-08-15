import edp.support.patchlister.PatchLister;

import com.jeremy.tools.*;

public class Main
{
	public static void main(String args[]) {
		// The following function allows us to override Log4j properties
		// via the command-line. For example, the following can be used:
		// java -Dlog4j.logger.PatchTool=INFO -jar patchtool.jar
		Log4jHelper.configureLog4jFromSystemProperties();
		
		new PatchLister().run(args);
	}
}
	