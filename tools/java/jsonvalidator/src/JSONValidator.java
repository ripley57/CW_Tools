import java.io.*;
import java.util.List;
import java.nio.charset.Charset;
import java.nio.file.*;
import org.json.*;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonNode;
import com.github.fge.jackson.JsonLoader;
import com.github.fge.jsonschema.core.exceptions.ProcessingException;
import com.github.fge.jsonschema.core.report.ProcessingReport;
import com.github.fge.jsonschema.main.JsonSchema;
import com.github.fge.jsonschema.main.JsonSchemaFactory;

public class JSONValidator
{
	// Empty schema (see https://www.jsonschemavalidator.net/)
	public final static String EMPTY_SCHEMA = "{ \"$schema\": \"http://json-schema.org/draft-07/schema#\" }";
	
	private static void usage() 
	{
		System.err.println(
			"Usage: \n" +
			"	JSONValidator <data.json> [<schema.json>]\n"
			);
	}
	
	public static void main(String[] args) throws IOException, ProcessingException
	{
		if (args.length < 1) {
			usage();
			System.exit(1);
		}
		
		String data_json = args[0];
		System.out.println("Json data: " + data_json);
		
		String schema_json = EMPTY_SCHEMA;
		if (args.length == 2 && args[1].length() > 1)
			schema_json = args[1];
		System.out.println("Json schema: " + schema_json);
			
		new JSONValidator().validate(data_json, schema_json);
	}
	
	private JsonNode loadJson(String str_json) throws IOException
	{
		JsonNode node = null;
		File f = new File(str_json);
		if (f.exists()) {
			//System.err.println("Treating input argument as file: \"" + str_json + "\"...");
			node = JsonLoader.fromFile(f);
		} else {
			node = JsonLoader.fromString(str_json);
		}
		return node;
	}
	
	private void reportSuccess() 
	{	
		System.out.println("SUCCESS: Validation was successful.");		
	}
	
	private void reportFailure(String msgText, Exception error)
	{
		System.out.println(String.format("\nFAILED: %s\n\n%s\n", msgText, error));
	}
	
	private void reportFailure(String msgText)
	{
		System.out.println(String.format("\nFAILED: %s\n", msgText));
	}
	
	public boolean validate(String str_json, String str_schema) throws IOException, ProcessingException
	{
		JsonNode dataNode = null;
		try {
			dataNode = loadJson(str_json);
		} 
		catch (Exception e) 
		{
			reportFailure("Syntax validation failure of the data file!", e);
			return false;
		}
		
		JsonNode schemaNode = null;
		try {
			schemaNode	= loadJson(str_schema);
		}
		catch (Exception e) {
			reportFailure("Syntax validation failure of the schema file!", e);
			return false;
		}
				
		JsonSchemaFactory factory = JsonSchemaFactory.byDefault();

		// Validate the json data against the json schema.		
		// http://java-json-tools.github.io/json-schema-validator/2.2.x/com/github/fge/jsonschema/main/JsonSchema.html
		JsonSchema schema = factory.getJsonSchema(schemaNode);
		
		ProcessingReport report = null;
		try {
			report = schema.validate(dataNode, true);
		}
		catch (Exception e) {
			reportFailure("Validation against schema failed!", e);
			return false;
		}
		
		if (report.isSuccess()) {
			reportSuccess();
		} else {
			reportFailure("Validation against schema failed!\n\n" + report);
		}

		return report.isSuccess();
	}
}