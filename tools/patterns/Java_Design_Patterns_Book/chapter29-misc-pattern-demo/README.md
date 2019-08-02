# page 201. Small, cut-down application demonstrating various design patterns, including:

* Layers
* Singleton
* Facade
* Factory
* Observer
* Strategy
* Decorator


NOTE: To build this as a Maven project, I used my own custom Maven archetype (see CW_Tools/tools/maven)
to generate a template Maven project, using this command:

mvn archetype:generate -DarchetypeGroupId=com.jeremyc -DarchetypeArtifactId=my-demo-archetype -DarchetypeVersion=1.0-SNAPSHOT


To build the jar:
mvn package


To run the application:
java -jar target/com.jeremyc.chapter29-1.0-SNAPSHOT-jar-with-dependencies.jar 


JeremyC 31-07-2019
