# Spock parametized table data generated using expressions, or derived from constants or other parameters.

In a Spock parametized test, nothing is stopping you from using custom classes, 
collections, object factories, or any other Groovy expression that results in 
something that can be used as an input or output parameter.

## ExpressionInTableSpec.groovy
This is a (very unrealistic) Spock test, that demonstrates how the data table
values can be expressions.

*NOTE:* Using many expressions like this does make the test less readable.
This is a sign that you need to convert the tabular data into "data pipes" (see below).


## BasicPipesSpec.groovy
This spec introduces the use of "data pipes" to generate the parametized input
values dynamically.
*NOTE:* Notice the number of tests run due to the use of Groovy ranges!


## DerivedValuesSpec.groovy
This spec demonstrates the following:
o A value in the data table can be constant.
o A value in the data tables can be derived from another value.


To run tests:
`mvn test`


JeremyC 15-07-2019
