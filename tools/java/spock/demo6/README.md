# Groovy: Advanced syntax

## Groovy Closures
The following techniques are in no way essential to Spock tests. They have their uses at times.

Closures are the Swiss army knife of Groovy. They’re used almost everywhere, and it’s hard to
deal with Groovy code without stumbling upon them. Prior to Java 8 (lambdas), they were one of 
the main advantages of Groovy over Java, and even after Java 8, they still offer great value 
and simplicity.

Closures are so powerful in Groovy that you can use them directly to implement interfaces or 
as exit points in switch statements.


## Closures demo script 1: GroovyClosure.groovy
Closures are in many ways similar to methods. Unlike Java methods, they can be passed
around as arguments to other methods.
To run:
groovy GroovyClosure.groovy


## Closures demo script 2: GroovyClosureSpec.groovy
The Groovy GDK augments the existing JDK with several new methods that accept closures for 
arguments. For example, a handy Groovy method for unit testing is the every() method available 
in collections. For example, assume that you have a Java class that gets a list of image names 
from a text file and returns only those that end in a specific file extension:
To run the Spock test:
mvn clean verify


## Test input generation: GraphBuilderDemo.groovy
In sufficiently large enterprise projects, test input generation might need a separate code
module of its own, outside the production code.

Groovy to the rescue! Groovy comes with a set of builders that allow you to create test data 
by using a fancy DSL (Domain Specific Language).

By default, the ObjectGraphBuilder will treat as plural (for collections) the class name
plus "s" (ship becomes ships). It also supports special cases with words that end in "y"
(daisy becomes daisies, army becomes armies, and so forth).

To run:
mvn compile	(to compile the object model classes)
groovy -cp target/classes GraphBuilderDemo.groovy


JeremyC 13-07-2019
