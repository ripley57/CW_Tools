# Spock enterprise testing (continued): Automating function tests driving a web browser using Geb and Tomcat.

User experiences:
https://rushby.silvrback.com/automation-with-geb-spock
https://allegro.tech/2015/05/automated-tests-with-geb-spock-and-groovy.html


To run the tests:
`cd web-ui-example`
`mvn verify`


*************************************************
**** Had to use Chromium instead of Firefox  ****
*************************************************
These Spock tests were originally configured to automate (my Linux Mint) Firefox (67.0.2), but the
tests failed to launch. I kept getting the following error:
	geb.driver.DriverCreationException: failed to create driver from callback
Much research suggested changing the version settings for geb & selenium in the pom.xml file.
The big question here is which version combination(s) are supported! I thought the safest
combination of versions to try would be to use that mentioned in the Geb documentation:
	https://gebish.org/manual/current/#installation-usage
...which (currently) is this for the example Maven config:
	geb-core			3.0.1
	selenium-firefox-driver		3.141.59
...but this still didn't work! My conclusion was that my Firefox version was too new for Selenium.
So this is when I switched to using chrome browser on Linux Mint 19.1 - and this worked...

To switch to using Chrome, I first installed it, using the regular Linux Mint 19.1 GUI.
I then had to edit my pom.xml and also the GebConfig.groovy config files.
But initially this didn't work, with this error:
	geb.driver.DriverCreationException: failed to create driver from callback 'script15634764450721173356546$_run_closure1@600b9d27'
		at com.google.common.base.Preconditions.checkState(Preconditions.java:199)
		at org.openqa.selenium.remote.service.DriverService.findExecutable(DriverService.java:109)
It turns out that this was caused because I did not have the "chromedriver" exe installed.
The page https://seleniumblocks.blogspot.com/2016/02/open-google-chrome-browser-with-selenium.html pointed
me to the download page for chromedrive (https://sites.google.com/a/chromium.org/chromedriver/downloads).
I downloaded the zip to match my chromium version (75), extracted the "chromedriver" exe and copied it to
/usr/lib/chromium-browser/. I then updated the GebConfig.groovy config by adding this:
	System.setProperty("webdriver.chrome.driver", "/usr/lib/chromium-browser/chromedriver");
=> The Spock tests in this demo then worked !!! I could see chrome being launched, the form values
   being entered and the submit button being clicked !!!


**********************************
**** Starting Tomcat manually ****
**********************************
These Spock tests automatically start Tomcat (see the Maven pom.xml and maven-testing-phases.png).
But, outside of automatic testing, you can manually start and stop Tomcat using Maven like this...

To manually start Tomcat:
`cd web-ui-example`
`mvn package`
`mvn tomcat7:run-war-only`	(Notice that "tomcat7" is the prefix of "tomcat7-maven-plugin" in pom.xml)

=> You can now view the web pages, like this:
http://localhost:8080/web-ui-example/index.html
See homepage.png showing what you should see.
*NOTE:* The HTML pages, such as about.html (click on "Technology" tab), are generated dynamically from template .ftl files. See the references to "freemarker".
*NOTE:* Because we're not passing the Tomcat port number in pom.xml, our manual-launched server listens on Tomcat default port 8080

To manually shutdown Tomcat:
*NOTE*: The earlier Tomcat start command ties-up that terminal, and Maven, I suspect. I think this
is why the following does NOT work when run on the command-line, just like the start command:
`cd web-ui-example`
`mvn tomcat7:shutdown`
=> In the end, I had to Ctrl-C in the active terminal where Tomcat was started, to stop it.


## Geb - Calling Selenium using Groovy
Geb is a Groovy library that provides a Groovy abstraction on top of the popular Selenium/
WebDriver framework for automating web browser interactions. Geb has excellent integration 
with Spock and provides a jQuery-like language for accessing web page ccontent.

[Geb & Spock creators](https://www.youtube.com/watch?v=SNMgf6ndoeU&feature=youtu.be)
[Geb creator Luke Daley](https://www.youtube.com/watch?v=T2qXCBT_QBs)
[Geb github](https://github.com/geb/geb)
[Geb docs](https://gebish.org/manual/current/)
[Selenium](https://www.seleniumhq.org/)
[Selenium docs](https://docs.seleniumhq.org/docs/01_introducing_selenium.jsp#supported-browsers-and-platforms)


*NOTE:* Geb might be the easiest way for me to learn/use Selenium! The big question is
        how difficult is it to run Geb scripts from the command-line, and without Spock? (TBC).

*NOTE:* Like the REST API functional tests in demo24, Spock doesn't care here that our 
        applicaton uses Java Spring.


## HomePageSpec.groovy
This spec includes some tests to verify the home page HTML contents. 

## AddProductGebSpec.groovy
This spec includes a test that populated a form and clicks submit.

## demo-firefox.groovy & demo-chrome.groovy
These are simple demos of controlling Firefox or Chrome web browser.
Remember that Geb is a groovy library. These two scripts contain no Spock syntax
so they are pure Groovy, and can therefore be run using the command-line Groovy
executable "groovy" (included in my CW_Tools).


JeremyC 18-07-2019
