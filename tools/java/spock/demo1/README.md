# Java testing with Spock vs JUnit

This demo shows how Spock and JUnit tests can be run together. 

## Results when running `mvn clean ; mvn verify` (in the directory contain pom.xml)
You should see this:
```-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.manning.chapter1.AdderSpec
Tests run: 2, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 4.651 sec
Running com.manning.chapter1.AdderTest
Tests run: 2, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.251 sec

Results :

Tests run: 4, Failures: 0, Errors: 0, Skipped: 0```

*NOTE*: By default, Maven expects JUnit tests to be in src/test/java and Spock (i.e. Groovy) tests in src/test/groovy. If you rename these directories, you will find that the tests are skipped.


JeremyC 11-07-2019
