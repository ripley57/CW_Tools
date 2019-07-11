# Java testing with Spock vs JUnit for a test fail

*NOTE*: This demo includes an intentional bug introduced in the Multiplier.java class.

This demo shows the combined testing of two different classes using a single JUnit 
test and a single Spock test, and highlights how a test failure is reported differently.
*NOTE*: The extra information in the Spock failure output is one of Spock's killer features!

Remember:
MultiplierSpec	= The Spock test
MultiplierTest	= The (same) JUnit test

## Running `mvn clean ; mvn verify` (in the directory contain pom.xml)
Notice blowhow the fail is reported by Spock vs JUNit. The Spock output is much more useful,
because it shows that the add result (2+3) worked (5), but the multiply result (25) failed.
This tells us that the issue is with the Multipler class and not the Adder class.
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

Running com.manning.chapter1.MultiplierTest
Tests run: 2, Failures: 1, Errors: 0, Skipped: 0, Time elapsed: 0.138 sec <<< FAILURE!
combinedOperationsTest(com.manning.chapter1.MultiplierTest)  Time elapsed: 0.002 sec  <<< FAILURE!
java.lang.AssertionError: 4 times (2 plus 3) is 20 expected:<20> but was:<25>
	at org.junit.Assert.fail(Assert.java:88)
	at org.junit.Assert.failNotEquals(Assert.java:834)
	at org.junit.Assert.assertEquals(Assert.java:645)
	at com.manning.chapter1.MultiplierTest.combinedOperationsTest(MultiplierTest.java:20)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.junit.runners.model.FrameworkMethod$1.runReflectiveCall(FrameworkMethod.java:50)
	at org.junit.internal.runners.model.ReflectiveCallable.run(ReflectiveCallable.java:12)
	at org.junit.runners.model.FrameworkMethod.invokeExplosively(FrameworkMethod.java:47)
	at org.junit.internal.runners.statements.InvokeMethod.evaluate(InvokeMethod.java:17)
	at org.junit.runners.ParentRunner.runLeaf(ParentRunner.java:325)
	at org.junit.runners.BlockJUnit4ClassRunner.runChild(BlockJUnit4ClassRunner.java:78)
	at org.junit.runners.BlockJUnit4ClassRunner.runChild(BlockJUnit4ClassRunner.java:57)
	at org.junit.runners.ParentRunner$3.run(ParentRunner.java:290)
	at org.junit.runners.ParentRunner$1.schedule(ParentRunner.java:71)
	at org.junit.runners.ParentRunner.runChildren(ParentRunner.java:288)
	at org.junit.runners.ParentRunner.access$000(ParentRunner.java:58)
	at org.junit.runners.ParentRunner$2.evaluate(ParentRunner.java:268)
	at org.junit.runners.ParentRunner.run(ParentRunner.java:363)
	at org.apache.maven.surefire.junit4.JUnit4TestSet.execute(JUnit4TestSet.java:59)
	at org.apache.maven.surefire.suite.AbstractDirectoryTestSuite.executeTestSet(AbstractDirectoryTestSuite.java:120)
	at org.apache.maven.surefire.suite.AbstractDirectoryTestSuite.execute(AbstractDirectoryTestSuite.java:103)
	at org.apache.maven.surefire.Surefire.run(Surefire.java:169)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.apache.maven.surefire.booter.SurefireBooter.runSuitesInProcess(SurefireBooter.java:350)
	at org.apache.maven.surefire.booter.SurefireBooter.main(SurefireBooter.java:1021)

Results :

Failed tests: 
  Combine both multiplication and addition(com.manning.chapter1.MultiplierSpec)
  combinedOperationsTest(com.manning.chapter1.MultiplierTest)

Tests run: 4, Failures: 2, Errors: 0, Skipped: 0
```

JeremyC 11-07-2019
