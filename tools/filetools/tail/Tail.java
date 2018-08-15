/*
** Description:
**    Tail command using Java.
**
** Example usage:
**    java Tail /c:/tmp/out.log
*/

import java.io.FileReader;
import java.io.LineNumberReader;
import java.io.PrintStream;
 
public class Tail
{
	public void t1(String filestr)
	{
		int lineNumber = 0;
		boolean skipped = false; // Avoid printing all line from start of file.
		try
		{
			LineNumberReader reader = new LineNumberReader(new FileReader(filestr));
			String line = null;
			while (true)
			{
				int data = reader.read();
				while (data != -1)
				{
					lineNumber = reader.getLineNumber();
					if ((line = reader.readLine()) != null)
					{
						if (skipped)
							System.out.println((char)data + line);
					}
           				data = reader.read();
				}
				if (!skipped)
					skipped = true;
				Thread.sleep(500L);
			}
		}
		catch (Exception e) {
			System.err.println(e);
		}
	}
 
	public static void main(String[] args) 
	{
		try {
			if ((args == null) && (args[0] == null)) {
				System.out.println(" usage: Java Tail [file name]");
				System.exit(1);
			} else {
				Tail tail = new Tail();
				tail.t1(args[0]);
			}
		}
		catch (Exception ee) {
			System.out.println(" usage: Java Tail [file name]");
		}
	}
}
