# Maven

## Maven - life cycles, phases, and goals
https://www.baeldung.com/maven-goals-phases


## Maven Archetypes - for creating a Maven starting project:
From https://maven.apache.org/guides/introduction/introduction-to-archetypes.html:
"we use archetypes to try and get our users up and running as quickly as possible by 
providing a sample project that demonstrates many of the features of Maven, while 
introducing new users to the best practices employed by Maven. In a matter of seconds, 
a new user can have a working Maven project to use as a jumping board for investigating 
more of the features in Maven."

For example, to create a simple Java application with main() (plus a JUnit class):
`mvn archetype:generate -DarchetypeArtifactId=maven-archetype-quickstart`

This will ask you for values for your project including:
groupId		(The groupId are the people creating the application, i.e. you, e.g. "com.jeremyc").
artifactId	(The artifactId identifies your new project, e.g. "testproject").
version		(The version number of your project. You can accept the default here, "1.0-SNAPSHOT").
package		(The Java package name of your project. You can accept the default here, "com.jeremyc"). 

NOTE: See https://www.youtube.com/watch?v=KNGQ9JBQWhQ for more details on these basic pom.xml attributes.

This example archetype command will create a "src" directory and a "pom.xml" file. The "src" directory 
will contain a template Java "hello world" project with a static main(), plus a JUnit class too.

Now we have a pom.xml, we can compile and package it using the regular "package" Maven phase:
`mvn package`

NOTE: This will build you app in "target/testproject-1.0-SNAPSHOT.jar", but it won't be an executable
jar. To build one of those, use "maven-assembly-plugin". See https://www.baeldung.com/executable-jar-with-maven
(Apparently, you can create your own custom archetypes, but I haven't looked into this yet).


## Maven Surefire plugin vs Maven Failsafe plugin:
From https://maven.apache.org/surefire/maven-failsafe-plugin/:
"The Failsafe Plugin is designed to run integration tests while the Surefire Plugin is designed to run unit tests."

## JFrog - https://www.jfrog.com/confluence/display/RTF/Maven+Repository
From https://devops.stackexchange.com/questions/1898/what-is-an-artifactory:
"Artifactory is a product by JFrog that serves as a binary repository manager.  

The binary repository is a natural extension to the source code repository, in 
that it will store the outcome of your build process, often denoted as artifacts. 
Most of the times one would not use the binary repository directly but through a 
package manager that comes with the chosen technology.

Note that you do not need a very large team to start reaping benefits from binary 
package management. The initial investment is not very large and the benefits are 
felt immediately. 

My personal opinion is that binary repositories are as vital a part of a well 
designed devops setup as the source code repository or continuous integration."


JeremyC 19-07-2019
