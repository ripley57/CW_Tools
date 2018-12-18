/*
** See https://github.com/arenn/java-getopt/blob/master/gnu/getopt/Getopt.java
*/

import gnu.getopt.LongOpt;
import gnu.getopt.Getopt;

public class GetoptDemo
{
	public static void main(String[] argv) {
		/*
		** Handle options which can be specified optionally 
		** by a longer name, e.g. "--help" instead of "-h".
		*/
		LongOpt[] longopts = new LongOpt[3];
		StringBuffer sb = new StringBuffer();
		longopts[0] = new LongOpt("help", LongOpt.NO_ARGUMENT, null, 'h');			// This option will return 'h'.
		longopts[1] = new LongOpt("outputdir", LongOpt.REQUIRED_ARGUMENT, sb, 'o');	// Because we have a sb, this option will return 0.
		longopts[2] = new LongOpt("maximum", LongOpt.OPTIONAL_ARGUMENT, null, 2);	// This option will return 2.
		
		Getopt g = new Getopt("mytestprog", argv, "ab:c::d", longopts, true /* allows -help and --help */);
		//g.setOpterr(false); // We'll do our own error handling

		int c;
		String arg;
		while ((c = g.getopt()) != -1) {
			switch(c) {
			case 'h':// --help, -help, or -h
				System.out.println("You picked option '--help (-h)'");
				break;
				
			case 0:	// --outputdir=xxx, --outputdir xxx, -outputdir=xxx, -outputdir xxx, or -o xxx
				System.out.println("sb=" + (char)(new Integer(sb.toString())).intValue());
				arg = g.getOptarg();
				System.out.println("You picked option '--outputdir (-o)' with argument " + ((arg != null) ? arg : "null"));
				break;
				
			case 2:	// --maximum, --maximim=xxx, -maximum, -maximum=xxx, -m, or -m=xxx
				// NOTE: An optional cannot be specified as "--maxmimum xxx". It must be "--maximum=xxx".
				arg = g.getOptarg();
				System.out.println("You picked option '--maximum (-m)' with argument " + ((arg != null) ? arg : "null"));
				break;
				
			case 'a':
			case 'd':
				System.out.println("You picked " + (char)c);
				break;
				
			case 'b':
			case 'c':
				arg = g.getOptarg();
				System.out.println("You picked " + (char)c + " with an argument of " + ((arg != null) ? arg : "null"));
				break;
				
			case '?':
				//System.err.println("The option '" + (char)g.getOptopt() + "' is not valid");
				break;
				
			default:
				System.out.println("getopt() returned " + c);
			}
		}
		
		for (int i = g.getOptind(); i < argv.length ; i++) {
			System.out.println("Non option argv element: " + argv[i]);
		}
	}
}
