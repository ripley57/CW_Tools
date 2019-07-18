/*
	This is the Geb configuration file.
	See: http://www.gebish.org/manual/current/configuration.html
*/


/*
	JeremyC 18-07-2019. 

	Had to switch from using Firefox (67.0.2, Linux Mint 19.1) to using Chromium:
	Version 75.0.3770.90 (Official Build) Built on Ubuntu , running on LinuxMint 19.1 (64-bit)

	This was because the selenium driver would not launch for Firefox.

	See:
	https://seleniumblocks.blogspot.com/2016/02/open-google-chrome-browser-with-selenium.html
	https://sites.google.com/a/chromium.org/chromedriver/downloads

	Simply download the chromedriver zip, extract "chromedriver" and copy it somewhere.
	Oh, and you still also need to install Chromium via the Linux Mint 19.1 GUI installer.
*/

/*
import org.openqa.selenium.firefox.FirefoxDriver
*/
import org.openqa.selenium.chrome.ChromeDriver;

System.setProperty("webdriver.chrome.driver", "/usr/lib/chromium-browser/chromedriver");

/* 
driver = { new FirefoxDriver() }
*/
driver = { new ChromeDriver() }

baseUrl = "http://localhost:9081"
reportsDir = "target/geb-reports"
