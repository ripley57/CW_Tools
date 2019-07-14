# Spock demo of stubbing/mocking capability.

This demonstrates stubbing using Spock. See page 77 of Java Testing with Spock.

JUnit doesn’t support mocking (faking external object communication) out of the box.
People usually use Mockito when they need to fake objects in their JUnit tests.

Note that different names exists for the same thing:
- Mocks/stubs
- Test doubles
- Fake collaborators
All of these usually mean the same thing, i.e. dummy objects that are injected in the 
class under test, replacing the real implementations.

"stub" vs a "mock"
==================
"Stub" - Is a fake class that is pre-programmed with return values, to fake the input values being tested.
"Mock" - Is a fake class that can be examined after the test is finished for its interactions with the class 
         under test (for example, you can ask it whether a method was called or how many times it was called).
         This is faking the output values.
         Note: To complicate things, a Mock can also act as a stub.

In this demo, we need to "trick" the class under test (TemperatureMonitor.java) to use different temperature 
readings. We need to fake the input from the collaborating class that implements the interface TemperatureReader.java.

How do we do this?

We could write your own dummy class implementation of TemperatureReader that does what we want. "I’ve seen this 
technique too many times in enterprise projects, and I consider it an "antipattern". This introduces a new class
that’s used exclusively for unit tests, and must be kept in sync with the specifications."

=> The recommended approach is to use the built-in mocking capabilities of Spock.
Spock allows you to create a replacement class (or interface implementation) on the fly. 
The class under test will thinks it’s talking to a real object.
=> That's what we do in this demo - *** we will create a stub ***, i.e. a fake class with canned responses.


To run the Spock stubbing test:
`mvn clean verify`
or to be more specific:
mvn test "-Dtest=CoolantSensorSpec"

(*NOTE:* See the next demo for a mocking demo).


JeremyC 14-07-2019
