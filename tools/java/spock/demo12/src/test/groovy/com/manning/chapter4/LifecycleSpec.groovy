package com.manning.chapter4.lifecycle

import spock.lang.*

import com.manning.chapter4.Basket
import com.manning.chapter4.Product

/*
* This spock spec class demonstrates the following:
*
* o Your regular "def" test methods run in the order that they are declared.
* o The special "def setup()" method runs before each regular "def" test method.
* o The special "def cleanup()" method runs after each regular "def" test method.
* o The special "def setupSpec()" method runs only once.
* o The special "def cleanupSpec()" method runs only once.
*/

class LifecycleSpec extends spock.lang.Specification{

	def setupSpec() {
		println "Will run only once"
	}     
	
	def setup() {
		println "Will run before EACH feature"
	}         
	
	def "first feature being tested"() {
		expect: "trivial test"
		println "first feature runs"
		2 == 1 +1 
	}

	def "second feature being tested"() {
		expect: "trivial test"
		println "second feature runs"
		5 == 3 +2 
	}
	
	def cleanup() {
		println "Will run once after EACH feature"
	}        
	
	def cleanupSpec() {
		println "Will run once at the end"
	}   
}
