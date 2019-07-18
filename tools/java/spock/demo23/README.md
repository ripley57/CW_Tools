# Spock enterprise testing features: Categories of tests. Spock testing a Spring-based Java application.

Spock can cover:
- trivial plain unit tests
- larger integration tests,
- functional tests (aka "specification-based testing", i.e. testing against a specification).

This demo builds a Java Swing application and demonstrates Spock integration 
tests to test a Java program that was built using the Spring Framework.


*NOTE:*For the basics on the Spring Framework, see CW_Tools/tools/spring/


To run the tests:
'mvn clean test`

To build the application as a self-exectable jar:
`mvn clean package`
To run:
java -jar ./target/spring-standalone-swing-1.0.jar

To run the application directly from Maven:
`mvn exec:java -Dexec.mainClass=com.manning.spock.warehouse.Launcher`


### A note on Maven with Eclipse:
Use Eclipse "File->Import" to import the pom.xml file. This worked for me and I was
able to build and run the application from Eclipse successfully.
Comment about Eclipse on Mint 19.1:
Initially I used "apt install eclipse", but it wouldn't launch. In the end, I had to
manually download the Linux version directly from eclipse.org. To make launching it
easier,  I replaced by bad previous eclipse files (under /usr/lib/eclipse) with the
downloaded and extracted ones (the eclipse download is simply a tar of these files).


## Categories of tests

### "unit tests" focus on a single class.
These always examine a single class. All other classes are mocked/stubbed.
These are the easiest to, write and maintain. 
These run quickly, and depend only on the production code.
These should take milliseconds to run.

### "integration tests" examine how individually tested classes integrate into modules.
These focus on multiple classes. 
Mocks/stubs are rarely used, because you are interested in the iteractions between classes.
These are more difficult to write and maintain, as they can require external services such as a DB.
These usually takes seconds to run.
Integration tests should be focused on testing things that pure unit tests can’t detect, including transactions.
Integration tests are often used to ensure correct functionality between the prior code base and new modules added to a project.

### "functional tests (also called acceptance tests).
These tests are the most complex. 
These tests assume that the whole system is a black box.
These test end-to-end interactions, starting from the UI, and passing through the entire system.
These are even more difficult to setup and maintain, as they often require a clone or duplicate of a real system.
An example would be to open a web browser and purchase some items.
Unlike unit and integration tests, these are usually written by developers and customers/business analysts.
These usually take seconds to minutes to run.

*NOTE:* For further comparisons, see "test-categories-part1.png" and "test-categories-part2.png" (from page 196/197).

## The "testing pyramid"
Unit tests are the building blocks, upon which integration and then functional tests depend.
Only after you have enough unit tests can you safely start writing integration tests.
You should usually expect: 70% unit tests, 20% integration tests, 10% functional tests.
See also https://martinfowler.com/bliki/TestPyramid.html


## Spock with Spring:
Spock support for Spring tests is as easy as marking a test with the Spring test annotations.
Spock already contains a Spring extension that instantly recognizes the "@ContextConfiguration"
annotation provided by the Spring test facilities, e.g.:
	@ContextConfiguration(locations = "classpath:spring-context.xml")
	class RealDatabaseSpec extends spock.lang.Specification{

### RealDatabaseSpec.groovy - An Integration test in Spock for a program that uses the Spring framework.
This is an integration test, because the real database is initialized, and a product is saved on it 
and then read back. Nothing is mocked here, so if your database is slow, this test will also run slowly.

### RealDatabaseRollbackSpec.groovy - Same Spring integration test as before but with database rollback.
Note the following, to make the test honor transactions:
	@Transactional
Then this causes database changes to be reverted after the test runs:
	@Rollback
Even if your Spock test deletes or changes data in the database, these changes won’t be persisted at 
the end of the test suite. Again, this capability is offered by Spring, and Spock is completely 
oblivious to it.

### DummyDatabaseSpec.groovy - creates a special test "Spring Context" for running our Spock tests.
Our two test specs are using the full program Spring context:
	@ContextConfiguration(locations = "classpath:spring-context.xml")
This is not a good idea, because all the product classes will be initialized, even though not all
of them will be used. Furthermore, some GUI tests might not run correctly in a headless build.
To solve this, we use a different context for our tests, containing a reduced set of classes:
	@ContextConfiguration(locations = "classpath:reduced-test-context.xml")
With out own new context, we are free to redefine the "beans" that are active during the Spock
test. Two common techniques are replaceing the real database with a memory-based one, and 
removing beans not needed for the test. In own new context file, we've removed the GUI class and
replaced the file-based datasource with an in-memory H2 DB:
	<jdbc:embedded-database id="dataSource" type="H2"/> 
Because unit tests use specific datasets (small in size) and also need to run fast, an in-memory 
database is a good candidate for DB testing.
(See also http://www.h2database.com/html/main.html)

### DummyDatabaseGroovySqlWriteSpec.groovy - Groovy SQL interface with Spring.
The Groovy SQL class is a thin abstraction over JDBC that allows you to access a database in a 
convenient way. The Groovy SQL interface is a powerful feature and supports all SQL statements 
you’d expect. It can be used both in production code and in Spock tests.
Note: It gets direct access to the database, so it acts outside the caches of JPA/Hibernate.


### Spock testing applications based on JavaEE, instead of based on the Spring Framework:
The respective facilities offered by Spring in integration tests can be replicated by using
Arquillian (http://arquillian.org), a test framework for Java EE applications that acts as a 
testing container.


### Spock with Guice:
Apart from Spring, the core Spock distribution also includes support for the Guice dependency 
injection framework (https://github.com/google/guice). In a similar manner (to Spring and
Arquillian), it allows you to access Guice services/beans inside the Spock test.


### ManualInjectionSpec.groovy - Getting to Spock to work with other Java frameworks:
If the dependency injection framework you use is something else (other than Spring, Guice, Arquillian),
and there isn’t a Spock extension, you have two choices:
- Manually initialize and inject your services in the Spock setupSpec() method.
- Find a way to initialize the DI container programmatically inside the Spock test.
The first option usually requires a lot of code and goes against a simple Spock test. 
As a demo, this Spock test example assumes that the Spock-Spring extension doesn't exist, so we 
have to create the Spring container programmatically.


JeremyC 17-07-2019
