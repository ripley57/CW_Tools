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
mkdir -p classes
cp Manifest.txt				classes/
cp patchlister.properties	classes/
# NOTE: File must be named log4j.properties to be automatically identified.
cp log4j.properties			classes/
(mkdir -p tmp_log4j && cd tmp_log4j && jar xf ../lib/log4j.jar)
cp -r tmp_log4j/org 		classes/

# Compile the source files
find ./src -name "*.java" > sources_list.txt
javac -Xlint:unchecked -cp classes -d classes @sources_list.txt

# Create the jar
(cd classes && jar cfm ../patchlister.jar Manifest.txt Main.class com org edp log4j.properties patchlister.properties)
