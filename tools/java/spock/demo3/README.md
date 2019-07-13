# Spock assert/truth demo - demonstrates the extra detail in Spock assert failure reports.

*NOTE:* For more basic Groovy (non-Spock) assert/truth examples, see CW_Tools/tools/java/groovy/demo3


## GroovyTruthSpec.groovy
Simple Spock demo to test a "WordDectector" Java class.
To run:
`mvn clean verify`


## PowerAssertSpec.groovy vs NormalAssert.java
Demonstrate the differences between the failure details reported by Spock compared to JUnit.
To run (both the Spock and JUnit tests):
`mvn clean verify`


Example #1: Simple number test failure
======================================
SPOCK FAILURE:
Demo for Spock assert numbers(com.manning.chapter2.PowerAssertSpec)  Time elapsed: 0.504 sec  <<< FAILURE!
Condition not satisfied:

(4 * 15) - (24 / 3) == ( 2 * 30 ) - 9
   |     |     |    |      |      |
   60    52    8    false  60     51

	at com.manning.chapter2.PowerAssertSpec.Demo for Spock assert numbers(PowerAssertSpec.groovy:15)

SAME JUNIT TEST FAILURE:
numbers(com.manning.chapter2.NormalAssertTest)  Time elapsed: 0.014 sec  <<< FAILURE!
java.lang.AssertionError: Expected same result expected:<52> but was:<51>
	at org.junit.Assert.fail(Assert.java:88)


Example #2: Simple string test failure
======================================
SPOCK FAILURE:
demo for Spock assert strings(com.manning.chapter2.PowerAssertSpec)  Time elapsed: 0.433 sec  <<< FAILURE!
Condition not satisfied:

quote =="Please scan Abut. Report to me his thoughts at present"
|     |
|     false
|     1 difference (98% similarity)
|     Please scan Ab(b)ut. Report to me his thoughts at present
|     Please scan Ab(-)ut. Report to me his thoughts at present
Please scan Abbut. Report to me his thoughts at present

	at com.manning.chapter2.PowerAssertSpec.demo for Spock assert strings(PowerAssertSpec.groovy:24

SAME JUNIT TEST FAILURE:
strings(com.manning.chapter2.NormalAssertTest)  Time elapsed: 0.026 sec  <<< FAILURE!
org.junit.ComparisonFailure: Expected same result expected:<Please scan Ab[b]ut. Report to me his...> but was:<Please scan Ab[]ut. Report to me his...>
	at org.junit.Assert.assertEquals(Assert.java:115)


Example #3: Lists test failure
==============================
SPOCK FAILURE:
demo for Spock assert lists(com.manning.chapter2.PowerAssertSpec)  Time elapsed: 0.461 sec  <<< FAILURE!
Condition not satisfied:

all.subList(0, all.indexOf("Humans")) == firstOnes
|   |          |   |                  |  |
|   |          |   3                  |  [Vorlon, Shadows]
|   |          |                      false
|   |          [Vorlon, Shadows, Minbari, Humans, Drazi]
|   [Vorlon, Shadows, Minbari]
[Vorlon, Shadows, Minbari, Humans, Drazi]

	at com.manning.chapter2.PowerAssertSpec.demo for Spock assert lists(PowerAssertSpec.groovy:34)

SAME JUNIT TEST FAILURE:
lists(com.manning.chapter2.NormalAssertTest)  Time elapsed: 0.021 sec  <<< FAILURE!
java.lang.AssertionError: Expected same result expected:<[Vorlon, Shadows, Minbari]> but was:<[Vorlon, Shadows]>
	at org.junit.Assert.fail(Assert.java:88)


Example #4: Method test failure
===============================
SPOCK FAILURE:
demo for Spock assert calls(com.manning.chapter2.PowerAssertSpec)  Time elapsed: 0.427 sec  <<< FAILURE!
Condition not satisfied:

wordDetector.feedText(text).duplicatesFound().size() == 5
|            |        |     |                 |      |
|            |        |     [are, They]       2      false
|            |        They are alone. They are a dying race.
|            com.manning.chapter2.WordDetector@397fbdb
com.manning.chapter2.WordDetector@397fbdb

	at com.manning.chapter2.PowerAssertSpec.demo for Spock assert calls(PowerAssertSpec.groovy:44)

SAME JUNIT TEST FAILURE:
methods(com.manning.chapter2.NormalAssertTest)  Time elapsed: 0.015 sec  <<< FAILURE!
java.lang.AssertionError: Expected same result expected:<2> but was:<5>
	at org.junit.Assert.fail(Assert.java:88)


JeremyC 13-07-2019
