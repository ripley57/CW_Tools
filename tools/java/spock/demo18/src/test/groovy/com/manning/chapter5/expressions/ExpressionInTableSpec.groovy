package com.manning.chapter5.expressions

import spock.lang.*

import com.manning.chapter5.Adder

/*
* This spec demonstrates how the parameter values in the data table
* of a Spock parametized test do not have to be scalar values, i.e.
* they can be expressions.
*
* NOTE: This is a VERY unrealistic test. It is purely for demonstration
*       purposes, to show how different types of expressions are permitted.
*/

class ExpressionInTableSpec extends spock.lang.Specification{

	@Unroll
	def "Testing the Adder for #first + #second = #sum "() {
		given: "an adder"
		Adder adder = new Adder()

		expect: "that it calculates the sum of two numbers"
		adder.add(first,second)==sum

		where: "some scenarios are"
		first                            |second                      || sum
		2+3                              | 10-2                       || new Integer(13).intValue()
		MyInteger.FIVE.getNumber()       | MyInteger.NINE.getNumber() || 14
		IntegerFactory.createFrom("two") | (7-2)*2                    || 12
		[1,2,3].get(1)                   | 3                          || IntegerFactory.createFrom("five")
		new Integer(5).intValue()        | new String("cat").size()   || MyInteger.EIGHT.getNumber() 
		["hello","world"].size()         | 5                          || IntegerFactory.createFrom("seven")
	}
}

