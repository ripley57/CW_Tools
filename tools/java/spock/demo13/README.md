# Spock: Improving the readability of failed tests.

The readaility of failed tests is important.

We've seen previously in a simple Spock test failure how Spock/Groovy can give us
handy information about the failure. For example:

multi.multiply(4, adder.add(2, 3)) == 20
|     |           |     |          |
|     25          |     5          false
|                 com.manning.chapter1.Adder@4313f5bc
com.manning.chapter1.Multiplier@161479c6

However, sometimes, depending on our class under test, we have to give Spock some
help, by overriding the "toString()" method to expose the internal implementation.


## ProblematicBasket.java
This version of the "Basket.java" class has an intentional bug introduced.
However many of a particular item you add to the basket, the class will only
ever add one. This causes the test "FailureRenderingSpec.groovy" to fail as follows:

`mvn test`
...
Adding products to a basket increases its weight(com.manning.chapter4.structure.FailureRenderingSpec)  Time elapsed: 0.705 sec  <<< FAILURE!
Condition not satisfied:

basket.currentWeight == (2 * camera.weight) + laptop.weight
|      |             |     | |      |       | |      |
|      7             false 4 |      2       9 |      5
|                            |                com.manning.chapter4.Product@bc423277
|                            com.manning.chapter4.Product@a13ec967
com.manning.chapter4.structure.ProblematicBasket@2dde1bff

Note how the value printed for "basket" is not very helpful, i.e. "com.manning.chapter4.structure.ProblematicBasket@2dde1bff"

Now, uncomment to overridden "toString()" implementation in "ProblematicBasket.java" and re-run the test.
This is what you see now:

Adding products to a basket increases its weight(com.manning.chapter4.structure.FailureRenderingSpec)  Time elapsed: 0.593 sec  <<< FAILURE!
Condition not satisfied:

basket.currentWeight == (2 * camera.weight) + laptop.weight
|      |             |     | |      |       | |      |
|      7             false 4 |      2       9 |      5
|                            |                com.manning.chapter4.Product@bc423277
|                            com.manning.chapter4.Product@a13ec967
[ 1 x toshiba, 1 x panasonic ]

=> Note, we can clearly see that there are NOT x2 cameras in the basket!! 
   This information clearly means you don't need to waste time debugging the unit test. Instead,
   go look for the bug in the "ProblematicBasket" class.
   We can instantly see here that the problem is not with the test implementation.

*NOTE:* After you finish writing a Spock test, check whether you need to implement any 
        custom toString() methods for the classes that are used in the final assertions.


JeremyC 15-07-2019
