@echo off

REM To build the Manifold-CF api_example program: 
REM go.bat
REM
REM To run the built program:
REM java -classpath lib\commons-codec.jar;lib\commons-logging.jar;lib\httpclient.jar;lib\httpcore.jar;lib\json.jar;lib\mcf-core.jar;build\jar\api-example.jar org.apache.manifoldcf.examples.RepositoryConnectionDumper "RSS"

set JAVA_HOME=C:\jdk-8u74-x64
set ANT_HOME=C:\apache-ant-1.10.1
set PATH=%ANT_HOME%\bin;%JAVA_HOME%\bin;%PATH%
set CLASSPATH=

REM Verbose Ant
REM ant -v %*

ant %*
