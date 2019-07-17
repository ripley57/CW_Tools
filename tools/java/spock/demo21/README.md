# Spock mocking. Verify order of method calls. Verify only certain methods are called. Verify passed method arguments.

The tests in this demo illustrate the most useful Spock mocking features.

*NOTE:* Spock records method interactions (number of method calls, etc) in the "when:" block.
        Therefore, any method call that invokes an interaction that is later checked in the
	"then:" block, *nust* be made inside the "when:" block. Otherwise the later interaction
	check will fail!


## Difference between stubs and mocks
Sometimes your class under test cannot be tested using simple assertions.
Sometimes the only way is to verify that the expected methods were called.
This is when mocking is used.

By mocking a collaborator of the class under test (remember, you never mock
or stub the class under test), you can not only preprogram it with canned 
responses (i.e. stubbing), but you can also query it (after the unit test 
has finished) about all its interactions.


Remember: A mock is a subset of a stub, so you can use "Mock()" in place of
          "Stub()". However, when writing Spock tests you should use a stub 
	  when you don't need to use a mock.
	   

## SimpleMockingSpec.groovy
The first test method in this spec simply demonstrates that, because a mock
is a superset of a stub in Spock, a mock can always be used in place of a
stub. However, for readability and maintainability, you should only use a 
mock when you really have to.

The second test method in this spec demonstrates a simple mock. In the test,
we verify that the "shutdown()" method of the CreditCardProcessor.java
collaborating interface was called *once* by our class under test (BillableBasket.java):
		1 * creditCardSevice.shutdown()
*NOTE:* If we update the BillableBasket.java class to incorrectly call
creditCardService.shutdown() twice, this test will fail.
*NOTE:* As with stubs, Spock "argument matchers" could be used here (see 
the next demo), e.g. .shutdown(_). 


## OrderMockingSpec.groovy - Verifying that "shutdown()" is called AFTER "sale()"
*NOTE:* Spock doesn’t pay any attention to the order of verifications inside 
        a "then:" block. Therefore the following will NOT work:
		then: "credit card is charged and CC service is closed down"
		1 * creditCardSevice.sale(1200,customer)
		1 * creditCardSevice.shutdown()
=> The solution is to use MULTIPLE "then:" blocks:
		then: "credit card is charged and"
		1 * creditCardSevice.sale( _ , _ )

		then: "the credit card service is closed down"
		1 * creditCardSevice.shutdown()


## CardinalityMockingSpec.groovy - combining a mock method with a stubbed response.
In this test we verify that one (mocked) method was never called (preload()), and we also stub a       
second mocked method so it always returns true (isProductAvailable()). We also use Spock argument 
matchers, because we don't care what arguments are passed:
	then: "order can be shipped"
	2 * inventory.isProductAvailable(_,_) >> true
	0 * inventory.preload( _ , _ )

You can also verify that only particular methods have been called, e.g.:
	then: "order can be shipped"
	2 * inventory.isProductAvailable(_,_) >> true
	1 * inventory.isEmpty() >> false
	0 * inventory._
This verifies that only methods "isProductAvailable()" and "isEmpty()" were called.

You can be even more strict, like this:
	then: "order can be shipped"
	2 * inventory.isProductAvailable(_,_) >> true
	_ * inventory.isEmpty() >> false
	0 * _
If your test uses two different mock objects, "0 * _" verifies that only methods 
"isProductAvailable()" and "isEmpty()" were called, and that no other methods were 
called, including the methods of any other mocks.
This example also states we don't care how many times "isEmpty()" was called, and
when it is called it will always return false using stubbing:
	_ * inventory.isEmpty() >> false


## ArgumentTypeVerificationSpec.groovy - Checking arguments passed to mocked methods.
For example, to verify that a null was not passed:
	then: "order can be shipped"
	2 * inventory.isProductAvailable(!null ,1) >> true

We can also verify the argument types used:
	then: "order can be shipped"
	2 * inventory.isProductAvailable(_ as String ,_ as Integer) >> true
*NOTE:* Using "_ as String" for the first argument, also implicitly includes
        the non-null verification earlier of "!null".


## ArgumentVerificationSpec.groovy - verify an object argument passed to a mocked method
The following example checks that the 2nd argument passed has a "vip" field value of "false":
	then: "credit card is charged"
	1 * creditCardSevice.sale(1550, { client -> client.vip == false})
(The other fields of the passed object can be anything).
Note that the closure code can contain pretty much anything. For example, you can do this:
	then: "credit card is charged"
	1 * creditCardSevice.sale({amount -> amount == basket.findOrderPrice()}, { client -> client.vip == false})


JeremyC 17-07-2019
