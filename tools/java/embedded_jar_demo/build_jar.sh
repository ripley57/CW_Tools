# Description:
#    Build a jar.
 
# Create manifest file. Note the carriage return.
cat >Manifest.txt <<EOI
Main-Class: Test
Class-Path: .

EOI

mkdir -p classes
cp Manifest.txt	classes/

# Compile the source file(s).
find ./src -name "*.java" > sources_list.txt
javac -cp classes -d classes @sources_list.txt

# Create the jar
(cd classes && jar cfm ../demo.jar Manifest.txt Test.class)

# Tidy
rm -f  Manifest.txt
rm -fr classes
rm -f  sources_list.txt
