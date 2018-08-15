import gnu.getopt.LongOpt;
import gnu.getopt.Getopt;

public class GetoptDemo
{
	public static void main(String[] argv) {
		int c;
		String arg;

		Getopt g = new Getopt("testprog", argv, "ab:c::d");
		//g.setOpterr(false); // We'll do our own error handling

		while ((c = g.getopt()) != -1) {
			switch(c) {
			case 'a':
			case 'd':
				System.out.print("You picked " + (char)c + "\n");
				break;
			case 'b':
			case 'c':
				arg = g.getOptarg();
				System.out.print("You picked " + (char)c + " with an argument of " +
									((arg != null) ? arg : "null") + "\n");
				break;
			case '?':
				break; // getopt() already printed an error
			default:
				System.out.print("getopt() returned " + c + "\n");
			}
		}
	}
	
} // Class GetoptDemo
