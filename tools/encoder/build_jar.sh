# Description:
#    Build an executable jar of the program.

# Create manifest file. Note the carriage return.
cat >Manifest.txt <<EOI
Main-Class: Encoder

EOI

# Create the jar
jar cfm encoder.jar Manifest.txt *.class

# To run program from the jar:
java -jar encoder.jar -h
