# Custom data generators / iterators for Spock parametized tests.

The demos in demo18 all used lists. But Spock can also iterate on things such as
Strings, Maps, Enums, Arrays, RegEx matchers and Iterators (i.e. anything that
Groovy can iterate on).

*NOTE:* Iterators are interfaces, meaning that you can implement your own classes.
        However, like the use of exprssions in data tables, the use of iterators
        makes your tests less readable.


## FileReadingSpec.groovy
This demo reads the input data values from a text file, rather than using a
custom generator. 


## DataIteratorsSpec.groovy
In this example, the txt file containing our test data values needs to be
pre-processed before we use it. This time we'll need to create our own
customer generator. We will create a custom data iterator.
*NOTE:* Our data iterator (InvalidNamesGen.java) goes under "src/test/java/",
        because it's part of the test code and not the Java classes under test.
*NOTE:* Ideally, we would write our data iterator/generator (InvalidNamesGen)
        in pure Groovy, so we can embed it directly inside the Spock spec file.
        But we currently don't know Groovy well enough :-(


## MultipleVarGenSpec.groovy
This time we create a new iterator (MultiVarReader.java), so we can read an
input txt file that contains two values per line, e.g.:
	bunny04.gif fail
	modern0034.JPEG pass
The second value indicates if the filename should cause a test fail or a pass.


To run the tests:
`mvn test`
 

JeremyC 15-07-2019
