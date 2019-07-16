# Spock stubbing.

The following are (essentially) the same thing:
- mocks
- stubs
- test doubles
- fake collaborators

Fake collaborators are a way to isolate a single class you want to test, so you 
can examine it under a well-controlled environment. A fake collaborator is a 
special class that replaces a real class in order to make its behaviour 
"deterministic" (preprogrammed).

Wikipedia - Deterministic:
A deterministic system is a system in which no randomness is involved in the 
development of future states of the system. A deterministic model will thus always 
produce the same output from a given starting condition or initial state.

Fake collaborators:
- Implement only the methods needed for the unit test.
- When making requests to a real class, the request parameters are pre-programmed.
- When answering requests from a real class, the answers are pre-programmed.


*NOTE:* Only the programmer knows the existence of the fake classes.
        From the point of view of the real class, everything is running normally

*NOTE:* If you use no fake collaborators, i.e. you only use real collobrator
        classes, then what you have is an "integration test", rather than a
        true unit test.

*NOTE:* We mock the collaborator classes, not the class under test!
        (The class under test is only ever mocked in extreme corner cases).

*NOTE:* Not all collaborator classes need to be mocked/stubbed.


Differences between a stub and a mock:
- stub: 
	A fake class that comes with preprogrammed return values. It’s injected
	into the class under test so that you have absolute control over what’s being
	tested as input. 
- mock: 
	A class that can be examined after the test is finished for its interactions
	with the class under test (for example, you can ask it whether a method was called
	or how many times it was called). 
*NOTE:* mocks can be stubbed, so mocks can be considered to be a superset of stubs.


JUnit:
Unlike JUnit, Spock has native support for mocks, so there’s no need to add an
external library to use this technique. 


When to use mocks and stubs - As a general rule: 
You should mock/stub all collaborator classes that do the following:
- classes that make the unit test non-deterministic (i.e. we want the same results each time!).
- classes that have severe side-effects (e.g. shutting down a real nuclear reactor!).
- classes where behaviour depends on the environment (e.g. env variables on a build vs a deployment system).
- classes that make the test slow (e.g. tests that communicate with a database).
- classes that need to exhibit strange behaviour (e.g. emulating a full disk, or a network failure).


Example:
This demo involves an eshop example. We will do the following:
- Stub the warehouse ("WarehouseInventory.java" class), so we can control the products and counts.
- Mock the (3rd party) credit card system, so we don't charge real credit cards! 

Basket.java collaborator classes:
   WarehouseInventory
   ShippingCalculator

# Testing the "canShipCompletely()" method of the Basket.java class:
     This method uses the WarehouseInventory class.
     This method returns true if all products selected by the customer are available in the warehouse.
     This method returns false othewise.
     We will stub the warehouse so we can simulate both of these use cases.

## SimpleStubbingSpec.groovy - Our first go at testing Basket.java
To run test:
`mvn test "-Dtest=SimpleStubbingSpec"`

## ArgumentStubbingSpec.groovy - Our improved test spec, utilising "argument matchers"
Here we've used Spock "argument matchers", so we can replace this...
	inventory.isProductAvailable("bravia",1) >> true
	inventory.isProductAvailable("panasonic",1) >> false
...with this:
	inventory.isProductAvailable( _, _) >> true
We can do this when our test doesn't care about the arguments being passed.

## SequenceStubbingSpec.groovy - Returning different responses from the same stubbed method 
This demonstrates how we can get a stubbed method to return a different response
depending on the number of times it is called:
	inventory.isProductAvailable( "bravia", _) >>> true >> false
	inventory.isEmpty() >>> [false, true]

## ExceptionStubbingSpec.groovy - Emulating exceptions from a stubbed method 
Here we verify that the "Basket.canShipCompletely()" method can handle an exception
thrown from the  WarehouseInventory class. We do this in Spock with this in our stub:
	inventory.isProductAvailable( "bravia", _) >> { throw new RuntimeException("critical error") }
The code inside "{...}" is actually a Groovy closure, so any Java/Groovy code can be put here.


# Testing the "findTotalCost()" method of the Basket.java class:
     This method uses the ShippingCalculator collaborator class interface.
     This is an interface, not a concrete class. This makes no difference to how we write our Spock test.
     => Spock can stub both interfaces and concrete classes in an agnostic way.

## DynamicStubbingSpec.groovy - Using Groovy closures to implement simple yet powerful stub methods
     shippingCalculator.findShippingCostFor( _, _) >> { Product product, int count ->  product.weight==0 ? 0 : 10 * count}

## StubsInStubsSpec.groovy - Stubs can return Stubs
This exampple demonstrates how easy it is to implement a stubbed class/interface 
that returns another stubbed class/interface.


JeremyC 16-07-2019
