# Groovy

## Executing Groovy scripts from Maven
Apparently there is a way to execute an "external" (i.e. not in the pom.xml file) 
Groovy script from Maven, like this:

`mvn groovy:execute -Dsource=src/main/groovy/com/manning/spock/chapter2/GettersSettersDemo.groovy -Dscope=test`

But this did'nt work for me, possibly due to the versions in my pom.xml file. 
See:
https://stackoverflow.com/questions/32625527/execute-external-groovy-script-from-maven
https://stackoverflow.com/questions/3914690/execute-my-groovy-script-with-ant-or-maven

However, knowing that the Groovy compiler creates regular Java byte-code, means that we 
can alternatively run the demos as a Java program, like this:
`mvn clean compile exec:java -Dexec.mainClass="com.manning.spock.chapter2.GettersSettersDemo"`


## Introduction to Groovy from the eBook "Java Testing with Spock":
(See also my eBook "Making Java Groovy".)

It would be a mistake to think that learning Groovy is like learning a new program-
ming language from scratch. Groovy was designed as a companion to Java.

Groovy offers the productivity boost of a dynamic language (think Python or
Ruby) because it doesn’t have as many restrictions as Java. But at the same time, it runs
in the familiar JVM and can take advantage of all Java libraries.

Groovy syntax is a superset of Java syntax. Almost all Java code (with some minor
exceptions) is valid Groovy code as well. The Groovy Development Kit, or GDK
(www.groovy-lang.org/gdk.html), is an enhanced version of the JDK . And most impor-
tant of all, Groovy runs on the JVM exactly like Java does (because Groovy generates
Java byte code)!

## Biggest differences between Groovy and Java:
In Groovy, a class/object can change during runtime in ways that are impossible in
Java. For example, it’s possible to add new methods to a Groovy object (that weren’t
in its source code), delegate existing methods to other objects, or even create 
completely new classes during runtime out of thin air. If you thought that Java 
introspection was a fancy trick, Groovy has a complete repertoire of magic tricks 
that will leave your head spinning with all the possibilities.


JeremyC 11-07-2019
