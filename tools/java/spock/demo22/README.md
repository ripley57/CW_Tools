# Spock mocking. A complex real-life example, demonstrating the various techniques (introduced in demo21).

## ComplexMockingSpec.groovy 

If you need a refresher to understand the syntax in this test spec,
see chapter 6 (and possibly also chapter 5 - stubbing) in the eBook
"Java Testing with Spock". See also the comments in demo21/REAMDE.md
and the demo21 groovy scripts.

*NOTE:* This test spec also uses an explicit "interaction" block:

	then: "credit card is checked"
	interaction {
		CreditCardResult sampleResult = CreditCardResult.OK
		sampleResult.setToken("sample");
		1 * creditCardSevice.authorize(1550, customer) >>  sampleResult
	}

This is needed to indicate to Spock that the variable declaration of 
"sampleResult" and the interaction check belong together. Without this
you will see the following error when the test is run:

groovy.lang.MissingPropertyException: No such property: sampleResult for class: com.manning.chapter6.ComplexMockingSpec
	at com.manning.chapter6.ComplexMockingSpec.happy path for credit card sale - alternative(ComplexMockingSpec.groovy:110

See also "Explicit Interaction Blocks" here in the Spock docs:
http://spockframework.org/spock/docs/1.1-rc-3/all_in_one.html#


To run test specs:
`mvn clean test`


JeremyC 17-07-2019
