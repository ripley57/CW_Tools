A good json data file (data.json) and a corresponding and good json schema file (schema.json).

Run the demo like this:

1) Basic syntax validation of data.json, i.e. without validating against the schema:

$ java -jar jsonvalidator.jar data.json
SUCCESS: Validation was successful.


2) Validation of data.json against the schema file schema.json:

$ java -jar jsonvalidator.jar data.json schema.json
SUCCESS: Validation was successful.


JeremyC 14-12-2018
