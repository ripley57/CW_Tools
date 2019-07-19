/*
	JeremyC 19-07-2019

	This example is from the Geb docs:
	https://gebish.org/manual/current/#installation-usage

	To run:
	groovy demo-firefox.groovy
	(This requires "groovy" command-line tool to be installed - it is automatically
	downloaded and installed when using my "groovy" CW_Tools wrapper function).

	We aren't using Spock here, so we depend on "geb-core" rather than "geb-spock".
	To see the use of "geb-spock" instead of "geb-core", see the Maven pom.xml files.

	NOTE: Currently, one of the big problems I have with things like Spock and Geb,
        is knowing which versions are compatible with each other. For example, if I run
	this Groovy script using my (2.5.7) groovy command-line installation, the script
	fails if I try to use "geb-core:3.0.1" (see code below):

		groovy mytest.groovy
		...
		roovy.lang.GroovyRuntimeException: Conflicting module versions. Module [groovy-xml is loaded in version 2.5.7 and you are trying to load version 2.5.6

	To me, this suggests that geb-core:3.0.1 is dependent on Groovy 2.5.6, because
	I know that command-line Groovy installation is version 2.5.7. I then examined
	Geb github (https://github.com/geb/geb/releases) and kept trying older versions
	until they worked with my "groovy" 2.5.7 command-line installation. I found that
	"geb-core:2.3.1" worked, so that is what I am using below.

	This script of course still didn't work. Here's the error I got next:

	Caught: java.lang.IllegalStateException: The path to the driver executable must be set by the webdriver.gecko.driver system property; 
	for more information, see https://github.com/mozilla/geckodriver. The latest version can be downloaded from https://github.com/mozilla/geckodriver/releases
	java.lang.IllegalStateException: The path to the driver executable must be set by the webdriver.gecko.driver system property; 
	for more information, see https://github.com/mozilla/geckodriver. The latest version can be downloaded from https://github.com/mozilla/geckodriver/releases

	Article https://stackoverflow.com/questions/43418035/the-path-to-the-driver-executable-must-be-set-by-the-webdriver-gecko-driver-syst
	confirms that we need the "geckodriver" for Firefox, in order to interact with Selemnium.
	We download this from here: 
		https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz 
	This simply contains one executable "geckodriver". I copied this to ~jcdc/geckodriver
	We then need to add this to our script:
		System.setProperty("webdriver.gecko.driver","/home/jcdc/geckodriver");

	=> This script then worked! (Linux Mint 19.1, Firefox 67.0.2 64-bit).
		You should see Firefox launched and the links clicked, etc.
*/


/*
	From https://docs.groovy-lang.org/latest/html/documentation/grape.html :
	"Grape is a JAR dependency manager embedded into Groovy. Grape lets you quickly
 	add maven repository dependencies to your classpath, making scripting even easier."
*/
@Grapes([
    // JeremyC. I had to use geb-core:2.3.1 in order for this script to work with my 2.5.7 groovy command-line installation.
    //@Grab("org.gebish:geb-core:3.0.1"),
    @Grab("org.gebish:geb-core:2.3.1"),
    @Grab("org.seleniumhq.selenium:selenium-firefox-driver:3.141.59"),
    @Grab("org.seleniumhq.selenium:selenium-support:3.141.59")
])


import org.openqa.selenium.firefox.FirefoxDriver

import geb.Browser

/*
	Configure GeckoDriver for Linux (from https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz).
	From https://github.com/mozilla/geckodriver:
	"This program provides the HTTP API described by the WebDriver protocol to communicate with Gecko browsers, such as Firefox"

	How I currently see it:
	We need a WebDriver-compatible client (the GeckoDriver) to talk to a Gecko-engine-based browser such as Firefox.
	We invoke the driver using Selenium, which we are doing via the Geb Groovy library, to make things easier for us.
*/
System.setProperty("webdriver.gecko.driver","/home/jcdc/geckodriver")

driver = { new FirefoxDriver() }

Browser.drive {
    go "http://gebish.org"

     // Check that we are at Geb’s homepage.
    assert title == "Geb - Very Groovy Browser Automation" 

    // Click on the manual menu entry to open it.
    $("div.menu a.manuals").click() 
    
    // Wait for the menu open animation to finish.
    waitFor { !$("#manuals-menu").hasClass("animating") } 

    // Click on the first link to a manual.
    $("#manuals-menu a")[0].click() 

    // Check that we are at The Book of Geb.
    assert title.startsWith("The Book Of Geb") 
}
