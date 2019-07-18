# Spock enterprise testing (continued): Functional testing of REST API using Spock and Tomcat.

To run tests:
`cd rest-service-example`
`mvn clean verify`

*NOTE*: Notice how Spring MVC makes is so easy to create a web service:
        using only two source files, Warehouse.java and Product.java!!!


## Tomcat is launched by Maven for running the tests:
*NOTE*: The tests will launch a Tomcat server listing on port 8080 (see pom.xml).
Apart from the two Java source files, there are three XML files, to configure
the web application deployment descriptor (web.xml), the Spring MVC XML file,
and the Sprint application context XML file:
	./src/main/webapp/WEB-INF/rest-example-servlet.xml
	./src/main/webapp/WEB-INF/web.xml	(see Maven pom.xml)
	./src/main/webapp/WEB-INF/applicationContext.xml


This demo is a continutation from demo23, where we discussed the different test types,
i.e. unit, integration, functional. While demo23 created examples of Spock integration 
tests, for a Spring-based application, demo24 looks at Spock functional tests, for a 
REST-based service.

Remember: Functional tests view the whole system as a black box. This is different to
Integraton tests, where we examine the interaction between different classes, e.g.
verify that we can retrieve/update/delete our model objects in the back-end db (see
demo23). 

## Testing REST services
A functional test sends a request and expects a certain response.
For non-UI systems, functional testing involves testing the application's services.    
This usually means testing the HTTP/REST endpoints of our application.

*NOTE*: The application in this demo uses Spring MVC. However, this doesn't matter to
Spock when testing a REST API. The application doesn't even need to be written in Java.

A REST service is based on HTTP, and usually the JSON message format.
See "http-endpoints-to-test.png" for the application endpoints we need to test.


## Testing REST services using Spock
Using Spock to test a REST service, you need to use a Java REST client library. There 
are many to chose from, including "Spring RestTemplate" (https://spring.io/guides/gs/consuming-rest/)

Spring "RestTemplate" enables you to act as a REST cient, like this:
    public static void main(String args[]) {
        RestTemplate restTemplate = new RestTemplate();
        Quote quote = restTemplate.getForObject("https://gturnquist-quoters.cfapps.io/api/random", Quote.class);
        log.info(quote.toString());
    }

## SpringRestSpec.groovy - using Sprint RestTemplate
These Spock tests are really simple and readable! These demonstrate GET, DELETE, POST.
*NOTE:* This Spock spec uses the "@Stepwise" annotation. This ensures that the individual
        Spock tests in the spec are run in the declared order in the source file.

## GroovyRestClientSpec.groovy - using Groovy's RESTClient
Groovy's "RESTClient" can be used instead of Spring "RestTemplate".
https://github.com/jgritman/httpbuilder/wiki/RESTClient
*NOTE:* The response HTTP error code is easy to check when using Groovy RESTClient.


JeremyC 18-07-2019
