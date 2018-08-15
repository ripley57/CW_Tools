# Description:
#    Build an executable jar of the program.

# Update build details in property file.
cat >patchlister.properties <<EOI
patchlister.version=build: $(date)

EOI

# Create manifest file. Note the carriage return.
cat >Manifest.txt <<EOI
Main-Class: Main
Class-Path: .

EOI

# Prepare to create jar 
mkdir -p 			classes/main/
cp Manifest.txt			classes/main/
cp patchlister.properties	classes/main/
# NOTE: File must be named log4j.properties to be automatically identified.
cp log4j.properties		classes/main/
(mkdir -p tmp_log4j && cd tmp_log4j && jar xf ../lib/log4j.jar)
cp -r tmp_log4j/org 		classes/main/

# Create the jar
(cd classes/main/ && jar cfm ../../patchlister.jar Manifest.txt Main.class com org edp log4j.properties patchlister.properties)
