# Description:
#    Build an executable jar of the program.

# Create manifest file. Note the carriage return.
cat >Manifest.txt <<EOI
Main-Class: Demo
Class-Path: .

EOI

# Prepare to create jar 
cp Manifest.txt			classes/main/
cp shortcuts.properties	classes/main/

# NOTE: File must be named log4j.properties to be automatically identified.
cp log4j.properties		classes/main/

# Any scripts to be included in the jar.
cp test.vbs				classes/main/
cp shortcuts.vbs		classes/main/

(mkdir -p tmp_log4j && cd tmp_log4j && jar xf ../lib/log4j.jar)
cp -r tmp_log4j/org 	classes/main/

# Create the jar
# NOTE: You cannot include a jar inside a jar, so I've included an extracted log4j.jar in my jar.
(cd classes/main && jar cfm ../../demo.jar Manifest.txt com org Demo.class Demo.class test.vbs log4j.properties shortcuts.properties)