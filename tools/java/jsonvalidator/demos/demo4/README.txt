A syntactically good data file (data.json), and a syntactically good schema file (schema.json), but the schema file includes an invalid type of "banjo".


Run the demo like this:

$ java -jar jsonvalidator.jar data.json schema.json
Json data: data.json
Json schema: schema.json

FAILED: Validation against schema failed!

com.github.fge.jsonschema.core.exceptions.InvalidSchemaException: fatal: invalid JSON Schema, cannot continue
Syntax errors:
[ {
  "level" : "error",
  "message" : "\"banjo\" is not a valid primitive type (valid values are: [array, boolean, integer, null, number, object, string])
",
  "domain" : "syntax",
  "schema" : {
    "loadingURI" : "#",
    "pointer" : "/definitions/testimonials"
  },
  "keyword" : "type",
  "found" : "banjo",
  "valid" : [ "array", "boolean", "integer", "null", "number", "object", "string" ]
} ]
    level: "fatal"



JeremyC 14-12-2018
