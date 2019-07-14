# Spock demo of stubbing/mocking capability.

This demonstrates both stubbing and mocking using Spock. See page 83 of Java Testing with Spock.
*NOTE:* This also includes a JUnit equivalent (CoolantSensorTest.java).

This demo is similar to demo10, but this time we inject both a stub and a mock
object into the class under test (ImprovedTemperatureMonitor.java).

Like a stub, a mock is another fake collaborator of the class under test. Spock allows you 
to examine mock objects for their interactions *** after *** the test is finished.

Unlike stubs, mocks can fake input and output, and can be examined after the test is
complete. When the class under test calls your mock, the test framework (Spock in
this case) notes the characteristics of this call (such as number of times it was 
called or even the arguments that were passed for this call). You can examine these 
characteristics afterwards and decide if they are what you expect.

In this demo, we stub the "TemperatureReader interface", and mock the "ReactorControl" concrete class.


To run the Spock test:
`mvn clean verify`
or to be more specific:
mvn test "-Dtest=ImprovedCoolantSensorSpec"

To run the (almost) equivalent JUnit test:
mvn test "-Dtest=CoolantSensorTest"


JeremyC 14-07-2019
