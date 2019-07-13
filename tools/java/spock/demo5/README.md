# Reading test data from an external file: txt, xml, or json.


Groovy comes with excellent facilities for extracting test data from external files,
and you should take advantage of these techniques in your Spock tests. Using the Java
approach will also work, but again in a much more verbose way.


Groovy allows you to read a file in the simplest way possible:
String testInput = new File ( "src/test/resources/quotes.txt").text


## GroovyFilesSpec.groovy
Spock test that demos how to read test data from a text file.
To run:
mvn clean verify


## XmlReading.groovy
Non-Spock Groovy script that demos how to read an XML file.
(NOTE: For more complex XML diffs, use a dedicated XML diff library such as XMLUnit.)
To run:
groovy XmlReading.groovy


## JsonReading.groovy
Non-Spock Groovy script that demos how to read a Json file.
To run:
groovy JsonReading.groovy


JeremyC 13-07-2019
