import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

import reflectiondemo.PropFileWrapper;

public class ReflectionDemo {
	public static void main(String[] args) {
		FileInputStream fis = null;
		PropFileWrapper wrapper = null;
		
		try {
			File propFile = new File("./somedir/demo.properties");
			fis = new FileInputStream(propFile);
			Properties props = new Properties();
			props.load(fis);
			wrapper = new PropFileWrapper(props);
		}
		catch (Exception e) 
		{
			System.err.println("ERROR: " + e.getMessage());
			return;
		}
		finally
		{
			try {
				if (fis != null)
					fis.close();
			}
			catch (Exception e2) 
			{
			}
		}
		
		if (wrapper != null) {
			System.out.println("Crawled volume: " + wrapper.getCrawledVolume());
		}
	}
}