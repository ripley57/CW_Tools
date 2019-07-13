## Introduction to Spock

NOTE: To run a specific Spock "Spec" file using Maven:
`mvn test "-Dtest=ExpandoDemoSpec"`

Spock is a comprehensive DSL (Domain Specific Language), for testing.
For this reason, it is much nicer and more descriptive than JUnit. 
Spock is written in the Groovy language.

Spock (i.e. Groovy) supports less-verbose code than Java. Less code is easier 
to read, easier to debug, and easier to maintain in the long run.

JUnit doesn't support mocking and stubbing out-of-the-box, but Spock does.
JUnit also doesn't support tests running in a specific order.

JUnit and Spock tools have a different philosophy when it comes to testing. 
JUnit is a Spartan library that provides the absolutely necessary things you 
need to test and leaves additional functionality (such as mocking and stubbing) 
to external libraries. Spock takes a holistic approach, providing a superset of 
the capabilities of JUnit, while at the same time reusing JUnit's mature 
integration with tools and development environments. Spock can do everything 
that JUnit does and more, keeping backward compatibility as far as test runners 
are concerned.

Spock uses the JUnit runner infrastructure and therefore is compatible with all
existing Java infrastructure. For example, code coverage with Spock is possible
in the same way as JUnit. It’s possible to keep your existing JUnit tests in place
and use Spock only for testing new code.

One of the killer features of Spock is the detail it gives when a test fails. 
JUnit mentions the expected and actual value, whereas Spock records the 
surrounding running environment, mentioning the intermediate results and allowing
the developer to pinpoint the problem with greater ease than JUnit.

## Spock & Groovy online playgrounds
[Online Spock playground)(https://meetspock.appspot.com/)
[Online Groovy playground)(https://groovyconsole.appspot.com/)

## A very short Maven refresher
Remember that Maven has a finite number of built-in targets, inluding:
- validate
- compile
- test
- package
- integration-test
- verify
- install
- deploy
Running "mvn verify" is usually sufficient to execute your JUnit & Spock tests.
See:
https://www.baeldung.com/maven-goals-phases
http://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html


*NOTE*: (By default) Maven expects JUnit tests to be in src/test/java and Spock tests in 
        src/test/groovy. If you don't use these names, your tests will be skipped.


JeremyC 11-07-2019
