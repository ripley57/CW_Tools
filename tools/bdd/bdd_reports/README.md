# BDD reporting, aka "Living Documentation"

Chapter-10 of "BDD In Action" includes sample projects using Cucumber, and JBehave/Thucydides.
This directory here also includes a copy of those two sample projects.

To generate the reports:
mvn verify


## Cucumber - built-in reports
As mentioned [here](https://cucumber.io/docs/cucumber/reporting/), Cucumber includes several 
built-in reports, including: "progress", "pretty", "html", "json". You can request any, or all of
these, be built, by adding them into your Cucumber JUnit test runner file, e.g.
AcceptanceTestSuite.java: 
    @Cucumber.Options(format = {"json:target/cucumber.json", "html:target/cucumber-html-report"})
NOTE: These "html" and "json" options allow you to specify the output file location.

NOTE: The "progress" and "pretty" reports only write to stdout (with pretty font colouring), so
they are not of great use. The "html" report is the most useful built-in report. See screenshot:
cucumber-builtin-html-report-screenshot.png
NOTE: The "@" annotations are tags in cucumber.


## Better Cucumber reports
From "BDD In Action":
	"Cucumber provides only basic feature reporting out of the box, but tools like
	Cucumber Reports (www.masterthought.net/section/cucumber-reporting) provide more 
	presentable reports."

But, the website mentioned above no longer exists (30-07-2019)! HOWEVER, from website
https://damienfremont.com/2015/07/30/how-to-cucumber-test-reporting-plugin-with-maven-and-java/
I've found the github location:

	https://github.com/damianszczepanik/cucumber-reporting

	"The project converts the (built-in) "json" report into an overview html linking to separate 
	feature files with stats and results."

NOTE: I've updated the pom.xml file in the cucumber demo, to add the necessary dependencies. However, the
dependencies in Maven don't invoke the report generation. The installation steps (see github link above) 
give us some Java code that we need to compile and execute to generate the report! I managed to get this 
to work - see comments in the pom.xml. The results are some nice visualizations of the features and steps
(see cucumber-reports-screenshot.png).

The github site also includes a demo:
http://damianszczepanik.github.io/cucumber-html-reports/overview-features.html


## Creating your own custom Cucumber report
Someone here has even created their own custom cucumber report:
https://mkolisnyk.blogspot.com/2015/05/cucumber-jvm-advanced-reporting.html


JeremyC 30-07-2019
