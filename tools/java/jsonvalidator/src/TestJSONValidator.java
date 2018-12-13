/**
 * Test the <CODE>JSONValidator</CODE> class
 */

import java.io.IOException;
import org.junit.*;
/*
** Static import is a feature introduced in the Java programming language that allows 
** members defined in a class as public static to be used in Java code without specifying 
** the class in which the field is defined. This feature was introduced into the language 
** in version 5.0.
*/
import static org.junit.Assert.*;

import com.github.fge.jsonschema.core.exceptions.ProcessingException;

public class TestJSONValidator
{
	// Syntactically valid json data.
	String valid_json_data_1 = 	"{																													" +
						"	\"testimonials\":[																								" +
						"		{\"testimonial\":\"Jeremy understood my problem very quickly.\",\"jobtitle\":\"Customer survey comment\"},	" +
						"		{\"testimonial\":\"Excellent support from Jeremy as always.\",\"jobtitle\":\"Customer survey comment\"}		" +
						"	]																												" +
						"}																													";
	
	// Syntactically invalid json data: there is a "." between the records instead of a ",".
	String invalid_json_data_1 =  "{																													" +
						"	\"testimonials\":[																								" +
						"		{\"testimonial\":\"Jeremy understood my problem very quickly.\",\"jobtitle\":\"Customer survey comment\"}.	" +
						"		{\"testimonial\":\"Excellent support from Jeremy as always.\",\"jobtitle\":\"Customer survey comment\"}		" +
						"	]																												" +
						"}																													";

	// Syntactically valid json schema.
	String valid_schema_1 = "{															" +
						"   \"$schema\": \"http://json-schema.org/draft-04/schema#\",	" +
						"	\"type\": \"object\",										" +
						"	\"definitions\": {											" +
						"		\"testimonials\": {										" +
						"			\"type\": \"array\",								" +
						"			\"items\": {										" +
						"				\"type\" : \"object\",							" +
						"				\"required\": [									" +
						"					\"testimonial\",							" +
						"					\"jobtitle\"								" +
						"				],												" +
						"				\"properties\" : {								" +
						"					\"testimonial\": {							" +
						"						\"type\": \"string\"					" + 
						"					},											" +
						"					\"jobtitle\": { 							" +
						"						\"type\": \"string\"					" + 
						"					}											" +
						"				}												" +
						"			}													" +
						"		}														" +
						"	},															" +
						"	\"required\": [												" +
						"		\"testimonials\"										" +
						"	],															" +
						"	\"properties\": {											" +
						"		\"testimonials\": {										" +
						"			\"$ref\": \"#/definitions/testimonials\"			" +
						"		}														" +
						"	}															" +
						"}																";	
	
	// Syntactically valid json schema.
	String valid_schema_2 = "{															" +
						"   \"$schema\": \"http://json-schema.org/draft-04/schema#\",	" +
						"	\"type\": \"object\",										" +
						"	\"definitions\": {											" +
						"		\"testimonials\": {										" +
						"			\"type\": \"array\",								" +
						"			\"items\": {										" +
						"				\"type\" : \"object\",							" +
						"				\"required\": [									" +
						"					\"XXXX\",									" +
						"					\"YYYY\",									" +
						"					\"ZZZZ\"									" +
						"				],												" +
						"				\"properties\" : {								" +
						"					\"XXXX\": 	{								" +
						"						\"type\": \"integer\"					" + 
						"					},											" +
						"					\"YYYY\": 	{ 								" +
						"						\"type\": \"integer\"					" + 
						"					},											" +
						"					\"ZZZZ\": 	{ 								" +
						"						\"type\": \"integer\" 					" +
						"					}											" +
						"				}												" +
						"			}													" +
						"		}														" +
						"	},															" +
						"	\"required\": [												" +
						"		\"testimonials\"										" +
						"	],															" +
						"	\"properties\": {											" +
						"		\"testimonials\": {										" +
						"			\"$ref\": \"#/definitions/testimonials\"			" +
						"		}														" +
						"	}															" +
						"}																";	
	
	private JSONValidator validator;
 
	@Before
	public void instantiate() throws Exception
	{
		validator = new JSONValidator();
	}

	@Test
	public void testValidationSuccessWithNoSchema() throws IOException, ProcessingException
	{
		boolean rtn = validator.validate(valid_json_data_1, JSONValidator.EMPTY_SCHEMA);
		assertEquals("Validator should return true for a successful validation.", true, rtn);
	}
	
	@Test(expected=com.fasterxml.jackson.core.JsonParseException.class)
	public void testValidationFailureWithNoSchema() throws IOException, ProcessingException
	{
		boolean rtn = validator.validate(invalid_json_data_1, JSONValidator.EMPTY_SCHEMA);
	}
	
	/*
	** Useful references regarding JSON schemas:
	**		https://stackoverflow.com/questions/35836392/json-validation-against-json-schemas-why-is-this-obvious-json-data-not-failing
	**		https://davidwalsh.name/json-validation
	**		https://json-schema.org/
	**		https://neiljbrown.com/2016/09/25/json-schema-part-2-automating-json-validation-tests/
	*/
	
	@Test	// Json data IS compliant with a valid json schema.
	public void testValidationSuccessWithSchema() throws IOException, ProcessingException
	{
		boolean rtn = validator.validate(valid_json_data_1, valid_schema_1);
		assertEquals("Validator should return true for a successful validation with good schema.", true, rtn);				
	}
	
	@Test	// Json data is non-compliant with a valid json schema.
	public void testValidationFailureWithSchema() throws IOException, ProcessingException
	{
		boolean rtn = validator.validate(valid_json_data_1, valid_schema_2);
		assertEquals("Validator should return false due to content not being compliant with the schema.", false, rtn);
	}
}
