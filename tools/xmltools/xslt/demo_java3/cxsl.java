/*
** Description:
**	Java xslt driver program.
**
** Example usage:
**	java cxsl transform.xml input.xml > out.txt
**
** JeremyC 1-2-2018
*/

 import java.io.FileInputStream;
 import java.util.*;
 import java.io.*;
 import javax.xml.transform.Transformer;
 import javax.xml.transform.TransformerFactory;
 import javax.xml.transform.sax.SAXSource;
 import javax.xml.transform.stream.StreamResult;
 import org.xml.sax.InputSource;

 public class cxsl
 {
	private static void usage() 
	{
		String s = "\nUsage:\n" 											+
				   "  java cxsl <input xsl file> <input xml file>\n\n"		+
				   "Example:\n"												+
				   "  java cxsl transform.xml input.xml > out.xml";
		System.out.println(s);
	}
	
	/*
	** Function called from our stylesheet transform.xsl.
	**
	** Extract the entry id value from the passed LocationURI string. 
	** The entry id value is the last element, e.g.:
	**
	** <LocationURI>esa:pst/*:\\edp-app1\d$\CaseData\Enron_Small1\bill_rapp\bill_rapp_000_1_1.pst:Top of Personal Folders\rapp-b\Rapp, Bill (Non-Privileged)\Rapp, Bill\Deleted 
	**  Items:0000000095b6e9026e396c4d9fe3d9e4ede7b38f840a2000</LocationURI>
	*/
	public static String getEntryID(String locationuri)
	{
		String[] parts = locationuri.split(":");
		String rtn = parts[4];
		return rtn;
	}
	
	public static void main(String[] args) throws Exception
	{
		if (args.length != 2) {
			usage();
			System.exit(1);
		}
		
		String inputXslFile = args[0];
		String inputXmlFile = args[1];
	 
		TransformerFactory localTransformerFactory = TransformerFactory.newInstance();
		Transformer localTransformer = localTransformerFactory.newTransformer(new SAXSource(new InputSource(new FileInputStream(inputXslFile))));
		localTransformer.transform(new SAXSource(new InputSource(new FileInputStream(inputXmlFile))), new StreamResult(System.out));
	}
}
