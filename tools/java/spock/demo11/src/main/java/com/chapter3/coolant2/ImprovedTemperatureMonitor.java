package com.manning.chapter3.coolant2;

import com.manning.chapter3.coolant.TemperatureReader;
import com.manning.chapter3.coolant.TemperatureReadings;

public class ImprovedTemperatureMonitor {
	
	private final TemperatureReader reader;
	private final ReactorControl reactorControl;

	private TemperatureReadings lastReadings;
	private TemperatureReadings currentReadings;

	public ImprovedTemperatureMonitor(final TemperatureReader reader, final ReactorControl reactorControl)
	{
		this.reader = reader;
		this.reactorControl = reactorControl;
	}
	
	private boolean isTemperatureDiffMoreThan(long degrees)
	{
		boolean firstSensorTriggered	= Math.abs(lastReadings.getSensor1Data() - currentReadings.getSensor1Data()) > degrees;
		boolean secondSensorTriggered	= Math.abs(lastReadings.getSensor2Data() - currentReadings.getSensor2Data()) > degrees;
		boolean thirdSensorTriggered	= Math.abs(lastReadings.getSensor3Data() - currentReadings.getSensor3Data()) > degrees;

		return firstSensorTriggered || secondSensorTriggered || thirdSensorTriggered;
	}
	
	public void readSensor()
	{
		lastReadings = currentReadings;
		currentReadings = reader.getCurrentReadings();
		
		// The first time we do nothing until a second reading is present
		if(lastReadings == null)
		{
			return;
		}
	
		/*
		** NOTE: Unlike demo10, this temperature monitor class does not provide any way
		**       to determine what, if anything, was triggered due to a temperature change.
		**       There are no public methods that can be called to determine if this class
		**       did anything to act of a temperature change.
		**       This is why we need to use a mock object, for the ReactorControl class.
		*/	
		if(isTemperatureDiffMoreThan(20))
		{
			reactorControl.activateAlarm();
		}
		if(isTemperatureDiffMoreThan(50))
		{
			reactorControl.shutdownReactor();
		}
	}
}
