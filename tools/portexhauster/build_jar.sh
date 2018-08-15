# Description:
#    Build an executable jar of the program.

# We need to ensure that the cwtools.jar program can run on Java 6.
JAVA_HOME="/cygdrive/c/jdk-8u45-windows-x64"
PATH=${JAVA_HOME}/bin:$PATH
export JAVA_HOME PATH

# Create manifest file. Note the carriage return.
cat >Manifest.txt <<EOI
Main-Class: PortExhauster
Class-Path: .

EOI

# Prepare to create jar 
mkdir -p classes
cp Manifest.txt		classes/

(mkdir -p tmp && cd tmp && jar xf ../lib/java-getopt-1.0.14.jar)
cp -r tmp/*			classes/

# Compile source files
find ./src -name "*.java" > sources_list.txt
javac -cp classes -d classes @sources_list.txt

# Create the jar
# NOTE: You cannot include a jar inside a jar, so we have to extract it.
(cd classes && jar cfm ../portexhauster.jar Manifest.txt gnu PortExhauster.class TCPServer.class TCPClient.class)

# Tidy
rm -f  Manifest.txt
rm -fr classes
rm -fr tmp
rm -f  sources_list.txt
