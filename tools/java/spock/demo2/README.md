# Spock killer feature: Test failure detail

This demo shows the combined testing of two different classes using a single JUnit 
test and a single Spock test, and highlights how a test failure is reported differently.

MultiplierSpec	= The Spock test
MultiplierTest	= The (same) JUnit test

*NOTE*: This demo includes an intentional bug introduced in the Multiplier.java class.


## To run the JUnit and Spock demos
`mvn clean ; mvn verify`	(in the directory contain pom.xml)

Notice how the fail is reported by Spock vs JUNit. The Spock output is much more useful,
because it shows that the add result (2+3) worked (5), but the multiply result (25) failed.
This tells us immediately (without needing to debug the test) that the issue is with the 
"Multipler" class and not with the "Adder" class:

```
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.manning.chapter1.MultiplierSpec
Tests run: 2, Failures: 1, Errors: 0, Skipped: 0, Time elapsed: 2.995 sec <<< FAILURE!
Combine both multiplication and addition(com.manning.chapter1.MultiplierSpec)  Time elapsed: 0.495 sec  <<< FAILURE!
Condition not satisfied:

multi.multiply(4, adder.add(2, 3)) == 20
|     |           |     |          |
|     25          |     5          false
|                 com.manning.chapter1.Adder@4313f5bc
com.manning.chapter1.Multiplier@161479c6

	at com.manning.chapter1.MultiplierSpec.Combine both multiplication and addition(MultiplierSpec.groovy:20)
```

JeremyC 11-07-2019
