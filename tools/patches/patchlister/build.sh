# Main java classes
classpath=lib/log4j.jar
find     src/main/ -type f -name "*.java" > sources_main_list.txt
mkdir -p classes/main/
rm -fr   classes/main/*
echo Compiling main Java classes...
javac -Xlint:unchecked -d classes/main/ @sources_main_list.txt -cp $classpath

# Test java classes
classpath=lib/junit-4.6.jar:classes/main/
find     src/test/ -type f -name "*.java" > sources_test_list.txt
mkdir -p classes/test/
rm -fr   classes/test/*
echo Compiling test Java classes...
javac -Xlint:unchecked -d classes/test/ @sources_test_list.txt -cp $classpath

# Build jar file
echo Building jar file...
sh ./build_jar.sh

# Run the JUnit tests.
classpath=lib/junit-4.6.jar:patchlister.jar:classes/test/
echo Running JUnit tests...
java -cp $classpath org.junit.runner.JUnitCore edp.support.patchlister.TestMD5Entry

# Tidy
rm -f sources_main_list.txt
rm -f sources_test_list.txt
rm -f Manifest.txt
rm -f patchlister.properties
rm -fr tmp_log4j
