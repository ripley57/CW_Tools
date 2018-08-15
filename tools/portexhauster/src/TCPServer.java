import java.io.*;
import java.net.*;
import java.util.concurrent.*;

class TCPServer implements Callable 
{
	private int m_serverport = 0;
	private int m_maxclientconns = 0;
	
	public TCPServer(String serverport, String maxclientconns)
	{
		this.m_serverport 		= Integer.parseInt(serverport);
		this.m_maxclientconns 	= Integer.parseInt(maxclientconns);
	}
	
	public String call() throws Exception
	{
		String clientSentence;
		String capitalizedSentence;
  
  		ServerSocket welcomeSocket = new ServerSocket(m_serverport);
		
		int clientcount = 0;
		while (true) {
			if (clientcount == m_maxclientconns)
				break;
			
			//System.out.println("SERVER: Waiting for new client connection...");
			Socket connectionSocket = welcomeSocket.accept();
			clientcount++;
			
			System.out.println("SERVER: Current client count=" + clientcount);
			BufferedReader inFromClient = new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
			DataOutputStream outToClient = new DataOutputStream(connectionSocket.getOutputStream());
			clientSentence = inFromClient.readLine();
			System.out.println("SERVER: Received from client: " + clientSentence);
			capitalizedSentence = clientSentence.toUpperCase() + '\n';
			//System.out.println("SERVER: Sending to client: " + capitalizedSentence);
			outToClient.writeBytes(capitalizedSentence);
		}
		
		return new String("Server terminating");
	}
}