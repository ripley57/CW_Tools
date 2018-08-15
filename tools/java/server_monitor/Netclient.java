import java.io.*;
import java.net.*;

public class Netclient {
    public static void main(String[] args) throws IOException {
        if (args.length != 2) {
            System.err.println("Usage: java EchoClient <host name> <port number>");
            System.exit(1);
        }

        while (true) {
			testConnection(args[0], Integer.parseInt(args[1]));
		
			try {        
				Thread.sleep(3000);
			} 
			catch(InterruptedException ex) 
			{
				Thread.currentThread().interrupt();
			}
		}
    }
	
	private static void testConnection(String hostName, int portNumber) throws IOException 
	{
		Socket echoSocket = null;
		PrintWriter out = null;
		BufferedReader in = null;
		
        try {
            echoSocket = new Socket(hostName, portNumber);
            out = new PrintWriter(echoSocket.getOutputStream(), true);
            in = new BufferedReader(new InputStreamReader(echoSocket.getInputStream()));
			System.out.println("Connected successfully");
		} 
		catch (Exception e) {
			System.out.println("Failed to connect: " + e);
        } 
		finally 
		{
			if (echoSocket != null) echoSocket.close();
			if (out != null) out.close();
			if (in != null) in.close();
			
			echoSocket = null;
			out = null;
			in = null;
		}
	}
}