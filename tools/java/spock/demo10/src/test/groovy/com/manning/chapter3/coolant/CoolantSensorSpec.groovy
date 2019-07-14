package com.manning.chapter3.coolant

import spock.lang.*

class CoolantSensorSpec extends spock.lang.Specification{
	
	def "If current temperature difference is within limits everything is ok"() {
		given: "that temperature readings are within limits"

		// Premade temperature readings.
		TemperatureReadings prev	= new TemperatureReadings(sensor1Data:20,sensor2Data:40,sensor3Data:80)
		TemperatureReadings current	= new TemperatureReadings(sensor1Data:30,sensor2Data:45,sensor3Data:73);

		// Here's the magic!
		// Behind the scene, Spock creates a dummy implementation of this interface.
		// By default the implementation does nothing, so it must be told how to react.
		// Dummy implementation of interface "TemperatureReader".
		TemperatureReader reader = Stub(TemperatureReader)
		// The following line does the following:
		// o The first time getCurrentReadings() is called, return instance "prev".
		// o The second time getCurrentReadings() is called, return instance "current".
		reader.getCurrentReadings() >>> [prev, current]
		
		// Inject our dummy interface into the class under test.
		TemperatureMonitor monitor = new TemperatureMonitor(reader)
		
		when: "we ask the status of temperature control"
		// Class under test calls our dummy interface.
		monitor.readSensor()
		monitor.readSensor()

		then: "everything should be ok"
		monitor.isTemperatureNormal()
	}
	
	def "If current temperature difference is more than 20 degrees the alarm should sound"() {
		given: "that temperature readings are not within limits"

		TemperatureReadings prev	= new TemperatureReadings(sensor1Data:20,sensor2Data:40,sensor3Data:80)
		TemperatureReadings current	= new TemperatureReadings(sensor1Data:30,sensor2Data:10,sensor3Data:73);

		TemperatureReader reader = Stub(TemperatureReader)
		reader.getCurrentReadings() >>> [prev,current]
		
		TemperatureMonitor monitor = new TemperatureMonitor(reader)
		
		when: "we ask the status of temperature control"
		monitor.readSensor()
		monitor.readSensor()

		then: "the alarm should sound"
		!monitor.isTemperatureNormal()
	}
}
