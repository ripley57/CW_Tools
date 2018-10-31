set BASE_PATH=.
set LIB_PATH=%BASE_PATH%\lib
set CLASSPATH=.;%BASE_PATH%\classes;^
%LIB_PATH%\jetty-server-8.1.13.v20130916.jar;^
%LIB_PATH%\jetty-util-8.1.13.v20130916.jar;^
%LIB_PATH%\jetty-servlet-8.1.13.v20130916.jar;^
%LIB_PATH%\jetty-servlets-8.1.13.v20130916.jar;^
%LIB_PATH%\servlet-api-3.0.jar;^
%LIB_PATH%\jetty-http-8.1.13.v20130916.jar;^
%LIB_PATH%\jetty-io-8.1.13.v20130916.jar;^
%LIB_PATH%\jetty-security-8.1.13.v20130916.jar;^
%LIB_PATH%\jetty-continuation-8.1.13.v20130916.jar;^
%LIB_PATH%\jetty.xml;^
%LIB_PATH%\log4j-1.2.17.jar;^
%LIB_PATH%\commons-codec-1.10.jar

javac MyServer.java
javac HelloServlet.java
javac SpitServlet.java
javac DummyResponseServlet.java
