package com.jeremyc;

import java.io.File;
import java.util.List;
import java.util.ArrayList;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import net.masterthought.cucumber.presentation.PresentationMode;


/**
 * See:
 *	https://github.com/damianszczepanik/cucumber-reporting
 *	https://github.com/damianszczepanik/cucumber-reporting/blob/master/src/test/java/LiveDemoTest.java
 *
 * NOTE: See my pom.xml file to see how I compile and run this program.
 * The generated reports can be found afterwards here:
 * ./target/cucumber-html-reports/overview-features.html
 * See cucumber-reports-screenshot.png
 *
 * JeremyC 30-07-2019
*/

public class GenerateExtraReports {

	public static void main(String args[]) {

		File reportOutputDirectory = new File("target");

		// JeremyC. Point to our input .json file from the built-in "json" 
		// cucumber report generation. See AcceptanceTestSuite.java.
		List<String> jsonFiles = new ArrayList<String>();
		jsonFiles.add("target/cucumber.json");

		String buildNumber = "1";
		String projectName = "cucumberProject";

		Configuration configuration = new Configuration(reportOutputDirectory, projectName);
		configuration.setBuildNumber(buildNumber);

		// JeremyC. Not sure what this is.
		// optional configuration - check javadoc for details
		configuration.addPresentationModes(PresentationMode.RUN_WITH_JENKINS);

		// JeremyC. Not sure what this is.
		// addidtional metadata presented on main page
		configuration.addClassifications("Platform", "Windows");
		configuration.addClassifications("Browser", "Firefox");
		configuration.addClassifications("Branch", "release/1.0");

		// JeremyC. Not sure what this is.
		// optionally add metadata presented on main page via properties file
		//List<String> classificationFiles = new ArrayList<String>();
		//classificationFiles.add("properties-1.properties");
		//classificationFiles.add("properties-2.properties");
		//configuration.addClassificationFiles(classificationFiles);

		ReportBuilder reportBuilder = new ReportBuilder(jsonFiles, configuration);
		reportBuilder.generateReports();
		// and here validate 'result' to decide what to do if report has failed
	}

}
