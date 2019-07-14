# Nice basic Spock test example.

See Java Testing with Spock, page 68.

Remember: Spock isn’t a full BDD tool, but it certainly pushes you in that direction. 
          With careful planning, your Spock tests can act as living business documentation.

To run the Spock spec:
mvn  clean verify

To generate a surefire test report:
`mvn surefire-report:report`
This generates the html report:
target/site/surefire-report.html

To generate a spock test report:
`mvn test`
(see "<scope>test</scope>" in pom.xml)
This generates the html report:
build/spock-reports/index.html


Surefire report (https://maven.apache.org/surefire/maven-surefire-report-plugin/)
=================================================================================
`mvn surefire-report:report`
ME: It looks like "mvn surefire-report:report" generates an XML file, for each Spock spec (or JUnit file?), 
    in directory "target/surefire-reports/".
    An html file is also generated (from this XML, I assume) in "target/site/surefire-report.html".
    But, the images/CSS referenced by the html were missing, e.g. "images/icon_success_sml.gif".
=>  The following generates the missing image and CSS files: 
    `mvn site -DgenerateReports=false`
    (see https://stackoverflow.com/questions/2846493/is-there-a-decent-html-junit-report-plugin-for-maven/23958874#23958874)


Spock report (https://github.com/renatoathaydes/spock-reports)
==============================================================
`mvn test`
(The included pom.xml file contains the necessary changes for spock report generation.)


JeremyC 14-07-2019
