# Creating a custom Maven archetype

(Using steps from: https://maven.apache.org/guides/mini/guide-creating-archetypes.html)

The built-in archetype "maven-archetype-quickstart" builds a simple "hello world"
application, but the jar is not executable! The steps below describe how to create,
and then install, our own custom Maven archetype, which we can use to create a
"hello world" application that is an executable jar :-)

1. We'll start at step "Alternative way to start creating your Archetype":

mkdir /tmp/tmp1 && cd $_
mvn archetype:generate -DgroupId="com.jeremyc" -DartifactId="my-demo-archetype" -DarchetypeGroupId=org.apache.maven.archetypes -DarchetypeArtifactId=maven-archetype-archetype

This will create the following files:
jcdc@E1317T:/tmp/tmp4$ find . -type f
./my-demo-archetype/src/main/resources/META-INF/maven/archetype-metadata.xml
./my-demo-archetype/src/main/resources/archetype-resources/src/main/java/App.java
./my-demo-archetype/src/main/resources/archetype-resources/src/test/java/AppTest.java
./my-demo-archetype/src/main/resources/archetype-resources/pom.xml
./my-demo-archetype/src/test/resources/projects/it-basic/goal.txt
./my-demo-archetype/src/test/resources/projects/it-basic/archetype.properties


2. Here we can now customise the contents of the "archetype-resources" directory above.
=> We will update the pom.xml file to make the jar executable, by adding plugin "maven-assembly-plugin",
and also by configuring the "<mainClass>" value using a variable based on the package name (which the
use provides when using our archetype to create their project.

NOTE: We remove the "<pluginManagement>" tags, because this denotes plugin settings that are to
      be inherited from this pom.xml. This *is* our pom.xml, so we remove this tag; otherwise
      are changes won't take effect, and we'll build the same non-execuctable jar as before.


3. Now we edit the "archetype-metadata.xml" file.
=> We don't need to edit anything here.


4. We install our new archetype:
cd my-demo-archetype
mvn install

NOTE: To check that our new (local) archetype is installed:
mvn archetype:generate
(See http://tutorials.jenkov.com/maven/maven-archetypes.html)

And we should also now see the archetype files installed in our "~/.m2" directory:
/home/jcdc/.m2/repository/com/jeremyc/my-demo-archetype/1.0-SNAPSHOT/my-demo-archetype-1.0-SNAPSHOT.jar
/home/jcdc/.m2/repository/com/jeremyc/my-demo-archetype/1.0-SNAPSHOT/my-demo-archetype-1.0-SNAPSHOT.pom


5. We can now use our new archetype (to create a Maven project for an executable "hello world" jar):
mvn archetype:generate -DarchetypeGroupId=com.jeremyc -DarchetypeArtifactId=my-demo-archetype -DarchetypeVersion=1.0-SNAPSHOT

Building the app as before:
mvn package

And we now get an extra (executable) jar:
jcdc@E1317T:/tmp/tmp6/test2$ java -jar ./target/test2-1.0-SNAPSHOT-jar-with-dependencies.jar
Hello World!

=> So, it does work!


JeremyC 27-07-2019
