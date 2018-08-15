import java.io.*;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Properties;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

public class StackDumper {
    	static String strVersion = "StackDumper 1.01";
	static Logger logger = Logger.getLogger(StackDumper.class);
	static Boolean bDebug = false;

	private static void printUsage() {
		String errString = "\n" + strVersion + "\n" +
			"\nUsage:" +
		        "\njava StackDumper [-r n] [-d secs] [-s stackdumper_dir] -h cw_home_dir\n"	+
			"\nWhere:\n" 									+
			"\n-r n               - Number of stack dumps to generate." 			+
			"\n-d secs            - Delay between multiple stack dumps." 			+
			"\n-s stackdumper_dir - Directory where logs files are created." 		+
			"\n                     Default is the current directory." 			+
			"\n-h cw_home_dir     - CW home directory, e.g. D:\\CW\\V711\n" 		+
			"\n-v                 - Debug mode. Don't actually run the dump command.\n"     +
			"\n\nExamples:\n" 								+
			"\njava StackDumper -r 2 -d 60 -h \"D:\\CW\\V711\" -s \"D:\\CW\\V711\\logs\\stackdumper\"" +
			"\njava StackDumper -h \"D:\\CW\\V711\"\n";
		System.err.println(errString);
	}

	public static void main(String[] args) {
		int nTotalDumps = 1;		// Default total number of dumps to create.
		int nDelaySecs = 60;		// Default delay between dumps, in seconds.
		String strCwHome = null;	// CW home directory. We must be here when we rnu the b command.
		String strStackdumpDir = null;	// Output directory for log files.

		if (args.length < 2) {
			printUsage();
			System.exit(-1);
		}

		for (int i=0; i<args.length; i++) {
			if (args.length == 1 && (args[0].equals("-h") || args[0].equals("/?"))) {
				printUsage();
				System.exit(0);
			}
			else if (args[i].equals("-v")) {
				bDebug = true;
			}
			else if (args[i].equals("-r")) {
				// Repeat n times
				if (args.length < i+2) {
					System.err.println("ERROR: No repeat number specified");
					System.exit(-2);
				}
				nTotalDumps = Integer.parseInt(args[i+1]);
				if (bDebug) System.out.println("-r: nTotalDumps=" + nTotalDumps);
			}
			else if (args[i].equals("-d")) {
				// Delay before next repeat dump
				if (args.length < i+2) {
					System.err.println("ERROR: No delay value specified");
					System.exit(-2);
				}
				nDelaySecs = Integer.parseInt(args[i+1]);
				if (bDebug) System.out.println("-r: nDelaySecs=" + nDelaySecs);
			}
			else if (args[i].equals("-h")) {
				// CW home directory
				if (args.length < i+2) {
					System.err.println("ERROR: No CW home directory specified");
					System.exit(-2);
				}
				strCwHome = args[i+1].trim();
				if (bDebug) System.out.println("-h: strCwHome=" + strCwHome);
			}
			else if (args[i].equals("-s")) {
				// Stackdumper directory
				if (args.length < i+2) {
					System.err.println("ERROR: No stackdumper directory specified");
					System.exit(-2);
				}
				strStackdumpDir = args[i+1].trim();
				if (bDebug) System.out.println("-s: strStackdumpDir=" + strStackdumpDir);
			}
		}

		// Check mandatory arguments.
		if (strCwHome == null) {
			System.err.println("ERROR: No CW home directory specified");
			System.exit(-2);
		}
		if (strStackdumpDir == null) {
			// Use default of current directory.
			strStackdumpDir = System.getProperty("user.dir");
			if (bDebug) System.out.println("strStackdumpDir=" + strStackdumpDir);
		}

		StackDumper sd = new StackDumper();

		// Set the Log4j properties file.
		String strLogFilePath = sd.LoadLog4jProps("stackdumper.properties", strStackdumpDir); 

		// Command to run. 
		String strCmd = strCwHome + File.separator + "b.bat admin-client monitor.thread getAllStackTraces ";

		// Run the command.
		for (int i=1; i<=nTotalDumps; i++) {
			sd.runCmd(strCmd, i, nTotalDumps, strLogFilePath);
			if (i < nTotalDumps) {
				// More dumps to come. Add delay first.
				try {
					sd.Log("");
					sd.Log("Sleeping for " + nDelaySecs + " seconds before next stack dump ...");
					sd.Log("");
					Thread.sleep(nDelaySecs * 1000);
				}
				catch (InterruptedException e) {
					System.err.println("Interrupted!");
					System.exit(-4);
				}
			}
		}
	}

	private String LoadLog4jProps(String strPropsFilename, String strStackdumpDir) {
		String strLogFilePath = null;
		Properties props = new Properties();  
		InputStream in = this.getClass().getResourceAsStream(strPropsFilename);  
		try {
			props.load(in);  

			// Set the full path to the output log file location.
			String strLogFileName = props.getProperty("log4j.appender.A2.File");
			strLogFilePath = strStackdumpDir + File.separator + strLogFileName;
			props.setProperty("log4j.appender.A2.File", strLogFilePath);
		
			// Set the Log4j properties.
			PropertyConfigurator.configure(props);

			in.close();
		}
		catch (IOException e) {
			System.err.println("Error setting Log4j properties: " + e);
			System.exit(-3);
		}
		return strLogFilePath;
	}

	private String getTimeNow() {
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Date date = new Date();
		return dateFormat.format(date);
	}

	private void Log(String s) {
		logger.info(s);
		System.out.println(s);
	}

	private void printPrologue(String strCmd, int nDumpNum, int nTotalDumps, String strLogFilePath) {
		Log("");
		Log("#########################################");
		Log(getTimeNow());
		Log("STARTING STACK DUMP COMMAND:");
		Log(strCmd);
		Log("Log file: " + strLogFilePath);
		Log("Dump number " + nDumpNum + " of " + nTotalDumps + " dumps.");
		Log("#########################################");
	}
	private void printEpilogue(String strCmd, int nDumpNum, int nTotalDumps, String strLogFilePath) {
		Log("#########################################");
		Log(getTimeNow());
		Log("COMPLETED STACK DUMP COMMAND");
		Log("Log file: " + strLogFilePath);
		Log("Dump number " + nDumpNum + " of " + nTotalDumps + " dumps.");
		Log("#########################################");
	}

	private void runCmd(String strCmd, int nDumpNum, int nTotalDumps, String strLogFilePath) {
		printPrologue(strCmd, nDumpNum, nTotalDumps, strLogFilePath);
		if (bDebug) {
			// Don't run the command. Display the command instead.
			System.out.println("runCmd: strCmd=\"" + strCmd);
		} else {
			try {	 
				String line;
				Process p = Runtime.getRuntime().exec(strCmd);
				BufferedReader bri = new BufferedReader(new InputStreamReader(p.getInputStream()));
				BufferedReader bre = new BufferedReader(new InputStreamReader(p.getErrorStream()));
				while ((line = bri.readLine()) != null) {
					logger.info(line);
				}
				bri.close();
				while ((line = bre.readLine()) != null) {
					logger.error(line);
				}
				bre.close();
				p.waitFor();
			} 
			catch (Exception e) {
				logger.error(e);
				e.printStackTrace();
			}
		}
		printEpilogue(strCmd, nDumpNum, nTotalDumps, strLogFilePath);
	}
}
