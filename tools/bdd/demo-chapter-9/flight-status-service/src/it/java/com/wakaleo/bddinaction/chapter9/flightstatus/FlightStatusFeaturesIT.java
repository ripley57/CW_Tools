package com.wakaleo.bddinaction.chapter9.flightstatus;

import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

/*
** JeremyC 29-070291
**
** This is our JUnit test runner.
**
** From https://www.toolsqa.com/cucumber/junit-test-runner-class/ :
**
** "As Cucumber uses Junit we need to have a Test Runner class. This class will use 
**  the Junit annotation @RunWith(), which tells JUnit what is the test runner class. 
**  It is more like a starting point for Junit to start executing your tests."
*/

@RunWith(Cucumber.class)
@Cucumber.Options(format = { "pretty", "html:target/cucumber-html-report", "json:target/report.json" })
public class FlightStatusFeaturesIT {
}
