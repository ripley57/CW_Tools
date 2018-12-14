A syntactically good data file (data.json), and a syntactically good schema file (schema.json), but the data file does not match the schema - the schema includes a field named "XXXX", instead of being named "testimonial".


Run the demo like this:

$ java -jar jsonvalidator.jar data.json schema.json
Json data: data.json
Json schema: schema.json

FAILED: Validation against schema failed!

com.github.fge.jsonschema.core.report.ListProcessingReport: failure
--- BEGIN MESSAGES ---
error: object has missing required properties (["XXXX"])
    level: "error"
    schema: {"loadingURI":"#","pointer":"/definitions/testimonials/items"}
    instance: {"pointer":"/testimonials/0"}
    domain: "validation"
    keyword: "required"
    required: ["XXXX","jobtitle"]
    missing: ["XXXX"]
error: object has missing required properties (["XXXX"])
...
 

JeremyC 14-12-2018
