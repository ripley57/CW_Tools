# Description:
#    Build an executable jar of the program.

# Create manifest file. Note the carriage return.
cat >Manifest.txt <<EOI
Main-Class: StackDumper
Class-Path: log4j.jar

EOI

# Create the jar
javac -cp ./log4j.jar StackDumper.java
jar cfm stackdumper.jar Manifest.txt *.class stackdumper.properties
