# Description:
#    Build an executable jar of the program.

# We need to ensure that the cwtools.jar program can run on Java 6.
JAVA_HOME="/cygdrive/c/Program Files (x86)/Java/jdk1.6.0_45"
PATH=${JAVA_HOME}/bin:$PATH
export JAVA_HOME PATH

# Create manifest file. Note the carriage return.
cat >Manifest.txt <<EOI
Main-Class: CWTools
Class-Path: .

EOI

# Prepare to create jar 
mkdir -p classes
cp Manifest.txt		classes/
cp cwtools.properties	classes/
cp shortcuts.properties	classes/

# NOTE: File must be named log4j.properties to be automatically identified.
cp log4j.properties		classes/

# Any scripts to be included in the jar.
cp test.vbs		classes/
cp shortcuts.vbs	classes/

(mkdir -p tmp_log4j && cd tmp_log4j && jar xf ../lib/log4j.jar)
cp -r tmp_log4j/org 	classes/

# Compile the source files
find ./src -name "*.java" > sources_list.txt
javac -cp classes -d classes @sources_list.txt

# Create the jar
# NOTE: You cannot include a jar inside a jar, so I've included an extracted log4j.jar in my jar.
(cd classes && jar cfm ../cwtools.jar Manifest.txt com org CWTools.class CWTools\$Cygwin.class CWTools\$CW_Tools.class test.vbs shortcuts.vbs log4j.properties shortcuts.properties cwtools.properties)

# Make the jar self-executing using a script named cwtools.bat
# See http://stackoverflow.com/questions/24048157/how-to-create-a-self-executing-jar-file
cat >stub.bat <<EOI
java -jar %* %~n0%~x0 
exit /b
EOI
unix2dos stub.bat
cat stub.bat cwtools.jar > cwtools.bat
rm -f stub.bat

# Tidy
rm -f  Manifest.txt
rm -fr classes
rm -fr tmp_log4j
rm -f  sources_list.txt

