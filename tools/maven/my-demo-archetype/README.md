# My custom Maven archetype: "my-demo-archetype"

This is my own archetype, useful for creating small Java apps, packaged in an executable jar. 
See also ../CUSTOM_ARCHETYPE.md


## To install this archetype (i.e. into the local ~/.m2 repository):
mvn install


## To use the archive type to create the default "hello world" app:
mvn archetype:generate -DarchetypeGroupId=com.jeremyc -DarchetypeArtifactId=my-demo-archetype -DarchetypeVersion=1.0-SNAPSHOT

This command will ask you interactively for the Maven pom.xl attributes to go in your new proejcet, a project which is based on our custom archetype.

Note how we specify the archetype version ("1.0-SNAPSHOT"). This is required, according to 
https://maven.apache.org/guides/mini/guide-creating-archetypes.html:
"Don't forget to include the version of your archetype (if you don't include the version, you 
archetype creation may fail with a message that version:RELEASE was not found)".


JeremyC 27-07-2019 
