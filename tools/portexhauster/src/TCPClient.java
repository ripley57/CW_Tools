import java.io.*;
import java.net.*;
import java.util.concurrent.*;

class TCPClient implements Callable 
{
	String m_serverport = null;
	String m_clientdelayMS = null;
	
	public TCPClient(String serverport, String clientdelayMS)
	{
		m_serverport 	= serverport;
		m_clientdelayMS = clientdelayMS;
	}
	
	public String call() throws Exception
	{
		String sentence;
		String modifiedSentence;
  
		Socket clientSocket = new Socket("localhost", Integer.parseInt(m_serverport));
		DataOutputStream outToServer = new DataOutputStream(clientSocket.getOutputStream());
		BufferedReader inFromServer = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
		sentence = "Hello from the client!";
		//System.out.println("CLIENT: Sending to server: " + sentence);
		outToServer.writeBytes(sentence + '\n');
		modifiedSentence = inFromServer.readLine();
		System.out.println("CLIENT: Received from server: " + modifiedSentence);
		
		// Sleep here to keep connection with server active.
		Thread.sleep(Integer.parseInt(m_clientdelayMS));
		
		clientSocket.close();
		
		return new String("Client terminating");
	}
}