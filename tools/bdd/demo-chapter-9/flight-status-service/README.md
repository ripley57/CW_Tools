# BDD in Action Chapter 9
## Sample web service testing application

JeremyC 29-07-2019: 
This is a nice BDD example using Cucumber-JVM (instead of JBehave + Thucydides).
This demo also shows how to create a web service API.


"A simple application that demonstrates testing a web service API using BDD."

"The application uses Jersey to provide a simple REST web service that reports on flight itineraries and statuses.
It runs using an embedded Tomcat server."


JeremyC 29-07-2019: This chapter in the book is about using BDD acceptance tests to
verify non-UI parts of the application, i.e. the service layer and business logic.


To manually launch our web service in Tomcat:
-----
mvn clean package tomcat:run
-----
(NOTE: The pom.xml DOES mention Jetty, which seems to be used when the tests run).
(NOTE: Similarly, you can instead run Jetty manually instead, using "mvn jetty:run")

JeremyC 29-07-2019:
This line above, to launch the website manually, is really quite amazing. There is no mention of 
Tomcat in the pom.xml file; all we have is a deployment descriptor (web.xml) under src/main/webapp. 
Simply running "mvn tomcat:run" is enough to fire up a Tomcat instance, using our war file! 

If I run the following command (to capture debug output) we DO see references to Tomcat being used:
	mvn -X tomcat:run 2>&1 | tee /tmp/mvn.log
	...
	[DEBUG] Resolved plugin prefix tomcat to org.codehaus.mojo:tomcat-maven-plugin from repository central
	...
	[DEBUG] Goal:          org.codehaus.mojo:tomcat-maven-plugin:1.1:run (default-cli)
	...
	INFO: Starting tomcat server
	...
	INFO: Initializing Coyote HTTP/1.1 on http-8080
	Jul 29, 2019 11:40:36 AM org.apache.coyote.http11.Http11Protocol start
	INFO: Starting Coyote HTTP/1.1 on http-8080


You can check that the web services are available by using the following URL:
-----
http://localhost:8080/flightstatus-service/rest/flights/status
-----

JeremyC 29-07-2019: To see the src/main/webapp/index.html contents:
http://localhost:8080/flightstatus-service/
And go here if you've manually restarted Jetty, instead of Tomcat:
http://localhost:8080/


To run the BDD acceptance tests using Cucumber-JVM:
-----
mvn verify
-----
QUESTION: Where's our "output report" from Cucumber-JVM?
ANSWER: ./target/cucumber-html-report/index.html


## Testing our API using curl (see also https://www.codepedia.org/ama/how-to-test-a-rest-api-from-command-line-with-curl/):

"flights/status"
================
curl http://localhost:8080/rest/flights/status
{'status':'OK'}j
...is the same as:
curl -X GET 'http://localhost:8080/rest/flights/status'
To advertise the content-types you understand:
curl -H "Accept: application/json" -X GET 'http://localhost:8080/rest/flights/status'
To ask for response headers:
curl -i -X GET 'http://localhost:8080/rest/flights/status'
To display request and response headers:
curl -v -X GET 'http://localhost:8080/rest/flights/status'

"/flights/{filenumber}"
=======================
curl http://localhost:8080/rest/flights/FH-102
{"flightNumber":"FH-102","departure":"SYD","destination":"MEL","time":"06:15"}

"/flights/from/{departure}"
===========================
curl http://localhost:8080/rest/flights/from/wibble?flightType=Domestic
[{"flightNumber":"FH-101","departure":"MEL","destination":"SYD","time":"06:00"},{"flightNumber":"FH-102","departure":"SYD","destination":"MEL","time":"06:15"}]jcdc@E1317T:~/BDD2/chapter-9-master/flight-status-service$ 


JeremyC 29-07-2019
