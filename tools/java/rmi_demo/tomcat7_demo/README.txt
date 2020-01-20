Tomcat 7 webapp demo RMI client
===============================

The code from rmi client "Client.java" was moved into "hello.jsp" and
added to the Tomcat sample webapp "sample.war". The rmi interface 
Hello.class was also been added to "WEB-INF\classes\example\hello\".

These changes were made to the existing Tomcat webapp demo:
https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/

To install, simply drop "sample.war" into the "webapps" directory.

Then go to "http://localhost:8080/sample" to load index.html.
Then click the link "To a JSP page" to load "hello.jsp" and
this will invoke the rmi client code. 

If rmiregistry and the rmi server are running ("start_all.bat")
then the Tomcat page should display "response: Hello, world!"

If you have any issues, try relaxing all the Tomcat 7 permissions
by having only this in the "catalina.policy" file:

grant {
    permission java.security.AllPermission;
};

You will probably also need to point to the "catalina.policy" file,
and enable the Tomcat SecurityManager, by running tomcat7w.exe and 
adding this to the end of the list of runtime properties (these values
are stored in the Windows Registry and can be edited using tomcat7w.exe):

-Djava.security.policy=C:\Program Files (x86)\Apache Software Foundation\Tomcat 7.0\conf\catalina.policy
-Djava.security.manager

JeremyC 20-1-2020