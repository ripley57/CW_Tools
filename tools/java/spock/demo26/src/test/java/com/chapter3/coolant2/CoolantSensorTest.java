package com.manning.chapter3.coolant2;

/*
** This performs the same JUnit tests as the Groovy spec ImprovedCoolantSensorSpec.groovy
**
** Mockito was one of the inspirations for Spock, and you might find some similarities in 
** the syntax. 
**
** NOTE: While the test looks equivalent to the Spock test, this Mockito test is
**       missing the parametized values test. To do this with Mockito, you need
**       to combine multiple Java libraries: JUnit plus Mockito plus JUnitParams.
*/

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.Test;

import com.manning.chapter3.coolant.TemperatureReadings;
import com.manning.chapter3.coolant.TemperatureReader;

import com.manning.chapter3.coolant2.ImprovedTemperatureMonitor;
import com.manning.chapter3.coolant2.ReactorControl;

public class CoolantSensorTest {

	@Test
	public void temperatureWithinLimits() {
		TemperatureReadings prev = new TemperatureReadings();
		prev.setSensor1Data(20);
		prev.setSensor2Data(40);
		prev.setSensor3Data(80);
		
		TemperatureReadings current = new TemperatureReadings();
		current.setSensor1Data(30);
		current.setSensor2Data(45);
		current.setSensor3Data(73);
		
		// Similar to Spock mocking.
		TemperatureReader reader = mock(TemperatureReader.class);
		when(reader.getCurrentReadings()).thenReturn(prev,current);
		ReactorControl control = mock(ReactorControl.class);

		ImprovedTemperatureMonitor monitor = new ImprovedTemperatureMonitor(reader,control);
		
		monitor.readSensor();
		monitor.readSensor();

		verify(control,times(0)).activateAlarm();
		verify(control,times(0)).shutdownReactor();
	}

	@Test
	public void temperatureOutsideOfLimits() {
		TemperatureReadings prev = new TemperatureReadings();
		prev.setSensor1Data(20);
		prev.setSensor2Data(40);
		prev.setSensor3Data(80);
		
		TemperatureReadings current = new TemperatureReadings();
		current.setSensor1Data(30);
		current.setSensor2Data(10);
		current.setSensor3Data(73);
		
		TemperatureReader reader = mock(TemperatureReader.class);
		when(reader.getCurrentReadings()).thenReturn(prev,current);
		ReactorControl control = mock(ReactorControl.class);

		ImprovedTemperatureMonitor monitor = new ImprovedTemperatureMonitor(reader,control);
		
		monitor.readSensor();
		monitor.readSensor();

		verify(control,times(1)).activateAlarm();
		verify(control,times(0)).shutdownReactor();
	}

	@Test
	public void extremeTemperatureChanges() {
		TemperatureReadings prev = new TemperatureReadings();
		prev.setSensor1Data(20);
		prev.setSensor2Data(40);
		prev.setSensor3Data(80);
		
		TemperatureReadings current = new TemperatureReadings();
		current.setSensor1Data(30);
		current.setSensor2Data(10);
		current.setSensor3Data(160);
		
		TemperatureReader reader = mock(TemperatureReader.class);
		when(reader.getCurrentReadings()).thenReturn(prev,current);
		ReactorControl control = mock(ReactorControl.class);

		ImprovedTemperatureMonitor monitor = new ImprovedTemperatureMonitor(reader,control);
		
		monitor.readSensor();
		monitor.readSensor();

		verify(control,times(1)).activateAlarm();
		verify(control,times(1)).shutdownReactor();
	}
}
