# Spock @Unroll annotation for parametized tests and identifying failure input parameters.

One problem with Spock parametized tests is that, although the test is run
multiple times automatically, Spock presents the collection of parametized
tests as a single test to the testing framework, e.g. Eclipse IDE.
This causes a problem when one of the parametized test fails, because it's
not obvious which set of values caused the failure.

The Spock "@Unroll" annotation makes the multiple parameterized scenarios/tests
appear as multiple test runs. The annotation can be applied at the spec class
level, or above each individual scenario/test "def" method.


## UnrollDataSpec.groovy
Edit the values in one row of the tables, to see how an individual
failure is clearly indicated, becaue of the "@Unroll" annotation.

To run the tests:
`mvn test`

Example output:
Trivial adder test[1](com.manning.chapter5.tables.UnrollDataSpec)  Time elapsed: 0.485 sec  <<< FAILURE!
*NOTE:* The scenario number ("...test[1]") is zero-based, hence this example indicates that the second row of table parameters failed.

*NOTE:* Note how the three scenario/test methods are declared differently, and
        this affects the detail reported. For example, if we edit
        the first row in each table to cause each test to fail:

	Failed tests: 
		Trivial adder test[0](com.manning.chapter5.tables.UnrollDataSpec)
		Testing the Adder for 10 + 1 = 2(com.manning.chapter5.tables.UnrollDataSpec)
		Testing the Adder for 10 + 1 = 2 (com.manning.chapter5.tables.UnrollDataSpec)

*NOTE:* As the third test method indicates, you can even embed the parameters 
        passed directly in the test method name:
       	def "Testing the Adder for #first + #second = #sum "() {


JeremyC 15-07-2019
