/*
** Description:
**		This program starts a TCP server and then
**		starts a specified number TCP client connections
**		to the server. The purpose of the program is
**		to demonstrate client port exhaustion, so that
**		the impact of this on mysql.exe client connections
**		can be examined.
**
** JeremyC 21-06-2017
*/

import gnu.getopt.LongOpt;
import gnu.getopt.Getopt;

import java.util.*;
import java.util.concurrent.*;

class PortExhauster 
{
	private String m_serverport = null;
	private String m_numclientconns = null;
	private String m_clientdelayMS = null;
	
	public PortExhauster(String serverport, String numclientconns, String clientdelayMS)
	{
		this.m_serverport		= serverport;
		this.m_numclientconns 	= numclientconns;
		this.m_clientdelayMS 	= clientdelayMS;
	}
	
	private static void usage()
	{
		System.out.println("java -jar portexhauster.jar --serverport <number> --numclientconns <number> --clientdelaysMS <number>");
	}
	
	public static void main(String argv[]) throws Exception {
		int c;
		String arg;
		StringBuffer sb = new StringBuffer();
		LongOpt[] longopts = new LongOpt[4];
		longopts[0] = new LongOpt("verbose",			LongOpt.NO_ARGUMENT, null, 1);
		longopts[1] = new LongOpt("serverport", 		LongOpt.REQUIRED_ARGUMENT, sb, 2);
		longopts[2] = new LongOpt("numclientconns", 	LongOpt.REQUIRED_ARGUMENT, sb, 3);
		longopts[3] = new LongOpt("clientdelayMS", 		LongOpt.REQUIRED_ARGUMENT, sb, 4);
 
		Getopt g = new Getopt("PortExhauster", argv, "hab:", longopts);
		g.setOpterr(true); // If we'll let getopt report errors.

		boolean verbose = false;
		String serverport = null;
		String numclientconns = null;
		String clientdelayMS = null;
		
		while ((c = g.getopt()) != -1) {
			//System.out.println("c="+c);
			switch(c) {
			case 0:	// Long option with argument.
				arg = g.getOptarg();	// Argument value.
				int longoptchar = (char)(new Integer(sb.toString()).intValue());	// Long option index converted to char.
				if (verbose) System.out.println("longoptchar=" + longoptchar + ", arg=" + arg);
				switch (longoptchar) {
				case 2:
					serverport = arg;
					break;
				case 3:
					numclientconns = arg;
					break;
				case 4:
					clientdelayMS = arg;
					break;
				default:
					break;
				}
				break;
			case 1:
				verbose = true;
				break;
			case 'a':	// Testing getopt().
				System.out.print("You picked " + (char)c + "\n");
				System.exit(0);
				break;
			case 'b':	// Testing getopt().
				arg = g.getOptarg();
				System.out.print("You picked " + (char)c + " with argument of " + ((arg != null) ? arg : "null") + "\n");
				System.exit(0);
				break;
			case '?':	// getopt() already printed an error.
				System.exit(1);
				break;
			case 'h':
				usage();
				System.exit(0);
				break;
			default:
				System.out.print("getopt() returned " + c + "\n");
				System.exit(2);
			}
		}
		
		if (verbose) {
			System.out.println("serverport=" 		+ serverport);
			System.out.println("numclientconns=" 	+ numclientconns);
			System.out.println("clientdelayMS="		+ clientdelayMS);
		}
		
		if (serverport == null)
			throw new IllegalArgumentException("server port number must be specified!");
		if (numclientconns == null)
			throw new IllegalArgumentException("number of client connections must be specified!");
		if (clientdelayMS == null)
			throw new IllegalArgumentException("client delays in MS must be specified!");
		
		new PortExhauster(serverport, numclientconns, clientdelayMS).run();
	}
	
	public void run() throws Exception {
		// Start the server.
		System.out.println("Starting server..");
		ExecutorService pool_server = Executors.newFixedThreadPool(1);
		Future<String> p = pool_server.submit(new TCPServer(m_serverport, m_numclientconns));
		
		// Start the clients. 
		System.out.println("Starting clients...");
		ExecutorService pool = Executors.newFixedThreadPool(3);
		Set<Future<String>> set = new HashSet<Future<String>>();
		int numclients = Integer.parseInt(m_numclientconns);
		for (int i=0; i<numclients; i++) {
			Callable<String> callable = new TCPClient(m_serverport, m_clientdelayMS);
			Future<String> future = pool.submit(callable);
			set.add(future);
		}
		for (Future<String> future : set) {
			String s = future.get();
			//System.out.println(s);
		}
		
		System.out.println("Finished");
		System.exit(0);
	}
}
