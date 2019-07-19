# Spock enterprise testing (continued): Code coverage.


QUESTION: "How can I determine what percentage of my code is covered by jUnit tests?"
ANSWER: This can be done using [JaCoCo](https://www.eclemma.org/jacoco/)

*NOTE:* Because Spock uses the jUnit runner, this coverage report will automatically
        include any Spock tests.

Just add JaCoCo to your pom.xml file.

Then run:
`mvn verify`

The "Java Testing with Spock" eBook says run "mvn jacoco:report", but this gave me an error:
http://www.ffbit.com/blog/2014/05/21/skipping-jacoco-execution-due-to-missing-execution-data-file/
In the end, I found that running everything (tests and report) worked for me: 
	mvn verify
	...
	[INFO] --- jacoco-maven-plugin:0.7.4.201502262128:report (default-report) @ chapter3 ---
	[INFO] Analyzed bundle 'Examples of Chapter 3' with 3 classes
Then find the report here:
	./target/site/jacoco/index.html


JeremyC 18-07-2019
