# RMI "Hello World" example.
##
# From https://docs.oracle.com/javase/7/docs/technotes/guides/rmi/hello/hello-world.html
#      "If the server needs to support clients running on pre-5.0 VMs, then a stub class 
#       for the remote object implementation class needs to be pregenerated using the rmic 
#       compiler, and that stub class needs to be made available for clients to download." 
#
# Useful References:
#	-Djava.rmi.server.codebase
#       See: https://docs.oracle.com/javase/7/docs/technotes/guides/rmi/codebase.html)
#
#	-Djava.rmi.server.useCodebaseOnly
# 	See: https://docs.oracle.com/javase/7/docs/technotes/guides/rmi/enhancements-7.html
#
# NOTE: When using Tomcat, which has a built-in SecurityManager similar to Java's you may
#	need to adjust the Tomcat security policy file in order to have access to the 
#	remove download location
#	From https://docs.oracle.com/javase/7/docs/technotes/guides/rmi/enhancements-7.html:
#	"This involves granting permissions such as FilePermission (ME: for shared/local
#	directory) and SocketPermission (ME: for a a web server http:// URL).
#
# JeremyC 19-1-2020


# To build:
javac -d classes Hello.java Server.java Client.java


# 1. Start the RMI registry on the server's host.
# (By default, the registry runs on TCP port 1099.)
#
# NOTE: There are two different ways to start "rmiregistry" and the server program.
#
#	Since JDK 7, when starting "rmiregistry", by default, -Djava.rmi.server.useCodebaseOnly=true. 
#	This change was to increase default security.
#	With this set to "true", your server program can no longer indicate to the client where it should 
#       download the remote stub object from. When set to "false", like this...
#
#	rmiregistry -J-Djava.rmi.server.useCodebaseOnly=false 1099

#	...the server can advertise to the client the stub download URL, by the server being started like this:
#
#	java -classpath classes -Djava.rmi.server.codebase=file:///home/jcdc/Downloads/classes/ example.hello.Server
#	(You would use a web server URL i.e. "http://..." if the client and server are on different machines).
#
#
#	However, the preferred (i.e. more secure) approach, is to start "rmiregistry" like this, so that only
#	rmiregistry has control over where the client downloads any files from:
#
#	rmiregistry -J-Djava.rmi.server.codebase=file:///home/jcdc/Downloads/classes/ 1099
#	(Remember that "-Djava.rmi.server.useCodebaseOnly=true" is the default now since JDK 7)
#
#	When rmiregistry is started like this, starting the server with "Djava.rmi.server.codebase=file:///..."
#	has no affect. The server can therefore be started with a simpler command:
#
#	java -classpath classes example.hello.Server
#
# Linux: 
# We'll use the less secure method of using rmiregistry:
rmiregistry -J-Djava.rmi.server.useCodebaseOnly=false 1099 &
#
# Windows
#start rmiregistry 


# 2. Start the Server.
#
# Linux:
# We'll use the less secure method of letting the server tell the client
# were to download the remote stub object classes from:
java -classpath classes -Djava.rmi.server.codebase=file:///home/jcdc/Download/classes/ example.hello.Server &
#
# Windows:
#start java -classpath classes -Djava.rmi.server.codebase=file:classes/ example.hello.Server


# 3. Run the client.
#
java  -classpath classes example.hello.Client

#
# TODO:
#	o Change the download url to "http://..." and verify this works across a network.
#	o Determine the minimum classes required on the client and server sides.
#

# END
