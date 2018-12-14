A syntactically good data file (data.json), but a syntactically bad schema file (schema.json) - see ",,"


Run the demo like this:

$ java -jar jsonvalidator.jar data.json schema.json
Json data: data.json
Json schema: schema.json

FAILED: Syntax validation failure of the schema file!

com.fasterxml.jackson.core.JsonParseException: Unexpected character (',' (code 44)): was expecting double-quote to start field name
 at [Source: (FileInputStream); line: 31, column: 5]
 

JeremyC 14-12-2018
