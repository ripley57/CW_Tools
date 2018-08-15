import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import javax.xml.XMLConstants;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

/**
 * Validator for EDRM XML files against the EDRM XSD
 */
public class EDRMValidator
{
	public static void main(String[] args) throws Exception
	{
		if (args.length != 1) {
			String s = "\nDescription\n"							+
			 	   "  Perform XML EDRM validation against input XML file.\n"	+
		            	   "Usage:\n" 								+
				   "  java EDRMValidator <input xml file>\n\n";
			System.out.println(s);
			System.exit(1);
		}

		File xmlFile = new File(args[0]);

	    	Validator m_validator;
	        String schemaPath = "schemas" + File.separator + "EDRM-1.0.xsd";
	        SchemaFactory sf = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
	        Schema schema = sf.newSchema(new StreamSource(new File(schemaPath)));
	
	        m_validator = schema.newValidator();
	        m_validator.setErrorHandler(new ErrorHandler() {
	            @Override
	            public void warning(SAXParseException exception) throws SAXException {
	                System.err.println("WARN: Schema validation warning at line " + exception.getLineNumber());
	            }
	
	            @Override
	            public void error(SAXParseException exception) throws SAXException {
	                System.err.println("ERROR: Schema validation error at line " + exception.getLineNumber());
	                throw exception;
	            }
	
	            @Override
	            public void fatalError(SAXParseException exception) throws SAXException {
	                System.err.println("FATAL: Schema validation fatal error at line " + exception.getLineNumber());
	                throw exception;
	            }
	        });
	
	        m_validator.validate(new StreamSource(xmlFile));
	        System.out.println("SUCCESS: This is a valid EDRM xml file: " + xmlFile.getAbsolutePath());
	}
}
