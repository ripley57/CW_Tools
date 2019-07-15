# Spock: Using Hamcrest matchers

Hamcrest matchers are a third-party library commonly used in JUnit assert statements.
They offer a pseudo-language that allows for expressiveness in what’s being evaluated.
Spock includes its own additional syntax for using Hamcrest matchers.
http://hamcrest.org/


To run these tests:
`mvn test`


## Spock supports Hamcrest matchers natively
For example:
	def "trivial test with Hamcrest"() {
		given: "a list of products"
		List<String> products= ["camera", "laptop","hifi"]

		expect: "camera should be one of them"
		products hasItem("camera")

		and: "hotdog is not one of them"
		products not(hasItem("hotdog"))
	}

Notice how we check a list for an item. This would require a loop in Java!
Notice also how "not" is being chained with "hasItem".


## Spock alternative syntax for using Hamcrest matchers
This is the same as the previous test, but reads a little better, because the matcher
lines are coupled with the Spock blocks:

	def "trivial test with Hamcrest (alt)"() {
		given: "an empty list"
		List<String> products= new ArrayList<String>()

		when: "it is filled with products"
		products.add("laptop")
		products.add("camera")
		products.add("hifi")

		then: "camera should be one of them"
		expect(products, hasItem("camera"))

		and: "hotdog is not one of them"
		that(products, not(hasItem("hotdog")))
	}

"expect()" is useful for then: blocks. 
"that()" is useful for "and:" and "expect:" Spock blocks.


## Replacing Hamcrest matchers with Groovy closures.
Hamcrest matchers can often be replaced by Groovy closures. For example:

	def "trivial test with Groovy closure"() {
		given: "a list of products"
		List<String> products= ["camera", "laptop", "hifi"]

		expect: "camera should be one of them"
		products.any{ productName -> productName == "camera"}

		and: "hotdog is not one of them"
		products.every{ productName -> productName != "hotdog"}
	}

As a general rule, if a Hamcrest matcher already covers what you want, use it
(e.g. "hasItem()"). If using Hamcrest matchers makes your example complex to read, 
then use closures.


JeremyC 15-07-2019
