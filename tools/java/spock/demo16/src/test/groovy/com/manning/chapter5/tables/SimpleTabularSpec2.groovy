package com.manning.chapter5.tables

import spock.lang.*

/*
* Simple data table parametized test example, that also includes
* calls to println to indicate how the test is automatically re-run
* multiple times.
*/

class SimpleTabularSpec2 extends spock.lang.Specification{

	def setup() {
		println "Setup prepares next run"
	}
	
	def "Trivial adder test"() {
		given: "an adder"
		Adder adder = new Adder()
		println "Given: block runs"
		
		when:"the add method is called for two numbers"
		int result = adder.add(first,second)
		println "When: block runs for first = $first and second = $second"

		then: "the result should be the sum of them"
		result ==sum
		println "Then: block is evaluated for sum = $sum"

		where: "some scenarios are"
		first   |second || sum
		1       | 1     || 2
		3       | 2     || 5
		3       | -3    || 0
	}
	
	def cleanup()
	{
		println "Cleanup releases resources of last run\n"
	}
}

