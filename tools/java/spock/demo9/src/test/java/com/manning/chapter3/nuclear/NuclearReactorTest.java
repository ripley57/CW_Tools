package com.manning.chapter3.nuclear;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

/*
** Note the hideous amount of code, and limitations, when using JUnit for parametized testing!:
**
** o The test class must be polluted with fields that repesent inputs.
** o The test class must be polluted with fields that repesent outputs.
** o A special constructor is needed for all inputs and outputs.
** o Test data has to be put into a two-dimensional object array, which is converted to a list.
** o Note that it's impossible to add a second parametized test into the same test class (i.e. JUnit
**   so strict that it forces you to have a single class for each test when multiple parameters are involved!).
**
** TestNG vs JUnit
** ===============
** Parameterized tests are an area where Test NG (http://testng.org) has been advertised as a better 
** replacement for JUnit. Test NG does away with all JUnit limitations and comes with extra annotations (@DataProvider) 
** that truly decouple test data and test logic.
**
** Despite these external (JUnit-replacement) efforts, Spock comes with an even better syntax for 
** parameters (Groovy magic again!).
*/

// Note: A specialized runner is needed for parametized tests.
@RunWith(Parameterized.class)
public class NuclearReactorTest {

	// Inputs become class fields.
	private final int triggeredFireSensors;
	private final List<Float> radiationDataReadings;
	private final int pressure;

	// Outputs become class fields.
	private final boolean expectedAlarmStatus;
	private final boolean expectedShutdownCommand;
	private final int expectedMinutesToEvacuate;

	// Special constructor with all inputs and outputs.
	public NuclearReactorTest(int pressure, int triggeredFireSensors,
			List<Float> radiationDataReadings, boolean expectedAlarmStatus,
			boolean expectedShutdownCommand, int expectedMinutesToEvacuate) {

		this.triggeredFireSensors = triggeredFireSensors;
		this.radiationDataReadings = radiationDataReadings;
		this.pressure = pressure;

		this.expectedAlarmStatus = expectedAlarmStatus;
		this.expectedShutdownCommand = expectedShutdownCommand;
		this.expectedMinutesToEvacuate = expectedMinutesToEvacuate;
	}

	@Test
	public void nuclearReactorScenario() {
		NuclearReactorMonitor nuclearReactorMonitor = new NuclearReactorMonitor();

		nuclearReactorMonitor.feedFireSensorData(triggeredFireSensors);
		nuclearReactorMonitor.feedRadiationSensorData(radiationDataReadings);
		nuclearReactorMonitor.feedPressureInBar(pressure);
		NuclearReactorStatus status = nuclearReactorMonitor.getCurrentStatus();

		assertEquals("Expected no alarm",	expectedAlarmStatus,		status.isAlarmActive());
		assertEquals("No notifications",	expectedShutdownCommand, 	status.isShutDownNeeded());
		assertEquals("No notifications",	expectedMinutesToEvacuate, 	status.getEvacuationMinutes());
	}

	@Parameters
	public static Collection<Object[]> data() {
		// Twod-dimensional array of test data.
		return Arrays.asList(new Object[][] {
				{ 150, 0, new ArrayList<Float>(), false, false, -1 },
				{ 150, 1, new ArrayList<Float>(), true, false, -1 },
				{ 150, 3, new ArrayList<Float>(), true, true, -1 },
				{ 150, 0, Arrays.asList(110.4f, 0.3f, 0.0f), true, true, 1 },
				{ 150, 0, Arrays.asList(45.3f, 10.3f, 47.7f), false, false, -1 },
				{ 155, 0, Arrays.asList(0.0f, 0.0f, 0.0f), true, false,	-1 },
				{ 170, 0, Arrays.asList(0.0f, 0.0f, 0.0f), true, true, 3 },
				{ 180, 0, Arrays.asList(110.4f, 0.3f, 0.0f), true, true, 1 },
				{ 500, 0, Arrays.asList(110.4f, 300f, 0.0f), true, true, 1 },
				{ 30, 0, Arrays.asList(110.4f, 1000f, 0.0f), true, true, 1 },
				{ 155, 4, Arrays.asList(0.0f, 0.0f, 0.0f), true, true, -1 },
				{ 170, 1, Arrays.asList(45.3f, 10.3f, 47.7f), true, true, 3 }, 
			});
	}
}
