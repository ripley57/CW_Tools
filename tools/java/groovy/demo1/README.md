# Groovy basics - automatic getters and setters

Remember: Groovy scripts are compile into regular Java byte-code.


## GettersSettersDemo.groovy
To compile and run:
`mvn clean compile exec:java -Dexec.mainClass="com.manning.spock.chapter2.GettersSettersDemo"`

Notice the following:
- Classes are public by default.
- Fields are private by default.
- Getters and setters are automatically created during runtime and thus 
  don’t need to be included in the class declarations.
- Semicolons are optional and should only be used in case of multiple 
  statements in the same line


## GettersSettersDemo2.groovy
To compile and run:
`mvn clean compile exec:java -Dexec.mainClass="com.manning.spock.chapter2.GettersSettersDemo2"`

Notice the following:
- Fields can be accessed without using the automatic getters or setters.
- The "System.out.println()" method is inherited by all Groovy objects,
  so you only need to use "println()".


## GettersSettersDemo3.groovy
To compile and run:
`mvn clean compile exec:java -Dexec.mainClass="com.manning.spock.chapter2.GettersSettersDemo3"`

Notice the following:
- The "main()" function is not needed; all code outside of the class is
  the "main()" method!
- The class name (Person2) does not have to match the name of the source file.
- You can use the syntax $varname when printing a Groovy string.
- Parenthese are optional when calling a method with at least one argument.


## PersonSpec.groovy
This is a Spock test, demonstrating all the Groovy features expained so far.
(The class being tested is actually defined in the test, so this is really 
just a demo.)

*NOTE*: This is a test, not part of the program, so it lives under the directory 
src/test/groovy. This means that "mvn compile" won't see this and create a file
PersonSpec.class. To compile and execute this test, we simply need to run "mvn test" 
and everything will be done for us automatically:
```
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.manning.spock.chapter2.PersonSpec
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 4.577 sec

Results :

Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
```


JeremyC 11-07-2019
