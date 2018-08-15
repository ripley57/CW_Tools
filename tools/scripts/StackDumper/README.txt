StackDumper
===========

Build instructions: (ote: This should be put into a single build.xml file really):

1. Compile Java files and create stackdumper.jar:

sh build_jar.sh

Use run_jar.sh to test this jar.


2. Create a single jar that includes the log4j.ar:

ant -f build.xml

Use run_sd_jar.sh to test this jar.


3. Generate Windows exe

Install http://launch4j.sourceforge.net and specify following settings:

o Output file: stackdumper.exe
o Input file: sd.jar
o Minimum Java version: 1.6.0

See launch4j_sd.xml configuration file.

NOTE: I cannot get this executable to run on a CW box because the
stackdump.exe is trying to use a 64-bit java. You see an error that
it cannot find a suitable Java version. So, for now, stick to using
sd.jar like this:

java -jar sd.jar -h C:\CW\V711


JeremyC 2/9/2013.
