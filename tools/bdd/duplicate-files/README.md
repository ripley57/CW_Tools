# Duplicate Files Project

This is my first attempt at using BDD practices, by following eBooks "BDD In Action" and
"Java Testing with Spock" to create my own Java application to identify duplicate files.

The main idea behind BDD is to create executable acceptance tests, that drive the design
and implementation of the application, whilst also ensuring the buiness goals are met and
providing application progress via visibile reports (using a tool like Thycydides).

## Thucydides:
From http://thucydides.info/docs/thucydides-one-page/thucydides.html#introduction:
"...provides features that make it easier to organize and structure your acceptance tests, 
associating them with the user stories or features that they test. As the tests are executed, 
Thucydides generates illustrated documentation describing how the application is used based 
on the stories described by the tests."

## To run unit tests, acceptance tests, and invoke Thucydides:
`mvn verify`

The output Thucydides acceptance test report can be found here:
./target/site/thucydides/index.html
(See thucydides-screenshot.png)

NOTE: I found that failing unit tests prevents my acceptance tests (JBehave) from running,
      hence my JBehave files and Thucydides report where not generated until I set my unit 
      tests (TestDataGeneratorSpec.groovy) to "@Ignore".


JeremyC 26-07-2019
