## Introduction to Spock
Spock is a comprehensive DSL (Domain Specific Language), for testing.
For this reason, it is much easier and more descriptive than JUnit. 
Spock is written in the Groovy language.

## Maven refresher
Remember that Maven has a finite list of built-in targets:
- validate
- compile
- test
- package
- integration-test
- verify
- install
- deploy
(See http://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)

*NOTE*: By default, Maven expects JUnit tests to be in src/test/java and Spock (i.e. Groovy) tests in src/test/groovy. If you rename these directories, you will find that the tests are skipped.


JeremyC 11-07-2019
