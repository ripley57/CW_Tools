# Run using default parameters.
#java -jar cwtools.jar

# Override the location of the CWTools download zip.
#java -Durl.cwtools=http://fred/cwtools.zip -jar cwtools.jar

# Override the location of the Cygwin_Light download zip.
#java -Durl.cygwin=http://fred/cygwin.zip -jar cwtools.jar

# Override the default Log4j level.
#java -Dlog4j.logger.CWTools=INFO -jar cwtools.jar

# Run with debug output enabled.
java -Dlog4j.logger.CWTools=DEBUG -jar cwtools.jar -cygwin
