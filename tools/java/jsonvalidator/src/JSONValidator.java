import java.io.*;
import java.util.List;
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
		
		String data_json = convertToString(args[0]);
		
		String schema_json = EMPTY_SCHEMA;
		if (args.length == 2 && args[1].length() > 1)
			schema_json = convertToString(args[1]);
			
		new JSONValidator().validate(data_json, schema_json);
	}
	
	private static String convertToString(String str) throws IOException
	{
		File f = new File(str);
		if (f.exists()) {
			System.err.println("Treating input argument as file: " + str + "...");
			List<String> lines = Files.readAllLines(Paths.get(str));
			StringBuilder sb = new StringBuilder();
			for (String s: lines)
				sb.append(s);
			return sb.toString();
		}
		return str;
	}
	
	public boolean validate(String str_json, String str_schema) throws IOException, ProcessingException
	{
		JsonNode dataNode	= JsonLoader.fromString(str_json);
		JsonNode schemaNode	= JsonLoader.fromString(str_schema);
				
		JsonSchemaFactory factory = JsonSchemaFactory.byDefault();

		// Validate data against the schema.		
		// http://java-json-tools.github.io/json-schema-validator/2.2.x/com/github/fge/jsonschema/main/JsonSchema.html
		JsonSchema schema = factory.getJsonSchema(schemaNode);
		ProcessingReport report = schema.validate(dataNode, true);
		//System.err.println("report.isSuccess()=" + report.isSuccess());
		return report.isSuccess();
	}
}