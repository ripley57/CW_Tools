# Spock's use of handy Groovy syntax: map-based constructors, maps, lists, and strings.

Remember: Groovy can use regular Java syntax, but it's the use of Groovy syntax that can
          make your tests shorter and more expressive.

"Lists and maps are one of the many areas where Groovy augments the existing Java collecion classes.
 Groovy comes with its own GDK that sits on top of the existing JDK . You should spend some time 
 exploring the GDK according to your own unit tests and discovering more ways to reduce your 
 existing Java code."


## Groovy map-based constructors vs JUnit.
Spock tests: ObjectCreationSpec.groovy
JUnit tests: ObjectCreationTest.java.
Unit tests often create objects and initialise them. This can be done with little Groovy code.
To run:
`mvn clean verify`


## Groovy maps and lists.
GroovyCollections.groovy.
To run, we don't need to use Spock, but we do need to first compile some classes we will be using:
`mvn clean compile`
Now we can run our Groovy script using the "groovy" command-line tool:
`groovy -cp target/classes GroovyCollections.groovy`


## Groovy strings. 
GroovyStrings.groovy
To run, we don't need to use Spock, and there are no external classes referenced, so we can simply use this:
`groovy GroovyStrings.groovy`


JeremyC 13-07-2019
