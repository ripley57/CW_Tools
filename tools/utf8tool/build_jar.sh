# Description:
#    Build an executable jar of the program.

# Create manifest file. Note the carriage return.
cat >Manifest.txt <<EOI
Main-Class: utf8tool

EOI

# Create the jar
javac utf8tool.java
jar cfm utf8tool.jar Manifest.txt *.class

# To run program from the jar:
java -jar utf8tool.jar -h
