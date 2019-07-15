# Spock parametized tests using the "where:" block. Data table examples.

Remember: "Parameterized tests" are unit tests that share the same test logic,
          and you need the test to be run multiple times with different inputs.

*NOTE:*
Every time you start a new unit test by copying-pasting an existing one, ask yourself, 
“Is this test that much different from the previous one?” 
If you find yourself duplicating unit tests and then changing only one or two variables 
to create a similar scenario, take a step back and think about whether a parameterized 
test would be more useful. 
=> Parameterized tests will help you keep the test code "DRY".

*NOTE:* The "where:" block must be the last block in a Spock test.

*NOTE:* You need to make sure that the names of the parameters don't clash with
        existing variables in the source code, in local or global scope.


## BadImageNameValidatorSpec.groovy
This shows a badly-written test!
This has terrible code duplication!


## GoodImageNameValidatorSpec.groovy
This is how the previous test SHOULD be written!
This reduces code duplication.
New tests are also simple to add.


## SimpleTabularSpec.groovy
A Very simple data table parametized test example.
*NOTE:* The second test in SimpleTabularSpec.groovy declares the types of the
        parameters, in the "def" method test declaration.
        Declaring the parameter types like this is optional, because Spock can
        usually infer the type automatically.


## SimpleTabularSpec2.groovy
This includes "println" calls to indicate how a parametized test is run
multiple times automatically.
To run just this test (so you can clearly see the println calls):
`mvn test "-Dtest=SimpleTabularSpec2"`


## SingleColumnSpec.groovy
One slightly annoying limitation with data tables is that the table must have
at least two columns. You there need to add a "filler" for the second column.


## DiscountSpec.groovy
*NOTE:* This is a more complex, and realistic, example of running a parametized 
        test using a data table.


To run all the test specs:
`mvn test`


JeremyC 15-07-2019
