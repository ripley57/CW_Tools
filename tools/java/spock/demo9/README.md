# Nice "parametized test" example (i.e. testing different combinations of input values).

ME: This feature of Spock vs JUnit is truely impressive!

See Java Testing with Spock, page 71.

This demo contrasts JUnit and Spock parametized testing.

See file "test-parameters.png". This contains 12 different scenarios, but creating 
12 separate tests would be a nightmare for code duplication and future maintenance.

Using a "parametized test" we can test all scenarios in a single Spock test!
Spock comes with built-in support for parameterized tests with a friendly DSL (domain
specific language) syntax, specifically tailored to handle multiple inputs and outputs.

Limitations of JUnit:
The limitations of JUnit make parameterized testing a challenge, and developers suffer 
because of inertia and their resistance to changing their testing framework.
The recent versions of JUnit advertise support for parameterized tests. The official
way of implementing a parameterized test with JUnit is included in this demo (NuclearReactorTest.java).


To run the Spock (and JUnit) tests:
`mvn clean verify`


To generate a surefire test report (for both JUnit and Spock tests):
`mvn surefire-report:report`
This generates the html report:
target/site/surefire-report.html
NOTE: To add the missing report images and CSS:
`mvn site -DgenerateReports=false`
NOTE: The surefire report lists the Spock spec as simply a single test :-(

To generate a spock test report:
`mvn test`
(see "<scope>test</scope>" in pom.xml)
This generates the html report:
build/spock-reports/index.html
NOTE: Unlike the surefire report, the Spock report knows how to display the input
      values for each sub-test in the Spock spec.


JeremyC 14-07-2019
