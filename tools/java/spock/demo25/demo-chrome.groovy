/*
	JeremyC 19-07-2019

	See also test-firefox.groovy. This is a version of that script,
	but for the Chrome and Linux Chromium web browsers.

	To run:
	groovy demo-chrome.groovy
	(This requires "groovy" command-line tool to be installed - it is automatically
	downloaded and installed when using my "groovy" CW_Tools wrapper function).

	To install chromedriver (the WebDriver for Chrome):
	o Download the "chromedrive" exe from https://sites.google.com/a/chromium.org/chromedriver/downloads
	o Extract the exe and copy it somewhere, e.g. /home/jcdc/chromedriver
        o Add this code below:
 	System.setProperty("webdriver.chrome.driver", "/home/jcdc/chromedriver");

	Chromium version used:
	Version 75.0.3770.90 (Official Build) Built on Ubuntu , running on LinuxMint 19.1 (64-bit)
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
    @Grab("org.seleniumhq.selenium:selenium-chrome-driver:3.141.59"),
    @Grab("org.seleniumhq.selenium:selenium-support:3.141.59")
])

import org.openqa.selenium.chrome.ChromeDriver

import geb.Browser

System.setProperty("webdriver.chrome.driver", "/home/jcdc/chromedriver")

driver = { new ChromeDriver() }

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
