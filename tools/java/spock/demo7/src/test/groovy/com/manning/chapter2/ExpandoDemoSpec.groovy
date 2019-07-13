package com.manning.chapter2

import spock.lang.*

class ExpandoDemoSpec extends spock.lang.Specification{
	
	def "Testing invalid address detection"() {
		when: "an address does not have a postcode"
		Address address = new Address(country:"Greece",number:23)
		
		// Create an object to mimic the "AddressDao" service,
		// and return our test "Address" object.
		def dummyAddressDao = new Expando()
		dummyAddressDao.load = { return address}
	
		// The "as" here is where the magic happens.
		// This performs powerful casting, but not in a Java way.
		// The Expando class has no common inheritance with the AddressDao, yet 
		// it can still work as one because of "duck typing" (both objects have a 
		// load () method, and that’s enough for Groovy).	
		Stamper stamper = new Stamper(dummyAddressDao as AddressDao)

		then: "this address is rejected"
		!stamper.isValid(1)
	}
	
	def "Testing invalid and valid address detection"() {
		when: "two different addresses are checked"
		Address invalidAddress = new Address(country:"Greece",number:23)
		Address validAddress = new Address(country:"Greece",number:23,street:"Argous", postCode:"4534")
		
		def dummyAddressDao = new Expando()
		dummyAddressDao.load = { id -> return id==2?validAddress:invalidAddress}
		
		Stamper stamper = new Stamper(dummyAddressDao as AddressDao)

		then: "Only the address with street and postcode is accepted"
		!stamper.isValid(1)
		stamper.isValid(2)
	}
	
}

