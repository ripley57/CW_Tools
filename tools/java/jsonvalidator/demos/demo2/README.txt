A syntactically bad data file (data.json) - there is a comma (,) after the last "testimonial" record.

Run the demo like this:

$ java -jar jsonvalidator.jar data.json

FAILED: Syntax validation failure of the data file!

com.fasterxml.jackson.core.JsonParseException: Unexpected character (']' (code 93)): expected a value
 at [Source: (FileInputStream); line: 20, column: 2]
 

JeremyC 14-12-2018
