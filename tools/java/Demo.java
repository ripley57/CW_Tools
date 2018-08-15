/*
** Simple Java program for quickly testing something.
*/

import java.nio.charset.*;
import java.nio.file.*;

public class Demo
{
        public static void main(String[] args) throws Exception
        {
                try {
			// \xF0\x9F\x87\xB1\xF0\x9F
			String s = new String(new byte[]{(byte) 0xF0, (byte) 0x9F, (byte) 0x87, (byte) 0xB1}, "UTF-8");
			//String s = "Zee\uC38Bn van tijd in Belgi\uC38B\r\n";
			Files.write(Paths.get("c://tmp//test.txt"), ("\uFEFF" + "This is a " + s + s + " test").getBytes(StandardCharsets.UTF_8));
		}
		catch (Exception e)
		{
			System.err.println("ERROR: " + e);
		}
	}
}
