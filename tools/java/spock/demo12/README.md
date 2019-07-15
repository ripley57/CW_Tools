# Spock: Demos of the different Spock "blocks" and annotations.

See also spock-blocks.png, and page 92 of "Java Testing with Spock".

Spock Examples:

BasketWeightSpec.groovy		-	Normal use of "given:", "when:" and "then:" blocks.
SetupBlockSpec.groovy		-	Simple demo to show that "setup:" is the same as "given:".
BasketWeightDetailedSpec.groovy	-	Use of "@Narrative", "@Title" and "@Subject" annotations,
					and also use of the "and:" block. NOTE: Although these are
					optional, you should include them always, for readbility.
LifecycleSpec.groovy		-	Use of special methods "def setup()", "def setupSpec()",
					"def cleanup" and "def cleanupSpec()".
CleanupBlockSpec.groovy		-	A simple example where you might use "def cleanup()".
SharedSpec.groovy		-	More real-life example, showing use of "@Shared" annotation,
					special methods "def setup()", "def setupSpec()", "def cleanup()",
					"def cleanupSpec()", and the "and:" block.


See below for details of each Spock syntax mentioned above ...


## Spock Blocks

"given:" block:
Although you can have Spock tests without a "given:" block, this is considered
a bad practice, because it makes the test less readable. An exception to this 
rule is a simple test that only really needs the "expect:" block.

"setup:" block:
The "setup:" block is an alias for the "given:" block. It functions exactly the same.

"when:" block:
This contains the test code that triggers some action(s) in your class under test or 
its collaborators. This code should ideally be as short as possible, to clearly indicate 
what’s being tested. The contents should be for testing just one particular feature.

"then" block:
This contains one or more test assertions. This is pure Groovy code.
All assertions should examine the same feature. If you have unrelated assertions that 
test different things then your Spock test should probably be broken up.

"and:" block:
The initialization block ("given:" or "setup:") can be very large sometimes. The "and:" 
block enables you to split-up a block. For example, you can use it to clearly indicate 
the class that is under test vs any collaborating classes:
	given: "an empty basket"
	Basket basket = new Basket()

	and: "several products"
	Product tv = new Product(name:"bravia",price:1200,weight:18)
	Product camera = new Product(name:"panasonic",price:350,weight:2)
	Product hifi = new Product(name:"jvc",price:600,weight:5)

You can also use "and:" with the "when:" block:
	when: "user wants to buy the TV.."
	basket.addProduct tv

	and: "..the camera.."
	basket.addProduct camera
The use of "and:" inside the "then:" block is somewhat controversial. This is because 
you can end up testing two different things (which really should be put in separate
tests). For example:
	then: "the basket weight is equal to all product weights"
	basket.currentWeight == (tv.weight + camera.weight + hifi.weight)

	and: "it contains 3 products"
	basket.productTypesCount == 3
There’s no hard rule on what’s correct and what’s wrong here. 
The simple advice is to avoid using "and:" blocks after "then:" blocks, unless you’re 
completely sure of the meaning of the Spock test. The "and:" block ise easy to abuse 
if you’re not careful."

"expect:" block:
The "expect:" block is a combination of "then:" and "when:" and can be used for
trivial tests or as an intermediate precondition in longer tests.
Like the "then:" block, it can contain assertions and will fail the Spock test if
any of them don’t pass. It is most often used for simple tests that don't need any 
initialization code. For example:
	def "An empty basket has no weight"() {
		expect: "zero weight when nothing is added"
		new Basket().currentWeight == 0
	}
Ideally, for clarity and readability, the "expect:" block should usually only ever be 
used to replace the "when:" and "then:" blocks. For example:
	def "An empty basket has no weight (alternative)"() {
		given: "an empty basket"
		Basket basket = new Basket()

		expect: "that the weight is 0"
		basket.currentWeight == 0
	}
But the "expect:" block can also be used to perform intermediate assertions.
(See also presentation: https://github.com/robfletcher/idiomatic-spock)
For example:
	def "A basket with two products weights as their sum (precondition)"() {
		given: "an empty basket, a TV and a camera"
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)
		Basket basket = new Basket()

		expect:"that nothing should be inside"
		basket.currentWeight == 0
		basket.productTypesCount == 0

		when: "user wants to buy the TV and the camera"
		basket.addProduct tv
		basket.addProduct camera

		then: "basket weight is equal to both camera and tv"
		basket.currentWeight == (tv.weight + camera.weight)
	}

"cleanup:" block:
This should be seen as the “finally” code segment of a Spock test.
The code will always run at the end of the Spock test, regardless of the result.
For example:
	cleanup: "refresh basket resources"
	basket.clearAllProducts()
This code always runs, even if the test stops at the "then:" block because of an
assertion failure.

"where:" block:
This is used exclusively for parameterized tests.


## Spock Annotations

"@Subject" annotation:
This indicates the class under test, to distinguish it from any collaborators.
For example:
	given: "an empty basket"
	@Subject
	Basket basket = new Basket()
At the time of writing, there’s no reporting tool that makes use of the 
"@Subject" annotation, but you should use it anyway to improve readability.

"@Title" annotation:
For technical reasons, Spock can’t allow you to name the class with full English text
like the Spock test methods. To remedy this limitation, Spock offers the "@Title"
annotation, which you can use to give a human-readable explanation of the test spec.
For example:
	@Title("Unit test for basket weight")
	class BasketWeightSpec extends spock.lang.Specification{

"@Narrative" annotations:
This can provide even more text that describes what the test does.
For example:
	@Narrative("""  A empty basket starts with no
			weight. Adding products to the basket
			increases its weight. The weight is
			then used for billing during shipping calculations.
			Electronic goods have always zero weight.
			""")
	@Title("Unit test for basket weight")
	@Subject(Basket)
	class BasketWeightDetailedSpec extends spock.lang.Specification{
Note that the "@Subject" annotation can be placed either at the class-level, or inside
each individual test method.

"@Shared" annotation:
You can indicate to Spock which objects you want to survive across all test methods by
using the "@Shared" annotation. You can use this to ensure that an object is only 
created once, usually inside method "def setupSpec()".
For example:
	class SharedSpec extends spock.lang.Specification{
		@Shared
		CreditCardProcessor creditCardProcessor;


## Spock special test methods

"def setup()":
In a spec class you'll often find yourself repeating some code in the "given:" block of 
each test method. The use of "def setup()" enables you to avoid this code duplication.
For example:
	def setup() {
		tv = new Product(name:"bravia",price:1200,weight:18)
		camera = new Product(name:"panasonic",price:350,weight:2)
	}
This "def setup()" method is automatically called before *** each *** test method.

"def cleanup()":
If defined, this method will be automatically executed after *** each *** test method.
For example:
	def cleanup() {
		basket.clearAllProducts()
	}
Like the "cleanup:" block, the "def cleanup()" method will always run, regardless of 
the result of the test.

"def setupSpec()" and "def cleanupSpec()":
These methods will only be run once in the test spec. This is useful for objects that
are expensive to construct, or long-living objects such as a database connection.
For example:
	class LifecycleSpec extends spock.lang.Specification {
		def setupSpec() {
			println "Will run only once"
		}
		def setup() {
			println "Will run before EACH feature"
		}
		def cleanup() {
			println "Will run once after EACH feature"
		}
		def cleanupSpec() {
			println "Will run once at the end"
		}


JeremyC 14-07-2019
