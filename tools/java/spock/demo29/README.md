# Spock "Spy".

Spies are like partial Mocks. You take over only some of an objects methods.
Methods can be stubbed (like mocks), or else they pass through to the real
object. A spy is a fake object that automatically calls the real methods of 
a class unless they’re explicitly mocked. Creating a spy without mocking any 
method is the same as using the object itself — not very exciting.

*NOTE* Spike are a controversial technique that implies problematic Java code.
Their primary use is in creating unit tests for badly designed production code 
that can’t be refactored for some reason (a common scenario with legacy code).

Remember: Despite Spock's support for spies, you should avoid using them,
and instead spend time improving the design of your code so that spies aren’t 
needed. 

## SimpleSpySpec.groovy - Demonstrates the need to use a Spock "spy"
This tests the code in package "com.manning.spock.chapter8.nuker".

## NoSpySpec.groovy - Demonstrates how to remove need to use a Spy.
This tests a re-written version of the application being tested.
The new application code is in package "src/main/java/com/manning/spock/chapter8/nuker2"
By refactoring the application code to make the classes more independent using
composition, there is no longer a need to use a Spy, and a Mock can be used
instead.


JeremyC 19-07-2019
