# The Spring Framework

[What is the Spring framework really all about?](https://youtu.be/gq4S-ovWVlM)
[Spring Boot REST walkthrough on YouTube](https://youtu.be/9Pl4rlVAoOc)
[Guides](https://spring.io/guides)
[Documentation](https://spring.io/docs)
[Github](https://github.com/spring-projects/spring-framework)

From https://www.geeksforgeeks.org/introduction-to-spring-framework/:

Spring makes the development of Web applications much easier as compared to classic Java frameworks
and APIs such as Java database connectivity(JDBC), JavaServer Pages(JSP), and Java Servlet.

The Spring framework can be considered as a collection of sub-frameworks, also called layers,
such as Spring AOP, Spring Object-Relational Mapping (Spring ORM), Spring Web Flow, and Spring Web MVC.


## Main features of Spring

### IoC container:
Refers to the core container that uses the DI (Dependency Injection) or IoC (Inversion Of Control)
pattern to implicitly provide an object reference in a class during runtime. This pattern acts as
an alternative to the service locator pattern.
See also https://stackoverflow.com/questions/1061717/what-exactly-is-spring-framework-for

### Data access framework:
This allows the developers to use persistence APIs, such as JDBC and Hibernate, for storing persistence
data in database. It helps in solving various problems of the developer, such as how to interact with a
database connection, how to make sure that the connection is closed, how to deal with exceptions, and
how to implement transaction management It also enables the developers to easily write code to access
the persistence data throughout the application.

### Spring MVC framework:
This allows you to build Web applications based on MVC architecture. All the requests made by a user
first go through the controller and are then dispatched to different views, that is, to different JSP
pages or Servlets.

### Transaction management:
This helps in handling transaction management of an application without affecting its code. This
framework provides Java Transaction API (JTA) for global transactions managed by an application server
and local transactions managed by using the JDBC Hibernate, Java Data Objects (JDO), or other data
access APIs.


JeremyC 18-07-2019
